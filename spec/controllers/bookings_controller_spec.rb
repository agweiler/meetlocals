require 'rails_helper'
require 'factory_girl_rails'
require 'rspec/rails'

describe BookingsController do
	before do

	end

	describe "Hosts revenue increases when mark_completed method is run" do
		before do
			@host = FactoryGirl.create(:host)
			@admin = FactoryGirl.create(:admin)
			@exp = FactoryGirl.create(:experience, host_id: @host.id)
			@guest = FactoryGirl.create(:guest)
			@booking = FactoryGirl.create(:booking, experience_id: @exp.id, guest_id: @guest.id, date: Date.today)
		end
		it "increases host revenue" do
		  xhr :post, :mark_completion, {id: @booking.id }
		  expect(Booking.count).to eq(1)
		  expect(@host.reload.revenue).to eq(91.97)
		end
	end


	describe "Hosts revenue increases even more when mark_completed method is run and admin increaes commision" do
		before do
			@host = FactoryGirl.create(:host)
			@admin = FactoryGirl.create(:admin)
			@exp = FactoryGirl.create(:experience, host_id: @host.id)
			@guest = FactoryGirl.create(:guest)
			@booking = FactoryGirl.create(:booking, experience_id: @exp.id, guest_id: @guest.id, date: Date.today)
		end
		it "increases host revenue" do
			@admin.update(commision_percentage: 20)
		  xhr :post, :mark_completion, {id: @booking.id }
		  expect(Booking.count).to eq(1)
		  expect(@host.reload.revenue).to eq(183.94)
		end
	end
end