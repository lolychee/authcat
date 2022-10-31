# frozen_string_literal: true

namespace :authcat_web_authn do
  # Prevent migration installation task from showing up twice.
  Rake::Task["install:migrations"].clear_comments
end

namespace :authcat do
  namespace :webauthn do
    desc "Copy over the migration needed to the application"
    task install: :environment do
      if Rake::Task.task_defined?("authcat_web_authn:install:migrations")
        Rake::Task["authcat_web_authn:install:migrations"].invoke
      else
        Rake::Task["app:authcat_web_authn:install:migrations"].invoke
      end
    end
  end
end
