#This gets copied from the root source control of TestWatirLauncher to the target output directory


def SetupTest()

  $sTSID = nil
  $sTCID = nil
  $lib = WIN32OLE.new('WatirCOM.Utility')

  if ARGV.length == 1

    LoadXML(ARGV.at(0))

  end

  if ARGV.length == 2

    $sTSID = ARGV.at(0)
    $sTCID = ARGV.at(1)

  end

  SetupTestCase($sTSID, $sTCID)

end


#Used to populate some global variables and get the test run information into the database
def SetupTestCase(sTSID, sTCID)

  #Assign arguments to global variables to be used everywhere
  $sTSID = sTSID
  $sTCID = sTCID
  $sSkipDB = false

  if $lib == nil

    $lib = WIN32OLE.new('WatirCOM.Utility')

  end

  if $sTSID == nil && ARGV.length != 1

    $sSkipDB = true

    $hash = BuildHashFromString("key=value")
    $sRID = 0

    return

  else

    if ARGV.length == 1 && $sTSID == nil

      LoadXML(ARGV.at(0))

    end

  end

  $args = $lib.RetrieveTestCaseData($sTSID, $sTCID)

  $sTRID = $lib.StartTestRun($sTSID, $sTCID)


  puts ""
  puts "Arguments passed into test case script: "
  puts ""


  puts "TestSuite " + $sTSID
  puts "TestCase " + $sTCID
  puts "TestRun " + $sTRID

  c = 0
  $args.each do |a|
    puts "Argument(#{c}): #{a}"
    c = c + 1
  end

  #Assign arguments to global variables to be used everywhere
  #0
  $nPort = $args.at(0)
  #1
  $sURLLogin = $args.at(1)
  #2
  $sScriptPath = $args.at(2)
  #3
  $bCloseBrowser = $args.at(3)
  #4
  $sURLJapan = $args.at(4)
  #5
  $sEmail = $args.at(5)
  #6
  $sPassword = $args.at(6)
  #7
  $bLogout = $args.at(7)
  #8
  $hash = BuildHashFromString($args.at(8))

  #9
  $sRID = $args.at(9)

  puts ""
  puts "Values of Hash Passed into test case script: "
  puts "********************************************"

  $hash.each do |key, value|
    puts key + " => " + value
  end

  puts "********************************************"
  puts ""
  puts ""

end

#assumes a string:   key=value&key2=value2&key3=value3 etc...
def BuildHashFromString(sString)

  pairs = sString.split('&')
  ohash = pairs.inject({}) do |h, pair|
    key, value = pair.split('=')
    h[key] = value
    h
  end

  ohash

end

#creates a string in the form of key=value&key2=value2&key3=value3
def BuildStringFromHash(oHash)

  sString = ""
  nCount = 0

  oHash.each do |key, value|

    sString = sString + key + "=" + value
    nCount = nCount + 1
    if nCount < oHash.length
      sString = sString + "&"
    end

  end

  sString

end


#Called at the beginning of each function
def DeclareFunction(sName, sDescription)

  puts ""
  puts "*******************************************"
  puts "Starting Function " + sName
  puts "     " + sDescription
  puts "*******************************************"
  puts ""

  if $sSkipDB == false

    tfid = $lib.SetFunction($sTSID, $sTCID, sName)
    puts "TestFunction " + tfid

    return tfid

  end

  0

end

#Callled to add fucntion data, this can then be retrieved by function id
def AddFunctionData(tfid, oArray)


  if $sSkipDB == false

    trdataid = $lib.AddRunData($sTRID, tfid, oArray)
    puts "Test Run Data ID " + trdataid

    return trdataid

  end

  0

end


#Called at the end of each function, also handles the last function to notify when the entire run is finished
def EndFunction(sName, sDescription, startdate, tfid, pass, error, comment, lastrun)

  puts ""
  puts "*******************************************"
  puts "Ending Function " + sName
  puts "     " + sDescription
  puts "*******************************************"
  puts ""

  if $sSkipDB == false


    enddate = Time.new
    puts "End Date" + enddate.inspect

    #Mark function pass or fail
    trdetailid = $lib.FunctionResults($sTRID, $sTSID, $sTCID, tfid, startdate, enddate, pass, error, comment)

    puts "Test Run Detail ID " + trdetailid

    comment = ""


    #Finish the run
    #If this is the last function in the test case
    if lastrun == true

      puts ""
      puts "*******************************************"
      puts "Ending Run for test run id " + $sTRID + " and suite id of " + $sTSID
      puts "     " + sDescription
      puts "*******************************************"
      puts ""

      $lib.EndRun($sTRID, $sTSID, enddate, comment)
    end

  end

end

