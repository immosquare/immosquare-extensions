class <%= "#{migration_name} < ActiveRecord::Migration#{migration_version}" %>

  def change
    create_table(:application_reccord_histories) do |t|
      t.references(:recordable, :polymorphic => true, :null => false)
      t.text(:data, :null => false, :limit => 4_294_967_295)
      t.datetime(:created_at, :null => false)
    end

    add_index(:application_reccord_histories, [:recordable_type, :recordable_id])
  end

end
