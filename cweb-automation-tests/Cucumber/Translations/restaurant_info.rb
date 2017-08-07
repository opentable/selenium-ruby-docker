# -*- coding: utf-8 -*-
def address_format(style="horizontal", *domain)
  formatted_address = nil
  if domain.length == 0
    domain = $domain.www_domain_selector.downcase
  else
    domain = domain[0]
  end

  case style
    when "horizontal"
      case domain
        when "www.opentable.com", "www.opentable.com/fr-ca", "www.opentable.co.uk", "www.opentable.jp/en-gb"
          formatted_address = %Q{street1 street2 city, state zip}
        when "www.opentable.com.mx", "www.opentable.com.mx/en-us", "www.opentable.de", "www.opentable.de/en-gb"
          formatted_address = %Q{street1 street2 zip city}
        when "www.opentable.jp"
          formatted_address = %Q{zip\nstatecitystreet1\nstreet2}
        else
          raise Exception, "Unknown domain: #{domain}"
      end
    when "vertical"
      case domain
        when "www.opentable.com", "www.opentable.com/fr-ca", "www.opentable.co.uk", "www.opentable.jp/en-gb"
          formatted_address = %Q{street1\nstreet2\ncity, state zip}
        when "www.opentable.com.mx", "www.opentable.com.mx/en-us", "www.opentable.de", "www.opentable.de/en-gb"
          formatted_address = %Q{street1\nstreet2\nzip city}
        when "www.opentable.jp"
          formatted_address = %Q{zip\nstatecitystreet1\nstreet2}
        else
          raise Exception, "Unknown domain: #{domain}"
      end
    else
      raise Exception, "Unknown style: #{style}"
  end

  formatted_address
end

PRICE = {
    "Spanish" => "MXN",
    "Spanish_symbol" => "$",
    "Japanese" => "円",
    "Japanese_symbol" => "¥",
    "French" => "CAD",
    "German" => "Euro",
    "EU_symbol" => "€",
    "English" => "£"
}

STATE_ABBR_US = {
    'AL' => 'Alabama',
    'AK' => 'Alaska',
    'AZ' => 'Arizona',
    'AR' => 'Arkansas',
    'CA' => 'California',
    'CO' => 'Colorado',
    'CT' => 'Connecticut',
    'DE' => 'Delaware',
    'FL' => 'Florida',
    'GA' => 'Georgia',
    'HI' => 'Hawaii',
    'ID' => 'Idaho',
    'IL' => 'Illinois',
    'IN' => 'Indiana',
    'IA' => 'Iowa',
    'KS' => 'Kansas',
    'KY' => 'Kentucky',
    'LA' => 'Louisiana',
    'ME' => 'Maine',
    'MD' => 'Maryland',
    'MA' => 'Massachusetts',
    'MI' => 'Michigan',
    'MN' => 'Minnesota',
    'MS' => 'Mississippi',
    'MO' => 'Missouri',
    'MT' => 'Montana',
    'NE' => 'Nebraska',
    'NV' => 'Nevada',
    'NH' => 'New Hampshire',
    'NJ' => 'New Jersey',
    'NM' => 'New Mexico',
    'NY' => 'New York',
    'NC' => 'North Carolina',
    'ND' => 'North Dakota',
    'OH' => 'Ohio',
    'OK' => 'Oklahoma',
    'OR' => 'Oregon',
    'PA' => 'Pennsylvania',
    'RI' => 'Rhode Island',
    'SC' => 'South Carolina',
    'SD' => 'South Dakota',
    'TN' => 'Tennessee',
    'TX' => 'Texas',
    'UT' => 'Utah',
    'VT' => 'Vermont',
    'VA' => 'Virginia',
    'WA' => 'Washington',
    'WV' => 'West Virginia',
    'WI' => 'Wisconsin',
    'WY' => 'Wyoming',
    'AB' => 'Alberta'
}


STATE_ABBR_CANADA = {
    'BC' => 'British Columbia',
    'MB' => 'Manitoba',
    'NB' => 'New Brunswick',
    'NL' => 'Newfoundland and Labrador',
    'NT' => 'Northwest Territories',
    'NS' => 'Nova Scotia',
    'NU' => 'Nunavut',
    'ON' => 'Ontario',
    'PE' => 'Prince Edward Island',
    'QC' => 'Quebec',
    'SK' => 'Saskatchewan',
    'YT' => 'Yukon Territory'
}

