require 'rails_helper'
require 'factory_girl_rails'
require 'rspec/rails'

describe HostsController do
	before do
		@host = FactoryGirl.create(:host)


	end

	it "has valid factory" do 
		expect(@host).to be_valid
	end

	describe "DELETE #destroy with bookings and experiences" do
		before do
			@exp = FactoryGirl.create(:experience, host_id: @host.id)
			@guest = FactoryGirl.create(:guest)
			@booking = FactoryGirl.create(:booking, experience_id: @exp.id, guest_id: @guest.id, date: Date.today)
			delete :destroy,id: @host
		end
		it "deletes the experience" do
			expect(Experience.count).to eq(0)
		end
		it "deletes the host" do
			expect(Host.count).to eq(0)
		end
		it "deletes the booking" do
			expect(Booking.count).to eq(0)
		end
	end

	describe "DELETE #destroy with experiences" do
		before do
			@exp = FactoryGirl.create(:experience, host_id: @host.id)
			delete :destroy,id: @host
		end
		it "deletes the experience" do
			expect(Experience.count).to eq(0)
		end
		it "deletes the host" do
			expect(Host.count).to eq(0)
		end
	end

	describe "DELETE #destroy WITHOUT experiences and bookings" do
		before do
			delete :destroy,id: @host
		end
		it "deletes the host" do
			expect(Host.count).to eq(0)
		end
	end

end