command: """
IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set theName to name of theTrack
        set output to theArtist & "|" & theName
        if length of output greater than 42 then
          return characters 1 thru 42 of output as text & "..."
        end if
          return output
        
    end tell')"
echo "$theArtist - $theName"
"""

refreshFrequency: 2000

style: """
  top: 28%
  left: 8.5%
  color: #fff

  .some-class
    font-family: Raleway
    opacity: 0.5
    //font-family: Helvetica Neue
    font-size: 30px
    font-weight: light
    text-shadow: 0 1px 5px #000000;
"""

render: (output) -> """
	<div class="some-class">#{output}</div>
"""