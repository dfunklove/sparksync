class DateviewsController < ApplicationController
  def update
    dv_id = params[:id]

    # actually do need to save dateview in db in
    # case there are more than one full admins
    # using them. id is session variable
    # dateviews can be deleted at logout
    puts "dateview params start_date " + params[:dateview][:start_date]
    puts "dateview params end_date " + params[:dateview][:end_date]
#    r = Dateview.new
#    r.start_date = params[:dateview][:start_date]
#    r.end_date = params[:dateview][:end_date]
#    puts "r.start_date " + r.start_date.to_s
#    puts "r.end_date " + r.end_date.to_s
#    puts "retrieving dateview " + session[:dv_id].to_s
#    d = Dateview.find(session[:dv_id])
#    d.start_date = r.start_date
#    d.end_date = r.end_date
#    puts "d.start_date " + d.start_date.to_s
#    puts "d.end_date " + d.end_date.to_s
#    d.save
    if Dateview.update(dv_id, 
      start_date: params[:dateview][:start_date], 
      end_date: params[:dateview][:end_date])

      # go back to the page where you changed date
      # e.g. GET teacher/35 teachers/show.html.erb
      redirect_to session[:forwarding_url]
    else
      raise
    end
  end
end
