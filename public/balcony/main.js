console.log('balcony main.js running');
window.map = null;

function addItems(data) {
	var orig = $('.single_item');
	data.items.forEach(item => {
		console.log('adding ',item)
		var newItem = orig.clone().removeClass('hidden');
		newItem.on('click',() => showOne(item));
		newItem.attr('data-id',item.id).attr('src',item.url).appendTo(orig.parent());
		addMapMarker(data.center, item);
	})
}

function initHeader(data) {
	$('.title').text(data.title);
	$('.subtitle').text(data.subtitle);
}

function setContent(data) {	
	initHeader(data);	
	initMap(data.center);
	addItems(data);	
}

function fetchContent() {
	var items = [
		{id: 'a', url: 'https://www.dogster.com/wp-content/uploads/2018/09/Carolina-Dog.jpg'},
		{id: 'b', url: 'https://images.pexels.com/photos/39317/chihuahua-dog-puppy-cute-39317.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'},
		{id: 'c', url: 'https://images.pexels.com/photos/3299896/pexels-photo-3299896.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'},
		{id: 'd', url: 'https://images.pexels.com/photos/2023386/pexels-photo-2023386.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'}
	]

	var data = {
		center: {lat: -34.397, lng: 150.644 }, 
		items: items,
		title: 'We reached out to employees',
		subtitle: 'Can you share info about the earthquake?'
	}	

	setContent(data);
}

function showOne(item) {
	showAll();
	$(`.single_item[data-id='${item.id}']`).addClass('highlighted');
	$('#show_all').show();
}

function showAll() {
	$('#show_all').hide();
	$(`.single_item`).removeClass('highlighted');	
}

function mapFirst() {
	$('.map').addClass('bigger')
	$('.items').addClass('smaller')
}

function contentFirst() {
	$('.map').removeClass('bigger')
	$('.items').removeClass('smaller')
}

function addMapMarker(center, item) {
	var gmaps = google.maps;
	var icon  = {
    url: item.url,
    scaledSize: new gmaps.Size(50, 50), // scaled size
    // origin: new gmaps.Point(0,0), // origin
    // anchor: new gmaps.Point(0,0) // anchor
	};
  var marker = new gmaps.Marker({
    position: {lat: center.lat+Math.random(), lng: center.lng+ Math.random()},
    map: window.map,
    icon
  });

  google.maps.event.addListener(marker, 'click', () => showOne(item));
}

function initMap(center) {	
	var el     = $('#map').last()[0];	
	var map    = new google.maps.Map(el, {center, zoom: 8});
	window.map = map;
}

fetchContent();