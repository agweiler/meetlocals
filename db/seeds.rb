Admin.create(
	email:"user@mail.com",
	password:"password"
	)
guest = Guest.create(
	username:"Guest User",
	email:"user@mail.com",
	password:"password",
	about:"I am a default Guest!"
	)
host = Host.create(
	username:"Host User",
	email:"user@mail.com",
	password:"password",
	about:"I am a default Host!"
	)
host.experience.create(
	title:"Ameristralian Brunch",
	description:"Have an american/australian hybrid	breakfast/lunch with us in Ameristralia",
	halal: true,
	cuisine:"American and Australian",
	max_group_size: 10,
	host_style: "All Ameristralian Hospitality (Wash your own dishes you lil'- I mean, I'll wash the plates, no problem!)",
	price: 19.95
	)
