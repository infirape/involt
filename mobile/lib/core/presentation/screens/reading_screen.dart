import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/database.dart';
import '../../data/repositories/drift_reading_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/numeric_keypad.dart';
import '../providers/app_state_provider.dart';

class ReadingScreen extends StatefulWidget {
  final Customer customer;
  final AppDatabase db;

  const ReadingScreen({
    super.key,
    required this.customer,
    required this.db,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final TextEditingController _kwhController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _inputKey = GlobalKey();

  File? _image;
  Position? _currentPosition;
  Reading? _existingReading;
  double _previousValue = 0;
  bool _isSaving = false;

  // Business Logic Constants
  final double _cargoFijo = 4.50;
  final double _alumbrado = 2.10;
  final double _pricePerKwh = 0.85;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;
    
    // 1. Get previous reading to calculate consumption
    final lastReadings = await (widget.db.select(widget.db.readings)
          ..where((r) => r.customerId.equals(widget.customer.id))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .get();

    if (lastReadings.isNotEmpty) {
      _previousValue = lastReadings.first.currentValue;
    } else {
      _previousValue = widget.customer.lastReadingValue;
    }

    // 2. Check if there's already a reading for the CURRENT period
    final existing = await (widget.db.select(widget.db.readings)
          ..where((r) => r.customerId.equals(widget.customer.id))
          ..where((r) => r.period.equals(selectedPeriod))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null && mounted) {
      setState(() {
        _existingReading = existing;
        _kwhController.text = existing.currentValue.toString();
        // Set previous from the record if it exists
        _previousValue = existing.previousValue;
        if (existing.photoUrl != null && existing.photoUrl!.isNotEmpty) {
          _image = File(existing.photoUrl!);
        }
      });
    }

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint('Error location: $e');
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  double get _currentValue => double.tryParse(_kwhController.text) ?? 0;
  double get _consumption => _currentValue > _previousValue ? _currentValue - _previousValue : 0;
  double get _totalToPay => _cargoFijo + _alumbrado + (_consumption * _pricePerKwh);

  Future<void> _saveReading() async {
    if (_image == null) {
      _showError('La foto de evidencia es obligatoria');
      return;
    }
    if (_currentValue <= 0) {
      _showError('Ingrese una lectura válida');
      return;
    }

    setState(() => _isSaving = true);
    final selectedPeriod = context.read<AppStateProvider>().selectedPeriod;

    try {
      final repo = DriftReadingRepository(widget.db);
      final reading = Reading(
        id: _existingReading?.id ?? 'read-${widget.customer.id}-${DateTime.now().millisecondsSinceEpoch}',
        customerId: widget.customer.id,
        period: selectedPeriod,
        previousValue: _previousValue,
        currentValue: _currentValue,
        consumptionKwh: _consumption,
        photoUrl: _image?.path,
        timestamp: DateTime.now(),
        latitude: _currentPosition?.latitude ?? 0,
        longitude: _currentPosition?.longitude ?? 0,
        cargoFijo: _cargoFijo,
        alumbradoPublico: _alumbrado,
        saldoRedondeo: 0,
        totalToPay: _totalToPay,
        isSynced: false,
      );

      await repo.saveReading(reading);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lectura guardada')));
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onyx,
      appBar: AppBar(
        title: const Text('Registro de Lectura', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCustomerInfo(),
                  const SizedBox(height: 20),
                  _buildCalculationsCard(),
                  const SizedBox(height: 20),
                  _buildPhotoSection(),
                  const SizedBox(height: 20),
                  _buildReadingInput(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildKeypadSection(),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.person, color: AppColors.cyan),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.customer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Suministro: ${widget.customer.code}', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCalcRow('Lectura Anterior', '${_previousValue.toStringAsFixed(1)} kWh', Colors.white38),
          const Divider(color: Colors.white10),
          _buildCalcRow('Consumo Actual', '${_consumption.toStringAsFixed(1)} kWh', AppColors.cyan, isBold: true),
          _buildCalcRow('Cargo Fijo', 'S/ ${_cargoFijo.toStringAsFixed(2)}', Colors.white70),
          _buildCalcRow('Alumbrado', 'S/ ${_alumbrado.toStringAsFixed(2)}', Colors.white70),
          const Divider(color: Colors.white10),
          _buildCalcRow('TOTAL ESTIMADO', 'S/ ${_totalToPay.toStringAsFixed(2)}', AppColors.magenta, isBold: true, fontSize: 20),
          if (_currentPosition != null)
             Text('GPS: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: Colors.green, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, Color color, {bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _takePhoto,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Container(
          height: 150, width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: _image != null ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) : null,
          ),
          child: _image == null
              ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.camera_alt, color: AppColors.magenta, size: 40),
                  Text('Capturar Foto del Medidor', style: TextStyle(color: AppColors.magenta, fontWeight: FontWeight.bold)),
                ])
              : null,
        ),
      ),
    );
  }

  Widget _buildReadingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lectura Actual (kWh)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _kwhController,
            readOnly: true,
            style: const TextStyle(color: AppColors.cyan, fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(border: InputBorder.none, hintText: '0.0'),
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NumericKeypad(controller: _kwhController, onChanged: () => setState(() {})),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveReading,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.magenta, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('REGISTRAR', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
