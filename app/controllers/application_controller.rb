class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def home
  	render '/home', layout: :default
  end

  def historical_data
    dformat = '%b %d, %Y'
    case params[:period]
    when "2"
      @start_date = (Time.now.ago 1.month).strftime(dformat)
    when "3"
      @start_date = (Time.now.ago 3.months).strftime(dformat)
    else
      @start_date = (Time.now-7.day).strftime(dformat)
    end
    @end_date = Time.now.strftime(dformat)

    @base = params[:base] || 'GBP'
    @versus = params[:versus] || 'USD'
  	render '/historical'
  end

  def list
    dformat = '%b %d, %Y'
    @base = params[:base] || 'GBP'
    @start_date = (Time.now - 7.day).strftime(dformat)
    @end_date = Time.now.strftime(dformat)
    render '/list'
  end
end
