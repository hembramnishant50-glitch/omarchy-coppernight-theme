#!/usr/bin/env python3
import psutil
import json
import shutil
import subprocess

# ==============================================================================
# 🛠️ QUICK CONFIGURATION
# ==============================================================================
# Add any other mount points here (e.g., "/mnt/data")
PARTITIONS = {"Root": "/"}

C = {
    "red": "#f38ba8", "peach": "#fab387", "yellow": "#f9e2af",
    "green": "#a6e3a1", "blue": "#89b4fa", "mauve": "#cba6f7", 
    "teal": "#94e2d5", "sky": "#89dceb", "lavender": "#b4befe",
    "subtext": "#a5adce", "surface": "#313244", "text": "#cdd6f4"
}
# ==============================================================================

def fmt_size(bytes):
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes < 1024: return f"{bytes:.1f}{unit}"
        bytes /= 1024

def get_gpu_info():
    gpu = {"usage": 0, "active": False}
    try:
        res = subprocess.check_output(
            ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"], 
            encoding='utf-8', stderr=subprocess.DEVNULL
        )
        gpu.update({"usage": int(res.strip()), "active": True})
        return gpu
    except: pass

    try:
        with open("/sys/class/drm/card0/device/gpu_busy_percent", "r") as f:
            gpu["usage"] = int(f.read().strip())
            gpu["active"] = True
    except: pass
    return gpu

def get_top_apps(n=7):
    apps = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']):
        try:
            apps.append(proc.info)
        except (psutil.NoSuchProcess, psutil.AccessDenied): pass

    apps = sorted(apps, key=lambda x: x['memory_percent'], reverse=True)
    header = f"<span color='{C['red']}'>{'PID':<7} {'APP NAME':<16} {'CPU%':>6} {'RAM%':>6}</span>\n"
    rows = []
    for a in apps[:n]:
        name = (a['name'][:14] + '..') if len(a['name']) > 15 else a['name']
        cpu = a['cpu_percent'] if a['cpu_percent'] else 0.0
        mem = a['memory_percent'] if a['memory_percent'] else 0.0
        rows.append(f"<span face='monospace'>{a['pid']:<7} {name:<16} {cpu:>5.1f}% {mem:>5.1f}%</span>")
    return header + "\n".join(rows)

def get_sys_info():
    cpu_usage = psutil.cpu_percent(interval=0.1)
    ram = psutil.virtual_memory()
    gpu = get_gpu_info()
    
    storage_list = []
    for name, path in PARTITIONS.items():
        try:
            usage = shutil.disk_usage(path)
            # Calculate GB values
            used_gb = usage.used / (1024**3)
            total_gb = usage.total / (1024**3)
            percent = int((usage.used / usage.total) * 100)
            
            bar = "■" * (percent // 10) + "□" * (10 - (percent // 10))
            
            # Formatting: Name | Bar | Used/Total GB | %
            storage_list.append(
                f"<span color='{C['teal']}'>{name:<6}</span> "
                f"<span color='{C['surface']}'>{bar}</span>  "
                f"<span color='{C['text']}'>{used_gb:.1f}/{total_gb:.1f} GB</span> "
                f"<span color='{C['subtext']}'>({percent}%)</span>"
            )
        except: continue

    tt = f"<b><span color='{C['red']}'>󰀻  SYSTEM DASHBOARD</span></b>\n"
    tt += f"<span color='{C['surface']}'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
    
    # Usage Stats
    tt += f"<span color='{C['blue']}'>  CPU Load:</span>   <span color='{C['text']}'>{cpu_usage:.1f}%</span>\n"
    tt += f"<span color='{C['peach']}'>󰰠  RAM Used:</span>   <span color='{C['text']}'>{fmt_size(ram.used)} / {fmt_size(ram.total)} ({ram.percent:.1f}%)</span>\n"
    
    if gpu["active"]:
        tt += f"<span color='{C['yellow']}'>󰢮  GPU Load:</span>   <span color='{C['text']}'>{gpu['usage']}%</span>\n"

    # Storage Section (Proper Numbers Added Here)
    tt += f"<span color='{C['surface']}'>─────────────────────────────────────</span>\n"
    tt += f"<span color='{C['mauve']}'>󰋊  STORAGE USAGE</span>\n" + "\n".join(storage_list) + "\n"
    
    # Apps Section
    tt += f"<span color='{C['surface']}'>─────────────────────────────────────</span>\n"
    tt += f"<span color='{C['yellow']}'>󰜎  TOP 7 APPS (BY RAM)</span>\n\n"
    tt += get_top_apps(7)
    
    tt += f"\n<span color='{C['surface']}'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
    tt += f"<b><span color='{C['green']}'>󰰠 LMB:</span></b> Btop  |  <b><span color='{C['red']}'>󰰠 RMB:</span></b> Monitor"

    # Bar Text
    gpu_bar = f" <span color='{C['yellow']}'>󰢮</span> {gpu['usage']}%" if gpu['active'] else ""
    bar_text = f"<span color='{C['blue']}'></span> {int(cpu_usage)}% <span color='{C['peach']}'>󰰠</span> {int(ram.percent)}%{gpu_bar}"

    return {"text": bar_text, "tooltip": tt}

if __name__ == "__main__":
    print(json.dumps(get_sys_info()))