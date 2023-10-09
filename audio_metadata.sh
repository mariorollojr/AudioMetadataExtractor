#!/bin/zsh

# This script extracts date, creation time, duration, and bitrate
# from audio files in WAV format and saves the results as a CSV file.

# Output CSV file name
output_csv="audio_metadata.csv"

# Ensure you have the necessary prerequisites installed:
# - ffmpeg for ffprobe
# - jq for JSON parsing
# You can install them as follows:
# - ffmpeg: https://ffmpeg.org/download.html
# - jq: Install using your system's package manager (e.g., sudo apt-get install jq on Debian/Ubuntu).

# Specify the folder containing your audio files.
audio_folder="/Volumes/G-RAID/Abisko_2023/long-term/Ants_09-21.07"

# Initialize CSV file with headers
echo "File Name,Date,Creation Time,Duration,Bitrate" > "$output_csv"

# Loop through each WAV file in the folder
for file in $audio_folder/*.WAV; do
    # Use ffprobe to extract metadata as JSON
    metadata=$(ffprobe -v quiet -print_format json -show_entries format_tags=creation_time,date,duration,bit_rate:format=Duration,bit_rate:format=Audio "$file" 2>/dev/null)

    # Parse date, creation_time, duration, bitrate, and audio info from metadata using jq
    date=$(echo "$metadata" | jq -r '.format.tags.date // .format.tags.DATE // empty')
    creation_time=$(echo "$metadata" | jq -r '.format.tags.creation_time // .format.tags.CREATION_TIME // empty')
    duration=$(echo "$metadata" | jq -r '.format.duration')
    bitrate=$(echo "$metadata" | jq -r '.format.bit_rate')


    # Remove path and extension from the file name
    file_name=$(basename "$file" .WAV)

    # Append the data to the CSV file
    echo "$file_name,$date,$creation_time,$duration,$bitrate" >> "$output_csv"
done

# Inform the user that metadata extraction is complete
echo "Metadata extraction complete. CSV file saved as $output_csv"
