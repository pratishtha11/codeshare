class CreateSnippets < ActiveRecord::Migration[7.0]
  def change
    create_table :snippets do |t|
      t.text :code_content, null: false
      t.string :language, null: false, default: 'plaintext'
      t.string :short_code, null: false
      t.string :title
      t.integer :views_count, default: 0
      t.datetime :expires_at
      t.timestamps
    end
    
    add_index :snippets, :short_code, unique: true
    add_index :snippets, :language
  end
end
