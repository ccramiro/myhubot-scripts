clubs = 
  atm: 78 
  ars: 57
  rma: 86
  liv: 64
  fcb: 81
  manc: 65

module.exports = (robot) ->
  robot.respond /get me result (.*)/i, (msg) ->
    team = escape(msg.match[1])
    url = 'http://api.football-data.org/alpha/teams/' + clubs[team] + '/fixtures'
    msg.http( url )
      .headers(Accept: 'application/json')
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
