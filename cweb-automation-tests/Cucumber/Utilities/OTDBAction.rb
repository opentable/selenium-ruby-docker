require 'tiny_tds'
class OTDBAction

  def initialize(sqlserverip, dbname, user, pwd)
    env_string = "-pp.otenv.com"
    if  ENV['TEST_ENVIRONMENT'].to_s.downcase == "sfqa" or $TEST_ENVIRONMENT == "sfqa"
      env_string = "-ci.otenv.com"
    end
    if sqlserverip.include? "web"
      sqlserverip = "#{sqlserverip}#{env_string}"
    end
    #Increase timeout due to tests failing here
    @client = TinyTds::Client.new(:username => user, :password => pwd, :dataserver => sqlserverip, :database => dbname, :timeout => 1500)
    @client.execute("SET ANSI_PADDING ON")
    @client.execute("SET ANSI_WARNINGS ON")
    @client.execute("SET CONCAT_NULL_YIELDS_NULL ON")
    @client.execute("set nocount on")
    @client.execute("set ARITHABORT ON")
    @client.execute("set QUOTED_IDENTIFIER ON")
    @client.execute("SET ANSI_NULLS ON")
  end

  def runquery_no_result_set(sql)
    puts "Executing SQL: #{sql}"
    @client.execute(sql).do
  end

  def runquery_return_resultset(sql)
    arr = []
    results = @client.execute(sql)
    results.each(:as => :array) do |row|
      arr << row
      puts row
    end
    return arr
  end

  def execute(sql)
    puts "Executing SQL: #{sql}"
    @client.execute(sql).do
  end
end