#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
max_length=20
separator="    "
scroll_file="${current_dir}/np_scroll_position.txt"

if [ ! -f "$scroll_file" ]; then
  echo 0 >"$scroll_file"
fi

convert_seconds_to_mm_ss() {
  local total_seconds=$1
  local minutes=$((total_seconds / 60))
  local seconds=$((total_seconds % 60))
  printf "%02d:%02d" $minutes $seconds
}

main() {
  IFS=$'\n' read -d '' -r -a track_info < <($current_dir/nowplaying-cli get title artist duration elapsedTime && printf '\0')

  title="${track_info[0]}"
  artist="${track_info[1]}"
  duration="${track_info[2]}"
  elapsedTime="${track_info[3]}"

  # Convert the elapsed time to an integer
  elapsed_time_seconds=$(printf "%.0f" "$elapsedTime")

  # Convert to MM:SS format
  elapsed_time_formatted=$(convert_seconds_to_mm_ss "$elapsed_time_seconds")

  current_track="${title} - ${artist}${separator}"

  scroll_position=$(cat "$scroll_file")

  track_length=${#current_track}

  scroll_position=$((scroll_position + 1))
  if [ $scroll_position -ge $track_length ]; then
    scroll_position=0
  fi
  echo $scroll_position >"$scroll_file"

  visible_track="${current_track}${current_track}"
  visible_track="${visible_track:$scroll_position:$max_length}"

  echo " $elapsed_time_formatted $visible_track"
}

main
# #!/usr/bin/env bash
# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# max_length=20    # Adjust the maximum length as needed
# separator="    " # Five spaces as separator, adjust as you like
# scroll_file="${current_dir}/np_scroll_position.txt"
#
# # Initialize scroll position if it doesn't exist
# if [ ! -f "$scroll_file" ]; then
#   echo 0 >"$scroll_file"
# fi
#
# # Function to convert seconds to MM:SS format
# convert_seconds_to_mm_ss() {
#   local total_seconds=$1
#   local minutes=$((total_seconds / 60))
#   local seconds=$((total_seconds % 60))
#   printf "%02d:%02d" $minutes $seconds
# }
#
# main() {
#   track_info=$($current_dir/nowplaying-cli get title artist duration elapsedTime)
#
#   # Split track info into components
#   IFS=' | ' read -r title artist duration elapsedTime <<<"$track_info"
#
#   # Convert elapsedTime to MM:SS format
#   elapsed_time_formatted=$(convert_seconds_to_mm_ss "$elapsedTime")
#
#   # Concatenate track title and artist
#   current_track="${title} - ${artist}${separator}"
#
#   # Read the current scroll position
#   scroll_position=$(cat "$scroll_file")
#
#   # Calculate the length of the track info with separator
#   track_length=${#current_track}
#
#   # Update scroll position
#   scroll_position=$((scroll_position + 1))
#   if [ $scroll_position -ge $track_length ]; then
#     scroll_position=0
#   fi
#   echo $scroll_position >"$scroll_file"
#
#   # Concatenate the track with itself and then cut out the visible portion
#   visible_track="${current_track}${current_track}"
#   visible_track="${visible_track:$scroll_position:$max_length}"
#
#   # Output play time and visible track
#   echo " $elapsed_time_formatted $visible_track"
# }
#
# # Run main program
# main
#!/usr/bin/env bash
# current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# max_length=20    # Adjust the maximum length as needed
# separator="    " # Five spaces as separator, adjust as you like
# scroll_file="${current_dir}/np_scroll_position.txt"
#
# # Initialize scroll position if it doesn't exist
# if [ ! -f "$scroll_file" ]; then
#   echo 0 >"$scroll_file"
# fi
#
# main() {
#   track_info=$($current_dir/nowplaying-cli get title artist duration elapsedTime)
#
#   # Split track info into playtime and track
#   IFS=' | ' read -r play_time current_track <<<"$track_info"
#
#   # Append the separator to the track
#   current_track="${current_track}${separator}"
#
#   # Read the current scroll position
#   scroll_position=$(cat "$scroll_file")
#
#   # Calculate the length of the track info with separator
#   track_length=${#current_track}
#
#   # Update scroll position
#   scroll_position=$((scroll_position + 1))
#   if [ $scroll_position -ge $track_length ]; then
#     scroll_position=0
#   fi
#   echo $scroll_position >"$scroll_file"
#
#   # Concatenate the track with itself and then cut out the visible portion
#   visible_track="${current_track}${current_track}"
#   visible_track="${visible_track:$scroll_position:$max_length}"
#
#   # Output play time and visible track
#   echo " $play_time $visible_track"
# }
#
# # Run main program
# main
