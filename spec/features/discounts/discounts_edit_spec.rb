require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'Edit Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount = @merchant_1.discounts.create(name: '5 percent', quantity: 10, discount: 5.0)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :merchant_admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I see an edit button below every discount that leads to an edit form" do
      visit '/merchant/discounts'

      within id="#discount-#{@discount.id}" do
        click_link 'Edit'
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")
    end

    it "I can edit the discount" do
      visit "/merchant/discounts/#{@discount.id}/edit"

      quantity = 25

      fill_in 'discount[quantity]', with: quantity

      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")

      within id="#discount-#{@discount.id}" do
        expect(page).to have_content("Quantity required: #{quantity}")
      end
    end

    it "I cant leave form unfilled" do
      visit "/merchant/discounts/#{@discount.id}/edit"


      fill_in 'discount[name]', with: ''
      fill_in 'discount[quantity]', with: ''

      click_button 'Update Discount'

      expect(page).to have_content("Quantity can't be blank and Name can't be blank")
    end
  end
end
