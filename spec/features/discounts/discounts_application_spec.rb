require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'Edit Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @discount = @brian.discounts.create(name: '5 percent', quantity: 5, discount: 5.0)
      @discount_2 = @brian.discounts.create(name: '10 percent', quantity: 10, discount: 10.0)
      @discount_3 = @megan.discounts.create(name: 'conflict 10 percent', quantity: 2, discount: 10.0)
      @discount_4 = @megan.discounts.create(name: 'conflict 15 percent', quantity: 2, discount: 15.0)
      @m_user = @megan.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :merchant_admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@giant)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit '/cart'
      3.times do
        within id="#item-#{@hippo.id}" do
          click_button 'More of This!'
        end
      end
    end

    it "In the cart if an item meets the quanity required a discount is applied only to that item" do
      within id="#item-#{@ogre.id}" do
        expect(page).to have_content("Subtotal: $20.00")
      end

      within id="#item-#{@giant.id}" do
        expect(page).to have_content("Subtotal: $50.00")
      end

      within id="#item-#{@hippo.id}" do
        expect(page).to_not have_content("5% Bulk Discount Applied")
        expect(page).to have_content("Subtotal: $200.00")
        click_button 'More of This!'
      end

      within id="#item-#{@hippo.id}" do
        expect(page).to have_content("5% Bulk Discount Applied")
        expect(page).to have_content("Subtotal: $237.50")
      end
    end

    it "When there is a conflict the discount with the highest discount gets applied" do
      within id="#item-#{@ogre.id}" do
        click_button 'More of This!'
      end

      within id="#item-#{@ogre.id}" do
        expect(page).to have_content("15% Bulk Discount Applied")
        expect(page).to have_content("Subtotal: $34.00")
      end
    end

    it "When I checkout the discounted prices appear in the order show page" do
      within id="#item-#{@hippo.id}" do
        click_button 'More of This!'
      end

      within id="#item-#{@ogre.id}" do
        click_button 'More of This!'
      end

      within id="#checkout" do
        click_button 'Check Out'
      end

      order = Order.last

      click_link "#{order.id}"

      order_items = OrderItem.all

      within id="#order-item-#{order_items.first.id}" do
        expect(page).to have_content("Price: #{number_to_currency(order_items.first.item.price)}")
        expect(page).to have_content("Price after discount: #{number_to_currency(order_items.first.price)}")
        expect(page).to have_content("Subtotal: #{number_to_currency(order_items.first.subtotal)}")
      end

      within id="#order-item-#{order_items[1].id}" do
        expect(page).to have_content("Price: #{number_to_currency(order_items[1].item.price)}")
        expect(page).to_not have_content("Price after discount:")
      end

      within id="#order-item-#{order_items.last.id}" do
        expect(page).to have_content("Price: #{number_to_currency(order_items.last.item.price)}")
        expect(page).to have_content("Price after discount: #{number_to_currency(order_items.last.price)}")
        expect(page).to have_content("Subtotal: #{number_to_currency(order_items.last.subtotal)}")
      end
    end
  end
end
