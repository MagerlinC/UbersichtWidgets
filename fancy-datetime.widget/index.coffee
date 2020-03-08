###
----------------------------------------------------------------

    Fancy DateTime - v1.0.0

    Uebersicht-widget for displaying the current time and date


    Robin 'codeFareith' von den Bergen
    robinvonberg@gmx.de
    https://github.com/codefareith

----------------------------------------------------------------
###

# Widget Settings
settings =
    lang: 'en'
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
  de:
    weekdays: [
      'Sonntag'
      'Montag'
      'Dienstag'
      'Mittwoch'
      'Donnerstag'
      'Freitag'
      'Samstag'
    ]
    months: [
      'Januar'
      'Februar'
      'März'
      'April'
      'Mai'
      'Juni'
      'Juli'
      'August'
      'September'
      'Oktober'
      'November'
      'Dezember'
    ]
  jp:
    weekdays: [
      '日曜日'
      '月曜日'
      '火曜日'
      '水曜日'
      '木曜日'
      '金曜日'
      '土曜日'
    ]
    months: [
      '１月'
      '２月'
      '３月'
      '４月'
      '５月'
      '６月'
      '７月'
      '８月'
      '９月'
      '１０月'
      '１１月'
      '１２月'
    ]

command: ""

settings: settings
locale: locale

refreshFrequency: 60000

style: """
  position: absolute
  top: 0
  font-family: 'Anurati', sans-serif
  left: 0
  width: 100%
  height: 100%
  .bg
    position: absolute
    top: 0
    left: 0
    width: 100%
    height: 100%
    background-repeat: no-repeat;
    background-size: cover;
    background-position: center;
  .layer
    z-index: 5
    background-image: url('fancy-datetime.widget/assets/layer.png')
  .full
    z-index: 2
    background-image: url('fancy-datetime.widget/assets/full.png')
  .container
    z-index: 3
    position: absolute
    top: 44%
    left: 11%
    opacity: 0.5
    letter-spacing: 4px
    font-size: 16px
    line-height: 1
    text-transform: uppercase
    text-shadow: #{ settings.shadows.text }

  .cell
    position: relative
    display: table-cell
    vertical-align: middle
    overflow: hidden

  .left
    float: left

  .txt-default
    color: #{ settings.colors.default }

  .txt-accent
    color: #{ settings.colors.accent }

  .txt-small
    font-size: 2rem
    font-weight: 500

  .txt-large
    font-size: 7rem
    font-weight: 700

  .divider
    display: block
    width: 1rem
    height: 90px
    margin: 0 1rem 0.5rem 1rem
    background: #{ settings.colors.accent }
    box-shadow: #{ settings.shadows.text }
"""

render: () -> """
<div class='wrapper'>
  <div class='full bg'/>
  <div class='container'>
      <div class='cell'>
        <span class='hours txt-default txt-large left'></span>
        <span class='minutes txt-accent txt-large left'></span>
        <span class='suffix txt-default txt-small'></span>
      </div>
      <div class='cell'>
        <span class='divider'></span>
      </div>
      <div class='cell txt-small'>
        <span class='weekday txt-accent'></span>
        <div class='txt-default'>
          <span class='day'></span>
          <span>|</span>
          <span class='month'></span>
        </div>
        <span class='year txt-accent'></span>
      </div>
      </div>
  </div>
  <div class='layer bg'/>
"""

afterRender: (domEl) ->

update: (output, domEl) ->
  date = @getDate()

  $(domEl).find('.hours').text(date.hours)
  $(domEl).find('.minutes').text(date.minutes)
  $(domEl).find('.suffix').text(date.suffix)
  $(domEl).find('.weekday').text(date.weekday)
  $(domEl).find('.day').text(date.day)
  $(domEl).find('.month').text(date.month)
  $(domEl).find('.year').text(date.year)

# Helper-Functions
zeroFill: (value) ->
  return ('0' + value).slice(-2)

getDate: () ->
  date = new Date()
  hour = date.getHours()

  suffix = (if (hour >= 12) then 'pm' else 'am') if (@settings.militaryTime is false)
  hour = (hour % 12 || 12) if (@settings.militaryTime is false)

  hours = @zeroFill(hour);
  minutes = @zeroFill(date.getMinutes())
  seconds = @zeroFill(date.getSeconds())
  weekday = @locale[@settings.lang].weekdays[date.getDay()]
  day = @zeroFill(date.getDate())
  month = @locale[@settings.lang].months[date.getMonth()]
  year = date.getFullYear()

  return {
    suffix: suffix
    hours: hours
    minutes: minutes
    seconds: seconds
    weekday: weekday
    day: day
    month: month
    year: year
  }
