# GITHUB-SETUP.md — One-Time Setup Required

## The Problem
GitHub no longer accepts password-based API calls.
We need either an SSH key or a personal access token.

## Option A: SSH Key (Recommended)

### Step 1: Add this public key to GitHub
Go to: https://github.com/settings/keys → New SSH key

Title: termux-ark-node-2026
Key:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZTA7k3oADGenqJ1PNcB3V2k4jhFrODIDuaxXvEWYM2 termux
```

### Step 2: Test
```bash
ssh -T git@github.com
```

### Step 3: Push
```bash
cd ~/ARCHIVE
git remote add origin git@github.com:swwjak/ark-node.git
git push -u origin main
```

## Option B: Personal Access Token

### Step 1: Create token
Go to: https://github.com/settings/tokens → Generate new token (classic)
Scopes: repo, workflow, read:org

### Step 2: Configure gh
```bash
echo "YOUR_TOKEN" | gh auth login --with-token
```

### Step 3: Push
```bash
cd ~/ARCHIVE
gh repo create ark-node --public --source=. --push
```

## What Will Be Pushed
- 20 files of civilization memory
- Knots, Articles, Procedures, Reports
- Recovery documentation
- First-boot seeds
- Verification reports
- NO images (too large, on phone and Adam SSD)

## After Push
The civilization memory survives even if all local hardware is lost.
A future traveler can clone the repo and rebuild everything.
