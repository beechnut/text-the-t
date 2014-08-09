class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.string  :phone_number
      t.string  :language,    default: 'English'
      t.boolean :subscribed,  default: false
      t.integer :total_sent
    end

    add_index :users, :phone_number, unique: true
  end
end
