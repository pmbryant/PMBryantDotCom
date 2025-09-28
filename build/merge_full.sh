#!/bin/bash

set -e

HUGO_DIR="pmbryant-hugo"

if [ ! -d "$HUGO_DIR" ]; then
    echo "ERROR: This script must be run from within the root dir of this project and there must be a $HUGO_DIR directory inside it."
    exit 1
fi

DEST_DIR="public"

# Remove all contents of destination directory if it exists
if [ -d "$DEST_DIR" ]; then
    rm -rf "$DEST_DIR"/*
fi

cd "$HUGO_DIR"
hugo --buildDrafts --cleanDestinationDir --destination "../$DEST_DIR"
cd -

# Function to merge subdirectories from a source into destination
merge_subdirs() {
    src_dir="$1"
    for sub in "$src_dir"/*; do
        if [ -d "$sub" ]; then
            subname=$(basename "$sub")
            # Rename pmbryant.typepad.com to x
            if [ "$subname" = "pmbryant.typepad.com" ]; then
                subname="x"
            fi
            mkdir -p "$DEST_DIR/$subname"
            cp -a "$sub"/. "$DEST_DIR/$subname/"
        fi
    done
}

merge_subdirs "bb-blog"

merge_subdirs "lyg-blog"

echo "Merge complete."
