# Description:
#   Get last result from football team
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FOOTBALL_ACCOUNT_KEY
#
# Commands:
#   hubot get me result <team> - Displays last result of football team
#
# Author:
#   ccramiro

clubs =
  atm: 78
  ars: 57
  rma: 86
  liv: 64
  fcb: 81
  manc: 65

footballApiKey = process.env.HUBOT_FOOTBALL_ACCOUNT_KEY
unless footballApiKey
  throw "You must enter your HUBOT_FOOTBALL_ACCOUNT_KEY in your environment variables"

module.exports = (robot) ->
  robot.respond /get me result (.*)/i, (msg) ->
    team = escape(msg.match[1])
    url = 'http://api.football-data.org/alpha/teams/' + clubs[team] + '/fixtures'
    msg.http( url )
      .headers('X-Auth-Token': footballApiKey, Accept: 'application/json')
      .get() (err, res, body) ->
        json = JSON.parse(body)
        first = json.fixtures
        last = json.fixtures[0]
        for key,value of first
          if value.status == 'TIMED'
            break
          else
            last = value
        msg.send( last.homeTeamName + ' ' + last.result.goalsHomeTeam + ' - ' + last.result.goalsAwayTeam + ' ' + last.awayTeamName )
