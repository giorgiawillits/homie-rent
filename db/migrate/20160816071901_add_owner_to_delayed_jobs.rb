class AddOwnerToDelayedJobs < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :owner_type, :string
    add_reference :delayed_jobs, :owner, index: false, foreign_key: true

    add_index :delayed_jobs, [:owner_type, :owner_id]
  end

  def self.down
    remove_column :delayed_jobs, :owner_type
    remove_column :delayed_jobs, :owner_id
  end
end
