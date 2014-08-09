class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :phone_number
      t.string  :language,    default: 'English'
      t.boolean :subscribed
      t.integer :total_sent
    end
  end
end
