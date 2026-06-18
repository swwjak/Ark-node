# INVENTORY — Local AI Civilization
## Complete Hardware and Software Inventory

**Date:** 2026-06-17
**Compiled by:** OWL (Hermes Agent) on Galaxy S22 Ultra

---

## 1. HARDWARE INVENTORY

### 1.1 Active Nodes

#### galaxy-s22 (THIS DEVICE) — Role: APERTURE + FORGE (light)
- **Device:** Samsung Galaxy S22 Ultra 5G
- **OS:** Android 13 (Kernel 4.19.113, aarch64)
- **CPU:** AArch64 (8 cores)
- **RAM:** 10 GB total (~3.3 GB available)
- **Storage:** 108 GB total (~48 GB available)
- **Swap:** 4 GB (1.5 GB used)
- **Connectivity:** WiFi, cellular, USB OTG, Bluetooth
- **Termux:** Full development environment
- **Ollama:** Installed (v0.30.8), model: Qwen3-4B (2.4 GB GGUF Q3_K_M)
- **Status:** ACTIVE — Primary human interface, light inference

#### pi4-1 — Role: CITY
- **Device:** Raspberry Pi 4 Model B (4 GB)
- **OS:** Debian 12 (aarch64)
- **Hostname:** ScottNet (SSID)
- **IP:** 10.98.79.63 (AP mode)
- **Subnet:** 10.98.79.0/24
- **Password:** sc0ttnet
- **Services:** Ollama (llama3.1), OpenSCAD nightly (Manifold backend)
- **ADB:** v33.0.3-debian
- **Status:** ACTIVE but currently unreachable (no upstream internet on AP)
- **Note:** Phone loses cellular data when connected to Pi AP

#### aqua-1 — Role: FORGE (primary)
- **Device:** ASRock X570 Aqua (limited ATX)
- **CPU:** Ryzen 9 5900X
- **RAM:** 64 GB
- **Storage:** 2x 512 GB NVMe
- **GPU:** 2x GTX 1080 FE HB SLI
- **PSU:** Corsair HX1200i (replacement arriving 2026-06-18)
- **OS:** Windows (to be wiped for Linux)
- **Purpose:** Local LLM inference, SCAD with Manifold
- **Status:** STANDBY — PSU replacement pending

#### gear-s3 — Role: APERTURE (secondary)
- **Device:** Samsung Gear S3 Frontier (SM-R765A)
- **OS:** Tizen 4.0.0.7
- **Dev/Debug:** ON
- **WiFi Direct:** 10.144.28.8
- **SSH:** 10.144.28.147:8022
- **sdb:** ~/sdb-source/bin/sdb
- **Status:** STANDBY — sdb daemon needs Tizen Studio trigger

### 1.2 Standby / Offline Nodes

#### zero-1 — Role: ARK (primary)
- **Device:** Raspberry Pi Zero W
- **Location:** Ark bag (portable)
- **Capabilities:** USB gadget, file serving, SSH, emergency WiFi
- **Storage:** 16GB SD + cargo
- **Status:** ACTIVE (portable, not currently connected)

#### zero-2 — Role: ARK (backup)
- **Device:** Raspberry Pi Zero W
- **Location:** Home office (off-site)
- **Status:** STANDBY

#### rpi3-{1-4} — Role: CITY (3D printing farm)
- **Device:** 4x Raspberry Pi 3 Model B+
- **Connected to:** 4x Ender 2 3D printers
- **Purpose:** OctoPrint, printer control
- **Status:** ACTIVE (on home network, unreachable from here)

#### ardrone-1 — Role: SCOUT
- **Device:** AR Drone 2.0
- **Capabilities:** Camera, flight, wireless reconnaissance
- **Status:** STANDBY

#### shield-1 — Role: APERTURE (secondary)
- **Device:** NVIDIA Shield Tablet
- **Status:** ACTIVE (on home network)

#### rampage-1 — Role: FORGE (secondary)
- **Device:** Rampage IV Gene workstation
- **Status:** STANDBY (in storage)

### 1.3 Network Infrastructure

#### switch-1 — Role: TRADE ROUTE
- **Device:** Managed network switch
- **Capabilities:** VLAN, QoS, port management
- **Status:** ACTIVE (on home network)

#### router-1 — Role: NAVIGATOR
- **Device:** Router
- **Capabilities:** Routing, firewall, DHCP, DNS, VPN
- **Status:** ACTIVE (on home network)

---

## 2. SOFTWARE INVENTORY

### 2.1 This Device (Termux on Galaxy S22)

#### Runtime Environments
| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.13.13 | General scripting, ML |
| Node.js | 26.3.0 | Web services, code-server |
| Go | 1.26.3 | Compiled services |
| Rust | 1.95.0 | Compiled services |
| Clang | 21.1.8 | C/C++ compilation |
| CMake | 4.3.3 | Build system |
| OpenJDK | 17, 21 | Java/Kotlin/Gradle |
| Dart | latest | Flutter |

