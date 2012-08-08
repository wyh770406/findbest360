Findbest360::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # A dummy setup for development - no deliveries, but logged
#  config.action_mailer.delivery_method = :sendmail
#  config.action_mailer.perform_deliveries = true
#  config.action_mailer.raise_delivery_errors = true
#  config.action_mailer.default :charset => "utf-8"



  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false
end

require 'tlsmail'
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address            => 'smtp.gmail.com',
  :port               => 587,
  :tls                  => true,
  :domain             => 'gmail.com', #you can also use google.com
  :authentication     => :plain,
  :user_name          => 'wyh770406@gmail.com',
  :password           => 'wyh770604'
}

#ActionMailer::Base.delivery_method = :sendmail
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = true
#  ActionMailer::Base.default_charset = "utf-8"
#  ActionMailer::Base.default_content_type = "text/html"

#ActionMailer::Base.sendmail_settings = {
#    :location       => '/usr/sbin/sendmail',
#    :arguments      => '-i -t'
#}
