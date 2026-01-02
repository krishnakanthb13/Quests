# Load assemblies first (required for color definitions)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================
# CONFIGURATION - EDIT THESE VALUES
# ============================================

# Window Settings
$windowWidth = 380
$windowHeight = 220
$windowMinWidth = 250
$windowMinHeight = 150

# Header Bar (drag area)
$headerHeight = 32
$headerBackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)  # Dark blue

# Resize Grip
$resizeGripHeight = 12
$resizeGripBackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)

# Close Button
$closeBtnBackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
$closeBtnForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$closeBtnHoverBackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$closeBtnHoverForeColor = [System.Drawing.Color]::White
$closeBtnFontSize = 12

# Main Window Background (visible as border around browser)
$formBackColor = [System.Drawing.Color]::FromArgb(26, 26, 46)

# ============================================
# END CONFIGURATION
# ============================================

$htmlPath = Join-Path $PSScriptRoot "time_widget_simple.html"

# Force IE11 mode
$registryPath = "HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION"
$processName = [System.IO.Path]::GetFileName([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
if (-not (Test-Path $registryPath)) { New-Item $registryPath -Force | Out-Null }
Set-ItemProperty $registryPath -Name $processName -Value 11001 -Type DWord

# Script-level variables for dragging/resizing
$script:dragging = $false
$script:resizing = $false
$script:dragStart = [System.Drawing.Point]::Empty
$script:formStartPos = [System.Drawing.Point]::Empty
$script:originalSize = [System.Drawing.Size]::Empty

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Time Widget"
$form.Width = $windowWidth
$form.Height = $windowHeight
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.TopMost = $true
$form.BackColor = $formBackColor
$form.ShowInTaskbar = $true
$form.MinimumSize = New-Object System.Drawing.Size($windowMinWidth, $windowMinHeight)

# Header panel for drag and close button
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Height = $headerHeight
$headerPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$headerPanel.BackColor = $headerBackColor
$headerPanel.Cursor = [System.Windows.Forms.Cursors]::SizeAll

# Close button
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "X"
$closeBtn.Width = 32
$closeBtn.Height = $headerHeight
$closeBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.BackColor = $closeBtnBackColor
$closeBtn.ForeColor = $closeBtnForeColor
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", $closeBtnFontSize, [System.Drawing.FontStyle]::Bold)
$closeBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeBtn.Dock = [System.Windows.Forms.DockStyle]::Right

$closeBtn.Add_Click({ $form.Close() })
$closeBtn.Add_MouseEnter({ 
    $closeBtn.BackColor = $closeBtnHoverBackColor
    $closeBtn.ForeColor = $closeBtnHoverForeColor
})
$closeBtn.Add_MouseLeave({ 
    $closeBtn.BackColor = $closeBtnBackColor
    $closeBtn.ForeColor = $closeBtnForeColor
})

# Header drag events
$headerPanel.Add_MouseDown({
    param($sender, $e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $script:dragging = $true
        $script:dragStart = [System.Windows.Forms.Cursor]::Position
        $script:formStartPos = $form.Location
    }
})

$headerPanel.Add_MouseMove({
    param($sender, $e)
    if ($script:dragging) {
        $currentPos = [System.Windows.Forms.Cursor]::Position
        $deltaX = $currentPos.X - $script:dragStart.X
        $deltaY = $currentPos.Y - $script:dragStart.Y
        $form.Location = New-Object System.Drawing.Point(
            ($script:formStartPos.X + $deltaX),
            ($script:formStartPos.Y + $deltaY)
        )
    }
})

$headerPanel.Add_MouseUp({ $script:dragging = $false })

# Resize grip panel at bottom
$resizeGrip = New-Object System.Windows.Forms.Panel
$resizeGrip.Height = $resizeGripHeight
$resizeGrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
$resizeGrip.BackColor = $resizeGripBackColor
$resizeGrip.Cursor = [System.Windows.Forms.Cursors]::SizeNWSE

$resizeGrip.Add_MouseDown({
    param($sender, $e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $script:resizing = $true
        $script:dragStart = [System.Windows.Forms.Cursor]::Position
        $script:originalSize = $form.Size
    }
})

$resizeGrip.Add_MouseMove({
    param($sender, $e)
    if ($script:resizing) {
        $currentPos = [System.Windows.Forms.Cursor]::Position
        $deltaX = $currentPos.X - $script:dragStart.X
        $deltaY = $currentPos.Y - $script:dragStart.Y
        $newWidth = [Math]::Max($form.MinimumSize.Width, $script:originalSize.Width + $deltaX)
        $newHeight = [Math]::Max($form.MinimumSize.Height, $script:originalSize.Height + $deltaY)
        $form.Size = New-Object System.Drawing.Size($newWidth, $newHeight)
    }
})

$resizeGrip.Add_MouseUp({ $script:resizing = $false })

# Draw resize grip icon
$resizeGrip.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 255, 255, 255), 1)
    $w = $resizeGrip.Width
    $h = $resizeGrip.Height
    for ($i = 0; $i -lt 3; $i++) {
        $offset = ($i + 1) * 4
        $g.DrawLine($pen, ($w - $offset), $h, $w, ($h - $offset))
    }
    $pen.Dispose()
})

# WebBrowser control
$browser = New-Object System.Windows.Forms.WebBrowser
$browser.Dock = [System.Windows.Forms.DockStyle]::Fill
$browser.ScriptErrorsSuppressed = $true
$browser.ScrollBarsEnabled = $false
$browser.IsWebBrowserContextMenuEnabled = $false

# Add controls in correct order
$headerPanel.Controls.Add($closeBtn)
$form.Controls.Add($browser)
$form.Controls.Add($resizeGrip)
$form.Controls.Add($headerPanel)

# Navigate to HTML
$browser.Navigate($htmlPath)

# Show the form
[System.Windows.Forms.Application]::Run($form)
