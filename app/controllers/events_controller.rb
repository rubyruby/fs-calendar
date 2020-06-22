class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @calendar_month = CalendarMonth.new(params[:year], params[:month], current_user)
  end

  def all
    @calendar_month = CalendarMonth.new(params[:year], params[:month])
    render 'index'
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(start_date: Date.today)
  end

  def create
    @event = Event.new(event_params.merge(user: current_user))
    if @event.save
      redirect_to events_path, notice: t('.notice')
    else
      render 'new'
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.update(event_params)
      redirect_to events_path, notice: t('.notice')
    else
      render 'edit'
    end
  end

  def destroy
    event = current_user.events.find(params[:id])
    event.destroy
    redirect_to events_path, notice: t('.notice')
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :periodicity)
  end
end
