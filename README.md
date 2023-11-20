# Music Scripts
Miscalaneous Powershell scripts for dealing with music files, with use-cases common for Music Producers & DJs.

## FFmpeg Batch Conversion
Convert batches of audio files using [FFmpeg](https://www.ffmpeg.org/)

It will grab all files of a specified filetype in a folder, and convert them to your target filetype.

This example is to convert **FLAC audio to AIFF**.
Replace the extension types & the ffmpeg command paramaters as needed.

[ffmpeg](https://www.ffmpeg.org/) must be in your PATH directory ([Instructions](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/))


## Prefix Remover

Remove prefixes from file names.

Purpose: Renaming track stems from Ableton Live.

In Ableton, when you export stems, you are forced to provide a track name prefix that will be appended to every file name.

As a result, you end up with "Prefix Bass.wav", "Prefix Lead.wav", etc. as opposed to "Bass.wav" & "Lead.wav"


## Remove "(Original Mix)" From Song Titles

Beatport downloads, unless an extended mix or remix, always tack "(Original Mix)" onto the end of the song title.

I used to spend hours painstakingly manually renaming all the songs I got from beatport... so I automated it 😀
