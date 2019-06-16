class DateviewsController < ApplicationController
  def create
    puts "dateview params start_date " + params[:dateview][:s_date_formatted]
    puts "dateview params end_date " + params[:dateview][:e_date_formatted]
    @d = current_dateview # find the original or last stored dateview
    @d.s_date_formatted =  params[:dateview][:s_date_formatted] 
    @d.e_date_formatted = params[:dateview][:e_date_formatted]
    puts "dateview errors " + @d.errors.messages.to_s
    if @d.errors.count == 0
      # go back to the page where you changed date
      # e.g. GET teacher/35 teachers/show.html.erb
      set_current_dateview @d
      puts "going back to show teacher/id page"
      redirect_to session[:forwarding_url]
    end
    # show the update dateview/id page with form to correct date
  end
end
