require "../lib/SqlServer.rb"

db = SqlServer.new( { :host => '10.2.1.135', 
                      :user_name => 'user_name', 
                      :password => 'password', 
                      :database => 'database' } )

puts "------------------------------------------"
puts "Testing SQL Query"
puts "------------------------------------------"
qry = 'SELECT TOP 10 [PA-PT-NO-WOSCD], [PA-ACCT-TYPE], [PA-PT-NAME] FROM PatientDemographics'
puts "#{qry}\n"

patients = db.query( qry )

patients.each do |patient|
  puts patient.values[1].strip << " (#{patient['PA-ACCT-TYPE']}):"
  patient.each { |f,v| puts "  #{f} => #{v}" }
  puts "------------------------------------------"
end

drop_text   = "IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='RubyTest') DROP TABLE RubyTest"
create_text = "Create table RubyTest (test_col varchar(25))"
insert_text = "Insert into RubyTest (test_col) values('Created From Ruby')"

puts "\n------------------------------------------"
puts "Testing SQL Commands"
puts "------------------------------------------"

db.execute_command( drop_text )
db.execute_command( create_text )
db.execute_command( insert_text )

puts "Test Table Created and Populated"
puts "Testing select from"
test_recs = db.query( 'Select * From RubyTest ' )
test_recs.each do |rec|
  rec.each { |k,v| puts "  #{k} => #{v}" }
end