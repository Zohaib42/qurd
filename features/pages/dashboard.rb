module Pages
  class Dashboard
    include Capybara::DSL

    def visit_page
      visit '/'
      self
    end

    def has_heading?(heading)
      find('.jumbotron').has_css? 'h1', text: heading
    end

    def has_notification?(error)
      has_css? 'div.toast-message', text: error
    end

    def has_link?(link)
      find('.jumbotron').has_link? link
    end

    def log_out
      find('.jumbotron').click_on 'Logout'
    end
  end
end
