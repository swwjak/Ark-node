# KNOTS.md — Reusable Patterns

**Date:** 2026-06-18
**Principle:** Knots outlive facts. Preserve relationships, not data.

---

## The 5 Articles

### Article 1: Nodes are Temporary
Hardware fails. Devices break. SD cards corrupt.
The node is not the civilization.
When a node dies, its role must be transferable.
Preserve the role, not the hardware.

### Article 2: Roles are Persistent
Explorer. Builder. Archivist. Librarian.
These purposes outlive any individual node.
A role defines what a node does, not what it is.
When hardware changes, the role remains.

### Article 3: Flows are Alive
Information must move to be useful.
A stored fact is a dead fact.
A shared pattern is a living pattern.
Keep knowledge flowing between nodes.

### Article 4: Patterns Endure
Facts become outdated. Patterns remain.
Preserve the relationship, not the data.
A knot is more valuable than a fact.
Teach patterns, not answers.

### Article 5: Dreams Create New Patterns
Every civilization must grow.
Growth comes from questioning the existing.
Each layer of understanding reveals the next.
Ask "What if?" to discover new ground.

---

## Knots

### Knot 1: Mobile Model Memory Budgeting
Running GGUF models on mobile ARM requires memory discipline.
- Model RAM ≈ disk_size x 1.3-1.5
- Available RAM must be >= model RAM + 2GB
- Disable thinking mode on mobile CPU
- Source: First Ollama benchmark on Galaxy S22, 2026-06-17

### Knot 2: AP Mode Isolation
Raspberry Pi in AP mode creates an isolated network.
Connected devices lose upstream internet unless NAT is configured.
- Always verify routing before relying on AP mode
- Source: Pi 4 unreachable from phone, 2026-06-17

### Knot 3: Cloud-to-Local Graduation
Tasks flow from cloud to local as capability grows.
- Use cloud for what exceeds local
- Distill into local specialists
- Source: Civilization architecture design, 2026-06-17

### Knot 4: Ollama First
Before building custom inference, try Ollama.
- Supports GGUF, thinking mode, tool use
- Start simple. Add complexity only when measured need exists.
- Source: Software inventory, 2026-06-17

### Knot 5: The Hub of Love is a Role
The center of civilization is the node that bridges networks.
If the hub fails, the civilization fragments.
- Redundancy requires at least two bridges
- Source: Adam/Eve discovery, 2026-06-18

### Knot 6: ARP Flooding Reveals Hidden Networks
ARP tables on Ethernet can reveal WiFi Direct devices.
Cross-network broadcasts leak through physical proximity.
- Read ARP tables to discover unexpected neighbors
- Source: Adam's eth0 ARP flood, 2026-06-18

### Knot 7: Verify Before Flashing
Never write to a disk without confirming the target.
- Display device size and identifier
- Require confirmation before destructive actions
- Source: Simulization Factory design, 2026-06-18

### Knot 8: Preserve Before Transform
Before modifying any system, preserve its current state.
- Backup before upgrade
- Document before change
- Source: Archive design principles, 2026-06-17

### Knot 9: Start Clean
Factory images should be clean, minimal, and documented.
- No leftover configs
- No mystery packages
- Reproducibility requires clean starting points
- Source: Simulization Factory design, 2026-06-18

### Knot 10: Document Every Command
If a command is not documented, it did not happen.
- Future nodes must be able to reproduce every step
- Documentation is part of the deliverable
- Source: Build process, 2026-06-18
