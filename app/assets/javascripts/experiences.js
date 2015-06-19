

$(document).on('change', '.upload-experience :file', function() {
  var input = $(this),
  numFiles = input.get(0).files ? input.get(0).files.length : 1,
  label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [numFiles, label]);
});

// $(document).ready( function() {
//   $('.upload-experience :file').on('fileselect', function(event, numFiles, label) {
//     var input = $(this).parents('.input-group').find(':text');
//     log = numFiles > 1 ? numFiles + ' files selected' : label;
// 		$('input[type*=submit]').prop('disabled', false);

//     if(numFiles != 3){
// 			input.val("Please upload 3 experience images.").attr('style','color:red');
// 			$('input[type*=submit]').prop('disabled', true);
// 		}else if( input.length ) {
// 			input.removeAttr('style');
//       input.val(log);
//     } else {
//       if( log ) alert(log);
//     }

//   });
// });

$(function(){
	var choice_box = $('div#dinner_choice')

	function showhide(foo){
		(foo === "Dinner") ? choice_box.show() : choice_box.hide();
	};

	showhide($('select#experience_meal').val()) //default
	$('#meal').on('change', '#experience_meal', function(event){
		showhide(this.value);
	});
});
