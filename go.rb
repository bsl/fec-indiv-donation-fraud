require "date"

FILENAME = "data/itcont.txt"

NUM_DAYS = (Date.today - Date.parse("2023-01-01")).to_i
MIN_DONATIONS = NUM_DAYS / 2
MIN_AMOUNT_TOTAL = NUM_DAYS * 10

def fix_name(orig)
  name = orig.dup
  name.gsub!(/\bPROF\b/, "")
  name.gsub!(/\bDR\b/, "")
  name.gsub!(/\bSR\b/, "")
  name.gsub!(/\bJR\b/, "")
  name.gsub!(/\bMR\b/, "")
  name.gsub!(/\bMR?S\b/, "")
  name.gsub!(/\b[A-Z]\b/, "")
  name.gsub!(/\./, "")
  name.gsub!("`", "")
  loop do
    prev = name.dup
    name.gsub!(" ,", ",")
    name.gsub!("  ", " ")
    name.strip!
    break if name == prev
  end
  name
end

R_CMTE_IDS = %w(C00873893 C00770941 C00694323 C00027466 C00770214 C00075820 C00764860 C00837492 C00852343 C00770941 C00873893 C00652727 C00632257 C00831123 C00836403 C00545749 C00825281 C00003418)
D_CMTE_IDS = %w(C00401224 C00213512 C00603084 C00580068 C00745786 C00782599 C00042366 C00000935 C00562983 C00685297 C00718510 C00659599 C00633404 C00847673)

def d_or_r(cmte_ids)
  R_CMTE_IDS.each do |id|
    return "R" if cmte_ids.include?(id)
  end
  D_CMTE_IDS.each do |id|
    return "D" if cmte_ids.include?(id)
  end
  return "?"
end

db = {}

