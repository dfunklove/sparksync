class DropDateviewTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :dateviews do |t|
	    t.datetime "start_date"
	    t.datetime "end_date"
	    t.datetime "created_at", null: false
	    t.datetime "updated_at", null: false
  	end
  end
end
