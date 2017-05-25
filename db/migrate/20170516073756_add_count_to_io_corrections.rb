class AddCountToIoCorrections < ActiveRecord::Migration[5.0]
  def change
    add_column :io_corrections, :count, :decimal, precision: 8, scale: 3, default: 0
  end
end
