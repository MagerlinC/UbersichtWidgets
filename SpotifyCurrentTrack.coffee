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
  top: 38%
  left: 11.5%
  color: #fff 
  z-index: 3
  .some-class
    opacity: 0.4
    font-family: Raleway
    // text-transform: uppercase
    font-size: 24px
    font-weight: bold
    text-shadow: 0 0 0.625em rgba(0, 0, 0, .25)
"""

render: (output) -> """
	<div class="some-class">#{output}</div>
"""