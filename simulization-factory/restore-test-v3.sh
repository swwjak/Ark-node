#!/bin/bash
# restore-test-v3.sh — Final recovery proof test
# Fixes: loop device cleanup, correct phone paths

set -e

TREE="/home/pi/TREE"
PASS=0
FAIL=0

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "ok" ]; then
        echo "  [PASS] $desc"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $desc"
        FAIL=$((FAIL + 1))
    fi
}

echo "========================================="
echo "  RECOVERY PROOF TEST v3"
echo "  $(date)"
echo "========================================="

# Cleanup ALL loop devices
sudo losetup -D 2>/dev/null || true
sleep 2

# === Test 1: Tree ===
echo ""
echo "--- [1] Tree Structure ---"
for dir in Images Adam Eve Seeds Documentation Checksums Archive Knots; do
    [ -d "$TREE/$dir" ] && check "$dir" ok || check "$dir" fail
done

# === Test 2: Images ===
echo ""
echo "--- [2] Image Integrity ---"
for img in Adam.img Eve.img; do
    [ -f "$TREE/Images/$img" ] && check "$img exists" ok || check "$img exists" fail
    [ -r "$TREE/Images/$img" ] && check "$img readable" ok || check "$img readable" fail
done

ADAM_SIZE=$(stat -c%s "$TREE/Images/Adam.img" 2>/dev/null || echo 0)
[ "$ADAM_SIZE" -gt 7000000000 ] && check "Adam.img size: $((ADAM_SIZE/1073741824)) GB" ok || check "Adam.img size" fail

EVE_SIZE=$(stat -c%s "$TREE/Images/Eve.img" 2>/dev/null || echo 0)
[ "$EVE_SIZE" -gt 7000000000 ] && check "Eve.img size: $((EVE_SIZE/1073741824)) GB" ok || check "Eve.img size" fail

# === Test 3: Checksums ===
echo ""
echo "--- [3] Checksums ---"
for img in Adam.img Eve.img; do
    EXPECTED=$(cat "$TREE/Checksums/${img}.sha256" 2>/dev/null | awk '{print $1}')
    ACTUAL=$(sha256sum "$TREE/Images/$img" 2>/dev/null | awk '{print $1}')
    [ "$EXPECTED" = "$ACTUAL" ] && check "$img checksum" ok || check "$img checksum MISMATCH" fail
done

# === Test 4: Mount ===
echo ""
echo "--- [4] Mount Test ---"
MOUNT="/tmp/recovery-proof-v3"
rm -rf "$MOUNT"
mkdir -p "$MOUNT/Adam" "$MOUNT/Eve"

