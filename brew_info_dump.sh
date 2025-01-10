#!/bin/bash
set -xv
# Output file
OUTPUT_FILE="brew_info_dump.txt"

# Clear previous file content if exists
> "$OUTPUT_FILE"

# Dump Homebrew taps
echo "### Homebrew Taps ###" >> "$OUTPUT_FILE"
brew tap >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# Dump installed casks
echo "### Installed Casks ###" >> "$OUTPUT_FILE"
brew list --cask >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# Dump installed formulae
echo "### Installed Formulae ###" >> "$OUTPUT_FILE"
brew list --formula >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# Dump all installed packages (both casks and formulae)
echo "### All Installed Packages ###" >> "$OUTPUT_FILE"
brew list >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# Dump versions of installed packages
echo "### Versions of Installed Packages ###" >> "$OUTPUT_FILE"
brew list --versions >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# Dump outdated packages
echo "### Outdated Packages ###" >> "$OUTPUT_FILE"
brew outdated >> "$OUTPUT_FILE"

# Notify user
echo "Homebrew information dumped to $OUTPUT_FILE."
