require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    
      it "is valid with valid attributes of first/last name, password/password_confirmation and email" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'test')

        expect(@user).to be_valid
      end

      it "is invalid with first name as nil" do
        @user = User.create(first_name: nil, last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'test')

        expect(@user.errors.full_messages.length == 1)
        expect(@user.errors.full_messages[0] == "First_name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with last name as nil" do
        @user = User.create(first_name: 'Adam', last_name: nil, password: 'password', password_confirmation: 'password', email: 'test')

        expect(@user.errors.full_messages.length == 1)
        expect(@user.errors.full_messages[0] == "Last_name can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: nil, password_confirmation: 'password', email: 'test')

        expect(@user.errors.full_messages.length == 1)
        expect(@user.errors.full_messages[0] == "password can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no password confirmation" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: nil, email: 'test')

        expect(@user.errors.full_messages.length == 1)
        expect(@user.errors.full_messages[0] == "Password_confirmation can't be blank")
        expect(@user).to_not be_valid
      end

      it "is invalid with no email" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: nil)

        expect(@user.errors.full_messages.length == 1)
        expect(@user.errors.full_messages[0] == "email can't be blank")
        expect(@user).to_not be_valid
      end

     context "verifying email inputs" do
      it "is invalid if email is already taken, same case" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'test')
        @user2 = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'test')

        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end

      it "is invalid if email is already taken, different case" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'test')
        @user2 = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'TEST')
      
        expect(@user2.errors.full_messages.length).to eql(1)
        expect(@user2.errors.full_messages[0]).to eql("Email has already been taken")
        expect(@user2).to_not be_valid

        expect(@user.errors.full_messages.length).to eql(0)
        expect(@user).to be_valid
      end
    end

    context "verifying password inputs" do
      it "is invalid if password and password confirmation do not match" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'different', email: 'test2')

        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password confirmation doesn't match Password")
        expect(@user).to_not be_valid
      end

      it "is invalid if password has less than 5 characters" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'no', password_confirmation: 'no', email: 'test3')
        expect(@user.errors.full_messages.length).to eql(1)
        expect(@user.errors.full_messages[0]).to eql("Password is too short (minimum is 5 characters)")
        expect(@user).to_not be_valid
      end
    end

    context 'authenticating with credentials' do
      it "is valid if email is in db and password matches email" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials('testing', 'password')
  
        expect(@authenticate).to eql(@user)
      end
  
      it "is valid if email is correct, in different case, with whitespace and password matches" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials(' TeStInG   ', 'password')
  
        expect(@authenticate).to eql(@user)
  
      end
  
      it "is invalid if user does not input an email" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials(nil, 'password')
  
        expect(@authenticate).to eql(nil)
      end
  
      it "is invalid if user does not input a password" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials('test', nil)
  
        expect(@authenticate).to eql(nil)
      end
  
      it "is invalid if user inputs nothing" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials(nil, nil)
  
        expect(@authenticate).to eql(nil)
      end
  
      it "is invalid if user inputs right email, but the wrong password, is case sensitive" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials('testing', 'Password')
  
        expect(@authenticate).to eql(nil)
      end
  
      it "is valid if user logs in with spaces in email (case-insensitive)" do
        @user = User.create(first_name: 'Adam', last_name: 'Eve', password: 'password', password_confirmation: 'password', email: 'testing')
        @authenticate = User.authenticate_with_credentials(' testing', 'password')
  
        expect(@authenticate).to eql(@user)
      end
  
    end

  end
end
