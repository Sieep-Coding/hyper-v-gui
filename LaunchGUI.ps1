#  script to launch the GUI

# Define paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$guiScript = Join-Path $scriptDir "GUI.ps1"

# Execute GUI script
& $guiScript
