["george@skroutz.gr", "mikezaby@gmail.com", "stratosiii@gmail.com",
 "nemlah@skroutz.gr", "gakos.ioannis@gmail.com", "giorgos.tsiftsis@gmail.com",
 "alup@aloop.org", "kostas.karachalios@me.com"].each do |email|
   User.create(email: email, password: 'foobar')
 end

t = Tournament.new({name: 'Ping pong hero',
                   description: "Do you think you have what it takes?",
                   game_type: Tournament::CUP})

t.owner = User.first
t.save!

User.all.each do |u| t.users << u end

# first round
t.start

round = t.rounds.first

round.matches.each {|m|
  m.played = true
  m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
  m.save!
}

# go the second round
t.next_round
t.save

#second round, four players left
round = t.rounds.last

round.matches.each {|m|
  m.played = true
  m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
  m.home_score = m.winner_id == m.home_player_id ? 4 : 0
  m.away_score = m.winner_id == m.away_player_id ? 4 : 0
  m.save!
}

t.next_round
t.save

t = Tournament.new({name: 'Tennis Ninja',
                   description: "Do you think you have what it takes?",
                   game_type: Tournament::SWEDISH})

t.owner = User.first
t.save!

User.all.each do |u| t.users << u end

# first round
t.start

# play 4 rounds
4.times do

  round = t.rounds.last

  round.matches.each {|m|
    m.played = true
    m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
    m.home_score = m.winner_id == m.home_player_id ? 4 : 0
    m.away_score = m.winner_id == m.away_player_id ? 4 : 0
    m.save!
  }

  # go the second round
  t.next_round
  t.save
end
