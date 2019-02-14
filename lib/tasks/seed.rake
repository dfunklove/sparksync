# generates documented tasks for executing the scripts in db/seeds
# e.g. db/seeds/production.rb becomes task db:seed:production
namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
      desc "Loads the seed data from db/seeds/#{File.basename(filename)}"
      task File.basename(filename, '.rb').to_sym => :environment do
        load(filename)
      end
    end
  end
end