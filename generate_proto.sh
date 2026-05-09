#!/bin/bash

# Configuration
PROTO_SRC="proto"
GO_OUT="backend/internal/gen"
DART_OUT="mobile/lib/core/gen/proto"

# Ensure plugins are in PATH
export PATH="$PATH:$HOME/go/bin:$HOME/.pub-cache/bin"

echo "🧹 Cleaning old generated files..."
rm -rf "$GO_OUT"
rm -rf "$DART_OUT"

echo "📂 Creating output directories..."
mkdir -p "$GO_OUT"
mkdir -p "$DART_OUT"

echo "⚙️ Generating Go code (ConnectRPC)..."
protoc --proto_path=proto \
       --go_out="backend/internal/gen" --go_opt=module=github.com/infira/involt/backend/internal/gen \
       --connect-go_out="backend/internal/gen" --connect-go_opt=module=github.com/infira/involt/backend/internal/gen \
       proto/involt/v1/*.proto

echo "⚙️ Generating Dart code..."
protoc --proto_path="$PROTO_SRC" \
       --dart_out="$DART_OUT" \
       proto/involt/v1/*.proto

echo "⚙️ Generating TypeScript code (Connect ES)..."
# We only want TS from buf generate to avoid overwriting Go files if buf.gen.yaml is not perfectly aligned
export PATH="$PATH:$(pwd)/admin-ui/node_modules/.bin"
admin-ui/node_modules/.bin/buf generate proto --template buf.gen.yaml

echo "✅ Generation complete!"
