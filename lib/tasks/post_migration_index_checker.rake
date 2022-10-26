Rake::Task["db:migrate"].enhance do
  tables = ActiveRecord::Base.connection.tables
  all_foreign_keys = tables.flat_map { |table_name|
    ActiveRecord::Base.connection.columns(table_name).map { |c| [table_name, c.name].join(".") }
  }.select { |c| c.ends_with?("_id") }

  indexed_columns = tables.map { |table_name|
    ActiveRecord::Base.connection.indexes(table_name).map do |index|
      index.columns.map { |c| [table_name, c].join(".") }
    end
  }.flatten

  unindexed_foreign_keys = (all_foreign_keys - indexed_columns)

  if unindexed_foreign_keys.any?
    warn "WARNING: The following foreign key columns don't have an index, which can hurt performance: #{unindexed_foreign_keys.join(", ")}"
  end
end
