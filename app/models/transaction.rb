class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number, :result
  belongs_to :invoice
  has_many :invoice_items, through: :invoice
end
