#!/usr/bin/env bash

MONITOR="DP-4"
NOTIF_ID=9910
STATE_FILE="/tmp/hypr-hdr-active"

# 1. Check State
if [[ -f "$STATE_FILE" ]]; then
    # --- STATE: HDR IS ON -> TURN OFF ---
    notify-send -r $NOTIF_ID -u low "HDR Disabled" "Returning to SDR"
    
    # Reload the monitor rule WITHOUT 'cm,hdr' (Keep scale 1.5)
    hyprctl keyword monitor "$MONITOR, 3840x2160@240, 0x0, 1.5, bitdepth, 10"
    
    # Remove state file
    rm "$STATE_FILE"
else
    # --- STATE: HDR IS OFF -> TURN ON ---
    notify-send -r $NOTIF_ID -u low "HDR Enabled" "Enabling HDR (Scale 1.5)"
    
    # Load the monitor rule WITH 'cm,hdr' (Keep scale 1.5)
    hyprctl keyword monitor "$MONITOR, 3840x2160@240, 0x0, 1.5, bitdepth, 10, cm, hdr"
    
    # Create state file
    touch "$STATE_FILE"
fi
