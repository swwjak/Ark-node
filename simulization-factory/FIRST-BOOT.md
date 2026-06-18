# FIRST-BOOT.md — What Happens When a Node Wakes Up

## Overview
When a fresh Adam or Eve node boots for the first time, it automatically configures itself for its role. No manual intervention needed.

## Common First Boot (Both Nodes)

### Step 1: System Setup
- Set hostname (adam or eve)
- Enable SSH
- Start Avahi/mDNS
- Configure networking
- Expand filesystem

### Step 2: Identity
- Generate node ID
- Create role directories
- Initialize local log

### Step 3: Discovery
- Scan local network
- Attempt to find the other node
- Report findings

## Adam First Boot

### Step 4a: Adam Setup
- Install role-specific packages
- Configure network tools
- Set up discovery scripts
- Start diagnostic services

### Step 5a: Adam Discovery
- Run `discover-network.sh`
- Run `find-eve.sh`
- Generate `node-report.sh`
- Save report to ~/NODE-REPORTS/

### Step 6a: Adam Report
- Display findings on console
- If Eve is found: send report to Eve
- If Eve not found: log and retry

## Eve First Boot

### Step 4b: Eve Setup
- Create archive directory structure
- Initialize SQLite database
- Configure archive services
- Set up verification tools

### Step 5b: Eve Archive
- Mount archive storage
- Initialize KNOTS.md, MEMORY.md, INVENTORY.md
- Start archive sync service
- Begin listening for node reports

### Step 6b: Eve Verification
- Verify archive integrity
- Generate checksums
- Log first-boot results
- Wait for Adam's report

## After First Boot

### Adam
- Continues network exploration
- Sends periodic reports to Eve
- Builds tools as needed
- Assists with setup and recovery

### Eve
- Maintains archive
- Verifies incoming reports
- Preserves discoveries
- Generates new images when needed

## Recovery
If a node fails:
1. Flash a new SD card from Eve's image
2. Boot the new node
3. First-boot runs automatically
4. Node rejoins civilization
5. No data lost (preserved in Archive)
