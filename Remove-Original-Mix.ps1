<#
.SYNOPSIS
	Remove "(Original Mix)" from AIFF song titles using FFMpeg.

.DESCRIPTION
    Removes the text "(Original Mix)" from AIFF song titles.
    Requires FFMpeg to be installed in a PATH location.

.PARAMETER titleCase
    Correct song title casing to use Title Casing (Like This).

.EXAMPLE
    PS C:\scripts> .\Remove-Original-Mix.ps1
    PS C:\scripts> .\Remove-Original-Mix.ps1 -titleCase

####################################################################################################################

.NOTES
    Version: 1.1
    Last Updated: 12/12/2023
    Created Date: 11/20/2023
    Author: Justin Lund

.ROADMAP
- Optional Input & Output folder (-input / -output)
   - If run from the same directory without -input, apply to AIFFs in current directory
   - Allow output folder directory selection
- Option to overwrite the existing files instead of creating a new folder (-overwrite)
   - Cannot be used simaltaneously with -output
- Exclude phrases "a", "of", "the, etc from Title Casing unless it's the 1st word
- Update output to show file name changes for Title Casing updates without (Original Mix) removal

####################################################################################################################

param (
    [switch]$titleCase
)

$OutputFolder = ".\Output"
if (-not (Test-Path -Path $OutputFolder -PathType Container)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}

$AiffFiles = Get-ChildItem -Filter *.aiff

$OriginalColour = "Red"
$SeparatorColour = "Cyan"
$NewColour = "Green"

Write-Host "Remove (Original Mix) from all song titles in this folder" -ForegroundColor $SeparatorColour
Write-Host "If you found this helpful, please consider checking out my music!"
Write-Host "https://soundcloud.com/MartianMoon" -ForegroundColor $NewColour
Write-Host ""

foreach ($AiffFile in $AiffFiles) {
    $SongTitleInfo = ffprobe -v error -select_streams a:0 -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$AiffFile"
    $SongTitle = $SongTitleInfo.Trim()
    $OriginalTitle = "$SongTitle"

    $SongTitle = $SongTitle -replace "\s\(Original Mix\)", ""

    # Conditional Title Case Conversion
    if ($titleCase) {
        $TextInfo = (Get-Culture).TextInfo
        $SongTitle = $TextInfo.ToTitleCase($SongTitle.ToLower())
    }

    $Separator = " -> "
    $Modified = $OriginalTitle -ne $SongTitle

    if ($Modified) {
        Write-Host "$OriginalTitle" -ForegroundColor $OriginalColour -NoNewline
        Write-Host "$Separator" -ForegroundColor $SeparatorColour -NoNewline
        Write-Host "$SongTitle" -ForegroundColor $NewColour
    } else {
        Write-Host $SongTitle -ForegroundColor $NewColour
    }

    # Always update metadata and save to "Output" folder
    $OutputFilePath = Join-Path -Path $OutputFolder -ChildPath $AiffFile.Name
    ffmpeg -loglevel error -i "$AiffFile" -write_id3v1 1 -write_id3v2 1 -metadata title="$SongTitle" -c:v copy $OutputFilePath
}
