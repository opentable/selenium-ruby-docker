#----------- test case 1 -----------
Given /^I delete wish list data for user id "([^"]*)"$/ do |user|
  Wishlist.new($domain, user).delete_user_wishlists_in_db()
end

When /^I call wishlist API to create wishlist name "([^"]*)" for user id "([^"]*)"$/ do |list_name, uid|
    @test_wishlist_obj = Wishlist.new($domain, uid, list_name)
    @test_wishlist_obj.call_create_wish_list()
    @test_wishlist_obj.response_code_check('201')
end

Then /^I verify wishlist created in mongodb$/ do
    result_cursor = @test_wishlist_obj.search_wish_list_in_db()
    if (result_cursor.count == 0)
            raise Exception, "Wish list Document not present should be present "
    end
    wish_list = {}
    result_cursor.each { |doc|
            wish_list =  doc
    }
    @test_wishlist_obj.verify_testuser_wish_list_data(wish_list)
end

#----------------- Test case 2 ----------------------

Given /^I delete wishlist name "([^"]*)" for user "([^"]*)"$/ do |list_name, uid|
  @test_wishlist_obj =  Wishlist.new($domain, uid, list_name)
  @test_wishlist_obj.call_delete_wish_list()
  @test_wishlist_obj.response_code_check('200')
end

Given /^I call Get WishList API for User "([^"]*)" and list name "([^"]*)"$/ do |uid, listname|
  @test_wishlist_obj.call_Get_wishlist()
end

Then /^I verify API returns response code "([^"]*)"$/ do |exp_code|
  @test_wishlist_obj.response_code_check(exp_code)
end

#------------ Test case 3 ---------------------


When /^I call Get All WishList API for User "([^"]*)"$/ do |uid|
    @test_wishlist_obj.call_Get_users_all_wishlists()
    @test_wishlist_obj.response_code_check('200')
end

When /^I verify test user's wishlist data$/ do
  wish_list_response_body = JSON.parse(@test_wishlist_obj.response.body)
  @test_wishlist_obj.verify_testuser_wish_list_data(wish_list_response_body)
end

Given /^I create two wishlists for user "([^"]*)" with names "([^"]*)"$/ do |uid, listnames|
    #---delete all existing data for test user --
    @test_wishlist_obj = Wishlist.new($domain, uid)
    @test_wishlist_obj.delete_user_wishlists_in_db()
    #--- Create 2 wishlist with specified name ---
    list_array = listnames.split(",")
    @test_wishlist_obj.list_name =  list_array[0]
    @test_wishlist_obj.call_create_wish_list()
    @test_wishlist_obj.response_code_check('201')
    @test_wishlist_obj.list_name =  list_array[1]
    @test_wishlist_obj.call_create_wish_list()
    @test_wishlist_obj.response_code_check('201')
    @test_wishlist_obj.list_name = listnames
end

When /^I verify api returns user's all wishlist$/ do
      api_response_hash = JSON.parse(@test_wishlist_obj.response.body)
      db_cursor = @test_wishlist_obj.search_user_all_wish_list_in_db()
      db_cursor.each { |doc|
          db_wish_list =  doc
          list_found = false
          api_response_hash.each { |list|
            if (list["WLName"] == db_wish_list["WLName"] )
             list_found = true
             break
            end
          }
          if (list_found == false)
            raise Exception,  "Api doesn't returned #{db_wish_list["WLName"]} as wish list"
          end
      }
end

Given /^A test user "([^"]*)" has a rid "([^"]*)" in wishlist name "([^"]*)"$/ do |uid, rid, listname|
  #--- first clear test user data in mongo db ---
  @test_wishlist_obj = Wishlist.new($domain,uid,listname)
  @test_wishlist_obj.delete_user_wishlists_in_db()
  @test_wishlist_obj.call_create_wish_list(rid)
  @test_wishlist_obj.response_code_check('201')
 end


When /^I delete rid "([^"]*)" fom wishlist "([^"]*)" for user "([^"]*)"$/ do |rid, listname, uid|
  @test_wishlist_obj.call_delete_rid_from_wishlist_api(rid)
  @test_wishlist_obj.response_code_check('200')
end


Then /^I verify rid "([^"]*)" removed from wishlist$/ do |rid|
  @test_wishlist_obj.call_Get_wishlist()
  @test_wishlist_obj.response_code_check('200')
  resbody_hash = JSON.parse( @test_wishlist_obj.response.body)
  #--- now check deleted rid not present in response ---
  resbody_hash["Restaurants"].each { |rest|
       puts rest["RID"]
       if (rest["RID"].to_s.strip.eql? rid.to_s.strip)
          raise Exception,  "Api should not return deleted rid #{rid}"
       end
     }
end


