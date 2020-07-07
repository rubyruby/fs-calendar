require 'rails_helper'

RSpec.describe 'User sessions', type: :feature, js: true do

  let(:user) { create(:user) }

  describe 'Sign in' do

    context 'with valid credentials' do

      let(:password) { user.password }

      it 'signs in successfully' do
        visit root_path
        click_link I18n.t('devise.shared.links.sign_in')

        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: password
        click_button I18n.t('devise.sessions.new.sign_in')

        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
        expect(current_path).to eq(root_path)
      end

    end

    context 'with invalid credentials' do

      let(:password) { "wrong-#{user.password}" }

      it 'does not sign in' do
        visit root_path
        click_link I18n.t('devise.shared.links.sign_in')

        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: password
        click_button I18n.t('devise.sessions.new.sign_in')

        expect(page).
          to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
        expect(current_path).to eq(new_user_session_path)
      end

    end

  end

  describe 'Sign out' do
    before(:each) { login_as(user) }

    it 'signs out' do
      visit root_path
      find('.navbar-menu .navbar-link', text: user.email).click
      click_link I18n.t('devise.shared.links.sign_out')

      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
      expect(current_path).to eq(new_user_session_path)
    end
  end

end
