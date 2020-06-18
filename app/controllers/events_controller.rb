class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @calendar_month = CalendarMonth.new(params[:year], params[:month])
  end

  def show
    # TODO
  end

  def new
    @event = Event.new(start_date: Time.current.to_date)
  end

  def create
    @event = Event.new(event_params.merge(user: current_user))
    if @event.save
      redirect_back(fallback_location: events_path, notice: t('.notice'))
    else
      render 'new'
    end
  end

  def edit
    # TODO
  end

  def update
    # TODO
  end

  def destroy
    # TODO
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :periodicity)
  end
end
