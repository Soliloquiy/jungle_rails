require 'rails_helper'

RSpec.feature "Visitor clicks add to cart button", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'

    @category.products.create!(
      name: Faker::Hipster.sentence(3),
      description: Faker::Hipster.paragraph(4),
      image: open_asset('apparel1.jpg'),
      quantity: 10,
      price: 64.99
    )
  end

  scenario "Product will be added to cart" do
    
    visit root_path

    expect(page).to have_text 'My Cart (0)'
    save_screenshot 

    first('.product').find_button('Add').click

    expect(page).to have_text 'My Cart (1)'
    save_screenshot    
  end
end 