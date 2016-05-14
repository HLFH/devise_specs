Feature: Generate specs with factories

  Background:
    Given I set up devise-specs

  Scenario: running a devise generator with Factory Girl installed
    Given I install factory_girl_rails
    When I run `rails generate devise User`
    Then the output should contain:
      """
            invoke  specs
              gsub    spec/rails_helper.rb
            insert    spec/factories/users.rb
            create    spec/support/factory_girl.rb
            create    spec/support/helpers.rb
            create    spec/features/user_signs_up_spec.rb
            create    spec/features/user_signs_in_spec.rb
            create    spec/features/user_signs_out_spec.rb
            create    spec/features/user_resets_password_spec.rb
      """
    And the file "spec/features/user_signs_up_spec.rb" should contain:
      """
      require 'rails_helper'

      feature 'User signs up' do
        scenario 'with valid data' do
          visit new_user_registration_path

          fill_in 'Email', with: 'username@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Sign up'

          expect(page).to have_text 'Welcome! You have signed up successfully.'
        end

        scenario 'with invalid data' do
          visit new_user_registration_path

          click_button 'Sign up'

          expect(page).to have_text "Email can't be blank"
          expect(page).to have_text "Password can't be blank"
        end
      end
      """
    And the file "spec/features/user_signs_in_spec.rb" should contain:
      """
      require 'rails_helper'

      feature 'User signs in' do
        scenario 'with valid credentials' do
          user = create :user

          sign_in user

          expect(page).to have_text 'Signed in successfully.'
        end

        scenario 'with invalid credentials' do
          user = build :user

          sign_in user

          expect(page).to have_text 'Invalid Email or password.'
        end
      end
      """
    And the file "spec/features/user_signs_out_spec.rb" should contain:
      """
      require 'rails_helper'

      feature 'User signs out' do
        scenario 'user signed in' do
          user = create :user

          sign_in user

          click_link 'Sign Out'

          expect(page).to have_text 'Signed out successfully.'
        end
      end
      """
    And the file "spec/features/user_resets_password_spec.rb" should contain:
      """
      require 'rails_helper'

      feature 'User resets a password' do
        scenario 'user enters a valid email' do
          user = create :user

          visit new_user_password_path

          fill_in 'Email', with: user.email
          click_button 'Send me reset password instructions'

          expect(page).to have_text 'You will receive an email with instructions'
        end

        scenario 'user enters an invalid email' do
          visit new_user_password_path

          fill_in 'Email', with: 'username@example.com'
          click_button 'Send me reset password instructions'

          expect(page).to have_text 'Email not found'
        end

        scenario 'user changes password' do
          token = create(:user).send_reset_password_instructions

          visit edit_user_password_path(reset_password_token: token)

          fill_in 'New password', with: 'p4ssw0rd'
          fill_in 'Confirm new password', with: 'p4ssw0rd'
          click_button 'Change my password'

          expect(page).to have_text 'Your password has been changed successfully.'
        end

        scenario 'password reset token is invalid' do
          visit edit_user_password_path(reset_password_token: 'token')

          fill_in 'New password', with: 'p4ssw0rd'
          fill_in 'Confirm new password', with: 'p4ssw0rd'
          click_button 'Change my password'

          expect(page).to have_text 'Reset password token is invalid'
        end
      end
      """