#!/bin/bash
# SSH from Adam to Eve using sshpass
# This requires sshpass to be installed on ADAM

# Check if sshpass is on Adam
ssh -o ConnectTimeout=5 pi@10.98.79.63 'which sshpass 2>/dev/null || apt list --installed 2>/dev/null | grep sshpass' 2>&1