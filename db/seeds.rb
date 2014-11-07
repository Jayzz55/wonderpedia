# Create me
 member = User.new(
   name:     'Jayzz55',
   email:    'jayzzwijono@yahoo.com',
   password: 'helloworld',
 )
 member.skip_confirmation!
 member.save!

puts "Seed finished"
puts "#{User.count} users created"