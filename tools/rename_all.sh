#!/bin/bash

# Set the source directory where files are located
source_dir="../content/blog"

# Set the destination directory where you want to move files
dest_dir="../content/blog.new"

# Iterate through files in the source directory
for file in "$source_dir"/*.md; do
  if [[ -f "$file" ]]; then
    # Extract the timestamp (YYYY-MM-DD) from the filename
    timestamp="${file##*/}"
    year="${timestamp:0:4}"
    month="${timestamp:5:2}"
    day="${timestamp:8:2}"

    # Create the destination directory based on YYYY/MM/DD pattern
    dest_subdir="$dest_dir/$year/$month/$day"

    # Create the destination directory if it doesn't exist
    mkdir -p "$dest_subdir"

    # Move the file to the destination directory
    cp "$file" "$dest_subdir/"

    echo "Moved $file to $dest_subdir/"
  fi
done
