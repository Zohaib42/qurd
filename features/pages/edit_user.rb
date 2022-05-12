module Pages
  class Edit
    include Capybara::DSL

    def fill_details(details)
      fill_in 'user[first_name]', with: details[:first_name]
      fill_in 'user[last_name]', with: details[:last_name]
      sleep 1
      click_on 'Update profile'
    end

    def has_error?(error)
      has_css? '#user_form label', text: error
    end
  end
end