for img in Adam.img Eve.img; do
    LOOP=$(sudo losetup --find --show --partscan "$TREE/Images/$img" 2>/dev/null)
    if [ -z "$LOOP" ]; then
        check "$img loop device" fail
        continue
    fi
    sleep 2
    sudo partprobe "$LOOP" 2>/dev/null || true
    sleep 1
    
    MOUNT_POINT="$MOUNT/${img%.img}"
    if sudo mount "${LOOP}p2" "$MOUNT_POINT" 2>/dev/null; then
        check "$img mounts" ok
        
        if [ "$img" = "Adam.img" ]; then
            [ -f "$MOUNT_POINT/home/pi/first-boot.sh" ] && check "Adam first-boot.sh" ok || check "Adam first-boot.sh" fail
            [ -f "$MOUNT_POINT/boot/first-boot" ] && check "Adam boot marker (in /boot/)" ok || check "Adam boot marker (in /boot/)" warn
            [ -f "$MOUNT_POINT/boot/ssh" ] && check "Adam SSH (in /boot/)" ok || check "Adam SSH (in /boot/)" warn
            HNAME=$(cat "$MOUNT_POINT/etc/hostname" 2>/dev/null)
            [ "$HNAME" = "adam" ] && check "Adam hostname: $HNAME" ok || check "Adam hostname: $HNAME" fail
        fi
        
        if [ "$img" = "Eve.img" ]; then
            [ -f "$MOUNT_POINT/home/pi/first-boot.sh" ] && check "Eve first-boot.sh" ok || check "Eve first-boot.sh" fail
            [ -f "$MOUNT_POINT/boot/first-boot" ] && check "Eve boot marker (in /boot/)" ok || check "Eve boot marker (in /boot/)" warn
            [ -f "$MOUNT_POINT/boot/ssh" ] && check "Eve SSH (in /boot/)" ok || check "Eve SSH (in /boot/)" warn
            HNAME=$(cat "$MOUNT_POINT/etc/hostname" 2>/dev/null)
            [ "$HNAME" = "eve" ] && check "Eve hostname: $HNAME" ok || check "Eve hostname: $HNAME" fail
            [ -f "$MOUNT_POINT/home/pi/ARCHIVE/KNOTS.md" ] && check "Eve KNOTS.md" ok || check "Eve KNOTS.md" fail
            [ -f "$MOUNT_POINT/home/pi/ARCHIVE/MEMORY.md" ] && check "Eve MEMORY.md" ok || check "Eve MEMORY.md" fail
            [ -f "$MOUNT_POINT/home/pi/ARCHIVE/INVENTORY.md" ] && check "Eve INVENTORY.md" ok || check "Eve INVENTORY.md" fail
        fi
        
        sudo umount "$MOUNT_POINT" 2>/dev/null || true
    else
        check "$img mounts" fail
    fi
    
    sudo losetup -d "$LOOP" 2>/dev/null || true
done

# === Test 5: Seeds ===
echo ""
echo "--- [5] Seeds ---"
[ -f "$TREE/Adam/first-boot.sh" ] && check "Adam seed" ok || check "Adam seed" fail
[ -f "$TREE/Eve/first-boot.sh" ] && check "Eve seed" ok || check "Eve seed" fail
[ -f "$TREE/Seeds/base-raspios.img.xz" ] && check "Base Raspios" ok || check "Base Raspios" fail

# === Test 6: Documentation ===
echo ""
echo "--- [6] Documentation ---"
for doc in FLASHING.md FIRST-BOOT.md RECOVERY.md ROLE-MANIFEST.md; do
    [ -f "$TREE/Documentation/$doc" ] && check "$doc" ok || check "$doc" fail
done

# === Test 7: Phone backup (run from phone, not Adam) ===
echo ""
echo "--- [7] Phone Backup ---"
if [ -f /data/data/com.termux/files/home/ARCHIVE/KNOTS.md ]; then
    check "Phone archive" ok
    [ -f /data/data/com.termux/files/home/ARCHIVE/KNOTS.md ] && check "Phone KNOTS.md" ok || check "Phone KNOTS.md" fail
    [ -f /data/data/com.termux/files/home/ARCHIVE/RECOVERY.md ] && check "Phone RECOVERY.md" ok || check "Phone RECOVERY.md" fail
    [ -f /data/data/com.termux/files/home/ARCHIVE/simulization-factory/Adam.img.gz ] && check "Phone Adam.img.gz" ok || check "Phone Adam.img.gz" fail
    [ -f /data/data/com.termux/files/home/ARCHIVE/simulization-factory/Eve.img.gz ] && check "Phone Eve.img.gz" ok || check "Phone Eve.img.gz" fail
else
    check "Phone archive (run this test from phone)" warn
fi

# Cleanup
rm -rf "$MOUNT"

# === Score ===
TOTAL=$((PASS + FAIL))
echo ""
echo "========================================="
echo "  RESULTS: $PASS pass, $FAIL fail (of $TOTAL)"
echo "========================================="

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "  RECOVERY IS PROVEN."
    exit 0
else
    echo ""
    echo "  GAPS: $FAIL items."
    exit 1
fi