class DateviewsController < ApplicationController
  def update
    dv_id = params[:id]

    # actually do need to save dateview in db in
    # case there are more than one full admins
    # using them. id is session variable
    # dateviews can be deleted at logout
    puts "dateview params start_date " + params[:dateview][:s_date_formatted]
    puts "dateview params end_date " + params[:dateview][:e_date_formatted]
    @d = Dateview.find(dv_id) # find the original or last stored dateview
    @d.s_date_formatted =  params[:dateview][:s_date_formatted] 
    @d.e_date_formatted = params[:dateview][:e_date_formatted]
    puts "dateview errors " + @d.errors.messages.to_s
    if @d.errors.count == 0
      if @d.save 
        # go back to the page where you changed date
        # e.g. GET teacher/35 teachers/show.html.erb
        puts "going back to show teacher/id page"
        redirect_to session[:forwarding_url]
      else
        raise Exception.new("no errors in dateview but unable to save")
      end
    end
    # show the update dateview/id page with form to correct date
  end
end
