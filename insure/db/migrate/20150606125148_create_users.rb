class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :aadhar_id
      t.string :name
      t.string :address
      t.string :pincode
      t.date :date_of_birth
      t.string :mobile
      t.string :email

      t.timestamps null: false
    end
  end
end
