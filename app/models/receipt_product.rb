class ReceiptProduct < ApplicationRecord
  belongs_to :receipt
  belongs_to :product
end
