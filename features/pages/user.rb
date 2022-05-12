module Pages
  class User
    include Capybara::DSL

    def has_heading?(heading)
      has_css? 'h1', text: heading
    end

    def user_rows
      all('table tbody tr')
    end
  end
end
