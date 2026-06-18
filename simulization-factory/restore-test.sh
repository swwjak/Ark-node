#!/bin/bash
# restore-test.sh — Prove recovery works
# Run on Adam. Simulates total loss by:
# 1. Verifying every file needed for recovery exists
# 2. Verifying every file is readable
# 3. Verifying checksums match
# 4. Verifying mount + contents
# 5. Generating a recovery score

set -e

TREE="/home/pi/TREE"
PASS=0
FAIL=0
WARN=0

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "ok" ]; then
        echo "  [PASS] $desc"
        PASS=$((PASS + 1))
    elif [ "$result" = "warn" ]; then
        echo "  [WARN] $desc"
        WARN=$((WARN + 1))
    else
        echo "  [FAIL] $desc"
        FAIL=$((FAIL + 1))
    fi
}

echo "========================================="
echo "  RECOVERY PROOF TEST"
echo "  $(date)"
echo "========================================="

# === Test 1: Tree exists ===
echo ""
echo "--- [1] Tree Structure ---"
[ -d "$TREE" ] && check "Tree directory exists" ok || check "Tree directory exists" fail
[ -d "$TREE/Images" ] && check "Images directory" ok || check "Images directory" fail
[ -d "$TREE/Adam" ] && check "Adam seed" ok || check "Adam seed" fail
[ -d "$TREE/Eve" ] && check "Eve seed" ok || check "Eve seed" fail
[ -d "$TREE/Seeds" ] && check "Seeds directory" ok || check "Seeds directory" fail
[ -d "$TREE/Documentation" ] && check "Documentation" ok || check "Documentation" fail
[ -d "$TREE/Checksums" ] && check "Checksums" ok || check "Checksums" fail

# === Test 2: Images exist and are readable ===
echo ""
echo "--- [2] Image Integrity ---"
[ -f "$TREE/Images/Adam.img" ] && check "Adam.img exists" ok || check "Adam.img exists" fail
[ -f "$TREE/Images/Eve.img" ] && check "Eve.img exists" ok || check "Eve.img exists" fail
[ -r "$TREE/Images/Adam.img" ] && check "Adam.img readable" ok || check "Adam.img readable" fail
[ -r "$TREE/Images/Eve.img" ] && check "Eve.img readable" ok || check "Eve.img readable" fail

# Check sizes (should be ~7.8 GB)
ADAM_SIZE=$(stat -c%s "$TREE/Images/Adam.img" 2>/dev/null || echo 0)
EVE_SIZE=$(stat -c%s "$TREE/Images/Eve.img" 2>/dev/null || echo 0)
[ "$ADAM_SIZE" -gt 7000000000 ] && check "Adam.img size: $((ADAM_SIZE/1024/1024/1024)) GB" ok || check "Adam.img size: $((ADAM_SIZE/1024/1024/1024)) GB (too small)" fail
[ "$EVE_SIZE" -gt 7000000000 ] && check "Eve.img size: $((EVE_SIZE/1024/1024/1024)) GB" ok || check "Eve.img size: $((EVE_SIZE/1024/1024/1024)) GB (too small)" fail

# === Test 3: Checksums match ===
echo ""
echo "--- [3] Checksum Verification ---"
if [ -f "$TREE/Checksums/Adam.img.sha256" ]; then
    EXPECTED=$(cat "$TREE/Checksums/Adam.img.sha256" | awk '{print $1}')
    ACTUAL=$(sha256sum "$TREE/Images/Adam.img" | awk '{print $1}')
    [ "$EXPECTED" = "$ACTUAL" ] && check "Adam.img checksum" ok || check "Adam.img checksum MISMATCH" fail
else
    check "Adam.img checksum file" fail
fi

if [ -f "$TREE/Checksums/Eve.img.sha256" ]; then
    EXPECTED=$(cat "$TREE/Checksums/Eve.img.sha256" | awk '{print $1}')
    ACTUAL=$(sha256sum "$TREE/Images/Eve.img" | awk '{print $1}')
    [ "$EXPECTED" = "$ACTUAL" ] && check "Eve.img checksum" ok || check "Eve.img checksum MISMATCH" fail
else
    check "Eve.img checksum file" fail
fi

# === Test 4: Mount and verify contents ===
echo ""
echo "--- [4] Mount Test ---"
MOUNT="/tmp/recovery-test"
mkdir -p "$MOUNT"

# Adam
LOOP_A=$(sudo losetup --find --show --partscan "$TREE/Images/Adam.img")
sleep 2
sudo partprobe "$LOOP_A" 2>/dev/null || true
sleep 1
if sudo mount "${LOOP_A}p2" "$MOUNT/adam" 2>/dev/null; then
    check "Adam.img mounts" ok
    [ -f "$MOUNT/adam/home/pi/first-boot.sh" ] && check "Adam first-boot.sh" ok || check "Adam first-boot.sh" fail
    [ -f "$MOUNT/adam/boot/first-boot" ] && check "Adam first-boot marker" ok || check "Adam first-boot marker" fail
    [ -f "$MOUNT/adam/boot/ssh" ] && check "Adam SSH" ok || check "Adam SSH" fail
    [ "$(cat $MOUNT/adam/etc/hostname 2>/dev/null)" = "adam" ] && check "Adam hostname" ok || check "Adam hostname" fail
    sudo umount "$MOUNT/adam" 2>/dev/null || true
else
    check "Adam.img mounts" fail
