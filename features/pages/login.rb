module Pages
  class Login
    include Capybara::DSL

    def visit_page
      visit 'users/sign_in'
      self
    end

    def has_heading?(heading)
      has_css?('h1', text: heading)
    end

    def has_notification?(alert)
      has_css? 'div.toast-message', text: alert
    end

    def login_with(email, password)
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_on 'Log in'
    end
  end
end
