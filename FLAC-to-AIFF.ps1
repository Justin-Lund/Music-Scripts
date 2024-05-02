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

    # Set defaults for codec and sample_fmt
    $codec = "pcm_s16be"
    $sampleFmt = "s16"

    switch ($bitDepth) {
        16 {
            $sampleFmt = "s16"  # 16-bit files use s16 sample format with pcm_s16be codec
            $codec = "pcm_s16be"
        }
        24 {
            $sampleFmt = "s32"  # 24-bit files use s32 sample format with pcm_s24be codec
            $codec = "pcm_s24be"
        }
        32 {
            $sampleFmt = "s32"  # 32-bit files also use s32 sample format, but with pcm_s32be codec
            $codec = "pcm_s32be"
        }
    }

    $NewName = $_.Name.Remove($_.Name.Length - $_.Extension.Length) + ".$OutputExtension"
    
    # Run ffmpeg with dynamic parameters
    & ffmpeg -i $_.FullName -ar $sampleRate -sample_fmt $sampleFmt -acodec $codec -write_id3v2 1 ".\$OutputExtension\$NewName"
}
