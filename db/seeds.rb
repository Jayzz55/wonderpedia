# Create me
member1 = User.new(
   name:     'Jayzz55',
   email:    'jayzzwijono@yahoo.com',
   password: 'helloworld',
   premium: true
 )
 member1.skip_confirmation!
 member1.save!

member2 = User.new(
  name:     'Ben',
  email:    'Ben@example.com',
  password: 'helloworld',
)
member2.skip_confirmation!
member2.save!

member3 = User.new(
  name:     'Arnold',
  email:    'Arnold@example.com',
  password: 'helloworld',
)
member3.skip_confirmation!
member3.save!

Wiki1 = member1.wikis.create(title:"Hello world", body:"welcome to my world!")
Wiki2 = member2.wikis.create(title:"Ben is marvelous", body:"Marvelous and yet superficial is the key")
Wiki3 = member3.wikis.create(title:"Travel around the world", body:"Japan in winter is so super cold")

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"