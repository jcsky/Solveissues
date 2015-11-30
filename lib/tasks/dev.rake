namespace :dev do

  country = %w[台北市 基隆市 新北市 連江縣 宜蘭縣 新竹市 新竹縣 桃園縣 苗栗縣 台中市 彰化縣 南投縣 嘉義市 嘉義縣 雲林縣 台南市 高雄市 澎湖縣 金門縣 屏東縣 台東縣 花蓮縣]
  usrenames = %w[零加隆 王晶平 馬一九 無思哇 花媽 沒勝文 扁扁 賴德德 波多野結衣 志玲姐姐 陳小刀 賭神 賭聖 習老大 喔爸爸 東拉蕊 吳中憲]


  task :test_db_rebuild => ['db:drop:all', 'db:create', 'db:migrate', 'db:seed', 'dev:mass_user', 'dev:user_vote', 'dev:issue_votes', 'dev:agent_votes', 'dev:random_tagging']

  task :random_tagging => :environment do
    Tagging.delete_all
    puts "隨機標籤"
    Issue.all.each do |x|
      tagging = [*1..17].sample(1 +  Random.rand(4))
      tagging.each do |i|
        x.taggings.create(:tag_id => i )
      end
    end
  end

  #task :agent_history => :environment do
  #  puts "產生一個月名聲紀錄"
  #  AgentHistory.delete_all
  #  agents = User.where(:role => 1)
  #  agents.each do |x|
  #    30.times do |i|
  #      history_data = AgentHistory.create(:user_id => x.id, :date => i.days.ago, :likes => Faker::Number.number(3))
  #    end
  #  end
  #end

  # OK
  task :mass_user => :environment do
    CONN = ActiveRecord::Base.connection
    inserts = []
    time = Time.now.to_s(:db)
    a = User.all.count
    (a..a + 100).each do |n|
      # 避免email重覆
      email = "a#{n}@email.com"
      inserts.push %Q{('#{email}', '12345678', 0, '#{country.sample}', '#{Faker::Avatar.image}', '#{Faker::Internet.user_name}', '#{time}', '#{time}')}
    end
    sql = "INSERT INTO users (email, encrypted_password, role, country, fb_image, name, created_at, updated_at) VALUES #{inserts.join(", ")}"
    begin
      CONN.execute sql
      puts '新增 1萬筆 User'
    rescue
      puts '失敗'
    end
  end

  task :user_vote => :environment do
    Vote.delete_all
    User.all.each {|u|
      inserts =[]
      hash = {}
      u.role == 1 ? times = [5,10,15,20,25,35].sample : times = [3,5,7,9,11].sample
      if u.role == 1
        times = [5,10,15,20,25,35].sample
        vote_scope = "agent"
      else
        times = [3,5,7,9,11].sample
        vote_scope = nil
      end

      Issue.all.sample(times).each{|i|
        # hash = {:user => u, :issue => i}
        hash = {:voter_type => "User", :voter_id => u.id, :votable_type => "Issue", :votable_id => i.id, :vote_scope => vote_scope,
          :vote_weight => 1, :vote_flag => true
        }
        inserts.push hash
      }
      vote = Vote.create(inserts)
    }
    puts "每人投10票"
  end


  task :create_seed_elections => :environment do
    Election.create(:name => "2014-九合一選舉", :vote_date => "2014/11/29")
    Election.create(:name => "2016-第14任總統大選", :vote_date => "2016/01/16")
    Election.create(:name => "2012-第13任總統大選", :vote_date => "2012/01/14")
    Election.create(:name => "2010-直轄市市長暨市議員選舉(五都選舉)", :vote_date => "2010/11/27")
    Election.create(:name => "2015-第8屆立委缺額補選", :description => "南投縣第2選區、屏東縣第3選區、臺中市第6選區、彰化縣第4選區、苗栗縣第2選區" , :vote_date => "2014/2/7")
    Election.create(:name => "2013-第8屆立委臺中市第2選區缺額補選", :vote_date => "2013/1/26")
  end

  task :issue_votes => :environment do
    puts "開始'假'投票（議題）"
    LatestIssueVote.destroy_all
    HistoricalIssueVote.destroy_all

    issue = []
    Issue.all.each do |i|
      issue.push(i.id)
    end

    CONN = ActiveRecord::Base.connection

    time = Time.now.to_s(:db)
    inserts0 = []
    d = 30
    30.times do

    time_date = d.day.ago.strftime("%Y-%m-%d")
    d -= 1
    inserts = []
    puts "每個user在#{time_date}向兩個議題投票"
      User.all.each do |u|
        User.transaction do
          issue.sample(2).each do |i|
            num = [1,-1].sample
            if inserts0.include? %Q{('#{i}', '#{u.id}', '#{time}', '#{time}')}
              inserts0.delete %Q{('#{i}', '#{u.id}', '#{time}', '#{time}')}
            elsif num == 1
              inserts.push %Q{('#{i}', '#{u.id}', '#{time}', '#{time}')}
            else

            end
          end
        end
      end

    inserts0 += inserts

    sql = "INSERT INTO latest_issue_votes (issue_id, user_id, created_at, updated_at) VALUES #{inserts.join(", ")}"
    begin
      CONN.execute sql
      puts '成功！'
    rescue
      puts '失敗！'
    end

    inserts2 = []
    puts "建立歷史投票記錄"

      Issue.all.each do |i|
        Issue.transaction do
          yes_user = []
          LatestIssueVote.where(:issue_id=>i.id).each do |liv|
            yes_user.push(liv.user_id)
          end
          inserts2.push %Q{('#{i.id}', '#{yes_user.count}', '#{yes_user}', '#{time_date}', '#{time}', '#{time}')}
        end
      end

      sql2 = "INSERT INTO historical_issue_votes (issue_id, likes_count, liked_users, vote_date, created_at, updated_at) VALUES #{inserts2.join(", ")}"

      begin
        CONN.execute sql2
        puts '成功！！'
      rescue
        puts '失敗'
      end
    end

  end

  task :agent_votes => :environment do
    puts "開始'假'投票（民代）"
    LatestAgentVote.destroy_all
    HistoricalAgentVote.destroy_all

    CONN = ActiveRecord::Base.connection

    time = Time.now.to_s(:db)

    agent = []
    User.where(:role=>1).each do |a|
      agent.push(a.id)
    end

    @agents = User.where(:role => 1)

    d = 30
    inserts0 = []

    30.times do
      inserts = []
      time_date = d.day.ago.strftime("%Y-%m-%d")
      d -= 1
      puts "每個user在#{time_date}向三個立委投票"

      User.all.each do |u|
        User.transaction do
          agent.sample(3).each do |i|
            num = [1,-1].sample
            if inserts0.include? %Q{('#{i}', '#{u.id}', '#{num}', '#{time}', '#{time}')}
               inserts0.delete %Q{('#{i}', '#{u.id}', '#{num}', '#{time}', '#{time}')}
            else
               inserts.push %Q{('#{i}', '#{u.id}', '#{num}', '#{time}', '#{time}')}
            end
          end
        end
      end

      inserts0 += inserts
      sql = "INSERT INTO latest_agent_votes (agent_id, user_id, value, created_at, updated_at) VALUES #{inserts.join(", ")}"

      begin
        CONN.execute sql
        puts '成功！'
      rescue
        puts '失敗！'
      end

      inserts2 = []
      puts "建立歷史投票記錄"
      @agents.each do |agent|
        yes_user = []
        no_user = []

        LatestAgentVote.where(:agent_id=>agent.id, :value=>1).each do |lav|
            yes_user.push(lav.user_id)
        end

        LatestAgentVote.where(:agent_id=>agent.id, :value=>-1).each do |lav|
            no_user.push(lav.user_id)
        end

        inserts2.push %Q{('#{agent.id}', '#{yes_user.count}', '#{no_user.count}', '#{yes_user}', '#{no_user}', '#{time_date}', '#{time}', '#{time}')}
      end

      sql2 = "INSERT INTO historical_agent_votes (agent_id, likes_count, dislikes_count, liked_users, disliked_users, vote_date, created_at, updated_at) VALUES #{inserts2.join(", ")}"

      begin
        CONN.execute sql2
        puts '成功！！'
      rescue
        puts '失敗'
      end

    end
  end

  # ========每日3點排程========
  # For 議題
  task :historical_issue_votes => :environment do
    puts "建立歷史記錄，每日議題投票人數（every day 3:00 am）"

    time_date = Time.now.strftime("%Y-%m-%d")

    Issue.all.each do |i|
      yes_user = []
      LatestIssueVote.where(:issue_id=>i.id).each do |liv|
        yes_user.push(liv.user_id)
      end

      exist = HistoricalIssueVote.find_by(:issue_id=>i.id, :vote_date=>time_date)

      if exist.present?
        exist.update(:issue_id=>i.id, :likes_count=>yes_user.count,  :liked_users=>yes_user, :vote_date=>time_date)
      else
        HistoricalIssueVote.create(:issue_id=>i.id, :likes_count=>yes_user.count,  :liked_users=>yes_user, :vote_date=>time_date)
      end
    end
  end

  # For 立委
  task :historical_agent_votes => :environment do
    puts "建立歷史記錄，每日立委投票人數（every day 3:00 am）"

    time_date = Time.now.strftime("%Y-%m-%d")

    @agents = User.where(:role => 1)

    @agents.each do |agent|
      yes_user = []
      no_user = []
      LatestAgentVote.where(:agent_id=>agent.id, :value=>1).each do |lav|
        yes_user.push(lav.user_id)
      end
      LatestAgentVote.where(:agent_id=>agent.id, :value=>-1).each do |lav|
        no_user.push(lav.user_id)
      end

      exist = HistoricalAgentVote.find_by(:agent_id=>agent.id, :vote_date=>time_date)

      if exist.present?
        exist.update(:agent_id=>agent.id, :likes_count=>yes_user.count, :dislikes_count=>no_user.count, :liked_users=>yes_user, :disliked_users=>no_user, :vote_date=>time_date)
      else
        HistoricalAgentVote.create(:agent_id=>agent.id, :likes_count=>yes_user.count, :dislikes_count=>no_user.count, :liked_users=>yes_user, :disliked_users=>no_user, :vote_date=>time_date)
      end
    end
  end

end
