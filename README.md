# sparksync
A simple music lesson tracker built in Ruby on Rails.

# Deploy to Heroku
Heroku is the preferred option for production deployment.  It's the simplest way to get Sparksync up and running for your organization.  Heroku provides free application hosting in the cloud.  You will need to create a free Heroku account to use their service.  

Note: For better performance, it is recommended to use the lowest non-free tier, "Hobby".  See the Heroku documentation for instructions on switching your deployment to Hobby.

Now, let's get started!

### Git
First make sure Git is installed.
##### Mac
On Mac, open a Terminal window and type
- git --version

If git is not already installed, you will be prompted to install it.

##### Linux
If you are on Linux, run this command on Debian/Ubuntu:
- sudo apt install git-all

On Fedora/CentOS/RHEL, run this:
- sudo dnf install git-all

### Heroku CLI
Next we'll install Heroku CLI.

##### Mac
On Mac, the install command is:
- brew tap heroku/brew && brew install heroku

##### Linux
If you are on Linux, run this command on Debian/Ubuntu:
- sudo snap install heroku --classic

If you prefer not to use Snap, you may install directly:
- curl https://cli-assets.heroku.com/install.sh | sh

### Deploy to Heroku
Run the following commands in Terminal on Mac or Linux.
- git clone https://github.com/dfunklove/sparksync.git
- cd sparksync
- heroku login
    - Note: Use the browser window to login, following the instructions in Terminal.
- heroku create
- git push heroku master
    -  Note: Save the URL where the app was deployed.  You'll need it shortly.
- heroku run rake db:migrate
- heroku run rake db:seed

### SendGrid
Finally we'll install SendGrid in your Heroku application.  This enables the app to send email.
- Open a browser window to dashboard.heroku.com
- Select the app which was listed in the output of the command 'git push heroku master'
- Select 'Configure Add-Ons'
- In the search box under 'Add Ons' type 'sendgrid'
- Click the 'SendGrid' link that appears
- Select 'Submit Order Form'

That's it!  Sparksync is ready to go!

# Setup Development Environment
These steps are only needed if you intend to modify the source code and test it on your computer.  To deploy the app to the cloud for use in your organization, see the previous section, Deploy to Heroku.

This guide assumes you do not have Ruby installed on your machine.  It outlines all the steps needed to setup your local machine to run this application.

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
        1.  sudo -u postgres createuser -s $USER
        2.  systemctl start postgresql.service
        3.  systemctl enable postgresql.service
    - cd \$APPDIR
    - rails db:setup
9.  Run the app
    - rails s
    - Open a browser and go to localhost:3000
    - Try to login using credentials from \$APPDIR/db/seeds.rb
