name: Update Releases

on:
  push:
    branches:
      - main  # Trigger on pushes to the main branch (adjust as necessary)

jobs:
  update-release:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Get the latest release tag
        id: get_latest_release
        run: |
          latest_tag=$(gh release list)
          echo "::set-output name=latest_tag::$latest_tag"

      - name: Get changed files since latest release
        id: get_changes
        run: |
          latest_tag=${{ steps.get_latest_release.outputs.latest_tag }}
          git fetch origin $latest_tag --depth=1
          git diff --name-only $latest_tag HEAD > changed_files.txt
          echo "::set-output name=changed_files::$(cat changed_files.txt | tr '\n' ' ')"

      - name: Upload changed files to the release
        if: steps.get_changes.outputs.changed_files != ''
        run: |
          latest_tag=${{ steps.get_latest_release.outputs.latest_tag }}
          changed_files=$(cat changed_files.txt)

          for file in $changed_files; do
            if [ -f "$file" ]; then
              gh release upload $latest_tag $file --clobber
              echo "Uploaded $file to release $latest_tag"
            fi
          done
