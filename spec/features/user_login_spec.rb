require 'rails_helper'

RSpec.feature "Visitor navigates to login page", type: :feature, js: true do

  before :each do
    @user = User.create!(
      first_name: 'Adam',
      last_name: 'Eve',
      email: 'adam@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  scenario 'Visitor is able to login with email and password' do
    visit login_path

    within 'form' do
      fill_in :email, with: 'adam@gmail.com'
      fill_in :password, with: 'password'

      click_button 'Submit'
    end

    expect(page).to have_text 'Username'
    save_screenshot
    
  end

end