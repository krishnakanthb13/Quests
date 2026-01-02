#!/usr/bin/env python3
"""
Time Widget - Python + Tkinter Version
A lightweight floating widget that displays time in words.
"""

import tkinter as tk
from tkinter import ttk
from datetime import datetime
import json
import os

# Number to word mappings
NUMBER_WORDS = {
    0: 'zero', 1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
    6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
    11: 'eleven', 12: 'twelve', 13: 'thirteen', 14: 'fourteen', 15: 'fifteen',
    16: 'sixteen', 17: 'seventeen', 18: 'eighteen', 19: 'nineteen', 20: 'twenty',
    30: 'thirty', 40: 'forty', 50: 'fifty'
}

HOUR_WORDS = {
    1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
    6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
    11: 'eleven', 12: 'twelve'
}

CONFIG_FILE = 'time_widget_config.json'

def get_hour_word(hour):
    """Convert hour (0-23) to word."""
    h = 12 if hour == 0 else (hour - 12 if hour > 12 else hour)
    return HOUR_WORDS[h]

def get_minute_word(minutes):
    """Convert minutes to word."""
    if minutes == 0:
        return ''
    if minutes < 20:
        return NUMBER_WORDS[minutes]
    tens = (minutes // 10) * 10
    ones = minutes % 10
    if ones == 0:
        return NUMBER_WORDS[tens]
    return f"{NUMBER_WORDS[tens]}-{NUMBER_WORDS[ones]}"

def get_minutes_to_word(minutes):
    """Get minutes remaining until next hour."""
    remaining = 60 - minutes
    if remaining < 20:
        return NUMBER_WORDS[remaining]
    tens = (remaining // 10) * 10
    ones = remaining % 10
    if ones == 0:
        return NUMBER_WORDS[tens]
    return f"{NUMBER_WORDS[tens]}-{NUMBER_WORDS[ones]}"

def time_to_words_numeric(hour, minutes):
    """Convert time to numeric format (e.g., 'Three fifteen')."""
    hour_word = get_hour_word(hour)
    
    if minutes == 0:
        return f"{hour_word.capitalize()} o'clock"
    
    minute_word = get_minute_word(minutes)
    formatted_minute = f"oh {minute_word}" if minutes < 10 else minute_word
    
    return f"{hour_word.capitalize()} {formatted_minute}"

def time_to_words_natural(hour, minutes):
    """Convert time to natural format (e.g., 'A quarter past three')."""
    hour_word = get_hour_word(hour)
    next_hour_word = get_hour_word(hour + 1)
    
    if minutes == 0:
        return f"{hour_word.capitalize()} o'clock"
    elif minutes == 15:
        return f"A quarter past {hour_word}"
    elif minutes == 30:
        return f"Half past {hour_word}"
    elif minutes == 45:
        return f"A quarter to {next_hour_word}"
    elif minutes < 30:
        minute_word = get_minute_word(minutes)
        return f"{minute_word.capitalize()} past {hour_word}"
    else:
        minutes_to = get_minutes_to_word(minutes)
        return f"{minutes_to.capitalize()} to {next_hour_word}"

def convert_time_to_words(hour, minutes, format_type='numeric'):
    """Convert time to words based on format."""
    if format_type == 'natural':
        return time_to_words_natural(hour, minutes)
    else:
        return time_to_words_numeric(hour, minutes)

def load_config():
    """Load configuration from file."""
    default_config = {
        'time_format': 'numeric',
        'text_size': 32,
        'window_width': 400,
        'window_height': 200
    }
    
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, 'r') as f:
                config = json.load(f)
                # Merge with defaults to handle missing keys
                default_config.update(config)
        except:
            pass
    
    return default_config

def save_config(config):
    """Save configuration to file."""
    try:
        with open(CONFIG_FILE, 'w') as f:
            json.dump(config, f, indent=2)
    except:
        pass

class TimeWidget:
    def __init__(self):
        self.config = load_config()
        self.root = tk.Tk()
        self.setup_window()
        self.setup_ui()
        self.update_time()
        self.root.mainloop()
    
    def setup_window(self):
        """Configure the main window."""
        self.root.title("Time Widget")
        self.root.geometry(f"{self.config['window_width']}x{self.config['window_height']}")
        self.root.minsize(300, 150)
        
        # Make window always on top
        self.root.attributes('-topmost', True)
        
        # Remove window decorations (optional - comment out if you want title bar)
        # self.root.overrideredirect(True)
        
        # Dark theme colors
        self.bg_color = '#1a1a2e'
        self.bg_color2 = '#16213e'
        self.text_color = '#ffffff'
        self.accent_color = '#4a9eff'
        self.hover_color = '#5aaeff'
        
        self.root.configure(bg=self.bg_color)
        
        # Make window draggable
        self.root.bind('<Button-1>', self.start_drag)
        self.root.bind('<B1-Motion>', self.on_drag)
        self.drag_start_x = 0
        self.drag_start_y = 0
    
    def start_drag(self, event):
        """Start dragging the window."""
        self.drag_start_x = event.x
        self.drag_start_y = event.y
    
    def on_drag(self, event):
        """Handle window dragging."""
        x = self.root.winfo_pointerx() - self.drag_start_x
        y = self.root.winfo_pointery() - self.drag_start_y
        self.root.geometry(f"+{x}+{y}")
    
    def setup_ui(self):
        """Create the UI elements."""
        # Main container with gradient-like background
        self.container = tk.Frame(self.root, bg=self.bg_color, padx=20, pady=20)
        self.container.pack(fill=tk.BOTH, expand=True)
        
        # Header with buttons
        self.header = tk.Frame(self.container, bg=self.bg_color)
        self.header.pack(fill=tk.X, pady=(0, 10))
        
        # Settings button
        self.settings_btn = tk.Button(
            self.header, text="⚙", font=('Arial', 14),
            bg='#2a2a3e', fg=self.text_color, border=0,
            width=3, height=1, cursor='hand2',
            command=self.toggle_settings
        )
        self.settings_btn.pack(side=tk.RIGHT, padx=(0, 5))
        
        # Close button
        self.close_btn = tk.Button(
            self.header, text="×", font=('Arial', 18),
            bg='#2a2a3e', fg=self.text_color, border=0,
            width=3, height=1, cursor='hand2',
            command=self.root.quit
        )
        self.close_btn.pack(side=tk.RIGHT)
        
        # Time display
        self.time_frame = tk.Frame(self.container, bg=self.bg_color)
        self.time_frame.pack(fill=tk.BOTH, expand=True)
        
        self.time_label = tk.Label(
            self.time_frame,
            text="Loading...",
            font=('Georgia', self.config['text_size']),
            fg=self.text_color,
            bg=self.bg_color,
            wraplength=350,
            justify=tk.CENTER
        )
        self.time_label.pack(expand=True)
        
        # Settings panel (initially hidden)
        self.settings_panel = tk.Frame(self.container, bg=self.bg_color)
        self.settings_visible = False
        
        # Time format selection
        format_label = tk.Label(
            self.settings_panel, text="Time Format:",
            font=('Arial', 10), fg='#b0b0b0', bg=self.bg_color
        )
        format_label.pack(anchor=tk.W, pady=(10, 5))
        
        self.format_var = tk.StringVar(value=self.config['time_format'])
        
        format_frame = tk.Frame(self.settings_panel, bg=self.bg_color)
        format_frame.pack(fill=tk.X, pady=5)
        
        numeric_radio = tk.Radiobutton(
            format_frame, text="Three fifteen",
            variable=self.format_var, value='numeric',
            font=('Arial', 10), fg=self.text_color, bg='#2a2a3e',
            selectcolor='#1a1a2e', activebackground='#2a2a3e',
            activeforeground=self.text_color, cursor='hand2'
        )
        numeric_radio.pack(fill=tk.X, pady=2, padx=5)
        
        natural_radio = tk.Radiobutton(
            format_frame, text="A quarter past three",
            variable=self.format_var, value='natural',
            font=('Arial', 10), fg=self.text_color, bg='#2a2a3e',
            selectcolor='#1a1a2e', activebackground='#2a2a3e',
            activeforeground=self.text_color, cursor='hand2'
        )
        natural_radio.pack(fill=tk.X, pady=2, padx=5)
        
        # Text size control
        size_label = tk.Label(
            self.settings_panel, text="Text Size:",
            font=('Arial', 10), fg='#b0b0b0', bg=self.bg_color
        )
        size_label.pack(anchor=tk.W, pady=(10, 5))
        
        size_frame = tk.Frame(self.settings_panel, bg=self.bg_color)
        size_frame.pack(fill=tk.X, pady=5)
        
        self.size_var = tk.IntVar(value=self.config['text_size'])
        self.size_scale = tk.Scale(
            size_frame, from_=16, to=64, orient=tk.HORIZONTAL,
            variable=self.size_var, bg='#2a2a3e', fg=self.text_color,
            troughcolor='#1a1a2e', activebackground=self.accent_color,
            highlightthickness=0, length=300, command=self.on_size_change
        )
        self.size_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)
        
        self.size_label_display = tk.Label(
            size_frame, text=f"{self.config['text_size']}px",
            font=('Arial', 10), fg='#b0b0b0', bg=self.bg_color, width=5
        )
        self.size_label_display.pack(side=tk.RIGHT, padx=5)
        
        # Save button
        self.save_btn = tk.Button(
            self.settings_panel, text="Save",
            font=('Arial', 11, 'bold'), bg=self.accent_color, fg=self.text_color,
            border=0, cursor='hand2', command=self.save_settings,
            activebackground=self.hover_color, activeforeground=self.text_color
        )
        self.save_btn.pack(fill=tk.X, pady=(10, 0))
    
    def on_size_change(self, value):
        """Handle text size slider change."""
        size = int(value)
        self.size_label_display.config(text=f"{size}px")
        self.time_label.config(font=('Georgia', size))
    
    def toggle_settings(self):
        """Toggle settings panel visibility."""
        if self.settings_visible:
            self.settings_panel.pack_forget()
            self.settings_visible = False
        else:
            self.settings_panel.pack(fill=tk.X, pady=(10, 0))
            self.settings_visible = True
    
    def save_settings(self):
        """Save settings and update display."""
        self.config['time_format'] = self.format_var.get()
        self.config['text_size'] = self.size_var.get()
        self.config['window_width'] = self.root.winfo_width()
        self.config['window_height'] = self.root.winfo_height()
        
        save_config(self.config)
        self.time_label.config(font=('Georgia', self.config['text_size']))
        self.update_time()
        self.toggle_settings()
    
    def update_time(self):
        """Update the time display."""
        now = datetime.now()
        hours = now.hour
        minutes = now.minute
        
        time_string = convert_time_to_words(hours, minutes, self.config['time_format'])
        self.time_label.config(text=time_string)
        
        # Update every second
        self.root.after(1000, self.update_time)
    
    def on_resize(self, event):
        """Handle window resize."""
        if hasattr(self, 'time_label'):
            # Update wrap length based on window width
            width = self.root.winfo_width() - 80
            self.time_label.config(wraplength=max(200, width))

if __name__ == "__main__":
    app = TimeWidget()

