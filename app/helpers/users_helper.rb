module UsersHelper

  def return_total_user_country_hash(total_users)
    country_hash = Hash.new
    total_users.each do |user|
      user.country
      unless country_hash[user.country]
        country_hash[user.country] = 1
      else
        country_hash[user.country] += 1
      end
    end
    country_hash
  end

  def setup_user(user)
    user.build_information unless user.information
    user
  end

end