#### Key Termux Packages
- **Development:** git, vim, nano, micro, cmake, clang, make, pkg-config, autoconf, automake
- **Networking:** openssh, nmap, net-tools, curl, wget, libpcap
- **Media:** ffmpeg, mpv, imlib2
- **Utilities:** tmux, htop, tree, fzf, ripgrep, fd, bat, jq, dos2unix
- **Android:** android-tools (adb), termux-api, proot, proot-distro
- **ML/AI:** ollama (v0.30.8)

#### ML/AI Software
| Software | Status | Notes |
|----------|--------|-------|
| Ollama | Installed, not running | v0.30.8, Qwen3-4B model |
| PyTorch | NOT installed | Would need pip install |
| Transformers | NOT installed | Would need pip install |
| llama-cpp-python | NOT installed | Would need pip install |
| ctransformers | NOT installed | Would need pip install |

#### Services
| Service | Status | Notes |
|---------|--------|-------|
| code-server | Installed | v4.122.0-linux-arm64 |
| Hermes Gateway | Installed | Cloud-assisted AI agent |
| Ollama | Installed, not running | Needs manual start |

### 2.2 Pi 4 (CITY)
| Software | Notes |
|----------|-------|
| Ollama | Running llama3.1 |
| OpenSCAD nightly | Manifold backend replacing CGAL |
| Docker | Available |
| Web server, DNS, DHCP | Infrastructure services |

### 2.3 Aqua X570 (FORGE)
| Software | Notes |
|----------|-------|
| Windows (current) | To be replaced with Linux |
| Planned: Linux | For LLM inference + SCAD |
| Planned: Ollama | Local model serving |
| Planned: OpenSCAD + Manifold | CAD design |

---

## 3. LOCAL MODELS

### 3.1 Galaxy S22 (This Device)

#### Qwen3-4B (GGUF Q3_K_M)
- **Location:** ~/.ollama/models/blobs/sha256-3e4cb... (2.4 GB)
- **Format:** GGUF (v3)
- **Quantization:** Q3_K_M (3-bit, medium quality)
- **Architecture:** Qwen3
- **Parameters:** 4B
- **Context:** Unknown (likely 32K-128K)
- **Template:** ChatML variant with thinking support
- **Params:** temp=0.6, top_k=20, top_p=0.95, repeat_penalty=1
- **License:** Apache 2.0
- **Status:** Downloaded, Ollama installed but not running
- **RAM requirement:** ~3-4 GB estimated (fits in 10 GB with swap)

### 3.2 Pi 4 (CITY)

#### llama3.1
- **Served by:** Ollama on Pi 4
- **Status:** Running on home network (currently unreachable)
- **RAM requirement:** Fits in 4 GB Pi RAM (likely 8B Q4 quant)

### 3.3 Cloud Models (via OpenRouter)

#### owl-alpha (current)
- **Provider:** OpenRouter
- **Role:** Teacher / General intelligence
- **Status:** Active (this session)
- **Cost:** Per-token

---

## 4. BOTTLENECK ANALYSIS

### 4.1 Critical Bottlenecks

1. **Ollama not running on S22** — Model is downloaded but not serving. Biggest immediate gap.
2. **No GPU acceleration on S22** — CPU-only inference on Cortex-A78/A55 cores. Slow but functional for 4B Q3.
3. **Pi 4 unreachable** — No upstream internet on AP mode. Phone loses cellular when connected. Need routing fix.
4. **Aqua X570 PSU DOA** — Primary FORGE node offline. Replacement arriving 2026-06-18.
5. **No PyTorch/transformers on S22** — Python ML ecosystem not installed. Only Ollama available.
6. **Limited RAM on S22** — 10 GB total, ~3.3 GB available. 4B Q3 model fits but leaves little headroom.
7. **No model specialization** — Only general-purpose models. No fine-tuned specialists.

### 4.2 Complexity Reduction Opportunities

1. **Remove Gradle/Android SDK** — 2.6 GB of Android firmware + Gradle cache. Not needed for AI work.
2. **Remove code-server** — 290 MB. Not actively used. Can reinstall if needed.
3. **Consolidate models** — Qwen3-4B is good for general use. Don't add more until this one is working.
4. **Simplify network** — Pi AP needs NAT/routing to share cellular. Or use a travel router.

---

## 5. SHORTEST PATH TO LOCAL INTELLIGENCE

### Phase 1: Bootstrap (NOW)
1. Start Ollama on S22 with Qwen3-4B
2. Verify inference works
3. Measure tokens/sec and quality
4. Create basic Archive structure

### Phase 2: Hybrid (THIS WEEK)
1. Fix Pi 4 routing (share cellular or add travel router)
2. Access Pi 4's llama3.1 remotely
3. Distribute tasks: S22 for light inference, Pi 4 for medium
4. Begin documenting procedures in Archive

### Phase 3: Local-First (THIS MONTH)
1. Aqua X570 comes online with PSU replacement
2. Install Linux + Ollama + larger models (13B-70B with 64GB RAM + dual 1080)
3. S22 becomes APERTURE only, heavy lifting moves to Aqua
4. Create first specialist models

### Phase 4: Self-Improving (ONGOING)
1. Teachers (cloud) create specialists (local)
2. Specialists perform work, generate experience
3. Experience becomes memory in Archive
4. Memory becomes patterns and knots
5. Knots improve future specialists
