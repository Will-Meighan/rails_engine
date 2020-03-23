class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def self.search_for(search_params)
    where(search_params.keys.map { |param| "#{param} ILIKE '%#{search_params[param]}%'" }
      .join(' AND '))
  end

  def self.find_first_merchant(search_params)
    search_for(search_params).limit(1)
  end

  def self.find_all_merchants(search_params)
    search_for(search_params)
  end
end
