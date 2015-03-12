// mapMake() begin
// Only define mapMake if on host display page
if (/\/hosts\/\d+$/.test(window.location.href)) {
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
}
// mapMake() end


// geocode() begin
function geocode() {
	var geocoder = new google.maps.Geocoder();
  var country = $('#host_country').val();
  var state = $('#host_state').val();
  var suburb = $('#host_suburb').val();
  address = suburb + " " + state + " " + country
	if (geocoder) {
		geocoder.geocode({ 'address': address }, function (results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				console.log(results[0].geometry.location)
				$('#host_latitude').val(results[0].geometry.location['k'])
				$('#host_longitude').val(results[0].geometry.location['D'])
				$('input[name=commit]').click();
			} else {
				console.log("Geocoding failed: " + status);
				alert('Address not found, Use google maps to find your address')
			}
		});
	}  
};
// geocode() end