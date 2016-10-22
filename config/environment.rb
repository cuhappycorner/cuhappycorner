# Load the Rails application.
require_relative 'application'

ActionMailer::Base.smtp_settings = {
  :user_name => 'system_cuhappycorner',
  :password => ',7MG_}~HnMKx@zuY',
  :domain => 'cuhappycorner.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

# Initialize the Rails application.
Rails.application.initialize!
