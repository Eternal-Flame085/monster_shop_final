require 'rails_helper'

describe Discount do
  describe 'relationships' do
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :discount}
    it {should validate_presence_of :name}
  end
end
