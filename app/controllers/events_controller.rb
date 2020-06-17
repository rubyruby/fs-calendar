class EventsController < ApplicationController

  before_action :authenticate_user!

  def index
    @date = Date.parse(params[:date]) rescue Time.current.to_date
    start_date = @date.beginning_of_month.beginning_of_week
    end_date = @date.end_of_month.end_of_week
    @days = (start_date..end_date).to_a
  end

  def new
    @event = Event.new(start_date: Time.current.to_date)
  end

  def create
    @event = Event.new(event_params.merge(user: current_user))
    if @event.save
      redirect_to(events_path, notice: t('.notice'))
    else
      render 'new'
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :periodicity)
  end

end