import { convertTimeToWords } from './timeConverter.js';
import { getCurrentWindow } from '@tauri-apps/api/window';

let timeFormat = localStorage.getItem('timeFormat') || 'numeric';
let textSize = parseInt(localStorage.getItem('textSize')) || 32;
let updateInterval;

function updateTime() {
    const now = new Date();
    const hours = now.getHours();
    const minutes = now.getMinutes();
    
    const timeString = convertTimeToWords(hours, minutes, timeFormat);
    document.getElementById('timeText').textContent = timeString;
}

function updateTextSize(size) {
    textSize = size;
    document.getElementById('timeText').style.fontSize = `${size}px`;
    localStorage.setItem('textSize', size.toString());
}

function initializeSettings() {
    const savedFormat = localStorage.getItem('timeFormat');
    if (savedFormat) {
        timeFormat = savedFormat;
        document.querySelector(`input[value="${savedFormat}"]`).checked = true;
    }
    
    const savedTextSize = localStorage.getItem('textSize');
    if (savedTextSize) {
        textSize = parseInt(savedTextSize);
        document.getElementById('textSizeSlider').value = textSize;
        document.getElementById('textSizeValue').textContent = textSize;
        updateTextSize(textSize);
    }
}

function setupEventListeners() {
    // Settings button
    document.getElementById('settingsBtn').addEventListener('click', () => {
        const panel = document.getElementById('settingsPanel');
        panel.classList.toggle('active');
    });
    
    // Close button
    document.getElementById('closeBtn').addEventListener('click', async () => {
        const appWindow = getCurrentWindow();
        await appWindow.close();
    });
    
    // Text size slider
    const textSizeSlider = document.getElementById('textSizeSlider');
    const textSizeValue = document.getElementById('textSizeValue');
    
    textSizeSlider.addEventListener('input', (e) => {
        const size = parseInt(e.target.value);
        textSizeValue.textContent = size;
        updateTextSize(size);
    });
    
    // Save button
    document.getElementById('saveBtn').addEventListener('click', () => {
        const selectedFormat = document.querySelector('input[name="timeFormat"]:checked').value;
        timeFormat = selectedFormat;
        localStorage.setItem('timeFormat', selectedFormat);
        
        const currentTextSize = parseInt(textSizeSlider.value);
        updateTextSize(currentTextSize);
        
        document.getElementById('settingsPanel').classList.remove('active');
        updateTime();
    });
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initializeSettings();
    setupEventListeners();
    updateTime();
    
    // Update every second
    updateInterval = setInterval(updateTime, 1000);
});

// Cleanup on close
window.addEventListener('beforeunload', () => {
    if (updateInterval) {
        clearInterval(updateInterval);
    }
});

