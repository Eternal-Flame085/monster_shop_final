require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'Deleting discounts' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount = @merchant_1.discounts.create(name: '5 percent', quantity: 10, discount: 5.0)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :merchant_admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I see a delete link below the discount" do
      visit '/merchant/discounts'
      within id="#discount-#{@discount.id}" do
        expect(page).to have_button('Delete')
      end
    end

    it "I can delete the discount" do
      visit '/merchant/discounts'

      within id="#discount-#{@discount.id}" do
        click_button 'Delete'
      end

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to_not have_css("#discount-#{@discount.id}")
      expect(page).to have_content('Discount is sucessfully deleted')
    end
  end
end
