# GITHUB-STATUS.md — Authentication Blocked

## Problem
GitHub password-based API authentication is deprecated.
The credentials provided (swwjak69@gmail.com) cannot:
- Create personal access tokens via API
- Authenticate API calls
- Be used with `gh auth login` non-interactively

## What Works
- SSH key exists: `~/.ssh/id_ed25519.pub`
- `gh` CLI is installed
- Git repo is committed and ready

## What's Needed
One of these (requires user action in browser):

### Option A: Add SSH Key (30 seconds)
1. Go to https://github.com/settings/keys
2. Click "New SSH key"
3. Title: `termux-ark-node-2026`
4. Key: `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZTA7k3oADGenqJ1PNcB3V2k4jhFrODIDuaxXvEWYM2 termux`
5. Click "Add SSH key"

Then: `ssh -T git@github.com` should succeed.

### Option B: Create PAT (30 seconds)
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Scopes: repo, workflow, read:org
4. Generate and copy

Then: `echo "TOKEN" | gh auth login --with-token`

## After Authentication
```bash
cd ~/ARCHIVE
git remote add origin git@github.com:swwjak/ark-node.git
git push -u origin main
```

## Alternative: Use GitHub Web Interface
If CLI auth is too complex:
1. Go to https://github.com/new
2. Create repo: `ark-node`
3. Upload files via web interface
4. Drag-and-drop the 20 files from ~/ARCHIVE/

## Current State
- Local git repo: committed, ready to push
- Remote: nothing (no auth)
- Images: on phone (3.4 GB) and Adam SSD (13 GB)
- Documentation: complete and committed

## Risk
If phone is lost AND no GitHub push: civilization memory is lost.
The images survive on Adam SSD, but the patterns, procedures,
and knowledge exist only in this git repo on the phone.
