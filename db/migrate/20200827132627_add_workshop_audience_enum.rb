class AddWorkshopAudienceEnum < ActiveRecord::Migration[6.0]
  def up
    safety_assured {
      execute <<-SQL
        CREATE TYPE workshop_audience AS ENUM ('adult', 'child', 'adult_and_child');
      SQL
    }
  end

  def down
    safety_assured {
      execute <<-SQL
        DROP TYPE workshop_audience;
      SQL
    }
  end
end
