#!/bin/bash
# Update checksums after image modifications
# Run on Adam

TREE="/home/pi/TREE"

echo "Updating checksums..."

# Adam.img
cd "$TREE/Images"
sha256sum Adam.img > "$TREE/Checksums/Adam.img.sha256"
echo "Adam.img: $(cat $TREE/Checksums/Adam.img.sha256 | awk '{print $1}')"

# Eve.img
sha256sum Eve.img > "$TREE/Checksums/Eve.img.sha256"
echo "Eve.img: $(cat $TREE/Checksums/Eve.img.sha256 | awk '{print $1}')"

# Gzip files
sha256sum Adam.img.gz > "$TREE/Checksums/Adam.img.gz.sha256" 2>/dev/null
sha256sum Eve.img.gz > "$TREE/Checksums/Eve.img.gz.sha256" 2>/dev/null

echo "Checksums updated."