class RemoveTypeFromCreatorDocs < ActiveRecord::Migration[6.0]
  def change
    safety_assured { 
      remove_column :creator_docs, :type
      add_column :creator_docs, :document_type, :string    
    }
  end
end
