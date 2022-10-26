class AddPercentageAndCampaignToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_column :vouchers, :percentage, :boolean, null: false, default: false
    add_column :vouchers, :campaign, :boolean, null: false, default: false
  end
end
