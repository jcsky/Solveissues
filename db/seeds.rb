puts '產生選舉資料'
  Election.find_or_create_by(:name => "2014-九合一選舉", :vote_date => "2014/11/29")
  Election.find_or_create_by(:name => "2016-第14任總統大選", :vote_date => "2016/01/16")
  Election.find_or_create_by(:name => "2012-第13任總統大選", :vote_date => "2012/01/14")
  Election.find_or_create_by(:name => "2010-直轄市市長暨市議員選舉(五都選舉)", :vote_date => "2010/11/27")
  Election.find_or_create_by(:name => "2015-第8屆立委缺額補選", :description => "南投縣第2選區、屏東縣第3選區、臺中市第6選區、彰化縣第4選區、苗栗縣第2選區" , :vote_date => "2014/2/7")
  Election.find_or_create_by(:name => "2013-第8屆立委臺中市第2選區缺額補選", :vote_date => "2013/1/26")

puts '產生真實民代資料'
require 'csv'
arrs = CSV.read("config/representation.csv")
arrs[1..arrs.length].each do |row|

  user = User.find_or_initialize_by(name: row[0].to_s)
  user.email = Faker::Internet.email
  user.password = SecureRandom.hex
  user.birthday = Date.parse(row[1]) if row[1]
  user.gender = row[2]
  user.role = 1
  
  if user.fb_image == nil
    user.fb_image = "https://kev.inburke.com/wp-content/uploads/2014/04/hackedocat.png"
  end

  election_record = user.election_records.new
  election_record.party = row[3]
  election_record.electorate = row[4]
  election_record.category = row[5]
  election_record.onwork_title = row[6]
  election_record.election_result = row[7].to_i
  election_record.period_start = Date.parse(row[9]) if row[9]
  election_record.period_end = Date.parse(row[10]) if row[10]
  election_record.note = row[11]
  election_record.election = Election.find_by(vote_date: Date.parse(row[8])) if row[8]
  user.save

end

puts '產生議題資料'
issues = CSV.read("config/demoissues.csv")
issues[1..issues.length].each do |row|
  issue = Issue.create(title: row[0], description: row[1], creator: User.all.sample)
end
