#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
max_length=20    # Adjust the maximum length as needed
separator="    " # Five spaces as separator, adjust as you like
scroll_file="${current_dir}/scroll_position.txt"

# Initialize scroll position if it doesn't exist
if [ ! -f "$scroll_file" ]; then
  echo 0 >"$scroll_file"
fi

main() {
  track_info=$(osascript ${current_dir}/current_track.applescript)

  # Split track info into playtime and track
  IFS=' | ' read -r play_time current_track <<<"$track_info"

  # Append the separator to the track
  current_track="${current_track}${separator}"

  # Read the current scroll position
  scroll_position=$(cat "$scroll_file")

  # Calculate the length of the track info with separator
  track_length=${#current_track}

  # Update scroll position
  scroll_position=$((scroll_position + 1))
  if [ $scroll_position -ge $track_length ]; then
    scroll_position=0
  fi
  echo $scroll_position >"$scroll_file"

  # Concatenate the track with itself and then cut out the visible portion
  visible_track="${current_track}${current_track}"
  visible_track="${visible_track:$scroll_position:$max_length}"

  # Output play time and visible track
  echo "  $play_time $visible_track"
}

# Run main program
main

# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# scroll_position=0
# max_length=30 # Set the maximum length of the displayed text
#
# main() {
#   # Fetch current track and playtime
#   track_info=$(osascript ${current_dir}/current_track.applescript)
#
#   # Split track info into track and playtime
#   IFS=' | ' read -r current_track play_time <<<"$track_info"
#
#   # Truncate and shift the track text
#   if [ ${#current_track} -gt $max_length ]; then
#     scroll_position=$(((scroll_position + 1) % (${#current_track} + 1)))
#     truncated_track=$(echo $current_track | cut -c$scroll_position-$(($scroll_position + $max_length)))
#   else
#     truncated_track=$current_track
#     scroll_position=0
#   fi
#
#   # Output play time and truncated track
#   echo "$play_time $truncated_track"
# }
#
# # Run main program
# main

# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# max_length=20 # Adjust the maximum length as needed
#
# main() {
#   track_info=$(osascript ${current_dir}/current_track.applescript)
#
#   # Split track info into playtime and track
#   IFS=' | ' read -r play_time current_track <<<"$track_info"
#
#   # Truncate track if it's too long
#   if [ ${#current_track} -gt $max_length ]; then
#     current_track="${current_track:0:$max_length}󰇘"
#   else
#     current_track="$current_track"
#   fi
#
#   # Output play time and truncated track
#   echo "$play_time $current_track"
# }
#
# # Run main program
# main

# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# max_length=20 # Adjust the maximum length as needed
# scroll_file="${current_dir}/scroll_position.txt"
#
# # Initialize scroll position if it doesn't exist
# if [ ! -f "$scroll_file" ]; then
#   echo 0 >"$scroll_file"
# fi
#
# main() {
#   track_info=$(osascript ${current_dir}/current_track.applescript)
#
#   # Split track info into playtime and track
#   IFS=' | ' read -r play_time current_track <<<"$track_info"
#
#   # Read the current scroll position
#   scroll_position=$(cat "$scroll_file")
#
#   # Update scroll position
#   scroll_position=$(((scroll_position + 1) % (${#current_track} + max_length)))
#   echo $scroll_position >"$scroll_file"
#
#   # Create the scrolled track text
#   scrolled_track="${current_track:scroll_position:max_length}"
#   if [ $scroll_position -gt ${#current_track} ]; then
#     scrolled_track="${scrolled_track}${current_track:0:scroll_position-${#current_track}}"
#   fi
#
#   # Pad with spaces to ensure consistent width
#   while [ ${#scrolled_track} -lt $max_length ]; do
#     scrolled_track="${scrolled_track} "
#   done
#
#   # Output play time and scrolled track
#   echo "$play_time $scrolled_track"
# }
#
# # Run main program
# main
