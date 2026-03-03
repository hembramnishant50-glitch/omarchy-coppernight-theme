#!/usr/bin/env python3
import psutil
import json
import shutil
import os
import subprocess

def fmt(bytes_val):
    """Format bytes to human-readable (B/KB/MB/GB/TB)"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_val < 1024:
            return f"{bytes_val:.1f}{unit}"
        bytes_val /= 1024

def get_progress_bar(percent, length=10):
    """Creates a visual bar like: [■■■■■□□□□□]"""
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
                    # Extract percentage
                    import re
                    match = re.search(r'(\d+)%', line)
                    if match:
                        gpu_usage = int(match.group(1))
                if 'GPU memory use' in line or 'Memory' in line:
                    import re
                    match = re.search(r'(\d+)%', line)
                    if match:
                        gpu_mem_percent = int(match.group(1))
                if 'Card series' in line or 'Product Name' in line:
                    gpu_name = line.split(':')[-1].strip()
            if gpu_usage is not None:
                return gpu_usage, gpu_name, None, None
    except (subprocess.TimeoutExpired, FileNotFoundError, subprocess.SubprocessError):
        pass
    
    # Try generic method (reading from /sys/class/drm/)
    try:
        drm_path = '/sys/class/drm'
        if os.path.exists(drm_path):
            for item in os.listdir(drm_path):
                if item.startswith('card') and os.path.isdir(os.path.join(drm_path, item)):
                    # Try to get GPU name
                    name_path = os.path.join(drm_path, item, 'device', 'uevent')
                    if os.path.exists(name_path):
                        with open(name_path, 'r') as f:
                            for line in f:
                                if 'PCI_ID' in line or 'MODALIAS' in line:
                                    # Extract GPU model info
                                    pass
                    # For now, just return None if no specific GPU found
                    break
    except:
        pass
    
    return gpu_usage, gpu_name, gpu_mem_used, gpu_mem_total

def get_sys_info():
    # --- CPU DATA ---
    cpu_usage = psutil.cpu_percent(interval=1)   # Accurate recent usage (blocks 1s)
    cpu_percent = int(cpu_usage)

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
            processes.append((proc.info['name'], proc.info['memory_info'].rss))
        except:
            pass
    top_apps = sorted(processes, key=lambda x: x[1], reverse=True)[:8]

    # --- TOOLTIP DESIGN: CYBER-HUD ---
    tt = "<b><span color='#cba6f7'>╔════════ SYSTEM DIAGNOSTICS ════════╗</span></b>\n"

    # Row 1: CPU Visuals (NEW)
    tt += f"<b><span color='#89b4fa'>║ CPU    </span></b> <span color='#45475a'>[{get_progress_bar(cpu_percent)}]</span> <span color='#cdd6f4'>{cpu_percent}%</span>\n"

    # Row 2: GPU Visuals (if available)
    if gpu_usage is not None:
        tt += f"<b><span color='#f38ba8'>║ GPU    </span></b> <span color='#45475a'>[{get_progress_bar(gpu_usage)}]</span> <span color='#cdd6f4'>{gpu_usage}%</span>\n"
        if gpu_mem_percent is not None:
            tt += f"<b><span color='#f38ba8'>║</span></b> <span color='#cdd6f4'>VRAM: {fmt(gpu_mem_used):<8}</span> <span color='#6c7086'>│</span> <span color='#cdd6f4'>Total: {fmt(gpu_mem_total)}</span>\n"
        if gpu_name and gpu_name != "GPU":
            tt += f"<b><span color='#f38ba8'>║</span></b> <span color='#cdd6f4'>{gpu_name[:30]}</span>\n"

    # Row 3: Memory Visuals
    tt += f"<b><span color='#a6e3a1'>║ MEMORY </span></b> <span color='#45475a'>[{get_progress_bar(mem.percent)}]</span> <span color='#cdd6f4'>{int(mem.percent)}%</span>\n"
    tt += f"<b><span color='#a6e3a1'>║</span></b> <span color='#cdd6f4'>Used: {fmt(mem.used):<8}</span> <span color='#6c7086'>│</span> <span color='#cdd6f4'>Free: {fmt(mem.available)}</span>\n"

    # Row 4: Swap Visuals
    tt += f"<b><span color='#fab387'>║ SWAP   </span></b> <span color='#45475a'>[{get_progress_bar(swap.percent)}]</span> <span color='#cdd6f4'>{int(swap.percent)}%</span>\n"

    # Row 5: Storage Visuals
    tt += f"<b><span color='#89b4fa'>║ DISK   </span></b> <span color='#45475a'>[{get_progress_bar(disk_percent)}]</span> <span color='#cdd6f4'>{int(disk_percent)}%</span>\n"
    tt += f"<b><span color='#89b4fa'>║</span></b> <span color='#cdd6f4'>Used: {fmt(disk.used):<8}</span> <span color='#6c7086'>│</span> <span color='#cdd6f4'>Total: {fmt(disk.total)}</span>\n"
    
    tt += "<b><span color='#cba6f7'>╠════════════════════════════════════╣</span></b>\n"

    # Process List (Clean Table)
    tt += "<b><span color='#f9e2af'>║ ACTIVE TASKS                       ║</span></b>\n"
    for name, rss in top_apps:
        dots = "." * (20 - len(name[:15]))
        tt += f"<b><span color='#cba6f7'>║</span></b> <span color='#cdd6f4'>{name[:15].upper()}</span> <span color='#45475a'>{dots}</span> <span color='#f5c2e7'>{fmt(rss):>8}</span>\n"

    tt += "<b><span color='#cba6f7'>╚════════════════════════════════════╝</span></b>\n"

    # Footer: Uptime
    uptime = os.popen("uptime -p").read().replace("up ", "").strip()
    tt += f"<span color='#94e2d5'><b>UPTIME:</b> {uptime}</span>"

    # Bar Text (Kept your preferred icons)
    cpu_usage = int(psutil.cpu_percent())
    bar_text = f"<span color='#89b4fa'>󰻠</span> {cpu_usage}%"
    
    # Add GPU icon if GPU info is available (before memory)
    if gpu_usage is not None:
        bar_text += f"  <span color='#f38ba8'>󰾲</span> {gpu_usage}%"
    
    bar_text += f"  <span color='#a6e3a1'>󰍛</span> {int(mem.percent)}%"
    
    return json.dumps({"text": bar_text, "tooltip": tt})

if __name__ == "__main__":
    print(get_sys_info())
