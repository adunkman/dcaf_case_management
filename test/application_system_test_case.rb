require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # include IntegrationSystemTestHelpers
  include OmniauthMocker

  before { Capybara.reset_sessions! }
  OmniAuth.config.test_mode = true

  # Poltergeist

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  # Capybara.register_driver :poltergeist do |app|
  #   Capybara::Poltergeist::Driver.new(app, js_errors: false)
  # end
  # driven_by :poltergeist

  # def with_modified_env(options, &block)
    # ClimateControl.modify(options, &block)
  # end

  def log_in_as(user, line = 'DC')
    log_in user
    select_line line
  end

  def log_in(user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in with password'
  end

  def select_line(line = 'DC')
    choose line
    click_button 'Start'
  end

  def wait_for_element(text)
    has_content? text
  end

  def wait_for_no_element(text)
    has_no_content? text
  end

  def sign_out
    click_link @user.name
    click_link 'Sign Out'
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until _finished_all_ajax_requests?
    end
  end

  def _finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def go_to_dashboard
    click_link "DARIA - #{(ENV['FUND'] ? ENV['FUND'] : Rails.env)}"
  end
end
