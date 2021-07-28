require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it "is valid with valid attributes of name, price, quantity and category" do
      @category = Category.new
      @category.id = 4
      @category.name = 'Technology'
      @category.save!

      @product = Product.new
      @product.name = "phone"
      @product.price_cents = 2000
      @product.quantity = 5
      @product.category_id = @category.id
      @product.save!

      @category.products = [@product]
      

      expect(@category.products[0].name).to be_present
      expect(@category.products[0].price_cents).to be_present
      expect(@category.products[0].quantity).to be_present
      expect(@category.products[0].category_id).to be_present

      expect(@category.products[0].errors.full_messages.length).to eql(0)
    end
    

    it "is not valid without a name" do
      @category = Category.new
      @category.id = 4
      @category.name = 'Technology'
      @category.save!

      @product = Product.new
      @product.name = nil
      @product.price_cents = 2000
      @product.quantity = 5
      @product.category_id = @category.id
      @product.save
      
      expect(@product).not_to be_valid

      expect(@product.errors.full_messages.length).to eql(1)

    end

    it "is not valid without a price" do
      @category = Category.new
      @category.id = 4
      @category.name = 'Technology'
      @category.save!

      @product = Product.new
      @product.name = "Phone"
      @product.price_cents = nil
      @product.quantity = 5
      @product.category_id = @category.id
      @product.save
      
      
      expect(@product).not_to be_valid

      expect(@product.errors.full_messages.length).to eql(3)


    end

    it "is not valid without a quantity" do
      @category = Category.new
      @category.id = 4
      @category.name = 'Technology'
      @category.save!

      @product = Product.new
      @product.name = "Phone"
      @product.price_cents = 2000
      @product.quantity = nil
      @product.category_id = @category.id
      @product.save

      
      expect(@product).not_to be_valid

      expect(@product.errors.full_messages.length).to eql(1)

    end

    it "is not valid without a category_id" do
      @category = Category.new
      @category.id = 4
      @category.name = 'Technology'
      @category.save!

      @product = Product.new
      @product.name = "Phone"
      @product.price_cents = 2000
      @product.quantity = 5
      @product.category_id = nil
      @product.save
      
      expect(@product).not_to be_valid

      expect(@product.errors.full_messages.length).to eql(1)

    end

  end


end