File.foreach(FILENAME).with_index do |line, idx|
  #break if idx == 4_000_000
  fields = line.split("|")
  cmte_id = fields[0]
  tx_date = fields[13]
  year = tx_date[4,4]
  next unless year == "2023" || year == "2024"
  name = fields[7]
  name = fix_name(name)
  city = fields[8]
  state = fields[9]
  city.gsub!("`", "")
  city.gsub!(/ +/, " ")
  city.strip!
  city.gsub!(/,+$/, "") # this mistake happens a lot
  city.strip!
  zip_code = fields[10][0,5] # truncate zip
  if state == "AL" && city == "CREOLAAMOUNTS= 8" then city = "CREOLA" end
  if state == "AL" && city == "MOUNTAIN BRK" then city = "MOUNTAIN BROOK" end
  if state == "AR" && city == "BELLA VISTA, AR 72" then city = "BELLA VISTA" end
  if state == "AZ" && city == "GREEN VALLY" then city = "GREEN VALLEY" end
  if state == "AZ" && city == "TUCSAN" then city = "TUCSON" end
  if state == "CA" && city == "CALIFORNAI" && zip_code == "94124" then city = "SAN FRANCISCO" end
  if state == "CA" && ["CARDIFF BY THE SEA", "CARDIFF-BY-THE-SEA"].include?(city) then city = "CARDIFF" end
  if state == "CA" && city == "DSVIS" then city = "DAVIS" end
  if state == "CA" && city == "HUNTINGTON+BEACH" then city = "HUNTINGTON BEACH" end
  if state == "CA" && city == "LA" then city = "LOS ANGELES" end
  if state == "CA" && ["LA CANADA", "LA CANADA FLINTRID"].include?(city) then city = "LA CANADA FLINTRIDGE" end
  if state == "CA" && city == "LAJOLLA" then city = "LA JOLLA" end
  if state == "CA" && city == "LIS ANGELES" then city = "LOS ANGELES" end
  if state == "CA" && city == "MORGANHILL" then city = "MORGAN HILL" end
  if state == "CA" && city == "PALOS VERDES ESTAT" then city = "PALOS VERDES ESTATES" end
  if state == "CA" && city == "RANCHO MISSION VIE" then city = "RANCHO MISSION VIEJO" end
  if state == "CA" && city == "RANCHO SANTA MARGA" then city = "RANCHO SANTA MARGARITA" end
  if state == "CA" && city == "RIOLINDA" then city = "RIO LINDA" end
  if state == "CA" && city == "SACRAMENTI" then city = "SACRAMENTO" end
  if state == "CA" && ["SAN FRABCISCO", "SAN.FRANCISCO ,CA", "SF"].include?(city) then city = "SAN FRANCISCO" end
  if state == "CA" && city == "SANJOSE" then city = "SAN JOSE" end
  if state == "CA" && city == "SANTA ROSA," then city = "SANTA ROSA" end
  if state == "CA" && city == "SHERMAN OSKS" then city = "SHERMAN OAKS" end
  if state == "CA" && city == "SOUTH SAN FRANCISC" then city = "SOUTH SAN FRANCISCO" end
  if state == "CA" && city == "THOUSAND PLMS" then city = "THOUSAND PALMS" end
  if state == "CA" && city == "VAN NUYS, CA" then city = "VAN NUYS" end
  if state == "CO" && city == "COLORADO SPGS" then city = "COLORADO SPRINGS" end
  if state == "CO" && city == "FT COLLINS" then city = "FORT COLLINS" end
  if state == "CO" && city == "LONGMONT, CO" then city = "LONGMONT" end
  if state == "CO" && city == "PAGOSA SPGS" then city = "PAGOSA SPRINGS" end
  if state == "CT" && city == "STORRS MANSFIELD" then city = "STORRS" end
  if state == "DC" && ["WAS", "WASH", "WASHINGTON, DC", "WASHINGTOM"].include?(city) then city = "WASHINGTON" end
  if state == "FL" && city == "#W.MELBOURNE" then city = "WEST MELBOURNE" end
  if state == "FL" && city == "FERNANDINA BRACH" then city = "FERNANDINA BEACH" end
  if state == "FL" && ["FT LAUDERDALE", "FT. LAUDERDALE"].include?(city) then city = "FORT LAUDERDALE" end
  if state == "FL" && ["FT. MEYERS"].include?(city) then city = "FORT MEYERS" end
  if state == "FL" && ["KEY WEST, FL 33040", "KEYWEST"].include?(city) then city = "KEY WEST" end
  if state == "FL" && ["LAND O LAKES", "LLAND O LAKES"].include?(city) then city = "LAND O' LAKES" end
  if state == "FL" && ["LIGHTHOUSDE POINTF"].include?(city) then city = "LIGHTHOUSE POINT" end
  if state == "FL" && ["MIAMIBEACH"].include?(city) then city = "MIAMI BEACH" end
  if state == "FL" && ["OVEIDO"].include?(city) then city = "OVIEDO" end
  if state == "FL" && ["PORT ST LUCIE"].include?(city) then city = "PORT SAINT LUCIE" end
  if state == "FL" && ["PT ORANGE"].include?(city) then city = "PORT ORANGE" end
  if state == "FL" && ["PUNTA"].include?(city) then city = "PUNTA GORDA" end
  if state == "FL" && ["SAIINT JAMES CITY"].include?(city) then city = "SAINT JAMES CITY" end
  if state == "FL" && ["SARSOTA"].include?(city) then city = "SARASOTA" end
  if state == "FL" && ["ST AUGUSTINE", "ST. AUGUSTINE"].include?(city) then city = "SAINT AUGUSTINE" end
  if state == "FL" && ["ST PETERSBURG", "ST. PETERSBURG"].include?(city) then city = "SAINT PETERSBURG" end
  if state == "IL" && ["GLENVEIW"].include?(city) then city = "GLENVIEW" end
  if state == "IL" && ["HAZEL-CREST"].include?(city) then city = "HAZEL CREST" end
  if state == "IL" && ["HERSCHET"].include?(city) then city = "HERSCHER" end
  if state == "IL" && ["MT PROSPECT"].include?(city) then city = "MOUNT PROSPECT" end
  if state == "IL" && ["NAPERVILLE, IL"].include?(city) then city = "NAPERVILLE" end
  if state == "IL" && ["O FALLON", "OFALLON"].include?(city) then city = "O'FALLON" end
  if state == "IN" && ["BLOOMONGTON"].include?(city) then city = "BLOOMINGTON" end
  if state == "IN" && ["LAPORTE"].include?(city) then city = "LA PORTE" end
  if state == "LA" && ["ST. AMANT"].include?(city) then city = "SAINT AMANT" end
  if state == "MA" && ["DORCHESTER CTR"].include?(city) then city = "DORCHESTER CENTER" end
  if state == "MA" && ["JAMAIA PLAIN"].include?(city) then city = "JAMAICA PLAIN" end
  if state == "MA" && ["NEWTON CENTRE"].include?(city) then city = "NEWTON CENTER" end
  if state == "MA" && ["NORTHBORO"].include?(city) then city = "NORTHBOROUGH" end
  if state == "MA" && ["S WELLFLEET"].include?(city) then city = "SOUTH WELLFLEET" end
  if state == "MA" && ["W. FALMOUTH"].include?(city) then city = "WEST FALMOUTH" end
  if state == "MD" && ["ANNAPOLID"].include?(city) then city = "ANNAPOLIS" end
  if state == "MD" && ["BETHESFA"].include?(city) then city = "BETHESDA" end
  if state == "MD" && ["COLUNBIA"].include?(city) then city = "COLUMBIA" end
  if state == "MD" && ["FT WASHINGTON"].include?(city) then city = "FORT WASHINGTON" end
  if state == "MD" && ["LANHAM"].include?(city) && zip_code == "20706" then city = "LANHAM-SEABROOK" end
  if state == "MD" && ["LUTHERVILLE TIMONI", "LUTHERVILLE TIMONIUM", "LUTHERVILLE-TIMONI"].include?(city) then city = "LUTHERVILLE" end
  if state == "MD" && ["N BETHESDA"].include?(city) then city = "NORTH BETHESDA" end
  if state == "ME" && ["PORTLAN"].include?(city) then city = "PORTLAND" end
  if state == "ME" && ["SOUTH BERWICJ"].include?(city) then city = "SOUTH BERWICK" end
  if state == "MI" && ["GROSSE POINTE WOOD"].include?(city) then city = "GROSS POINTE WOODS" end
  if state == "MI" && ["NORTHVILLLE"].include?(city) then city = "NORTHVILLE" end
  if state == "MI" && ["SOUTFIELD"].include?(city) then city = "SOUTHFIELD" end
  if state == "MI" && ["WEST BLOOMFIELD TO"].include?(city) then city = "WEST BLOOMFIELD" end
  if state == "MN" && ["BROOKLYN PARL"].include?(city) then city = "BROOKLYN PARK" end
  if state == "MN" && ["MINNEAPOLIS, MN", "MINNEPOLIS"].include?(city) then city = "MINNEAPOLIS" end
  if state == "MN" && ["NO CITY PROVIDED"].include?(city) && zip_code == "55436" then city = "SAINT LOUIS PARK" end
  if state == "MN" && ["ST MICHAEL", "ST. MICHAEL"].include?(city) then city = "SAINT MICHAEL" end
  if state == "MN" && ["ST PAUL", "ST. PAUL"].include?(city) then city = "SAINT PAUL" end
  if state == "MN" && ["ST ANTHONY", "ST. ANTHONY"].include?(city) then city = "SAINT ANTHONY" end
  if state == "MO" && ["KC", "KCMO"].include?(city) then city = "KANSAS CITY" end
  if state == "MO" && ["LEES SUMMIT"].include?(city) then city = "LEE'S SUMMIT" end
  if state == "MO" && ["ST LOUIS", "ST. LOUIS"].include?(city) then city = "SAINT LOUIS" end
  if state == "MO" && ["ST JOSEPH", "ST. JOSEPH"].include?(city) then city = "SAINT JOSEPH" end
  if state == "MT" && ["GREATFALLS"].include?(city) then city = "GREAT FALLS" end
  if state == "NC" && ["WINSTON SALEM"].include?(city) then city = "WINSTON-SALEM" end
  if state == "NH" && ["MERRIMACK, NEW HAM"].include?(city) then city = "MERRIMACK" end
  if state == "NJ" && ["HACKETTSTOWN, NEW"].include?(city) then city = "HACKETTSTOWN" end
  if state == "NJ" && ["LITTLE EGG HARBOR TWP"].include?(city) then city = "LITTLE EGG HARBOR" end
  if state == "NJ" && ["MONMOUTH JCT"].include?(city) then city = "MONMOUTH JUNCTION" end
  if state == "NJ" && ["POMPTON PLAINES", "POMPTON PLNS"].include?(city) then city = "POMPTON PLAINS" end
  if state == "NJ" && ["TWP WASHINGTON"].include?(city) then city = "TOWNSHIP OF WASHINGTON" end
  if state == "NJ" && ["WOODBRIDGE TOWNSHI"].include?(city) then city = "WOODBRIDGE TOWNSHIP" end
  if state == "NM" && ["HIGH ROLLS MOUNTAIN PARK"].include?(city) then city = "HIGH ROLLS" end
  if state == "NV" && ["MC GILL"].include?(city) then city = "MCGILL" end
  if state == "NV" && city == "NYC" && zip_code == "10025" then state = "NY"; city = "NEW YORK CITY"; end
  if state == "NY" && ["ASTORIA, QUEENS"].include?(city) then city = "ASTORIA" end
  if state == "NY" && ["ATLANTIC BCH"].include?(city) then city = "ATLANTIC BEACH" end
  if state == "NY" && ["BKLYN.", "BROOKLYN NEW YORK"].include?(city) then city = "BROOKLYN" end
  if state == "NY" && ["CLIFTON SPGS"].include?(city) then city = "CLIFTON SPRINGS" end
  if state == "NY" && ["EAST. HAMPTON. NY"].include?(city) then city = "EAST HAMPTON" end
  if state == "NY" && ["HASTINGS ON HUDSON"].include?(city) then city = "HASTINGS-ON-HUDSON" end
  if state == "NY" && ["ITHACS"].include?(city) then city = "ITHACA" end
  if state == "NY" && ["JOHN"].include?(city) && zip_code == "13790" then city = "JOHNSON CITY" end
  if state == "NY" && ["LONG IS CITY"].include?(city) then city = "LONG ISLAND CITY" end
  if state == "NY" && ["NEEW YORK", "NEW YORK CITY", "NEW YORK P", "NEW YORK, N.Y.", "NEW YOTK", "NY", "NYC"].include?(city) then city = "NEW YORK" end
  if state == "NY" && ["QUEENS VLG"].include?(city) then city = "QUEENS VILLAGE" end
  if state == "NY" && ["ROCKAWAY"].include?(city) then city = "ROCKAWAY PARK" end
  if state == "NY" && ["S OZONE PK"].include?(city) then city = "SOUTH OZONE PARK" end
  if state == "NY" && ["SEA CLUFF"].include?(city) then city = "SEA CLIFF" end
  if state == "NY" && ["SO. JMSPRT"].include?(city) then city = "SOUTH JAMESPORT" end
  if state == "NY" && ["STATEN ISALND"].include?(city) then city = "STATEN ISLAND" end
  if state == "NY" && ["STONYBROOK"].include?(city) then city = "STONY BROOK" end
  if state == "OH" && ["BROADVIEW HTS"].include?(city) then city = "BROADVIEW HEIGHTS" end
  if state == "OH" && ["CLEVELAND HTS"].include?(city) then city = "CLEVELAND HEIGHTS" end
  if state == "OH" && ["DOBLIN"].include?(city) then city = "DUBLIN" end
  if state == "OH" && ["OLMSTED TWP"].include?(city) then city = "OMSTED FALLS" end
  if state == "OH" && ["WELLINGTOM"].include?(city) then city = "WELLINGTON" end
  if state == "PA" && ["COLUMBIA CROSS ROA"].include?(city) then city = "COLUMBIA CROSS ROADS" end
  if state == "PA" && ["G;ADWYNE"].include?(city) then city = "GLADWYNE" end
  if state == "PA" && ["LITIIZ"].include?(city) then city = "LITITZ" end
  if state == "PA" && ["NEWTOWN SQ"].include?(city) then city = "NEWTOWN SQUARE" end
  if state == "PA" && ["PA FURNACE"].include?(city) then city = "PENNSYLVANIA FURNACE" end
  if state == "PA" && ["PGH", "PGH."].include?(city) then city = "PITTSBURGH" end
  if state == "PA" && ["PHILA", "PHILA."].include?(city) then city = "PHILADELPHIA" end
  if state == "PA" && ["WASHINGTON CROSSIN"].include?(city) then city = "WASHINGTON CROSSING" end
  if state == "SC" && ["MT PLEASANT", "MT. PLEASANT"].include?(city) then city = "MOUNT PLEASANT" end
  if state == "SC" && ["SULLIVANS IS"].include?(city) then city = "SULLIVANS ISLAND" end
  if state == "SD" && ["ABERDEEN."].include?(city) then city = "ABERDEEN" end
  if state == "TN" && ["HENDERSONVILL"].include?(city) then city = "HENDERSONVILLE" end
  if state == "TX" && ["FT WORTH"].include?(city) then city = "FORT WORTH" end
  if state == "TX" && ["MCKI NNEY"].include?(city) then city = "MCKINNEY" end
  if state == "TX" && ["NORTH RICHLAND HIL"].include?(city) then city = "NORTH RICHLAND HILLS" end
  if state == "VA" && ["ROANOKE. VA"].include?(city) then city = "ROANOKE" end
  if state == "VA" && ["VA BEACH"].include?(city) then city = "VIRGINIA BEACH" end
  if state == "WA" && ["15369 BROOM STREET", "BAINBRIDGE IS", "BAINBRIDGE IS."].include?(city) then city = "BAINBRIDGE ISLAND" end
  if state == "WA" && ["EDGWOOD"].include?(city) then city = "EDGEWOOD" end
  if state == "WA" && ["LAKE FOREST PARK C"].include?(city) then city = "LAKE FOREST PARK" end
  if state == "WA" && ["OLYMPIA , WA"].include?(city) then city = "OLYMPIA" end
  if state == "WA" && ["SEATLE", "SESTTLE"].include?(city) then city = "SEATTLE" end
  if state == "WA" && ["YAKIMA, WA"].include?(city) then city = "YAKIMA" end
  if state == "WI" && ["FOX PT"].include?(city) then city = "FOX POINT" end
  tx_amount = fields[14].to_i
  db[state] ||= {}
  db[state][city] ||= {}
  key = [name, zip_code].join("|")
  unless db[state][city].has_key?(key)
    db[state][city][key] = {}
    db[state][city][key][:cmte_ids] = Set.new
    db[state][city][key][:amounts] = []
  end
  db[state][city][key][:cmte_ids].add(cmte_id)
  db[state][city][key][:amounts] << tx_amount
end

states = db.keys.sort {|a,b| a <=> b }
states.each do |state|
  state_db = db[state]
  cities = state_db.keys.sort {|a,b| a <=> b }
  cities.each do |city|
    city_db = state_db[city]
    donor_recs = city_db.to_a
      .filter {|e| e[1][:amounts].sum >= MIN_AMOUNT_TOTAL }
      .filter {|e| e[1][:amounts].length >= MIN_DONATIONS }
      .sort {|a,b| b[1][:amounts].length <=> a[1][:amounts].length }
    lines = donor_recs.map do |donor_rec|
      key, h = donor_rec
      dr = d_or_r(h[:cmte_ids])
      amount_total = h[:amounts].sum
      num_txs = h[:amounts].length
      num_per_day_s = if num_txs > NUM_DAYS
        "#{"%.1f" % (num_txs.to_f / NUM_DAYS)} times per day"
      else
        "every #{"%.1f" % (NUM_DAYS.to_f / num_txs)} days"
      end
      [num_txs, "$#{amount_total}", key, num_per_day_s, dr].join("|")
    end
    unless lines.empty?
      location = [state, city].join("|")
      puts "# #{location}"
      puts lines
      puts
    end
  end
end
