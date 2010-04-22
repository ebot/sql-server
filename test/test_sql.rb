require "../lib/SqlServer.rb"

db = SqlServer.new( { :host => '10.2.1.135', 
                      :user_name => 'user', 
                      :password => 'password', 
                      :database => 'database' } )

qry = 'SELECT TOP 10 [PA-PT-NO-WOSCD], [PA-ACCT-TYPE], [PA-PT-NAME] FROM PatientDemographics'
puts "\n#{qry}\n"

patients = db.query(qry)

patients[:data].each do |patient|
  patients[:fields].each do |field| 
    puts "#{field} => " << patient[patients[:fields].index(field)]
  end
  puts "------------------------------------------"
end