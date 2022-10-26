class CreateCreatorDocs < ActiveRecord::Migration[6.0]
  def change
    create_table :creator_docs, id: :uuid do |t|
      t.references :creator, type: :uuid, null: false, foreign_key: true
      t.string :type
      t.string :statut

      t.timestamps
    end
  end
end
