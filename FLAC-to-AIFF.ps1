# Set input/output here
$InputExtension = "flac"
$OutputExtension = "aiff"

# Create new directory named after the output filetype
New-Item -Name "$OutputExtension" -ItemType "directory"

Get-ChildItem .\ -Filter *.$InputExtension |
ForEach-Object {
    # Set the new file names
    $NewName = $_.Name.Remove($_.Name.Length - $_.Extension.Length) + ".$OutputExtension"

    # ffmpeg command can be modified to whatever paramaters you want
    ffmpeg -i $_.FullName -write_id3v2 1 -c:v copy ".\$OutputExtension\$NewName"
}
