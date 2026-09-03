#!/usr/bin/env bash

Report_Interval=2
Monitor_Name="${1:-}"
Monitor_URL="${2:-}"
Monitor_Token="${3:-}"

if [[-z "${1:-}" || -z "${2:-}" || -z "${3:-}"]]
    echo "Usage: $0 <Monitor_Name> <Monitor_URL> <Monitor_Token>"
    exit 1
fi

get_cpu_usage() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
