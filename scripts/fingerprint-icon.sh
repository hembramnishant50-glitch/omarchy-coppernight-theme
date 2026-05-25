#!/bin/bash

if fprintd-list "$USER" 2>/dev/null | grep -q "finger"; then
    echo "󰈷"
else
    echo ""
fi
