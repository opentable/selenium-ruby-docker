Then /^I login with username "([^"]*)" and password "([^"]*)"$/ do |login_name, pwd|
  $USER['email'] = login_name
  $USER['password'] = pwd
  $g_page = Login.new($driver, $domain.www_domain_selector)
  $g_page.login(login_name, pwd,0)
end

# requires that globals $user_email,
# $password are set for an existing account
Then /^I login as registered user$/ do
step %{I login with username "#{$USER['email']}" and password "#{$USER['password']}"}
end

Then /^I should see points changed by "([^"]*)" amount$/ do |points|
  points_before_change = $USER['points'].to_i
  # Get points from UI strip comma if any
  @page = MyProfile.new($driver, $domain.www_domain_selector)
  @page = ProfileInfo.new($driver, $domain.www_domain_selector) if $driver.url.include? "/profile/info"
  #@my_profile = MyProfile.new($driver, $domain.www_domain_selector)
  points_after_change = @page.total_user_points
  difference_in_pts =  points_before_change - points_after_change
  if difference_in_pts != points.to_i
    raise Exception, "points do not match! expected #{points} actual #{difference_in_pts}"
  end

  # Verify transaction history adjusted for points
  d = DateTime.now.strftime('%d')
  m = DateTime.now.strftime('%m')
  y = DateTime.now.strftime('%Y')

  # Convert back to string before comparing with UI
  points = points.to_i.to_s
  # Get latest points adjustment transaction record
  latest_transaction_row = @page.first_restaurant_transaction

  success = false
  puts "$domain.www_domain_selector = #{$domain.www_domain_selector}"
  date = case $domain.www_domain_selector
           when "www.opentable.jp"
             "#{y}/#{m}/#{d}"
           #when "www.opentable.com.mx"
            # "#{d}/#{m}/#{y}"
           when "www.opentable.com/fr-CA"
             "#{d}\\/#{m}\\/#{y}"     #See Auto-129
           when "www.opentable.com"
             "#{m}/#{d}/#{y}"
           when "www.opentable.co.uk"
             "#{d}/#{m}/#{y}"
           when "www.opentable.de"
             "#{d}#{m}#{y}" # Do not add the periods between because we will be stripping them out to verify with the points
           else
             "#{m}/#{d}/#{y}"
         end

  mod_transaction_row = latest_transaction_row.gsub(/\,/,"")  # Remove the , from the points
  mod_transaction_row = latest_transaction_row.gsub(/\./,"") if $domain.www_domain_selector.include? "www.opentable.de" # Remove the . from the points in DE

  puts "mod_transaction_row = #{mod_transaction_row}"
  if (mod_transaction_row.include? "#{points}") && (mod_transaction_row.include? date)
    success = true
  end

  if !success
    raise Exception, "did not find #{points} adjustment in transaction history #{latest_transaction_row} for date: #{date}"
  end
end

When /^I have registered (admin|regular) user with random email$/ do |usertype|
  register_new_user_with_random_email(usertype)
end

# Expected to be on profile page and store current points in $USER hash
When /^I store current user points$/ do
  $USER['points'] = $g_page.total_user_points
end

def register_new_user_with_random_email(usertype, optin_to_dining_offers = 0)
  isAdmin = usertype.eql?("admin")
  isRegister = usertype.eql?("regular")
  @user = NewUserAPI.new({:is_admin => isAdmin, :is_register => isRegister})
  @user.Register_using_new_API
  if isAdmin
    gpid = @user.get_user_gpid
    @user.patch_user_make_admin(gpid)
  end
  $USER['email'] = @user.email
  $USER['fname'] = @user.first_name
  $USER['lname'] = @user.last_name
end