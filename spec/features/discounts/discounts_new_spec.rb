require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :merchant_admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can create a new discount for the merhcant" do
      visit '/merchant/discounts/new'

      name = '5 percent discount'
      quantity = 10
      discount = 5.0

      fill_in 'discount[name]', with: name
      fill_in 'discount[quantity]', with: quantity
      fill_in 'discount[discount]', with: discount

      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts')

      discount = Discount.last
      within id="#discount-#{discount.id}" do
        expect(page).to have_content(discount.name)
        expect(page).to have_content(discount.quantity)
        expect(page).to have_content(discount.discount)
      end
    end

    it "I can create a new discount for the merhcant" do
      visit '/merchant/discounts/new'

      quantity = 10
      discount = 5.0

      fill_in 'discount[quantity]', with: quantity
      fill_in 'discount[discount]', with: discount

      click_button 'Create Discount'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
