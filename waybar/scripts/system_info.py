#!/usr/bin/env python3
import psutil
import json
import shutil
import os

def fmt(bytes):
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes < 1024: return f"{bytes:.1f}{unit}"
        bytes /= 1024

def get_progress_bar(percent, length=10):
    # Creates a visual bar like: [■■■■■□□□□□]
    filled = int(length * percent / 100)
    bar = "■" * filled + "□" * (length - filled)
    return bar

def get_sys_info():
    # --- RAM DATA ---
    mem = psutil.virtual_memory()
    swap = psutil.swap_memory()
    
    # --- DISK DATA ---
    disk = shutil.disk_usage('/')
    disk_percent = (disk.used / disk.total) * 100

    # --- TOP PROCESSES ---
    processes = []
    for proc in psutil.process_iter(['name', 'memory_info']):
        try: processes.append((proc.info['name'], proc.info['memory_info'].rss))
        except: pass
    top_apps = sorted(processes, key=lambda x: x[1], reverse=True)[:8]

    # --- TOOLTIP DESIGN: CYBER-HUD ---
    # Header
    tt = "<b><span color='#cba6f7'>╔════════ SYSTEM DIAGNOSTICS ════════╗</span></b>\n"

    # Row 1: Memory Visuals
    tt += f"<b><span color='#a6e3a1'>║ MEMORY </span></b> <span color='#45475a'>[{get_progress_bar(mem.percent)}]</span> <span color='#cdd6f4'>{int(mem.percent)}%</span>\n"
    tt += f"<b><span color='#a6e3a1'>║</span></b> <span color='#cdd6f4'>Used: {fmt(mem.used):<8}</span> <span color='#6c7086'>│</span> <span color='#cdd6f4'>Free: {fmt(mem.available)}</span>\n"
    
    # Row 2: Swap Visuals
    tt += f"<b><span color='#fab387'>║ SWAP   </span></b> <span color='#45475a'>[{get_progress_bar(swap.percent)}]</span> <span color='#cdd6f4'>{int(swap.percent)}%</span>\n"

    # Row 3: Storage Visuals
    tt += f"<b><span color='#89b4fa'>║ DISK   </span></b> <span color='#45475a'>[{get_progress_bar(disk_percent)}]</span> <span color='#cdd6f4'>{int(disk_percent)}%</span>\n"
    tt += f"<b><span color='#89b4fa'>║</span></b> <span color='#cdd6f4'>Used: {fmt(disk.used):<8}</span> <span color='#6c7086'>│</span> <span color='#cdd6f4'>Total: {fmt(disk.total)}</span>\n"

    tt += "<b><span color='#cba6f7'>╠════════════════════════════════════╣</span></b>\n"
    
    # Process List (Clean Table)
    tt += "<b><span color='#f9e2af'>║ ACTIVE TASKS                       ║</span></b>\n"
    for name, rss in top_apps:
        # Dots for visual connection
        dots = "." * (20 - len(name[:15]))
        tt += f"<b><span color='#cba6f7'>║</span></b> <span color='#cdd6f4'>{name[:15].upper()}</span> <span color='#45475a'>{dots}</span> <span color='#f5c2e7'>{fmt(rss):>8}</span>\n"

    tt += "<b><span color='#cba6f7'>╚════════════════════════════════════╝</span></b>\n"
    
    # Footer
    uptime = os.popen("uptime -p").read().replace("up ", "").strip()
    tt += f"<span color='#94e2d5'><b>UPTIME:</b> {uptime}</span>"

    # Bar Text (Kept your preferred icons)
    cpu_usage = int(psutil.cpu_percent())
    bar_text = f"<span color='#89b4fa'>󰻠</span> {cpu_usage}%  <span color='#a6e3a1'>󰍛</span> {int(mem.percent)}%"

    return json.dumps({"text": bar_text, "tooltip": tt})

if __name__ == "__main__":
    print(get_sys_info())