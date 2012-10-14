["george@skroutz.gr", "mikezaby@gmail.com", "stratosiii@gmail.com",
 "nemlah@skroutz.gr", "gakos.ioannis@gmail.com", "giorgos.tsiftsis@gmail.com",
 "alup@aloop.org", "demo@playoday.com"].each do |email|
   User.create(email: email, password: 'rumbledemo', company_name: "skroutz")
 end

t = Tournament.new({name: 'Ping pong hero',
                   description: "Do you think you have what it takes?",
                   game_type: Tournament::CUP})

t.owner = User.first
t.save!

trash_talks = ["Feeling lucky punk?",
               "Looks like i'm gonna kick some ass today",
               "Don't eat yellow snow",
               "When fear rears his ugly, you'll bravely turn your tail and fly"]

User.all.each do |u| t.users << u end

# first round
t.start

round = t.rounds.first

round.matches.each {|m|
  m.played = true
  m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
  m.home_score = m.winner_id == m.home_player_id ? 4 : 0
  m.away_score = m.winner_id == m.away_player_id ? 4 : 0
  m.home_comment = trash_talks[m.id.modulo(4)]
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
  m.home_comment = trash_talks[m.id.modulo(4)]
  m.save!
}

t.next_round
t.save

t.current_round.matches.each {|m|
  m.home_comment = trash_talks[m.id.modulo(4)]
  m.save!
}

# a swedish tournament
t = Tournament.new({name: 'Tennis Ninja',
                   description: "Do you think you have what it takes?",
                   total_rounds: 8,
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
    m.home_comment = trash_talks[m.id.modulo(4)]
    m.save!
  }

  # go the second round
  t.next_round
  t.save
end

t = Tournament.new({name: 'Chess master',
                   description: "Do you think you have what it takes?",
                   game_type: Tournament::CUP})

t.owner = User.first
t.save!

User.all.each do |u| t.users << u end

t.start

(t.total_rounds - 1).times do

  round = t.rounds.last

  round.matches.each {|m|
    m.played = true
    m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
    m.home_score = m.winner_id == m.home_player_id ? 4 : 0
    m.away_score = m.winner_id == m.away_player_id ? 4 : 0
    m.home_comment = trash_talks[m.id.modulo(4)]
    m.save!
  }

  # go the second round
  t.next_round
  t.save
end

round = t.rounds.last

round.matches.each {|m|
  m.played = true
  m.winner_id = [m.home_player_id, m.away_player_id][m.id.modulo(2)]
  m.home_score = m.winner_id == m.home_player_id ? 4 : 0
  m.away_score = m.winner_id == m.away_player_id ? 4 : 0
  m.home_comment = trash_talks[m.id.modulo(4)]
  m.save!
}

t.winner_id = Match.last.winner_id
t.status = Tournament::CLOSED
t.save

#add a tournament with players but pending
t = Tournament.new({name: 'Beer death match',
                   description: "3 hours, last man standing wins",
                   game_type: Tournament::CUP})

t.owner = User.first
t.save!

User.all.each do |u| t.users << u end
