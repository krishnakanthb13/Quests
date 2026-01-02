Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$htmlPath = Join-Path $PSScriptRoot "time_widget.html"

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
$form.Width = 380
$form.Height = 220
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(26, 26, 46)
$form.ShowInTaskbar = $true
$form.MinimumSize = New-Object System.Drawing.Size(250, 150)

# Header panel for drag and close button
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Height = 32
$headerPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$headerPanel.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
$headerPanel.Cursor = [System.Windows.Forms.Cursors]::SizeAll

# Close button
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "X"
$closeBtn.Width = 32
$closeBtn.Height = 32
$closeBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
$closeBtn.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$closeBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeBtn.Dock = [System.Windows.Forms.DockStyle]::Right

$closeBtn.Add_Click({ $form.Close() })
$closeBtn.Add_MouseEnter({ 
    $closeBtn.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
    $closeBtn.ForeColor = [System.Drawing.Color]::White
})
$closeBtn.Add_MouseLeave({ 
    $closeBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
    $closeBtn.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
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
$resizeGrip.Height = 12
$resizeGrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
$resizeGrip.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
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
    # Draw diagonal lines for grip
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

# Add controls in correct order (browser first, then overlays)
$headerPanel.Controls.Add($closeBtn)
$form.Controls.Add($browser)
$form.Controls.Add($resizeGrip)
$form.Controls.Add($headerPanel)

# Navigate to HTML
$browser.Navigate($htmlPath)

# Show the form
[System.Windows.Forms.Application]::Run($form)
