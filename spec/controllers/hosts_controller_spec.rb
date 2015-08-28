require 'rails_helper'
require 'factory_girl_rails'
require 'rspec/rails'

describe HostsController do
	before do
		@host = FactoryGirl.create(:host)
		@exp = FactoryGirl.create(:experience, host_id: @host.id)
		@guest = FactoryGirl.create(:guest)
		@booking = FactoryGirl.create(:booking, experience_id: @exp.id, guest_id: @guest.id, date: Date.today)
	end

	describe "DELETE #destroy" do
		before do
			delete :destroy, @host
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

end