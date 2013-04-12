class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      	t.string :orig_url
      	t.timestamps
      	t.attachment :image
    end
  end
end
