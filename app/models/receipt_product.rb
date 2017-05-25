class ReceiptProduct < ApplicationRecord
  belongs_to :receipt
  belongs_to :product
  belongs_to :causes_deviation
end
