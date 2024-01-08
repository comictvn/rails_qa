class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :questions, comment: 'Stores personality or compatibility questions for users to answer' do |t|
      t.text :content

      t.timestamps null: false
    end

    change_table_comment :user_answers, from: 'Stores answers to personality questions by users',
                                        to: 'Stores answers to personality or compatibility questions'
    change_table_comment :matches, from: 'Stores matches between users', to: 'Stores match information between users'
    change_table_comment :swipes, from: 'Stores swipe actions by users',
                                  to: 'Stores swipe actions by users on potential matches'
    change_table_comment :messages, from: 'Stores messages between matched users',
                                    to: 'Stores messages exchanged between matched users'

    add_column :messages, :read, :boolean

    add_reference :questions, :user_answer, foreign_key: true
  end
end
