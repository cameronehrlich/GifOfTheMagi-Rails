class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :url
      t.datetime :datetime
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps
    end
  end
end
