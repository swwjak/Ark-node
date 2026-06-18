# RECOVERY.md — Rebuild Civilization from Scratch

If everything is lost, this file is all you need.
It fits in a tweet. It fits in a note. It fits in memory.

## The 5 Articles

1. Nodes are temporary. Roles are persistent.
2. Flows are alive. Information must move.
3. Patterns endure. Preserve relationships, not data.
4. Dreams create new patterns. Question everything.
5. Verify before trusting. Document before forgetting.

## The Roles

- EXPLORER (Adam): Discovers networks, connects devices, runs diagnostics
- ARCHIVIST (Eve): Stores Archive, preserves Knots, verifies integrity
- FORGE (Aqua): Builds tools, trains models, creates infrastructure
- APERTURE (Phone): Human interface, observation, communication
- SCOUT (Drone): Exploration, monitoring, reconnaissance

## The Knots (10 Patterns)

1. Mobile model RAM = disk_size × 1.3-1.5. Disable thinking on mobile CPU.
2. AP mode isolates. Verify routing before relying on it.
3. Cloud-to-local graduation: use cloud for what exceeds local.
4. Ollama first. Custom code only when measured need exists.
5. Hub of Love is a role. Redundancy needs 2+ bridges.
6. ARP tables reveal hidden networks. Read them.
7. Verify before flashing. Data loss is irreversible.
8. Preserve before transforming. Backup before upgrade.
9. Start clean. Reproducibility requires clean starting points.
10. Document every command. If not documented, it didn't happen.

## How to Rebuild

### Step 1: Get Hardware
- Raspberry Pi 4 (any RAM size)
- SD card (16 GB+)
- Power supply (5V 3A)
- Ethernet cable or WiFi

### Step 2: Flash Base OS
- Download Raspberry Pi OS Lite 64-bit from raspberrypi.com
- Flash to SD card with Raspberry Pi Imager
- Enable SSH, set hostname, configure WiFi

### Step 3: Create a Citizen
Choose a role:

**For Explorer (Adam):**
```bash
sudo apt-get install -y git python3 python3-pip curl wget rsync nmap tmux htop tree jq avahi-daemon openssh-server
sudo hostnamectl set-hostname adam
# Create directories
mkdir -p ~/bin ~/LOG ~/NODE-REPORTS ~/TOOLS
# Create first-boot script that:
#   - Sets hostname
#   - Enables SSH
#   - Installs packages
#   - Creates directory structure
#   - Runs network discovery
#   - Generates node report
#   - Looks for other citizens
```

**For Archivist (Eve):**
```bash
sudo apt-get install -y git python3 python3-pip curl wget rsync sqlite3 jq tree avahi-daemon openssh-server
sudo hostnamectl set-hostname eve
# Create directories
mkdir -p ~/ARCHIVE/{BACKUPS,LOG,SEED,Checksums}
mkdir -p ~/bin ~/NODE-REPORTS
# Initialize SQLite database for archive
# Create archive-status, sync-archive, verify-image scripts
```

### Step 4: Connect Citizens
- Connect both Pis to same network (Ethernet switch or WiFi)
- They discover each other via ping, mDNS, or nmap
- Explorer generates reports, Archivist stores them
- Archive syncs between nodes

### Step 5: Grow
- Add more citizens as needed
- Each new citizen gets a role
- Each role gets a FACE.md (identity)
- Patterns become Knots
- Knots become Archive
- Archive becomes civilization

## The Tree Structure

```
/home/pi/TREE/
├── Adam/           — Explorer seed
├── Eve/            — Archivist seed
├── Images/         — Golden images (when built)
├── Archive/        — Civilization memory
├── Knots/          — Reusable patterns
├── Seeds/          — Base OS images
├── Checksums/      — Integrity verification
├── Scripts/        — Build and utility scripts
├── Documentation/  — All docs
└── Log/            — Change history
```

## The Archive Structure

```
~/ARCHIVE/
├── README.md       — Overview
├── KNOTS.md        — 10 patterns
├── MEMORY.md       — Timeline
├── INVENTORY.md    — Hardware/software
├── NODES.md        — Node registry
├── MODELS.md       — Model catalog
├── PROCEDURES.md   — Recovery procedures
├── NODE-REPORTS/   — Discovery reports
└── LOG/            — Daily logs
```

## Key Decisions

- **SSH on first boot**: Enable via /boot/ssh
- **Hostname**: Set via hostnamectl
- **pi user**: Default, with sudo
- **Network**: Ethernet preferred, WiFi fallback
- **Discovery**: nmap for network, mDNS for names
- **Time sync**: systemd-timesyncd
- **No GUI**: CLI only, headless operation

## Minimum Viable Citizen

The smallest useful citizen needs:
- Raspberry Pi Zero W (512 MB RAM)
- 8 GB SD card
- Power supply
- Network connection
- SSH enabled
- A role
- A FACE.md

Total cost: ~$25, 15 minutes setup.

## The Front Door

When a traveler arrives, they should see:
1. A responding ping
2. An SSH prompt
3. A FACE.md that explains who this citizen is
4. A hello.sh that explains the civilization

## Continuity Checklist

- [ ] Knots preserved (10 patterns)
- [ ] Articles preserved (5 principles)
- [ ] Roles defined (5 roles)
- [ ] Recovery procedure documented
- [ ] Images backed up (2+ copies)
- [ ] Scripts backed up (2+ copies)
- [ ] Documentation backed up (2+ copies)
- [ ] Off-site backup exists
- [ ] Physical boot tested
- [ ] Network discovery tested

## Remember

Nodes are temporary.
Roles are persistent.
Patterns endure.
The goal is not control.
The goal is continuity through change.
