require 'rails_helper'

RSpec.describe 'User registrations', type: :feature, js: true do

  let(:user_attributes) { attributes_for(:user) }

  context 'with valid registration data' do

    it 'registers successfully' do
      visit root_path
      find('.navbar-item', text: I18n.t('devise.shared.links.sign_up')).click

      fill_in 'user_email', with: user_attributes[:email]
      fill_in 'user_password', with: user_attributes[:password]
      fill_in 'user_full_name', with: user_attributes[:full_name]
      click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
      expect(current_path).to eq(root_path)
    end

  end

  context 'with invalid registration data' do

    it 'does not register' do
      visit root_path
      find('.navbar-item', text: I18n.t('devise.shared.links.sign_up')).click

      fill_in 'user_email', with: user_attributes[:email]
      fill_in 'user_full_name', with: user_attributes[:full_name]
      click_button I18n.t('devise.registrations.new.sign_up')

      expect(page).to have_css('#new_user .field .help.is-danger')
      expect(current_path).to eq(user_registration_path)
    end

  end

end