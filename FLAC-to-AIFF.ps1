# Set input/output here
$InputExtension = "flac"
$OutputExtension = "aiff"

# Create new directory named after the output filetype
New-Item -Name "$OutputExtension" -ItemType "directory" -Force

Get-ChildItem .\ -Filter *.$InputExtension | ForEach-Object {
    # Use ffprobe to get bit depth and sample rate
    $ffprobeOutput = & ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,bits_per_sample -of default=noprint_wrappers=1:nokey=1 $_.FullName
    $properties = $ffprobeOutput -split "`n"
    $sampleRate = $properties[0]
    $bitDepth = $properties[1]

    # Determine the appropriate sample_fmt and codec
    $codec = "pcm_s${bitDepth}be"
    $sampleFmt = "s${bitDepth}"

    if ($bitDepth -eq 24) {
        # If bit depth is 24, use s32 sample_fmt for pcm_s24be codec
        $sampleFmt = "s32"
    }

    $NewName = $_.Name.Remove($_.Name.Length - $_.Extension.Length) + ".$OutputExtension"
    
    # Run ffmpeg with dynamic parameters
    & ffmpeg -i $_.FullName -ar $sampleRate -sample_fmt $sampleFmt -acodec $codec -write_id3v2 1 ".\$OutputExtension\$NewName"
}
