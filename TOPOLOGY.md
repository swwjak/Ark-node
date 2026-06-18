# TOPOLOGY.md — Network Topology

## Current State (Pre-Netgear)

```
Phone (10.98.79.83) ←→ Adam (10.98.79.63)     [WiFi Direct / ScottNet AP]
                           ↕
                    Ethernet Hub (unmanaged)
                           ↕
                    Eve (10.42.0.152)          [DHCP from Adam, SSH blocked]
```

Problems:
- Adam and Eve on different subnets (10.98.79.x vs 10.42.0.x)
- SSH between them fails (password mismatch, no key exchange)
- No common DHCP server
- Phone is the only bridge
- Internet access depends on phone hotspot

## Future State (Post-Netgear)

```
                    ┌─────────────────────┐
                    │   Netgear Router     │
                    │   (PRIMARY TRUNK)    │
                    │   DHCP + DNS + GW    │
                    │   Static leases for  │
                    │   known nodes        │
                    └──────────┬──────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
    ┌─────▼─────┐      ┌──────▼──────┐     ┌──────▼──────┐
    │   Adam     │      │    Eve      │     │   Future    │
    │  (Explorer)│      │ (Archivist) │     │   Nodes     │
    │  Static IP │      │ Static IP   │     │             │
    └───────────┘      └─────────────┘     └─────────────┘
          │                    │
          └────────────────────┘
              Same subnet, direct
              SSH, mDNS, discovery
```

## Router as Trunk

The Netgear router provides:
- **DHCP server** with static reservations for known nodes
- **DNS resolution** (local names → IPs)
- **Default gateway** for internet access
- **Local routing** between all nodes
- **mDNS/Bonjour** for service discovery

## Design Principles

1. **Same subnet for all nodes** — no more split subnets
2. **Static DHCP leases** — nodes always get the same IP
3. **mDNS enabled** — adam.local, eve.local, aqua.local
4. **SSH key exchange** — passwordless between all nodes
5. **No cloud dependency** — Tree operates without internet
6. **Phone as Aperture only** — not a router, not a bridge

## Action Items for When Scott Gets Home

### Phase 1: Router Discovery
- [ ] Identify Netgear model
- [ ] Record LAN subnet (likely 192.168.1.0/24 or 10.0.0.0/24)
- [ ] Record gateway IP
- [ ] Record DHCP range
- [ ] Record admin credentials

### Phase 2: Device Discovery
- [ ] Scan all connected devices
- [ ] Record MAC addresses
- [ ] Identify each device by MAC + hostname
- [ ] Map physical connections (Ethernet ports)

### Phase 3: Static Leases
- [ ] Reserve IP for Adam (by MAC)
- [ ] Reserve IP for Eve (by MAC)
- [ ] Reserve IP for Aqua X570 (by MAC)
- [ ] Reserve IP for Rampage IV Gene (by MAC)
- [ ] Reserve IPs for printers (by MAC)

### Phase 4: Node Configuration
- [ ] Configure Adam with static IP + new subnet
- [ ] Configure Eve with static IP + new subnet
- [ ] Exchange SSH keys between Adam and Eve
- [ ] Test SSH: adam → eve, eve → adam
- [ ] Test mDNS: ping adam.local, ping eve.local

### Phase 5: Documentation
- [ ] Update STAR-CHART.md
- [ ] Update TOPOLOGY.md
- [ ] Update NODES.md
- [ ] Update CONTINUITY-REPORT.md

## MAC Addresses to Record
- Adam: (on Adam) `ip link show eth0 | grep ether`
- Eve: (on Eve) `ip link show eth0 | grep ether`
- Aqua: (check BIOS or Windows)
- Rampage: (check BIOS or Windows)
- Printers: (check label or web interface)

## Questions to Answer
1. What is the Netgear's default LAN IP?
2. What is the DHCP range?
3. Does it support static DHCP leases?
4. Does it support mDNS/Bonjour?
5. How many Ethernet ports?
6. Does it have VLAN support?
7. What is the Wi-Fi SSID/password?
8. Does it support port forwarding?
9. Does it have USB ports (for storage)?
10. What firmware version?
