# Filename Prefix Remover in PowerShell

# Introduction
Write-Host "Proceeding will rename all .WAV, .AIF, .MP3 & .ASD files in this folder"
Write-Host "Any prefix amongst the files will be removed (anything to the left of the first space in the file name)"
Write-Host "eg. 'Song Bass.wav' & 'Song Lead.wav' will be renamed to 'Bass.wav' & 'Lead.wav' respectively"
Write-Host ""
Write-Host "However, if there is a 2nd space in the prefix, it will only remove the first word"
Write-Host "eg. 'Song Title Bass.wav' will be renamed to 'Title Bass.wav'"
Write-Host "This can be solved by simply running this script twice."
Write-Host ""

# User Confirmation
$Proceed = Read-Host "Proceed? (Y/N)"
if ($Proceed -ne "Y") {
    exit
}

# Function to remove the prefix
function Remove-Prefix {
    param ($extension)
    Get-ChildItem "* *.$extension" -File | ForEach-Object {
        $newName = ($_.Name -split ' ', 2)[1]
        if ($newName) {
            Rename-Item $_.FullName -NewName $newName
        }
    }
}

# Remove prefix for each file type
Remove-Prefix "wav"
Remove-Prefix "aif"
Remove-Prefix "aiff"
Remove-Prefix "mp3"
Remove-Prefix "asd"