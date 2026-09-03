#!/usr/bin/env bash

Report_interval=2
Monitor_name="${1:-}"
Monitor_url="${2:-}"
Monitor_token="${3:-}"

if [[ -z "${1:-}" || -z "${2:-}" || -z "${3:-}" ]]; then
    echo "Usage: $0 <Monitor_name> <Monitor_url> <Monitor_token>"
    exit 1
fi

get_cpu_usage() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    Cpu_total_1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    Cpu_idle_1=$((idle + iowait))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    Cpu_total_2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    Cpu_idle_2=$((idle + iowait))

    Cpu_total_diff=$((Cpu_total_2 - Cpu_total_1))
    Cpu_idle_diff=$((Cpu_idle_2 - Cpu_idle_1))

    if ((Cpu_total_diff == 0)); then
        echo "0.00"
        return
    fi

    awk "BEGIN {
        printf \"%.2f\", (1 - $Cpu_idle_diff / $Cpu_total_diff) * 100
    }"
}

get_memory_usage() {
    Memory_total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
    Memory_available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)

    Memory_used=$((Memory_total - Memory_available))

    awk "BEGIN {
        printf \"%.2f\", $Memory_used / 1024
    }"
}
