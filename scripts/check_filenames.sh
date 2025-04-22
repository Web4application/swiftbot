function remove_valid_names() {
  sed '
    # Xcode-generated asset files
    /Assets.xcassets/ d

    # Files without spaces
    /^[^ ]*$/ d
  '
}

count=$(git ls-files | remove_valid_names | wc -l | xargs)

if [[ ${count} != 0 ]]; then
  echo 'ERROR: Spaces in filenames are not permitted in this repo. Please fix.'
  echo ''

  git ls-files | remove_valid_names
  exit 1
fi
