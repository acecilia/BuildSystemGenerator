#!/bin/bash
# Execute XcodeGen and generate all xcode projects recursively

# Fail if exit code is not zero, in pipes, and also if variable is not set
# See: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -eou pipefail

total_count=0
generated_count=0

for f in $(find . -name 'project.yml' | sort -n); do
  # Only create the project if it is not there already
  directory=$(dirname "$f")
  xcodeproj_files=$(find "$directory" -maxdepth 1 -name "*.xcodeproj")
  if [ -z "$xcodeproj_files" ]; then
    xcodegen --spec "$f"
    ((generated_count++))
  fi
  ((total_count++))
done

echo "✨ Done"
echo "✨ Number of 'project.yml' files detected: ${total_count}"
echo "✨ Number of projects generated: ${generated_count}"