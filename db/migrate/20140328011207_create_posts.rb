class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.timestamps
    end
    Post.create(title: "title1", body: "contents...")
    Post.create(title: "title2", body: "contents...222")
  end
 
  def down
    drop_table :posts
  end
end
