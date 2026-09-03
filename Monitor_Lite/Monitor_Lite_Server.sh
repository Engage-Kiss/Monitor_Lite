#!/usr/bin/env bash

Report_Interval=2
Monitor_Name="${1:-}"
Monitor_URL="${2:-}"
Monitor_Token="${3:-}"

if [[ -z "${1:-}" || -z "${2:-}" || -z "${3:-}" ]]; then
    echo "Usage: $0 <Monitor_Name> <Monitor_URL> <Monitor_Token>"
    exit 1
fi

get_cpu_usage() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    Total_1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    Idle_1=$((idle + iowait))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    Total_2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    Idle_2=$((idle + iowait))

    Total_diff=$((Total_2 - Total_1))
    Idle_diff=$((Idle_2 - Idle_1))

    if ((Total_diff == 0)); then
        echo "0.00"
        return
    fi

    awk "BEGIN {
        printf \"%.2f\", (1 - $Idle_diff / $Total_diff) *100
    }"
}
