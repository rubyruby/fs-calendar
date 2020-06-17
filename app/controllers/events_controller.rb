class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    @date = Date.parse(params[:date]) rescue Time.current.to_date
    start_date = @date.beginning_of_month.beginning_of_week
    end_date = @date.end_of_month.end_of_week
    @days = (start_date..end_date).to_a
  end

end