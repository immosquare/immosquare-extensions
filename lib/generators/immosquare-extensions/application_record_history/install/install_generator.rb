require "rails/generators"
require "rails/generators/migration"

module ImmosquareExtensions
  module ApplicationRecordHistory
    class InstallGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Génère la migration pour la table application_record_histories"

      def copy_migration
        migration_template("template_1.rb", "db/migrate/#{migration_name.underscore}.rb", :migration_version => migration_version)
      end

      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      private


      def migration_name
        "CreateApplicationRecordHistories"
      end

      def migration_version
        return if ActiveRecord::VERSION::MAJOR < 6

        "[#{ActiveRecord::VERSION::STRING.to_f}]"
      end

    end
  end
end