fi
sudo losetup -d "$LOOP_A" 2>/dev/null || true

# Eve
LOOP_E=$(sudo losetup --find --show --partscan "$TREE/Images/Eve.img")
sleep 2
sudo partprobe "$LOOP_E" 2>/dev/null || true
sleep 1
if sudo mount "${LOOP_E}p2" "$MOUNT/eve" 2>/dev/null; then
    check "Eve.img mounts" ok
    [ -f "$MOUNT/eve/home/pi/first-boot.sh" ] && check "Eve first-boot.sh" ok || check "Eve first-boot.sh" fail
    [ -f "$MOUNT/eve/boot/first-boot" ] && check "Eve first-boot marker" ok || check "Eve first-boot marker" fail
    [ -f "$MOUNT/eve/boot/ssh" ] && check "Eve SSH" ok || check "Eve SSH" fail
    [ "$(cat $MOUNT/eve/etc/hostname 2>/dev/null)" = "eve" ] && check "Eve hostname" ok || check "Eve hostname" fail
    [ -f "$MOUNT/eve/home/pi/ARCHIVE/KNOTS.md" ] && check "Eve KNOTS.md" ok || check "Eve KNOTS.md" fail
    [ -f "$MOUNT/eve/home/pi/ARCHIVE/MEMORY.md" ] && check "Eve MEMORY.md" ok || check "Eve MEMORY.md" fail
    [ -f "$MOUNT/eve/home/pi/ARCHIVE/INVENTORY.md" ] && check "Eve INVENTORY.md" ok || check "Eve INVENTORY.md" fail
    sudo umount "$MOUNT/eve" 2>/dev/null || true
else
    check "Eve.img mounts" fail
fi
sudo losetup -d "$LOOP_E" 2>/dev/null || true

# === Test 5: Seeds exist ===
echo ""
echo "--- [5] Recovery Seeds ---"
[ -f "$TREE/Adam/first-boot.sh" ] && check "Adam seed script" ok || check "Adam seed script" fail
[ -f "$TREE/Eve/first-boot.sh" ] && check "Eve seed script" ok || check "Eve seed script" fail
[ -f "$TREE/Seeds/base-raspios.img.xz" ] && check "Base Raspios image" ok || check "Base Raspios image" fail
[ -f "$TREE/Documentation/FLASHING.md" ] && check "FLASHING.md" ok || check "FLASHING.md" fail
[ -f "$TREE/Documentation/FIRST-BOOT.md" ] && check "FIRST-BOOT.md" ok || check "FIRST-BOOT.md" fail
[ -f "$TREE/Documentation/RECOVERY.md" ] && check "RECOVERY.md" ok || check "RECOVERY.md" fail
[ -f "$TREE/Knots/KNOTS.md" ] && check "KNOTS.md" ok || check "KNOTS.md" fail
[ -f "$TREE/Archive/MEMORY.md" ] && check "MEMORY.md" ok || check "MEMORY.md" fail
[ -f "$TREE/Archive/INVENTORY.md" ] && check "INVENTORY.md" ok || check "INVENTORY.md" fail

# === Test 6: Documentation completeness ===
echo ""
echo "--- [6] Documentation ---"
[ -f "$TREE/Documentation/RECOVERY.md" ] && check "Recovery procedure" ok || check "Recovery procedure" fail
[ -f "$TREE/Documentation/FLASHING.md" ] && check "Flashing guide" ok || check "Flashing guide" fail
[ -f "$TREE/Documentation/FIRST-BOOT.md" ] && check "First-boot behavior" ok || check "First-boot behavior" fail
[ -f "$TREE/Documentation/ROLE-MANIFEST.md" ] && check "Role definitions" ok || check "Role definitions" fail

# === Test 7: Phone backup ===
echo ""
echo "--- [7] Phone Backup ---"
PHONE_ARCHIVE="/data/data/com.termux/files/home/ARCHIVE"
[ -d "$PHONE_ARCHIVE" ] && check "Phone archive exists" ok || check "Phone archive exists" fail
[ -f "$PHONE_ARCHIVE/KNOTS.md" ] && check "Phone KNOTS.md" ok || check "Phone KNOTS.md" fail
[ -f "$PHONE_ARCHIVE/RECOVERY.md" ] && check "Phone RECOVERY.md" ok || check "Phone RECOVERY.md" fail
[ -f "$PHONE_ARCHIVE/simulization-factory/Adam.img.gz" ] && check "Phone Adam.img.gz" ok || check "Phone Adam.img.gz" fail
[ -f "$PHONE_ARCHIVE/simulization-factory/Eve.img.gz" ] && check "Phone Eve.img.gz" ok || check "Phone Eve.img.gz" fail

# Cleanup
rm -rf "$MOUNT"

# === Score ===
TOTAL=$((PASS + FAIL + WARN))
echo ""
echo "========================================="
echo "  RESULTS: $PASS pass, $FAIL fail, $WARN warn (of $TOTAL)"
echo "========================================="

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "  RECOVERY IS PROVEN."
    echo "  Every component needed for total restoration exists and is intact."
    echo ""
    echo "  What's still unproven:"
    echo "  - Physical boot on real hardware (needs blank SD + Pi)"
    echo "  - GitHub off-site backup (needs SSH key)"
    echo "  - Internet on Adam (needs NAT)"
    exit 0
else
    echo ""
    echo "  RECOVERY HAS GAPS."
    echo "  $FAIL critical component(s) missing."
    exit 1
fi