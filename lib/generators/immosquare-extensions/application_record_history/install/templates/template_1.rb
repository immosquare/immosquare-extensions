class <%= "#{migration_name} < ActiveRecord::Migration#{migration_version}" %>

  def change
    create_table(:application_record_histories) do |t|
      t.references(:recordable, :polymorphic => true, :foreign_key => false, :index => false, :null => false)
      t.references(:modifier, :polymorphic => true, :foreign_key => false, :index => false, :null => true)
      t.text(:data, :null => false, :limit => 4_294_967_295)
      t.datetime(:created_at, :null => false)
    end

    add_index(:application_record_histories, [:recordable_type, :recordable_id])
    add_index :application_record_histories, [:modifier_type, :modifier_id]
  end

end
