get '/guidde' do 
  erb :'guidde'
end


VIDS = ['https://www.youtube.com/embed/YYUiGs1dFno', 'https://www.youtube.com/embed/5oRQfO6MQ_w', 'https://www.youtube.com/embed/O9spk4MuEZU', 'https://www.youtube.com/embed/68X85SxAU1g', 'https://www.youtube.com/embed/N4_UtmnXPeI']
IMGS = ['/img/face1.png','/img/face2.png','/img/face3.png']
def build_playbook(val)
	res = {
		id: guid,
		type: ['Team', 'Company', 'myGuidde'].sample,
		title: "Guidde for #{val}",
		creator_name: ['Jane', 'Joe', 'Joel', 'Jake', 'Jerome'].sample + ' ' + ['Smith', 'Jones', 'Adams', 'Robson'].sample,
		creator_img: IMGS.sample,
		time_ago: (0..10).to_a.sample.to_s+" days ago",
		rating: (0..10).to_a.sample.to_s+"."+(0..10).to_a.sample.to_s,
		url: VIDS.sample
	}		
end

get '/guidde/search' do
	val = pr[:val]

	return {playbooks: (0..5).to_a.map {|i| build_playbook(val) } }
end

get '/guidde/test' do 
  erb :'test'
end 