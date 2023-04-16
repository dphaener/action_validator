# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.date :birthdate
      t.text :bio
      t.integer :age
      t.boolean :receive_emails
      t.string :homepage
      t.string :password

      t.timestamps
    end
  end
end
