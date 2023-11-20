# Create the "Output" folder if it doesn't exist
$OutputFolder = ".\Output"
if (-not (Test-Path -Path $OutputFolder -PathType Container)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}

# Get a list of all AIFF files in the current folder
$AiffFiles = Get-ChildItem -Filter *.aiff

# Define colours for formatting
$OriginalColour = "Red"
$SeparatorColour = "Cyan"  # Changed to Cyan
$NewColour = "Green"


Write-Host "Remove (Original Mix) from all song titles in this folder" -ForegroundColor $SeparatorColour
Write-Host "If you found this helpful, please consider checking out my music!"
Write-Host "https://soundcloud.com/MartianMoon" -ForegroundColor $NewColour
Write-Host ""

# Loop through each AIFF file
foreach ($AiffFile in $AiffFiles) {
    # Use ffprobe to extract song title
    $SongTitleInfo = ffprobe -v error -select_streams a:0 -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$AiffFile"
    $SongTitle = $SongTitleInfo.Trim()
    $OriginalTitle = "$SongTitle"

    # Remove "(Original Mix)" from song title
    $NewSongTitle = $SongTitle -replace "\s\(Original Mix\)", ""
    $Separator = " -> "

    # Track whether the title was modified
    $Modified = $false

    if ($OriginalTitle -ne $NewSongTitle) {
        Write-Host "$OriginalTitle" -ForegroundColor $OriginalColour -NoNewline
        Write-Host "$Separator" -ForegroundColor $SeparatorColour -NoNewline
        Write-Host "$NewSongTitle" -ForegroundColor $NewColour
        $Modified = $true
    } else {
        Write-Host $NewSongTitle -ForegroundColor $NewColour
        $OutputFilePath = Join-Path -Path $OutputFolder -ChildPath $AiffFile.Name
        ffmpeg -loglevel error -i "$AiffFile" -write_id3v1 1 -write_id3v2 1 -metadata title=$NewSongTitle -c:v copy $OutputFilePath
    }

    # Update metadata in the AIFF file and save it to the "Output" folder if modified
    if ($Modified) {
        $OutputFilePath = Join-Path -Path $OutputFolder -ChildPath $AiffFile.Name
        ffmpeg -loglevel error -i "$AiffFile" -write_id3v1 1 -write_id3v2 1 -metadata title=$NewSongTitle -c:v copy $OutputFilePath
    }
}