#gets an array of arrays that hold the function data.  For each inner array, the first element is the function id
def GetFunctionData()

  if $sSkipDB == false

    return $lib.GetFunctionDataBySuiteID($sTSID)

  end

  a=[]
  a[0]=[0, 5, 7]

  a

end

#get data by name
def GetFunctionDataByName(fname)

  if $sSkipDB == false

    fdata = $lib.GetFunctionDataByFName($sTSID, $sTCID, fname)
    return fdata

  end

  a=[]
  a[0]=[0, 5, 7]

  a
end

def ExecuteCSharpMethod(fileArray, functionName, parameters)


  rData = $lib.ExecuteCSharpFunctionByFile(fileArray, functionName, parameters)


  rData

end

def LoadXML(filePath)

  rData = $lib.LoadXMLFile(filePath)

  $sTSID = rData[0].to_s
  $sTCID = rData[1].to_s
  $sSkipDB = false


end


def ClickButton(ottid)

  ClickButton($browser, ottid)

end


def ClickButton(browser, ottid)
  template = "//*[@ottid='%s']"
  path = template % ottid
  browser.button(:xpath, path).click

end


#takes an array, prints out it's contents on new lines
def PrintArrayContents(arr)

  arr.each { |it| puts it.to_s }

end


#Date for the ottid is in the format of 'YYYY-MM-DD'
#Ruby represents this as t.strftime("%Y-%m-%d") if t is of type date
def ClickDate(year, month, day)

  ClickDate($browser, year, month, day)

end

def ClickDate(browser, year, month, day)

  sDate = "{ #{year}, #{month}, #{day} }"

  dt = Date.strptime(sDate, "{ %Y, %m, %d }")
  ottid = dt.strftime("%Y-%m-%d")

  template = "//span[@ottid = '%s']"
  path = template % ottid
  browser.link(:xpath, path).click

end


def SetText(ottid, txt)

  SetText($browser, ottid, txt)

end

def SetText(browser, ottid, txt)

  template = "//*[@ottid='%s']"
  path = template % ottid

  browser.text_field(:xpath, path).set(txt)

end


def ChooseSelectListItem(ottid, txt)
  ChooseSelectListItem($browser, ottid, txt)
end


def ChooseSelectListItem(browser, ottid, txt)
  template = "//*[@ottid='%s']"
  path = template % ottid
  browser.select_list(:xpath, path).select(txt)
end


def ChooseSelectListByPosition(ottid, position)
  ChooseSelectListByPosition($browser, ottid, position)
end

def ChooseSelectListByPosition(browser, ottid, position)
  template = "//*[@ottid='%s']"
  path = template % ottid
  browser.select_list(:xpath, path).set($browser.select_list(:xpath, path).options[position])
end


def ReturnSelectionListArray(ottid)
  ReturnSelectionListArray($browser, ottid)
end


def ReturnSelectionListArray(browser, ottid)
  template = "//*[@ottid='%s']"
  path = template % ottid

  contents = browser.select_list(:xpath, path).getAllContents

  contents

end


#The purpose of this function is to be able to print all the outputs in the following standard format instead of having to type them all in every single time.
def puts_custom(sMsg)
  puts ""
  puts "*********************************************************************************"
  puts sMsg
  puts "*********************************************************************************"
  puts ""
end


#Standard Login Function for consumer website.
#Pre requisites: The functions only handles any registered user.
#Written by Avik
#Date Added: 08/19/2010
#Last Modified:12/06/2010
#Comments: Can be modified in future when we have diff types browsers and regions added to the test harness

def login_consumer_site(browser_number, username, password, rid)

  $consumer_site_rest_profile = "www.opentable.com/rest_profile.aspx?rid"

  $consumer_site_rest_profile_url = $consumer_site_rest_profile + "=" + rid.to_s

  browser_number.goto($consumer_site_rest_profile_url)


  if browser_number.link(:id, "TopNav_linkSignIn").exists?

    puts_custom "The Sign in Link exist on the rest_profile page"

    browser_number.link(:id, "TopNav_linkSignIn").click

    browser_number.text_field(:id, "txtUserEmail").set(username)

    browser_number.text_field(:id, "txtUserPassword").set(password)

    browser_number.button(:id, "lblMember").click

    browser_number.goto($consumer_site_rest_profile_url)

  else

    puts_custom "The user probably did not Sign out from the previous Login: Remember to Delete the Cache before starting a New Test"

    if browser_number.link(:id, "TopNav_linkSignOut").exists?

      puts_custom "Since the Sign out link exists; It is confirmed that the user did not Sign Out from previous Login"

    else

      puts_custom "Both Sign In and Sign Out link does NOT exist on the rest_profile page; Possibly a bug"

    end
  end
