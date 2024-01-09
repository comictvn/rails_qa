class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :user_answers, comment: 'Stores answers to personality questions by users' do |t|
      t.text :answer

      t.timestamps null: false
    end

    create_table :personality_questions, comment: 'Stores personality or compatibility questions' do |t|
      t.text :question

      t.timestamps null: false
    end

    create_table :matches, comment: 'Stores matches between users' do |t|
      t.timestamps null: false
    end

    create_table :feedbacks, comment: 'Stores feedback from users about their matches' do |t|
      t.text :comment

      t.timestamps null: false
    end

    create_table :swipes, comment: 'Stores swipe actions by users' do |t|
      t.integer :direction, default: 0

      t.timestamps null: false
    end

    create_table :users, comment: 'Stores user profile information' do |t|
      t.text :preferences

      t.string :location

      t.text :interests

      t.integer :gender, default: 0

      t.integer :age

      t.timestamps null: false
    end

    create_table :messages, comment: 'Stores messages between matched users' do |t|
      t.text :content

      t.timestamps null: false
    end

    add_reference :user_answers, :personality_question, foreign_key: true

    add_reference :messages, :match, foreign_key: true

    add_reference :user_answers, :user, foreign_key: true

    add_reference :matches, :user, foreign_key: true

    add_reference :swipes, :user, foreign_key: true
  end
end
