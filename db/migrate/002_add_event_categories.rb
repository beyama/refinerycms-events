class AddEventCategories < ActiveRecord::Migration
  def self.up
    create_table :event_categories do |t|
      t.string :name, :length => 100
    end
    
    add_index :event_categories, :name, :unique => true
    
    create_table :event_categories_event_descriptions, :id => false do |t|
      t.integer :event_description_id
      t.integer :event_category_id
    end
    
    if defined?(ActsAsTaggableOn)
      event_categories = RefinerySetting.find_or_set(:event_categories, [])
      unless event_categories.empty?
        EventDescription.all.each do |desc|
          tags = ActsAsTaggableOn::Tag.joins(:taggings) \
            .where("taggable_type = 'EventDescription' AND taggable_id = ?", desc.id)
          desc.categories = tags.map do |tag|
            name = event_categories.find{|c| c.downcase == tag.name }
            if name
              category = EventCategory.find_by_name(name)
              category || EventCategory.create(:name => name)
            end
          end.compact
          desc.save
        end
        ActsAsTaggableOn::Tagging.delete_all("taggable_type = 'EventDescription' OR taggable_type = 'Event'")  
      end
    end
    
  end

  def self.down
    drop_table :event_categories
    drop_table :event_categories_event_descriptions
  end
end
