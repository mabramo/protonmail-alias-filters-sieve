#!/bin/bash

# Check if an input file was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

input_file="$1"
output_file="sieve-filters.out"

# Start Sieve script with required capabilities
printf 'require ["fileinto", "regex"];\n' > "$output_file"

declare -A folders

# Read the CSV line by line
while IFS=, read -r first _ _ email _ _ _ _ _ _ last; do
  # Skip lines where the first value is not "alias" or email/last is empty
  if [ "$first" != "alias" ] || [ -z "$email" ] || [ -z "$last" ]; then
    continue
  fi

  # Use the last field as folder name without modification (allow spaces)
  folder="$last"

  # Remove any potential hidden characters like carriage return (\r)
  folder=$(echo "$folder" | tr -d '\r')

  # Group emails by folder (no need to check for duplicates)
  folders["$folder"]+="$email "
done < "$input_file"

# Generate Sieve rules
for folder in "${!folders[@]}"; do
  # Retrieve the emails
  emails="${folders[$folder]}"
  if [ -n "$emails" ]; then
    printf "if anyof (\n" >> "$output_file"
    
    # Process each email in the list and add it to the rule
    emails_arr=($emails)
    for i in "${!emails_arr[@]}"; do
      email="${emails_arr[$i]}"
      email=$(echo "$email" | xargs)  # Trim any extra whitespace
      if [ -n "$email" ]; then
        if [ "$i" -eq $((${#emails_arr[@]} - 1)) ]; then
          # No comma after the last email
          printf "  address :is \"to\" \"%s\"\n" "$email" >> "$output_file"
        else
          printf "  address :is \"to\" \"%s\",\n" "$email" >> "$output_file"
        fi
      fi
    done

    # Close the rule block and file into (no semicolon before fileinto)
    printf ") {\n" >> "$output_file"
    
    # Ensure correct fileinto format and no extraneous characters
    folder=$(echo "$folder" | tr -d '\r')  # Remove carriage return if present
    printf "  fileinto \"%s\";\n" "$folder" >> "$output_file"

    # Close the rule block
    printf "}\n\n" >> "$output_file"
  fi
done

# End of script message
echo "Sieve filters generated in $output_file"


