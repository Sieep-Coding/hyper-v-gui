Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check if New-VM cmdlet is available
# if (-not (Get-Command -Name New-VM -ErrorAction SilentlyContinue)) {
#     $installFeatureResult = [System.Windows.Forms.MessageBox]::Show("Hyper-V management tools are not installed. Would you like to install them?", "Hyper-V Not Installed", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    
#     if ($installFeatureResult -eq "Yes") {
#         # Attempt to install Hyper-V management tools
#         try {
#             Install-WindowsFeature -Name Hyper-V-PowerShell -ErrorAction Stop
#         }
#         catch {
#             [System.Windows.Forms.MessageBox]::Show("Failed to install Hyper-V management tools. Please install them manually and try again.", "Installation Failed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
#             exit
#         }
#     }
#     else {
#         exit
#     }
# }

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Hyper-V VM Creation Utility"
$form.Size = New-Object System.Drawing.Size(600, 400) 
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.BackColor = [System.Drawing.Color]::WhiteSmoke 
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Greeting Label
$greetingLabel = New-Object System.Windows.Forms.Label
$greetingLabel.Text = "Hyper-V VM Creation Utility"
$greetingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$greetingLabel.AutoSize = $true
$greetingLabel.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($greetingLabel)

# Virtual Machine Name Label and TextBox
$vmNameLabel = New-Object System.Windows.Forms.Label
$vmNameLabel.Text = "Virtual Machine Name:"
$vmNameLabel.AutoSize = $true
$vmNameLabel.Location = New-Object System.Drawing.Point(20, 80)
$form.Controls.Add($vmNameLabel)

$vmNameBox = New-Object System.Windows.Forms.TextBox
$vmNameBox.Location = New-Object System.Drawing.Point(200, 80)
$vmNameBox.Size = New-Object System.Drawing.Size(200, 25) 
$form.Controls.Add($vmNameBox)

# Memory Label and ComboBox
$memoryLabel = New-Object System.Windows.Forms.Label
$memoryLabel.Text = "Memory (GB):"
$memoryLabel.AutoSize = $true
$memoryLabel.Location = New-Object System.Drawing.Point(20, 130) 
$form.Controls.Add($memoryLabel)

$memoryComboBox = New-Object System.Windows.Forms.ComboBox
$memoryComboBox.Location = New-Object System.Drawing.Point(200, 130)
$memoryComboBox.Size = New-Object System.Drawing.Size(100, 25)
@(1, 2, 3, 4, 6, 8, 12, 16) | ForEach-Object { [void]$memoryComboBox.Items.Add($_) } 
$memoryComboBox.SelectedIndex = 0
$form.Controls.Add($memoryComboBox)

# VHD Size Label and TextBox
$vhdSizeLabel = New-Object System.Windows.Forms.Label
$vhdSizeLabel.Text = "Virtual Hard Disk Size (GB):"
$vhdSizeLabel.AutoSize = $true
$vhdSizeLabel.Location = New-Object System.Drawing.Point(20, 180) 
$form.Controls.Add($vhdSizeLabel)

$vhdSizeBox = New-Object System.Windows.Forms.TextBox
$vhdSizeBox.Location = New-Object System.Drawing.Point(200, 180)
$vhdSizeBox.Size = New-Object System.Drawing.Size(100, 25)
$form.Controls.Add($vhdSizeBox)

# VHD Location Label and TextBox
$vhdLocationLabel = New-Object System.Windows.Forms.Label
$vhdLocationLabel.Text = "VHD Location:"
$vhdLocationLabel.AutoSize = $true
$vhdLocationLabel.Location = New-Object System.Drawing.Point(20, 230) 
$form.Controls.Add($vhdLocationLabel)

$vhdLocationBox = New-Object System.Windows.Forms.TextBox
$vhdLocationBox.Location = New-Object System.Drawing.Point(200, 230)
$vhdLocationBox.Size = New-Object System.Drawing.Size(200, 25)
$vhdLocationBox.Text = "C:\temp\" # Set default VHD location
$form.Controls.Add($vhdLocationBox)

# Create Button
$createButton = New-Object System.Windows.Forms.Button
$createButton.Text = "Create Virtual Machine"
$createButton.Location = New-Object System.Drawing.Point(200, 280) 
$createButton.Size = New-Object System.Drawing.Size(200, 40)
$createButton.BackColor = [System.Drawing.Color]::DeepSkyBlue 
$createButton.ForeColor = [System.Drawing.Color]::White
$createButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($createButton)

# Button Click Event
$createButton.Add_Click({
    $vmName = $vmNameBox.Text
    $vmMemory = $memoryComboBox.SelectedItem.ToString() + "GB"
    $vhdSize = $vhdSizeBox.Text + "GB"
    $vhdLocation = $vhdLocationBox.Text
    $vhdPath = "$vhdLocation\$vmName.VHDX"
    $newVMCommand = "New-VM -Name $vmName -MemoryStartupBytes $vmMemory -NewVHDPath $vhdPath -NewVHDSizeBytes $vhdSize"
    Invoke-Expression $newVMCommand
    $vmNameBox.Clear()
    $vhdSizeBox.Clear()
    [System.Windows.Forms.MessageBox]::Show("Virtual Machine created successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, 
    [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Display Form
$form.ShowDialog() | Out-Null
