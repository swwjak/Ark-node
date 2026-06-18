# REPOSITORY-POLICY.md — What Goes Where

## Principle
This repository is civilization memory. Not infrastructure prints.
Knowledge belongs here. Secrets don't.

## Classification

### PUBLIC — Safe for anyone to see
Information that helps understanding without revealing infrastructure.
Examples: patterns, articles, procedures, architecture concepts, recovery processes.
**Rule:** If it teaches something without identifying a specific device or person, it's public.

### PRIVATE — Infrastructure details
Information that identifies specific devices, networks, or locations.
Examples: IP addresses, MAC addresses, hostnames, physical locations, device fingerprints.
**Rule:** Never commit private information to this repo. Store in private repo only.

### SECRET — Grants access
Information that can be used to gain unauthorized entry.
Examples: passwords, API keys, SSH private keys, tokens, credentials.
**Rule:** Never commit secrets. Ever. Not even accidentally.

## File Guidelines

| Type | Where | Example |
|------|-------|---------|
| Patterns/Articles | Root | KNOTS.md |
| Role definitions | Root | FACES.md |
| Procedures | Root | RECOVERY.md |
| Build scripts | Root | (production only) |
| Debug/test scripts | NOWHERE | Remove after use |
| Infrastructure inventory | PRIVATE repo | NODES.md → private |
| Node reports | PRIVATE repo | Detailed reports → private |
| Logs with real data | PRIVATE repo | Anonymize before committing |
| Credentials | NEVER | Not even in private repo |

## Pre-Commit Checklist

Before every commit, verify:
- [ ] No IP addresses (10.x, 172.16-31.x, 192.168.x)
- [ ] No MAC addresses (xx:xx:xx:xx:xx:xx)
- [ ] No email addresses (unless generic like pi@localhost)
- [ ] No passwords, tokens, or keys
- [ ] No physical locations (home, office, city names)
- [ ] No device serial numbers or fingerprints
- [ ] No debug or test output
- [ ] No temporary files

## If You Accidentally Commit a Secret

1. Do NOT just delete the file — the secret is still in git history.
2. Use `git filter-branch` or BFG Repo-Cleaner to purge from history.
3. Rotate the compromised credential immediately.

## Repository Visibility

This repository should remain PRIVATE until all files pass the pre-commit checklist.
When all files pass, it can be made public safely.

Currently: Should be PRIVATE (NODES.md, NODE-REPORT, VERIFICATION-REPORT still contain sensitive data).

## Current Issues (to resolve before making public)

Files that still contain private information:
- NODES.md: Still has home/standby labels that map to physical locations
- NODE-REPORT-ADAM-EVE.md: Detailed infrastructure report → move to PRIVATE
- VERIFICATION-REPORT.md: Contains device details → move to PRIVATE
- MEMORY.md: Contains email, location → scrub
- TREE-FLOW.md: Contains role descriptions tied to specific hardware → review
