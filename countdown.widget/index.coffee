###
----------------------------------------------------------------

    Fancy DateTime - v1.0.0

    Uebersicht-widget for displaying the current time and date


    Robin 'codeFareith' von den Bergen
    robinvonberg@gmx.de
    https://github.com/codefareith

----------------------------------------------------------------
###
powerSaver = true;
# Widget Settings
settings =
    lang: 'en'
    powerSaver: powerSaver
    displaySecond: if (powerSaver) then 'none' else ''
    militaryTime: true
    colors:
      default: 'rgba(0, 0, 0, .75)'
      accent: 'rgba(255, 255, 255, .75)'
      background: 'rgba(255, 255, 255, .1)'
    shadows:
      box: '0 0 1.25em rgba(0, 0, 0, .5)'
      text: '0 0 0.625em rgba(0, 0, 0, .25)'

# Locale Strings
locale =
  en:
    weekdays: [
      'Sunday'
      'Monday'
      'Tuesday'
      'Wednesday'
      'Thursday'
      'Friday'
      'Saturday'
    ]
    months: [
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December'
    ]
  

command: ""

settings: settings
locale: locale

refreshFrequency: if settings.powerSaver then 60000 else 1000

style: """
  top: 54%
  opacity: 0.5
  left: 43%
  font-family: 'Anurati', sans-serif
  letter-spacing: 4px
  font-size: 14px
  line-height: 1
  text-transform: uppercase
  transform: translate(-50%, -50%) scale(0.2)
  z-index: 4
  .container
    position: relative
    display: table
    height: 100%
    padding: 1rem 2rem
    //border-radius: 1rem
    //background: #{ settings.colors.background }
    //box-shadow: #{ settings.shadows.box }
    text-shadow: #{ settings.shadows.text }
    overflow: hidden
    //-webkit-backdrop-filter: blur(10px)

  .cell
    position: relative
    display: flex
    flex-direction: row
    overflow: hidden

  .left
    float: left

  .txt-default
    color: #{ settings.colors.default }

  .txt-accent
    color: #{ settings.colors.accent }

  .txt-small
    margin-top: 42px
    margin-right: 8px
    font-size: 1.5rem
    font-weight: 500

  .txt-large
    font-size: 5rem
    font-weight: 700
  .conditional
    display: #{ settings.displaySecond }
"""
render: () -> """
  <div class='container'>
    <div class='cell'>
      <span class='daysnum txt-default txt-large left'></span>
      <span class='daystext txt-accent txt-small left'>days</span>
      <span class='hoursnum txt-default txt-large left'></span>
      <span class='hourstext txt-accent txt-small left'>hours</span>
      <span class='minutes txt-default txt-large left'></span>
      <span class='minutestext txt-accent txt-small left'>mins</span>
      <span class='seconds txt-default txt-large left'></span>
      <span class='secondstext txt-accent txt-small left conditional'>seconds</span>
    </div>
  </div>
"""

afterRender: (domEl) ->

update: (output, domEl) ->
  date = @getDate()

  $(domEl).find('.daysnum').text(date.days)
  $(domEl).find('.hoursnum').text(date.hours)
  $(domEl).find('.minutes').text(date.minutes)
  !settings.powerSaver && $(domEl).find('.seconds').text(date.seconds)

# Helper-Functions
zeroFill: (value) ->
  return ('0' + value).slice(-2)

getDate: () ->
  targetDate = new Date(2020, 3, 9, 0, 0, 0) # time till 9th of April at 00:00
  date = new Date()

  difference = targetDate.getTime() - date.getTime()
  differenceInDays = Math.round(difference / (1000 * 3600 * 24))

  minutes = 60 -  (Math.abs(targetDate.getMinutes() - date.getMinutes()) % 60)
  hours =  24 - (Math.abs(targetDate.getHours() - date.getHours()) % 24)

  seconds = if (settings.powerSaver) then 0 else (60 - (Math.abs(targetDate.getSeconds() - date.getSeconds()) % 60))

  differenceInDays = @zeroFill(differenceInDays - 1)
  hours = @zeroFill(hours)
  minutes = @zeroFill(minutes)
  seconds = @zeroFill(seconds)

  return {
    hours: hours
    minutes: minutes
    seconds: seconds
    days: differenceInDays
  }
