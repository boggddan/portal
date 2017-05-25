class RenameDiffToIoCorrections < ActiveRecord::Migration[5.0]
  def change
    rename_column :io_correction_products, :diff, :count_order
  end
end
