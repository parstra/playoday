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
t.start
