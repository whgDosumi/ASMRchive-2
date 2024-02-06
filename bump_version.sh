#!/bin/bash

# Read the last commit message
LAST_COMMIT_MSG=$(git log -1 --pretty=%B)

# Determine version bump type
VERSION_BUMP="patch"
if [[ "$LAST_COMMIT_MSG" == *"feat:"* ]]; then
  VERSION_BUMP="minor"
fi
if [[ "$LAST_COMMIT_MSG" == *"BREAKING CHANGE"* ]] || [[ "$LAST_COMMIT_MSG" == *"!:"* ]]; then
  VERSION_BUMP="major"
fi

# Get current version
CURRENT_VERSION=$(cat version.txt)

# Increment version
NEW_VERSION=$(python -c "import semver; print(semver.bump_${VERSION_BUMP}('${CURRENT_VERSION}'))")
echo $NEW_VERSION > version.txt

# Temporary file for new changelog content
TEMP_FILE=$(mktemp)

# Check if the first line of commit message starts with "-"
FIRST_LINE=$(echo "$LAST_COMMIT_MSG" | head -n 1)
if [[ "$FIRST_LINE" == -* ]]; then
  FORMATTED_COMMIT_MSG="$LAST_COMMIT_MSG"
else
  FORMATTED_COMMIT_MSG="- $LAST_COMMIT_MSG"
fi

# Format new changelog entry
{
    echo "## $NEW_VERSION - $(date +%Y-%m-%d)"
    echo "$FORMATTED_COMMIT_MSG"
    echo
} > $TEMP_FILE

# Append existing changelog to the new content
cat CHANGELOG.md >> $TEMP_FILE

# Replace old changelog with new content
mv $TEMP_FILE CHANGELOG.md

# Commit changes
git add version.txt CHANGELOG.md
git commit -m "chore(release): bump version to $NEW_VERSION [skip ci]"