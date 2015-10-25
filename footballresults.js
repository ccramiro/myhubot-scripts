// Generated by CoffeeScript 1.10.0
var clubs, footballApiKey;

clubs = {
  koln: 1,
  blv: 3,
  bvb: 4,
  bmn: 5,
  bfc: 5,
  s04: 6,
  wob: 11,
  bmg: 18,
  dus: 24,
  afc: 57,
  arsenal: 57,
  avfc: 58,
  cfc: 61,
  efc: 62,
  fulham: 63,
  liv: 64,
  lfc: 64,
  manc: 65,
  mcfc: 65,
  mufc: 66,
  manu: 66,
  thfc: 73,
  bil: 77,
  ath: 77,
  atm: 78,
  fcb: 81,
  fcg: 82,
  mal: 84,
  rma: 86,
  mad: 86,
  rss: 92,
  vcf: 94,
  val: 95
};

footballApiKey = process.env.HUBOT_FOOTBALL_ACCOUNT_KEY;

if (!footballApiKey) {
  throw "You must enter your HUBOT_FOOTBALL_ACCOUNT_KEY in your environment variables";
}

module.exports = function(robot) {
  return robot.respond(/(get me )?result (.*)/i, function(msg) {
    var team, url;
    team = escape(msg.match[2]);
    url = 'http://api.football-data.org/alpha/teams/' + clubs[team] + '/fixtures';
    return msg.http(url).headers({
      'X-Auth-Token': footballApiKey,
      Accept: 'application/json'
    }).get()(function(err, res, body) {
      var first, json, key, last, value;
      json = JSON.parse(body);
      first = json.fixtures;
      if (!first) {
        msg.send(team + '? No idea what is that, sorry man');
        return;
      }
      last = json.fixtures[0];
      for (key in first) {
        value = first[key];
        if (value.status === 'TIMED') {
          break;
        } else {
          last = value;
        }
      }
      return msg.send(last.homeTeamName + ' ' + last.result.goalsHomeTeam + ' - ' + last.result.goalsAwayTeam + ' ' + last.awayTeamName);
    });
  });
};
