package main

import (
	"bufio"
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	inputFile := "/Users/hbs/Documents/infira/involt/docs/USUARIOS-DE-LOS-CASERIOS.csv"
	outputFile := "/Users/hbs/Documents/infira/involt/docs/cleaned_customers.csv"

	file, err := os.Open(inputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	outFile, err := os.Create(outputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer outFile.Close()

	writer := csv.NewWriter(outFile)
	defer writer.Flush()

	// Header
	writer.Write([]string{"index", "name", "code", "community"})

	scanner := bufio.NewScanner(file)
	var currentCommunity string
	
	count := 0
	for scanner.Scan() {
		line := strings.Trim(scanner.Text(), "\" \f\t")
		if line == "" {
			continue
		}

		// Regex to match: Index Name Code Community
		// Example: "1   BACON CHILON MARIA CONCEPCION          ACH001   ALTO CHETILLA"
		re := regexp.MustCompile(`^(\d+)\s+(.+?)\s+([A-Z]{3}\d+)\s+(.+)$`)
		matches := re.FindStringSubmatch(line)

		if matches == nil {
			// Header line
			potentialComm := strings.TrimSpace(line)
			// Filter out metadata or noise
			if potentialComm != "Persona" && potentialComm != "Empresa" && potentialComm != "Cochapampa" && !strings.Contains(potentialComm, "---") {
				currentCommunity = potentialComm
			}
			continue
		}

		// Data line
		index := matches[1]
		name := strings.TrimSpace(matches[2])
		code := strings.TrimSpace(matches[3])
		// Matches[4] is the community from the line, but we trust the header logic more for grouping
		
		writer.Write([]string{index, name, code, currentCommunity})
		count++
	}

	fmt.Printf("✨ Cleaned CSV created: %s (%d records)\n", outputFile, count)
}
