module Pages
  class Navbar
    include Capybara::DSL

    def has_link?(link)
      find('.navbar').has_link? link
    end

    def log_out
      dropdown
      find('.navbar').click_on 'Logout'
    end

    def dropdown
      find('#dropdownMenuButton').click
    end

    def profile
      dropdown
      click_on 'Profile'
    end

    def users_list
      find('.navbar').click_on 'Users'
    end
  end
end
