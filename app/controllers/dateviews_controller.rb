class DateviewsController < ApplicationController
  def create
    @d = current_dateview # find the original or last stored dateview
    @d.s_date_formatted =  params[:dateview][:s_date_formatted] 
    @d.e_date_formatted = params[:dateview][:e_date_formatted]
    if @d.errors.count == 0
      set_current_dateview @d

      # go back to the page where user changed date
      if session[:previous_page]
        temp = session[:previous_page]
        session.delete(:previous_page)
        redirect_to temp
      else
        redirect_to request.referrer
      end
    else
      session[:previous_page] = request.referrer
      # show the update dateview/id page with form to correct date
    end
  end
end
