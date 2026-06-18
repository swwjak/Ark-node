# SECURITY-AUDIT.md — Exposure Analysis

## Repository: swwjak/ark-node
## Date: 2026-06-18

---

## 1. FILE INVENTORY

### PUBLIC (safe for anyone to see)
| File | Content | Risk |
|------|---------|------|
| KNOTS.md | 10 patterns + 5 articles | None — knowledge only |
| FACES.md | Citizen identity format | None — roles, not people |
| FRONT-DOOR.md | Traveler greeting | None — public interface |
| ROLE-MANIFEST.md | Role definitions | None — architecture |
| FIRST-BOOT.md | First-boot behavior | None — process docs |
| README.md | Archive overview | None — public docs |
| CONTINUITY.md | Continuity procedures | None — process docs |
| RECOVERY.md | Rebuild from scratch | None — educational |
| TREE-FLOW.md | Information flow | None — architecture |
| TOPOLOGY.md | Network topology | LOW — see below |
| STEWARD-REPORT.md | Status report | None — operational |
| DAY1-SUMMARY.md | Day 1 summary | None — historical |
| PUSH-SUCCESS.md | Push confirmation | None — operational |
| GITHUB-SETUP.md | Setup instructions | None — public docs |
| GITHUB-STATUS.md | Auth status | None — operational |
| .gitignore | Git ignore rules | None — config |

### PRIVATE (identifies infrastructure)
| File | Content | Risk |
|------|---------|------|
| INVENTORY.md | Hardware/software details | MEDIUM — reveals device models, OS versions |
| NODES.md | Node registry with IPs | MEDIUM — reveals internal IPs |
| NODE-REPORT-ADAM-EVE.md | Detailed node report | MEDIUM — reveals MAC addresses, hostnames, subnets |
| MODELS.md | Model catalog | LOW — model names only |
| STAR-CHART.md | Relationship map | LOW — roles + IPs |
| VERIFICATION-REPORT.md | Verification results | LOW — confirms infrastructure exists |
| CONTINUITY-REPORT.md | Continuity status | LOW — confirms node existence |
| PROCEDURES.md | Recovery procedures | LOW — generic processes |
| simulization-factory/FLASHING.md | Flashing guide | LOW — generic instructions |
| simulization-factory/README.md | Factory overview | None — public docs |

### SECRET (grants access or identifies people)
| File | Content | Risk |
|------|---------|------|
| GITHUB-SETUP.md | Contains SSH public key | LOW — public key only, but identifies the key |
| LOG/2026-06-17.md | Contains email address | MEDIUM — swwjak69@gmail.com |
| LOG/2026-06-18.md | Contains email address | MEDIUM — swwjak69@gmail.com |
| NODE-REPORT-ADAM-EVE.md | Contains MAC addresses | MEDIUM — device fingerprints |
| TOPOLOGY.md | Contains internal IPs | MEDIUM — 10.98.79.x, 10.42.0.x |
| NODES.md | Contains internal IPs | MEDIUM — multiple subnets |
| PROCEDURES.md | Contains internal IPs | MEDIUM — 10.98.79.x |
| Various scripts | Contain internal IPs | MEDIUM — hardcoded addresses |

---

## 2. SENSITIVE INFORMATION FOUND

### Email Addresses
- `swwjak69@gmail.com` in LOG/2026-06-17.md, LOG/2026-06-18.md, STEWARD-REPORT.md, GITHUB-SETUP.md

### Internal IP Addresses
- `10.98.79.63` (Adam), `10.98.79.83` (Phone), `10.98.79.128`, `10.98.79.147`
- `10.42.0.1` (Adam eth0), `10.42.0.152` (Eve)
- `10.144.28.228` (Eve last known), `10.144.28.8` (Gear S3)
- `10.162.252.10` (home network)
- `10.36.156.7`, `10.60.202.118` (phone cellular)

### MAC Addresses
- `dc:a6:32:7f:95:76` (Adam eth0), `dc:a6:32:7f:95:77` (Adam wlan0)