end


#Standard Login Function for OTConnect website.
#Pre requisites: The functions only handles any registered user with a Valid OTConnect RID[In CHARM].
#Written by Avik.[Using Functions Written by Jim.]
#Date Added: 12/06/2010
#Last Modified:12/06/2010
#Comments: Can be modified in future when we have diff types browsers and regions added to the test harness

def login_otconnect_site(browser, username, password)
  browser.goto "http://otconnect.com"
  sleep 3
  SetText(browser, 'LoginUsername', username)
  SetText(browser, 'LoginPassword', password)
  #browser_number.text_field(:xpath,"//*[@ottid='LoginUsername']").set(username)
  #browser_number.text_field(:xpath,"//*[@ottid='LoginPassword']").set(password)
  ClickButton(browser, 'Login')
  #browser_number.button(:xpath,"//*[@ottid='Login']").click
  #if multiple accounts set up, choose the restaurant
  if browser.text.include? 'Choose Your Restaurant'
    browser.select_list(:xpath, "//*[@ottid='ChooseRestaurant']").set($sTestRestaurant)
    #PrintArrayContents(ReturnSelectionListArray('ChooseRestaurant'))
    #pick the first in the selection list
    #ChooseSelectListByPosition('ChooseRestaurant', 0)
    # browser_number.button(:xpath,"//*[@ottid='Login']").click
    ClickButton(browser, 'Login')
  end
end


#Standard Function to Re_Cache the consumer website.
#Pre requisites: N/A
#Written by Avik
#Date Added: 10/12/2010
#Comments: Can be modified in future when we have diff types browsers and regions added to the test harness


def ReCacheWebsite(region)
  if region == "US"

    $browser.goto "http://www.opentable.com/cache/cachemgr.aspx"

  elsif region == "DE"

    $browser.goto "http://www.opentable.de/cache/cachemgr.aspx"

  else

    puts_custom "Please type a Valid Region: The code for JP is not in Yet"
  end

  $browser.button(:id, "btnSelectAll").click

  $items_recache = ["chkLstCaches_0", "chkLstCaches_1", "chkLstCaches_2", "chkLstCaches_3", "chkLstCaches_4", "chkLstCaches_5",
                    "chkLstCaches_6", "chkLstCaches_7", "chkLstCaches_8", "chkLstCaches_9", "chkLstCaches_10", "chkLstCaches_11",
                    "chkLstCaches_12", "chkLstCaches_13", "chkLstCaches_14", "chkLstCaches_15", "chkLstCaches_16", "chkLstCaches_17",
                    "chkLstCaches_18", "chkLstCaches_19", "chkLstCaches_20", "chkLstCaches_21", "chkLstCaches_22", "chkLstCaches_23",
                    "chkLstCaches_24", "chkLstCaches_25", "chkLstCaches_26", "chkLstCaches_27", "chkLstCaches_28", "chkLstCaches_29",
                    "chkLstCaches_30", "chkLstCaches_31", "chkLstCaches_32", "chkLstCaches_33", "chkLstCaches_34", "chkLstCaches_35",
                    "chkLstCaches_36", "chkLstCaches_37", "chkLstCaches_38", "chkLstCaches_39", "chkLstCaches_40", "chkLstCaches_41",
                    "chkLstCaches_42", "chkLstCaches_43", "chkLstCaches_44"]

  $bflag = true

  $items_recache.each do |n|

    $items_recache_state = $browser.checkbox(:id, "#{n}").checked?

    if $items_recache_state != true
      $bflag = false
    end

  end

  if $bflag == true
    puts_custom "All the Items in the Cache Manager are Selected upon Clicking 'Select All' Button"
  else
    puts_custom "All the Items in the Cache Manager are NOT Selected upon Clicking 'Select All' Button: Possibly a bug"
  end

  assert($bflag, "All the Items in the Cache Manager are NOT Selected upon Clicking 'Select All' Button: Possibly a bug")


  $browser.button(:id, "btnReCache").click


  $bflag = true

  $items_recache.each do |n|

    $items_recache_state = $browser.checkbox(:id, "#{n}").checked?

    if $items_recache_state != false
      $bflag = false
    end

  end


  if $bflag == true
    puts_custom "Successful Attempt: The Website is Re-Cached, All the items in the Cache Manager is Unchecked"
  else
    puts_custom "The Website is NOT Re-Cached, Unsuccessfull Attempt, Please Try again"
  end

  assert($bflag, "The Website is NOT Re-Cached, Unsuccessfull Attempt, Please Try again")

end


#$b.link(:xpath, "//div[@class='DPMcell']/div[. = 25]").click

#$b.link(:xpath, "//div[@class='DPMcellheader' and . = 25]").click

