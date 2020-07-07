require 'rails_helper'

RSpec.describe 'User profile', type: :feature, js: true do

  let(:user) { create(:user) }
  before(:each) { login_as(user) }

  context 'with valid attributes' do
    it 'updates profile' do
      visit events_path
      find('.navbar-menu .navbar-link', text: user.email).click
      click_link I18n.t('devise.registrations.edit.title')

      new_user_attrs = attributes_for(:user)
      fill_in 'user_email', with: new_user_attrs[:email]
      fill_in 'user_full_name', with: new_user_attrs[:full_name]
      fill_in 'user_password', with: new_user_attrs[:password]
      fill_in 'user_password_confirmation', with: new_user_attrs[:password]
      fill_in 'user_current_password', with: user.password
      click_button I18n.t('devise.registrations.edit.update')

      expect(page).to have_content(I18n.t('devise.registrations.updated'))
      user.reload
      expect(user.email).to eq(new_user_attrs[:email])
      expect(user.full_name).to eq(new_user_attrs[:full_name])
    end
  end

  context 'with invalid attributes' do
    it 'does not update profile' do
      visit events_path
      find('.navbar-menu .navbar-link', text: user.email).click
      click_link I18n.t('devise.registrations.edit.title')

      previous_password = user.encrypted_password
      fill_in 'user_password', with: 'new_pASsword'
      fill_in 'user_password_confirmation', with: 'wrong-COnfirmation'
      fill_in 'user_current_password', with: user.password
      click_button I18n.t('devise.registrations.edit.update')

      expect(page).to have_css('#edit_user .field .help.is-danger')
      user.reload
      expect(user.encrypted_password).to eq(previous_password)
    end
  end

end