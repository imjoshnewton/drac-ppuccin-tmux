
on formatTime(num)
    if num < 10 then
        return "0" & num as string
    else
        return num as string
    end if
end formatTime

tell application "Music"
    if it is running then
        if (player state is playing) then
            set currentPosition to player position

            set currentMinutes to (round (currentPosition / 60) rounding down) as integer
            set currentSeconds to (round (currentPosition mod 60) rounding to nearest) as integer

            set formattedPlayTime to my formatTime(currentMinutes) & ":" & my formatTime(currentSeconds)
        else
            set formattedPlayTime to ""
        end if
    else
        set formattedPlayTime to ""
    end if
end tell

return formattedPlayTime
