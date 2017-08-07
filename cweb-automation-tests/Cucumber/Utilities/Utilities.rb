module Utilities

  #constants defined at the top of Module
  FORBIDDEN_IPS = ['10.20.20.0/22',
                   '10.20.24.0/22',
                   '10.20.64.0/20',
                   '192.168.220.0/20',
                   '192.168.5.0/24',
                   '192.168.116.0/24',
                   '192.168.201.0/24',
                   '192.168.210.0/24']

  ALLOWED_IPS = ['127.0.0.1/32',
                 '10.0.0.0/8',
                 '172.16.0.0/12',
                 '192.168.0.0/16']

  PRODUCTION_IPS = [ '23.214.8.228',
                    '66.151.130.64',
                    '66.151.130.84',
                    '127.0.0.1/32',
                    '66.151.130.128',
                    '10.0.1.27/29',
                    '69.22.138.8',
                    '10.20.20.46',
                    '10.20.20.44',
                    '66.151.130.36',
                    '66.151.130.147',
                    '66.151.130.68',
                    '66.151.130.43',
                    '66.151.130.47',
                    '199.16.146.42',
                    '199.16.146.33',
                    '199.16.146.68',
                    '199.16.146.33'

  ]

  if ENV['TEST_ENVIRONMENT'].nil?
    $TEST_ENVIRONMENT = "PreProd"
  else
    $TEST_ENVIRONMENT = ENV['TEST_ENVIRONMENT']
  end

  if $TEST_ENVIRONMENT.eql? "Prod"
    ALLOWED_IPS= PRODUCTION_IPS
  end

  def Kernel.is_windows?
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform.include? 'mswin32' or platform.include? 'mingw32' or platform.include? 'cygwin32'
  end

  #tests for darwin and linux
  def Kernel.is_unix?
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform.include? 'darwin' or platform.include? 'linux'
  end

  def self.get_unix_process_ids(proc_name)
    ps_block = `ps -xc`
    processes = ps_block.each_line.map do |line|
      #capture just the number at the beginning of all lines that have the process name in them
      if line.downcase.match /^(?: )*(\d+).*?(?:#{proc_name.downcase})/
        $1
      end
    end
    return processes.compact
  end

  #potential signals can be found by consulting "$ man kill"
  #kill will accept either the plain text name or the number for signal.
  def self.kill_unix_process_ids(process_ids, signal = "TERM")
    process_ids.each do |process_number|
      `kill -#{signal} #{process_number}`
    end
  end

  def self.domains_pointing_prod_env
    ot_public_domains = ['www.opentable.com',
                         'www.opentable.com.mx',
                         'www.opentable.fr',
                         'www.opentable.es',
                         'www.opentable.co.uk',
                         'www.opentable.jp',
                         'www.opentable.de',
                         'www.charm.com',
                         'www.charm.eu',
                         'www.charm.jp',
                         'otconnect.com',
                         'otconnect.de',
                         'otconnect.jp',
                         'webmodule.opentable.com',
                         'webmodule-eu.opentable.com',
                         'webmodule-ap.opentable.com',
                         'www.otrestaurant.com',
                         'www.otrestaurant.com.mx',
                         'www.otrestaurant.de',
                         'www.otrestaurant.jp',
                         'm.opentable.com',
                         #'m.toptable.co.uk',
                         'm.opentable.de',
                         'cloud.opentable.com',
                         'guestcenter.opentable.com',
                         "m.opentable.co.uk"]

    domain_ip_pair = Array.new()
    hash_domain_ip_pair = nil
    ot_public_domains.each do |domain|
      begin
        ip = IPSocket::getaddress(domain)
      rescue Exception => e
        puts "Failed to resolve IP address for Domain: #{domain} thereby resulting nil in hash table below"
      end
      if (!is_ip_in_allowed_range(ip)) || (is_ip_in_not_allowed_range(ip))
        domain_ip_pair << [domain, ip]
        hash_domain_ip_pair = Hash[*domain_ip_pair.flatten]
      end
    end
    return hash_domain_ip_pair
  end

  def self.is_ip_in_allowed_range(ip)
    is_ip_in_given_ip_range_type(ip, ip_range_type = ALLOWED_IPS)
  end

  def self.is_ip_in_not_allowed_range(ip)
    is_ip_in_given_ip_range_type(ip, ip_range_type = FORBIDDEN_IPS)
  end

  def self.is_ip_in_given_ip_range_type(ip, ip_range_type)
    bflag = false
    ip_range_type.each do |range|
      ip_range = IPAddr.new(range)
      if ip_range === ip
        bflag = true
        break
      end
    end
    return bflag
  end

  def self.add_self_to_partner_ips()
    begin
      my_ips = self.get_self_ips
      my_ips.each do |my_ip|
        self.add_partner_ip_in_all_databases(my_ip)
      end
    rescue => e
      puts "failed to add self to partner IP table; #{e}"
    end
  end

  def self.get_self_ips
    if Kernel.is_windows?
      ipconfig_output = `ipconfig`
      return ipconfig_output.match(/IPv4 Address.+? : (\d+\.\d+\.\d+\.\d+)/).captures
    else
      #`ifconfig.match /en0: .+?inet (\d+\.\d+.\d+.\d+)/m
      #raise StandardError, 'SOAP Partner IP not added automatically for non-windows environments. Make sure your IP is in the partnerIPs table manually'
      ip_addresses = `ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d' ' -f 2`.split
      return ip_addresses
    end
  end

  def self.add_partner_ip_in_all_databases(ip_address)
    ['.com', '.co.uk', '.de', '.jp'].each do |domain_string|
      domain = Domain.new(domain_string)
      sql_query = "if not exists (select * from PartnerIPs where PartnerID=291 and IPAddress='#{ip_address}')
          insert into PartnerIPs (PartnerID, IPAddress) values (291, '#{ip_address}')"
      db = OTDBAction.new(domain.db_server_address, domain.db_name, $db_user_name, $db_password)
      db.runquery_no_result_set(sql_query)
    end
  end
end
