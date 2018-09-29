def fake_names
  ['Google', 'Facebook', 'Microsoft', 'Amazon', 'Apple', 'Dropbox', 'Intel', 'Oracle', 'Fiverr', 'Checkpoint', 'Mobileye', 'Radware', 'Elbit', 'Rafael', '8200', 'Mossad', 'Shabak', 'Yotpo', 'Cybereason', 'Autodesk', 'Gett', 'RedisLabs', 'PlayTika', '888', 'Samsung', 'SnapChat', 'Nice', 'Amdocs', 'GM', 'Wix', 'Texas Instruments', 'BlueVine', 'Taboola', 'Outbrain', 'Verbit', 'ZenCity', 'Guesty', 'Armis', 'Booking.com', 'Capitolis', 'Toluna', 'CWT', 'Ceragon Networks', 'F5', 'Cato Networks', 'CoinSafe', 'FundGuard', 'Nielsen', 'Starkware', 'Credifi', 'Namogoo', 'YouAppi', 'Spot.IM', 'Aqua Security', 'BioEye', 'CyberBit', 'CyberX', 'Colu', 'Tipalti', 'Healthy.io', 'ObserveIt', 'Wibbitz', 'Riskified', 'Bizzabo', 'Western Digital <wdc>', 'Personetics', 'Iguazio', 'Pipl', 'ControlUp', 'Neura', 'aiDoc', 'Natural Intelligence', 'JoyTunes', 'Dome9', 'CyberArk', 'K-Health', 'Deep Instinct']
end

def fake_address
  ['Dizengoff','Ben Yehuda','Allenby','Rothschild','Kaplan','Yigal Alon','HaUmanim','Menachem Begin','HaArad','HaBarzel'].sample+' '+(0..300).to_a.sample.to_s+', Tel Aviv, Israel'
end
fake_address

def fake_desc
["Pepperi is a growing startup providing omnichannel B2B commerce solutions to consumer goods brands and wholesalers. 

Our platform uniquely combines field sales automation, retail execution, and B2B e-commerce into an integrated mobile solution. 

We are experiencing an amazing growth period, working with the world’s leading consumer brands including Heineken, Sodastream, Seiko, Hallmark, Guess, Rip Curl and many more."].sample
end

def fake_org(name)
  { name: name,
    address: fake_address,
    desc: fake_desc,
    logo: Faker::Company.logo,
    slug: slugify(name) }
end
