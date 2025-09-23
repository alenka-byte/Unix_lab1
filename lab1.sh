#!/bin/sh 

file=$1

if [ ! -f "$file" ]; then
   echo "Error: File '$file'  not found"
   exit 1
fi

if grep -q "&Output:" "$file"; then
   output=$(grep "&Output:" "$file" | cut -d: -f2- | xargs)
else
   exit 1;
fi

tmp=$(mktemp -d) || exit 1

cp "$file" "$tmp/"
cd "$tmp" || exit 1

echo "Compiling $file -> $output"
if g++ "$(basename "$file")" -o "$output"; then
   cp "$output" "$(dirname "$file")/"
   echo "Success: Output copied to $(dirname "$file")/$output"
else
   echo "Complilation failed"
   exit 1
fi
