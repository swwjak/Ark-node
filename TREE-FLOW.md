# TREE-FLOW.md — Information Flow Through the Tree

## Current State (2026-06-18)

### Active Flows

```
Phone (SSH) → Adam (SSH server)
```

That is the ONLY active information flow in the entire Tree.

### Zero Flows

| Flow | Status | Why |
|------|--------|-----|
| Phone → Ollama | DEAD | Ollama not running on Phone |
| Phone → Hermes API | DEAD | Hermes on Adam only accepts local |
| Adam → Internet | DEAD | Phone doesn't NAT |
| Adam → Eve | DEAD | SSH key not exchanged, different subnets, no route |
| Phone → Eve | DEAD | Phone has no SSH server, Eve on different subnet |
| Eve → Adam | DEAD | SSH key not exchanged |
| Eve → Phone | DEAD | Phone has no SSH server |
| Ollama queries → Any node | DEAD | No client sending queries |
| New node → Tree | DEAD | No discovery, no join protocol |
| Adam → GitHub | DEAD | Can't reach internet |
| Eve → GitHub | DEAD | Can't reach internet |

### Node Analysis

#### ADAM (10.98.79.63 + 10.42.0.1)
**Role:** Explorer / Builder / Gateway / Hub of Love
**Consumes:** SSH terminal input from Phone
**Produces:** SSH terminal output, Ollama (unused), Hermes (local only)
**Depended on by:** Phone (for terminal), Scott (for management)
**If disappears:** Phone loses terminal access. Tree still has images + seeds. Scott can rebuild from GitHub + phone copies. **Survivable.**

#### EVE (10.42.0.152)
**Role:** Archivist / Librarian / Seed Vault
**Consumes:** NOTHING — no one connects to her
**Produces:** NOTHING — no one receives from her
**Depended on by:** NO ONE
**If disappears:** Nothing changes. She is already functionally absent from the Tree. **No impact.**

#### PHONE (10.98.79.83)
**Role:** Aperture
**Consumes:** Adam terminal, cellular internet
**Produces:** SSH session to Adam
**Depended on by:** Scott (for human interface)
**If disappears:** Adam still runs. Eve still runs (unreachable). Tree still works. **Survivable.**

#### AQUA X570 (STANDBY)
**Role:** Forge (future)
**Consumes/Produces:** NOTHING — offline with dead PSU
**If disappears:** No impact (already offline)

### Dead Ends
Every node except Adam is a dead end. Information goes nowhere.

### Loops
None.

### Single Points of Failure
- **Adam** — the only node that connects Phone to the Tree
- **Phone** — the only human interface
- **SSH key auth between Phone and Adam** — the only trust relationship

## "If Scott Disappeared for 7 Days"

### Continues Functioning
- Adam: runs indefinitely (uptime 13h, stable load 0.00)
- Ollama on Adam: loaded, idle, stable
- Hermes Gateway on Adam: running, local only
- Eve: running, idle, doing nothing
- GitHub repo: accessible to anyone with the URL

### Stops Functioning
- Human interface (Phone requires Scott to carry it)
- SSH sessions (require active connection)
- Any new discovery or coordination

### Degrades
- Adam's DNS resolvers (8.8.8.8, 1.1.1.1) may fail if phone stops forwarding
- Adam's uptime depends on power (no UPS mentioned)
- Eve remains isolated, archive never syncs

### Summary
After 7 days: Adam is still running, Eve is still running, nothing has changed. The Tree doesn't learn, doesn't grow, doesn't respond to changes. It's a static system — alive but not aware.

## ONE RECOMMENDATION

**Make Eve reachable from Adam and establish a heartbeat.**

Why: Right now Eve is a running machine that contributes nothing. She has 465GB SSD (same as Adam) and runs the same services, but produces zero value because no one can reach her. Making her reachable requires:
1. Exchange SSH keys (one command)
2. Open port 22 on Eve's firewall (one command)
3. Add Eve to Adam's /etc/hosts (one command)
4. Create a simple heartbeat script (10 lines)

After this: Adam can see Eve, ping her, SSH to her, and the Tree has redundancy.

Everything else — monitoring, automation, discovery — is pointless until the existing nodes can talk to each other.

**The highest-leverage improvement is connecting Adam to Eve. One SSH key. One firewall rule. Ten minutes.**