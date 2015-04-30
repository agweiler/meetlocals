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

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
  numFiles = input.get(0).files ? input.get(0).files.length : 1,
  label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [numFiles, label]);
});

$(document).ready( function() {
  $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
    var input = $(this).parents('.input-group').find(':text');
    log = numFiles > 1 ? numFiles + ' files selected' : label;
		$('input[type*=submit]').prop('disabled', false);

    if(numFiles != 3){
			input.val("Please upload 3 exeprience images.").attr('style','color:red');
			$('input[type*=submit]').prop('disabled', true);
		}else if( input.length ) {
			input.removeAttr('style');
      input.val(log);
    } else {
      if( log ) alert(log);
    }

  });
});
