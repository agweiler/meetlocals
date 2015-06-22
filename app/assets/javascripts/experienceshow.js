$(".experiences.show").ready(function(){

 $('#ga').on('click', function() {
    ga('send', 'event', 'button', 'click', 'booking');
 });

 // mapMake() begin



 function mapMake() {
 	var mapLat = document.getElementById('mapLat').innerHTML
 	mapLat = parseFloat(mapLat)
 	var mapLng = document.getElementById('mapLng').innerHTML
 	mapLng = parseFloat(mapLng)
 	var mapCanvas = document.getElementById('map-canvas');
 	var mapOptions = {
 		center: new google.maps.LatLng(mapLat, mapLng),
 		zoom: 15,
 		mapTypeId: google.maps.MapTypeId.ROADMAP
 	}
 	var map = new google.maps.Map(mapCanvas, mapOptions);
 	mapRad = 300
 	var circleOptions = {
 		strokeColor: '#0000FF',
 		strokeOpacity: 0.8,
 		strokeWeight: 2,
 		fillColor: '#1e90ff',
 		fillOpacity: 0.3,
 		map: map,
 		center: new google.maps.LatLng(mapLat, mapLng),
 		radius: mapRad
 	}

 	mapCircle = new google.maps.Circle(circleOptions)
 }
 google.maps.event.addDomListener(window, 'load', mapMake);
 // mapMake() end

});
