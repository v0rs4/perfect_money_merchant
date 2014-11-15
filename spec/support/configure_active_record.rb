ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Migrator.migrate File.expand_path('../../rails_test_app/db/migrate/', __FILE__)