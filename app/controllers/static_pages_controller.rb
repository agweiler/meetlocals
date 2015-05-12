class StaticPagesController < ApplicationController

  def home
    @recent_events = Experience.limit(3)
    @host_party = Experience.limit(3)
  end

  def how_it_works
  end

  def about
  end

  def explore
  end

  def terms_of_service
  end

  def page_not_found
  end

  def unknown_error
  end


end
