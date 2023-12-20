#!/usr/bin/env bash

ALERT_IF_IN_NEXT_MINUTES=10
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE="󰃯"
NERD_FONT_MEETING="󰃰"

get_attendees() {
  attendees=$(
    icalBuddy \
      --includeEventProps "attendees" \
      --propertyOrder "datetime,title" \
      --noCalendarNames \
      --dateFormat "%A" \
      --includeOnlyEventsFromNowOn \
      --limitItems 1 \
      --excludeAllDayEvents \
      --separateByDate \
      --excludeEndDates \
      --bullet "" \
      --excludeCals "training,omerxx@gmail.com" \
      eventsToday
  )
}

parse_attendees() {
  attendees_array=()
  for line in $attendees; do
    attendees_array+=("$line")
  done
  number_of_attendees=$((${#attendees_array[@]} - 3))
}

get_next_meeting() {
  next_meeting=$(icalBuddy \
    --includeEventProps "title,datetime" \
    --propertyOrder "datetime,title" \
    --noCalendarNames \
    --dateFormat "%A" \
    --timeFormat "%I:%M%p" \
    --includeOnlyEventsFromNowOn \
    --limitItems 1 \
    --excludeAllDayEvents \
    --separateByDate \
    --bullet "" \
    eventsToday)
}

get_next_next_meeting() {
  end_timestamp=$(date +"%Y-%m-%d ${end_time}:01 %z")
  tonight=$(date +"%Y-%m-%d 23:59:00 %z")
  next_next_meeting=$(
    icalBuddy \
      --includeEventProps "title,datetime" \
      --propertyOrder "datetime,title" \
      --noCalendarNames \
      --dateFormat "%A" \
      --limitItems 1 \
      --excludeAllDayEvents \
      --separateByDate \
      --bullet "" \
      eventsFrom:"${end_timestamp}" to:"${tonight}"
  )
}

parse_result() {
  array=()
  for line in $1; do
    array+=("$line")
  done
  time="${array[2]}"
  end_time="${array[4]}"
  title="${array[*]:5:30}"

  # echo $time
  # echo $end_time
  # echo $title

  # Debug output
  echo "Debug: Time variable is set to '$time'"
}
convert_to_24hr_format() {
  local input_time="$1"
  # echo "Attempting to convert: '$input_time'" # Debugging line

  # Explicitly set the locale to C to standardize the date format
  date -j -f "%I:%M %p" "$input_time" +"%H:%M" 2>/dev/null
}

calculate_times() {
  # Convert to 24-hour format and check for errors
  converted_time=$(convert_to_24hr_format "$time")
  if [ $? -ne 0 ] || [ -z "$converted_time" ]; then
    echo "Error in time conversion."
    return 1
  fi

  echo "Converted time: $converted_time" # Debugging line

  # Now proceed with the date command using the converted time
  epoc_meeting=$(date -j -f "%H:%M" "$converted_time" +%s 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error in date calculation."
    return 1
  fi

  epoc_now=$(date +%s)
  epoc_diff=$((epoc_meeting - epoc_now))
  minutes_till_meeting=$((epoc_diff / 60))
}
# calculate_times() {
#   # Check if time is in the correct format
#   if [[ $time =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
#     epoc_meeting=$(date -j -f "%T" "$time:00" +%s)
#     epoc_now=$(date +%s)
#     epoc_diff=$((epoc_meeting - epoc_now))
#     minutes_till_meeting=$((epoc_diff / 60))
#   else
#     return # Exit from the function with an error
#   fi
# }

display_popup() {
  tmux display-popup \
    -S "fg=#eba0ac" \
    -w50% \
    -h50% \
    -d '#{pane_current_path}' \
    -T meeting \
    icalBuddy \
    --propertyOrder "datetime,title" \
    --noCalendarNames \
    --formatOutput \
    --includeEventProps "title,datetime,notes,url,attendees" \
    --includeOnlyEventsFromNowOn \
    --limitItems 1 \
    --excludeAllDayEvents \
    --excludeCals "training" \
    eventsToday
}

print_tmux_status() {
  if [[ $minutes_till_meeting && $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES &&
    $minutes_till_meeting -gt -60 ]]; then
    echo "$NERD_FONT_MEETING \
			$time $title ($minutes_till_meeting minutes)"
  else
    echo "$NERD_FONT_FREE"
  fi

  if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && epoc_diff -lt $ALERT_POPUP_BEFORE_SECONDS+10 ]]; then
    display_popup
  fi
}

main() {
  get_attendees
  parse_attendees
  get_next_meeting
  parse_result "$next_meeting"
  calculate_times
  # if [[ "$next_meeting" != "" && $number_of_attendees -lt 2 ]]; then
  #   get_next_next_meeting
  #   parse_result "$next_next_meeting"
  #   calculate_times
  # fi
  print_tmux_status
  # echo "$minutes_till_meeting | $number_of_attendees"
}

main
