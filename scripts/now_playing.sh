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
  IFS=$'\n' read -d '' -r -a track_info < <($current_dir/nowplaying-cli get title artist duration elapsedTime playbackRate && printf '\0')

  title="${track_info[0]}"
  artist="${track_info[1]}"
  duration="${track_info[2]}"
  elapsedTime="${track_info[3]}"
  playbackRate="${track_info[4]}"

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

  # Choose the icon based on playback rate
  if [ "$playbackRate" == "0" ]; then
    icon="" # Pause icon from Nerd Fonts
  else
    icon="" # Play icon from Nerd Fonts
  fi

  echo "$icon $elapsed_time_formatted $visible_track"
}

main
