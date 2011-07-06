class CreateEventStructure < ActiveRecord::Migration

  def self.up
    create_table :events do |t|
      t.datetime    :start_at, :null => false
      t.datetime    :end_at, :null => false
      t.references  :location
      t.references  :description
      t.integer     :cost
      t.references  :created_by
      t.references  :updated_by

      t.timestamps
    end

    add_index :events, [:id, :start_at, :end_at]
    
    create_table :event_descriptions do |t|
      t.string      :name, :null => false
      t.text        :summary
      t.text        :description
      t.references  :location
      t.integer     :cost
      t.references  :created_by
      t.references  :updated_by
      
      t.timestamps
    end
    
    add_index :event_descriptions, :name
    
    create_table :event_locations do |t|
      t.string :venue, :null => false
      t.string :country, :limit => 100
      t.string :address
      t.string :city, :limit => 100
      t.string :state, :limit => 100
      t.string :zip, :limit => 20
      t.string :phone, :limit => 40
      
      t.float :lat
      t.float :lng
      
      t.boolean :show_map_link, :default => false
      t.boolean :show_map, :default => false
      
      t.timestamps
    end

    add_index :event_locations, [:venue, :country, :city, :state, :zip], :name => :index_event_locations
    add_index :event_locations, [:lat, :lng], :name => :geo_index_event_locations

    load(Rails.root.join('db', 'seeds', 'events.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "events"})

    Page.delete_all({:link_url => "/events"})

    drop_table :events
    drop_table :event_descriptions
    drop_table :event_locations
  end

end
