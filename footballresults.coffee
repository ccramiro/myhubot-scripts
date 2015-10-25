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
  afc: 57 # Arsenal
  arsenal: 57
  avfc: 58 # Aston Villa
  cfc: 61 # Chelsea
  efc: 62 # Everton
  fulham: 63
  liv: 64 # Liverpool
  lfc: 64
  manc: 65 # Manchester City
  mcfc: 65
  mufc: 66 # Manchester United
  manu: 66
  thfc: 73 # Tottenham
  bil: 77 # Athletic Bilbao
  ath: 77
  atm: 78 # Atletico Madrid
  fcb: 81 # Barcelona
  fcg: 82 # Getafe
  mal: 84 # Málaga
  rma: 86 # Real Madrid
  mad: 86
  rss: 92 # Real Sociedad
  vcf: 94 # Villareal
  val: 95 # Valencia


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
