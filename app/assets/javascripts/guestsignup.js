$(".registrations.new").ready(function(){

 $('#guest_signup').on('click', function() {

    ga('send', 'event', 'signup', 'click', 'guest');
 });

 $('#host_signup').on('click', function() {
 	
    ga('send', 'event', 'signup', 'click', 'host');
 });


});

