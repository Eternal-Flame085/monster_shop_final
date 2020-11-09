class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :quantity, :discount, :name
end
