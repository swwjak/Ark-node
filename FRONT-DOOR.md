# hello.sh — The Front Door

## Purpose
A traveler runs one script and knows everything.
No prior knowledge needed. No reading required.

## Usage
```bash
curl -s http://door.ark.local/hello | bash
```

## Behavior
1. Detect who the traveler is (IP, hostname, gateway)
2. Greet them: "You have arrived at ARK."
3. Show the civilization:
   - Who is alive
   - Who is missing
   - Where the Tree is
   - Where the Archive is
4. Offer next steps

## Output Example
```
══════════════════════════════════════════

  YOU HAVE ARRIVED AT ARK.

  Citizens:
  🔵 Adam  — Explorer / Builder — alive
  🟣 Eve   — Archivist          — missing
  ⚪ Phone — Aperture           — alive

  Tree:     10.98.79.63:/home/pi/TREE/
  Archive:  10.98.79.83:~/ARCHIVE/

  To join:
    curl -s http://door.ark.local/join | bash

  To see faces:
    curl -s http://door.ark.local/faces

  To see knots:
    curl -s http://door.ark.local/knots

══════════════════════════════════════════
```
