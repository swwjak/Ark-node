#!/bin/bash
# pi3-role-archive.sh — Setup Pi 3 as Archive node
# Run after pi3-boot.sh

set -e

echo "=== Pi 3 Archive Setup ==="

# Install archive-specific packages
sudo apt install -y -qq sqlite3 ripgrep fd-find tree

# Create archive directory structure
mkdir -p /home/pi/archive/{index,backup,metadata}

# Create simple index script
cat > /home/pi/archive/index.sh << 'INDEXEOF'
#!/bin/bash
# Index library files
LIBRARY="${1:-/library}"
OUTPUT="/home/pi/archive/index/files_$(date +%Y%m%d).txt"
echo "Indexing $LIBRARY..."
find "$LIBRARY" -type f -name "*.md" -o -name "*.txt" -o -name "*.json" | sort > "$OUTPUT"
echo "Indexed $(wc -l < "$OUTPUT") files to $OUTPUT"
INDEXEOF
chmod +x /home/pi/archive/index.sh

echo "=== Archive setup complete ==="
echo "Run /home/pi/archive/index.sh /library to index files"