### SSH Public Key
- `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZTA7k3oADGenqJ1PNcB3V2k4jhFrODIDuaxXvEWYM2 termux`
- This is a PUBLIC key — safe to share, but identifies the device

### Physical Locations
- "home" mentioned extensively (NODES.md, PROCEDURES.md, etc.)
- "office desk" (NODES.md)
- "Juneau, AK" (MEMORY.md — not in repo but in session context)

### Usernames
- `pi` — default Raspberry Pi user
- `swwjak` — GitHub username

### Passwords
- NONE found in repo files. Passwords were exchanged in session only.

### API Keys / Tokens
- NONE in repo files.

---

## 3. REPOSITORY HYGIENE

### Files That Should NOT Exist
| File | Reason | Action |
|------|--------|--------|
| GITHUB-SETUP.md | Contains SSH key, setup details | Move to PRIVATE or remove |
| GITHUB-STATUS.md | Contains auth troubleshooting | Remove — not knowledge |
| PUSH-SUCCESS.md | Transient status | Remove — not knowledge |
| CONTINUITY-REPORT.md | Contains internal IPs | Move to PRIVATE |
| STEWARD-REPORT.md | Contains internal details | Move to PRIVATE |
| simulization-factory/check-sshpass.sh | Build scaffolding | Remove |
| simulization-factory/diagnose-eve.sh | Debug script | Remove |
| simulization-factory/fix-eve-ssh.sh | Debug script | Remove |
| simulization-factory/identify-147.sh | Debug script | Remove |
| simulization-factory/investigate-147.sh | Debug script | Remove |
| simulization-factory/observe-flow.sh | Debug script | Remove |
| simulization-factory/push-key-to-eve.sh | One-time script | Remove |
| simulization-factory/restore-eve.sh | Debug script | Remove |
| simulization-factory/restore-test.sh | Test script | Remove |
| simulization-factory/restore-test-v2.sh | Test script | Remove |
| simulization-factory/restore-test-v3.sh | Test script | Remove |
| simulization-factory/update-checksums.sh | One-time script | Remove |
| simulization-factory/verify-adam-network.sh | Test script | Remove |
| simulization-factory/verify-eve.sh | Test script | Remove |
| simulization-factory/verify-eve-remote.sh | Test script | Remove |
| 63 | Accidental file | Remove |

### Files Safe for Public Documentation
All files in the PUBLIC list above.

---

## 4. RECOVERY REVIEW

### If GitHub Disappeared Tomorrow
- Phone has full Archive (22 files) ✅
- Adam SSD has Tree (images + seeds + docs) ✅
- Eve has nothing unique (same as Adam) ✅
- **Survival: COMPLETE** — GitHub is a convenience, not a requirement

### If Adam Disappeared Tomorrow
- Phone has all documentation ✅
- Phone has compressed images (Adam.img.gz, Eve.img.gz) ✅
- Eve is running but unreachable ✅
- **Survival: COMPLETE** — Rebuild from phone + GitHub

### If Eve Disappeared Tomorrow
- Adam has Tree + images ✅
- Phone has Archive ✅
- **Survival: COMPLETE** — Eve contributes nothing currently

### If Both Adam and Eve Disappeared
- Phone has everything needed to rebuild both ✅
- GitHub has all documentation ✅
- **Survival: COMPLETE** — Flash images, boot new Pis

### If Phone + Adam SSD Both Disappeared
- GitHub has documentation ✅
- Images NOT on GitHub ❌
- **Survival: PARTIAL** — Can rebuild procedures but need to re-create images from base Raspios

---

## 5. RECOMMENDED ACTIONS

### Immediate
1. Make repository private
2. Remove debug/test scripts from repo
3. Remove CONTINUITY-REPORT.md and STEWARD-REPORT.md (contain IPs)
4. Remove accidental file "63"

### Before Making Public Again
1. Create separate public repo for documentation only
2. Keep infrastructure details in private repo
3. Never commit passwords, tokens, or private keys

### Ongoing
1. Add .gitignore rule for *.sh (unless they're production scripts)
2. Review every commit for accidental sensitive data
3. Keep infrastructure inventory in private repo only
