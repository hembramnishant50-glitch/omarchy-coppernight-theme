#!/bin/bash

cpu_data=$(awk '/^cpu / {for(i=2;i<=8;i++) printf "%d ", $i; print $5}' /proc/stat)
read -r u1 n1 s1 i1 w1 x1 y1 idle1 <<< "$cpu_data"
cpu1=$(( u1 + n1 + s1 + i1 + w1 + x1 + y1 ))

sleep 0.5

cpu_data=$(awk '/^cpu / {for(i=2;i<=8;i++) printf "%d ", $i; print $5}' /proc/stat)
read -r u2 n2 s2 i2 w2 x2 y2 idle2 <<< "$cpu_data"
cpu2=$(( u2 + n2 + s2 + i2 + w2 + x2 + y2 ))

cpu_delta=$(( cpu2 - cpu1 ))
idle_delta=$(( idle2 - idle1 ))
cpu_usage=$(( (cpu_delta - idle_delta) * 100 / cpu_delta ))

temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%d", $1/1000}' || echo "?")
load=$(awk '{printf "%.2f", $1}' /proc/loadavg 2>/dev/null || echo "?")
freq=$(awk '/cpu MHz/ {printf "%.0f", $4; exit}' /proc/cpuinfo 2>/dev/null || echo "?")

mem_total=$(awk '/MemTotal/ {printf "%.0f", $2/1024}' /proc/meminfo 2>/dev/null || echo "0")
mem_avail=$(awk '/MemAvailable/ {printf "%.0f", $2/1024}' /proc/meminfo 2>/dev/null || echo "0")
mem_used=$(( mem_total - mem_avail ))
mem_pct=$(( mem_used * 100 / mem_total ))

format_mem() {
  local mb=$1
  if (( mb >= 1024 )); then
    echo "$(echo "scale=1; $mb / 1024" | bc)G"
  else
    echo "${mb}M"
  fi
}

ram_used_fmt=$(format_mem $mem_used)
ram_total_fmt=$(format_mem $mem_total)

# GPU detection - universal
get_gpu_name() {
  if command -v nvidia-smi &>/dev/null; then
    nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1 | sed 's/ *$//'
  elif command -v lspci &>/dev/null; then
    lspci 2>/dev/null | grep -E "VGA|3D|Display" | head -1 | sed 's/.*\[\(AMD\|Intel\|NVIDIA\)[^]]*\] //; s/.*Corporation //; s/ (rev.*)//; s/ (.*)//'
  fi
}
gpu_name=$(get_gpu_name)

gpu_line=""
if command -v nvidia-smi &>/dev/null; then
  gpu_pct=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')
  gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')
  if [[ -n "$gpu_pct" ]]; then
    gpu_line="<span color='#cba6f7'> ${gpu_name}: ${gpu_pct}%"
    [[ -n "$gpu_temp" ]] && gpu_line+="   ${gpu_temp}°C"
    gpu_line+="</span>"
  fi
elif [[ -d /sys/class/drm ]]; then
  for card in /sys/class/drm/card*/device/gpu_busy_percent; do
    if [[ -f "$card" ]]; then
      gpu_pct=$(cat "$card" 2>/dev/null)
      card_dir=$(dirname "$card")
      gpu_temp=$(cat "$card_dir/hwmon/hwmon*/temp1_input" 2>/dev/null | awk '{printf "%d", $1/1000}')
      if [[ -n "$gpu_pct" ]]; then
        gpu_line="<span color='#cba6f7'> ${gpu_name:-GPU}: ${gpu_pct}%"
        [[ -n "$gpu_temp" ]] && gpu_line+="   ${gpu_temp}°C"
        gpu_line+="</span>"
        break
      fi
    fi
  done
fi

tooltip="<span color='#585b70'>━━━ CPU ━━━</span>
<span color='#f38ba8'> CPU: ${cpu_usage}%</span>
<span color='#fab387'> ${temp}°C</span>
<span color='#f9e2af'> Load: ${load}</span>
<span color='#89b4fa'> Freq: ${freq}MHz</span>
<span color='#a6e3a1'> RAM: ${ram_used_fmt}/${ram_total_fmt} (${mem_pct}%)</span>"
[[ -n "$gpu_line" ]] && tooltip+="
${gpu_line}"

# Top processes (sorted by CPU)
tooltip+="
<span color='#585b70'>━━━ Top Processes ━━━</span>
<span color='#585b70'>CPU   MEM   PROCESS</span>"

while read -r cpu mem cmd; do
  [[ -z "$cmd" ]] && continue
  tooltip+="
<span color='#f38ba8'>$(printf "%5s" "${cpu}%")</span> <span color='#89b4fa'>$(printf "%5s" "${mem}%")</span> <span color='#cdd6f4'>${cmd}</span>"
done < <(ps -eo %cpu,%mem,comm --sort=-%cpu --no-headers 2>/dev/null | awk '$3 !~ /^ps$/ {print}' | head -7)

jq -nc --arg text " ${cpu_usage}%" --arg tooltip "${tooltip}" '{text: $text, tooltip: $tooltip}'
