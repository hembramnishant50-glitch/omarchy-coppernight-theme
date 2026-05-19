#!/usr/bin/env python3
import psutil
import json
import shutil
import os
import subprocess
import re

# --- THEME CONFIGURATION ---
# Change this to "waybar" to use your custom Waybar configuration colors, 
# or keep "catppuccin" for your old vibrant colors!
ACTIVE_THEME = "catppuccin"

THEMES = {
    "catppuccin": {
        "title": "#cba6f7",
        "cpu": "#89b4fa",
        "gpu": "#f38ba8",
        "mem": "#a6e3a1",
        "swap": "#fab387",
        "disk": "#89b4fa",
        "text": "#dcd6d6",
        "tasks_title": "#f9e2af",
        "task_name": "#cdd6f4",
        "task_dots": "#45475a",
        "task_rss": "#f5c2e7",
        "uptime": "#94e2d5",
        "border": "#cba6f7"
    },
    "waybar": {
        "title": "#85abbc",      # @selected-text
        "cpu": "#85abbc",
        "gpu": "#8c92a3",        # @hover
        "mem": "#dcd6d6",        # @text
        "swap": "#788587",       # @border
        "disk": "#39515A",       # @accent
        "text": "#dcd6d6",
        "tasks_title": "#8c92a3",
        "task_name": "#dcd6d6",
        "task_dots": "#788587",
        "task_rss": "#dcd6d6",
        "uptime": "#85abbc",
        "border": "#85abbc"
    }
}

c = THEMES[ACTIVE_THEME]
# ---------------------------

def fmt(bytes_val):
    """Format bytes to human-readable (B/KB/MB/GB/TB)"""
    if not bytes_val:
        return "0.0B"
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_val < 1024.0 or unit == 'TB':
            return f"{bytes_val:.1f}{unit}"
        bytes_val /= 1024.0

def get_progress_bar(percent, length=10):
    """Creates a visual bar like: [■■■■■□□□□□]"""
    # Clamp percent between 0 and 100 to prevent layout breaking
    percent = max(0, min(100, percent)) 
    filled = int(length * percent / 100)
    bar = "■" * filled + "□" * (length - filled)
    return bar

def get_gpu_info():
    """Get GPU usage and name. Supports NVIDIA, AMD, and generic GPUs."""
    gpu_usage = None
    gpu_name = "GPU"
    gpu_mem_used = None
    gpu_mem_total = None
    
    # Try NVIDIA first (most common)
    try:
        result = subprocess.run(['nvidia-smi', '--query-gpu=utilization.gpu,memory.used,memory.total,name', '--format=csv,noheader,nounits'], 
                              capture_output=True, text=True, timeout=2)
        if result.returncode == 0:
            parts = result.stdout.strip().split(', ')
            if len(parts) >= 4:
                gpu_usage = int(parts[0])
                gpu_mem_used = int(parts[1]) * 1024 * 1024  # Convert MB to bytes
                gpu_mem_total = int(parts[2]) * 1024 * 1024
                gpu_name = parts[3].strip()
                return gpu_usage, gpu_name, gpu_mem_used, gpu_mem_total
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
        pass
    
    # Try AMD ROCm
    try:
        result = subprocess.run(['rocm-smi', '--showuse', '--showmemuse', '--showproductname'], 
                              capture_output=True, text=True, timeout=2)
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')
            for line in lines:
                if 'GPU use' in line or 'GPU Utilization' in line:
                    match = re.search(r'(\d+)%', line)
                    if match:
                        gpu_usage = int(match.group(1))
                if 'GPU memory use' in line or 'Memory' in line:
                    match = re.search(r'(\d+)%', line)
                    if match:
                        pass # Kept for future logic if you want AMD vram % 
                if 'Card series' in line or 'Product Name' in line:
                    gpu_name = line.split(':')[-1].strip()
            if gpu_usage is not None:
                return gpu_usage, gpu_name, None, None
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
        pass
    
    return gpu_usage, gpu_name, gpu_mem_used, gpu_mem_total

