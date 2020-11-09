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

    it 'I can have multiple bulk discounts in the system' do
      visit '/merchant/discounts/new'

      name_1 = '5 percent discount'
      quantity_1 = 10
      discount_1 = 5.0

      fill_in 'discount[name]', with: name_1
      fill_in 'discount[quantity]', with: quantity_1
      fill_in 'discount[discount]', with: discount_1

      click_button 'Create Discount'

      visit '/merchant/discounts/new'

      name_2 = '7 percent discount'
      quantity_2 = 25
      discount_2 = 7.0

      fill_in 'discount[name]', with: name_2
      fill_in 'discount[quantity]', with: quantity_2
      fill_in 'discount[discount]', with: discount_2

      click_button 'Create Discount'

      discounts = Discount.all
      within id="#discount-#{discounts.last.id}" do
        expect(page).to have_content(name_2)
        expect(page).to have_content(quantity_2)
        expect(page).to have_content(discount_2)
      end

      within id="#discount-#{discounts.first.id}" do
        expect(page).to have_content(name_1)
        expect(page).to have_content(quantity_1)
        expect(page).to have_content(discount_1)
      end
    end
  end
end
