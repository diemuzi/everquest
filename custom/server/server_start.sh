#!/usr/bin/env bash

if test -f "./shared_memory"; then
   ./shared_memory
fi

perl server_launcher.pl loginserver zones="30" silent_launcher &

echo "Server started - use server_status.sh to check server status"