def get_sys_info():
    # --- CPU DATA ---
    cpu_percent = int(psutil.cpu_percent(interval=1))

    # --- RAM DATA ---
    mem = psutil.virtual_memory()
    swap = psutil.swap_memory()

    # --- DISK DATA ---
    disk = shutil.disk_usage('/')
    disk_percent = (disk.used / disk.total) * 100

    # --- GPU DATA ---
    gpu_usage, gpu_name, gpu_mem_used, gpu_mem_total = get_gpu_info()
    gpu_mem_percent = None
    if gpu_mem_used is not None and gpu_mem_total is not None:
        gpu_mem_percent = int((gpu_mem_used / gpu_mem_total) * 100)

    # --- TOP PROCESSES ---
    processes = []
    for proc in psutil.process_iter(['name', 'memory_info']):
        try:
            mem_info = proc.info['memory_info']
            if mem_info is not None:
                processes.append((proc.info['name'], mem_info.rss))
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
            
    top_apps = sorted(processes, key=lambda x: x[1], reverse=True)[:8]

    # --- TOOLTIP DESIGN ---
    tt = f"<b><span color='{c['title']}'>╔════════ SYSTEM DIAGNOSTICS ════════╗</span></b>\n"

    # Row 1: CPU Visuals
    tt += f"<b><span color='{c['cpu']}'>║ CPU    </span></b> <span color='{c['text']}'>[{get_progress_bar(cpu_percent)}]</span> <span color='{c['text']}'>{cpu_percent}%</span>\n"

    # Row 2: GPU Visuals
    if gpu_usage is not None:
        tt += f"<b><span color='{c['gpu']}'>║ GPU    </span></b> <span color='{c['text']}'>[{get_progress_bar(gpu_usage)}]</span> <span color='{c['text']}'>{gpu_usage}%</span>\n"
        if gpu_mem_percent is not None:
            tt += f"<b><span color='{c['gpu']}'>║</span></b> <span color='{c['text']}'>VRAM: {fmt(gpu_mem_used):<8}</span> <span color='{c['text']}'>│</span> <span color='{c['text']}'>Total: {fmt(gpu_mem_total)}</span>\n"
        if gpu_name and gpu_name != "GPU":
            tt += f"<b><span color='{c['gpu']}'>║</span></b> <span color='{c['text']}'>{gpu_name[:30]}</span>\n"

    # Row 3: Memory Visuals
    tt += f"<b><span color='{c['mem']}'>║ MEMORY </span></b> <span color='{c['text']}'>[{get_progress_bar(mem.percent)}]</span> <span color='{c['text']}'>{int(mem.percent)}%</span>\n"
    tt += f"<b><span color='{c['mem']}'>║</span></b> <span color='{c['text']}'>Used: {fmt(mem.used):<8}</span> <span color='{c['text']}'>│</span> <span color='{c['text']}'>Free: {fmt(mem.available)}</span>\n"

    # Row 4: Swap Visuals
    tt += f"<b><span color='{c['swap']}'>║ SWAP   </span></b> <span color='{c['text']}'>[{get_progress_bar(swap.percent)}]</span> <span color='{c['text']}'>{int(swap.percent)}%</span>\n"

    # Row 5: Storage Visuals
    tt += f"<b><span color='{c['disk']}'>║ DISK   </span></b> <span color='{c['text']}'>[{get_progress_bar(disk_percent)}]</span> <span color='{c['text']}'>{int(disk_percent)}%</span>\n"
    tt += f"<b><span color='{c['disk']}'>║</span></b> <span color='{c['text']}'>Used: {fmt(disk.used):<8}</span> <span color='{c['text']}'>│</span> <span color='{c['text']}'>Total: {fmt(disk.total)}</span>\n"
    
    tt += f"<b><span color='{c['border']}'>╠════════════════════════════════════╣</span></b>\n"

    # Process List
    tt += f"<b><span color='{c['tasks_title']}'>║ ACTIVE TASKS                       ║</span></b>\n"
    for name, rss in top_apps:
        dots = "." * (20 - len(name[:15]))
        tt += f"<b><span color='{c['border']}'>║</span></b> <span color='{c['task_name']}'>{name[:15].upper()}</span> <span color='{c['task_dots']}'>{dots}</span> <span color='{c['task_rss']}'>{fmt(rss):>8}</span>\n"

    tt += f"<b><span color='{c['border']}'>╚════════════════════════════════════╝</span></b>\n"

    # Footer: Uptime
    uptime = os.popen("uptime -p").read().replace("up ", "").strip()
    tt += f"<span color='{c['uptime']}'><b>UPTIME:</b> {uptime}</span>"

    # --- BAR TEXT ---
    bar_text = f"<span color='{c['cpu']}'>󰻠</span> {cpu_percent}%"
    
    # Add GPU icon if GPU info is available
    if gpu_usage is not None:
        bar_text += f"  <span color='{c['gpu']}'>󰾲</span> {gpu_usage}%"
    
    bar_text += f"  <span color='{c['mem']}'>󰍛</span> {int(mem.percent)}%"
    
    return json.dumps({"text": bar_text, "tooltip": tt})

if __name__ == "__main__":
    print(get_sys_info())