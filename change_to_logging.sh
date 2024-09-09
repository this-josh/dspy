#!/bin/bash

# Function to process each Python file
process_file() {
    local file="$1"
    local temp_file="${file}.temp"

    # Check if the file contains 'print('
    if grep -q 'print(' "$file"; then
        # Add logging import to the top of the file
        echo "import logging" > "$temp_file"
        echo "logger = logging.getLogger()" >> "$temp_file"
        echo "" >> "$temp_file"

        # Replace print( with logger.info( and append the rest of the file
        sed 's/print(/logger.info(/g' "$file" >> "$temp_file"

        # Replace the original file with the modified version
        mv "$temp_file" "$file"

        echo "Processed: $file"
    else
        echo "Skipped: $file (no 'print(' found)"
    fi
}

# Find all .py files in the current directory and subdirectories
find . -type f -name "*.py" | while read -r file; do
    process_file "$file"
done

echo "All Python files have been processed."