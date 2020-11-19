# sparksync
A simple music lesson tracker built in Ruby on Rails.

# Installation Guide
This guide assumes you do not have Ruby installed on your machine.  The steps provided are not 
Start by downloading the Sparksync repository, either from the GitHub project page, or using the 'git clone' command.
Regardless of where you choose to save it, this document refers to the root directory of the repository itself as \$APPDIR.

In order to run this application, you will need to install the following:

1.  rbenv
    -  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    -  cd ~/.rbenv && src/configure && make -C src
        -  it's ok if this fails
    -  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    -  ~/.rbenv/bin/rbenv init
        -  Follow the printed instructions to set up rbenv shell integration.
2.  ruby-build
    -  mkdir -p "$(rbenv root)"/plugins
    -  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
3.  ruby
    -  rbenv install 2.5.1
    -  rbenv rehash
4.  bundler
    -  gem install bundler
5.  rbenv-bundler
    -  git clone -- https://github.com/carsomyr/rbenv-bundler.git ~/.rbenv/plugins/bundler
6.  rails + puma
    -  cd \$APPDIR
    -  bundle install
7.  js runtime
    -  install nodejs
    -  There are many ways to do this.  Here is the current command on Ubuntu:
        -  snap install node --classic
8.  database: postgres
    - sudo apt install postgresql postgresql-contrib libpq-dev
    - these steps seem to be obsolete on ubuntu 18.04 and postgres v10
        1.  initdb \--locale \$LANG -E UTF8 -D \'/var/lib/postgres/data\'
        2.  systemctl start postgresql.service
        3.  systemctl enable postgresql.service
    - cd \$APPDIR
    - rails db:setup
    -  create app user (follow rails error message)
        1.  sudo su - postgres
        2.  psql
        3.  create role X with login createdb superuser;
        4.  Ctrl-D
    - rails db:setup
9.  Ready to run the app
    - rails s
    - Open a browser and go to localhost:3000
    - Try to login using credentials from \$APPDIR/db/seeds.rb
10. Deploy on Heroku
