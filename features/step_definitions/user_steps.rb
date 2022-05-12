def visitor
  @visitor ||= { email: 'some@mailinator.com',
                 first_name: 'something',
                 last_name: 'web-base',
                 password: 'please2',
                 password_confirmation: 'please2' }
end

def create_user(user_type)
  visitor
  @user = if user_type == 'admin'
            Admin.create(@visitor)
          elsif user_type == 'instructor'
            Instructor.create(@visitor)
          elsif user_type == 'student'
            Student.create(@visitor)
          end
end

Given('I am on the login page') do
  @login_page = Pages::Login.new
  @login_page.visit_page
  expect(@login_page).to have_heading('Log in')
end

Given(/^I exist as a(n)? (admin|student|instructor)$/) do |_agr1, user_type|
  create_user(user_type)
end

Given(/^I am signed in as a(n)? (admin|student|instructor)$/) do |_agr1, user_type|
  create_user(user_type)
  @login_page = Pages::Login.new
  @login_page.visit_page
  expect(@login_page).to have_heading('Log in')
  @login_page.login_with(@visitor[:email], @visitor[:password])
end

Given(/^there are (\d+) preloaded users in the system$/) do |number_of_users|
  [*1..number_of_users].each do |number|
    User.create(email: "test#{number}@mailinator.com",
                first_name: 'Babyface',
                last_name: 'Killer',
                password: 'password')
  end
end

When('I sign in with valid credentials') do
  @login_page.login_with(@visitor[:email], @visitor[:password])
end

And(/^I attach a file$/) do
  attach_file('user_image', "#{::Rails.root}/spec/fixtures/image.jpg")
end

When('I sign in with wrong email') do
  @login_page.login_with('wrong@example.com', @visitor[:password])
end

When('I sign in with wrong password') do
  @login_page.login_with(@visitor[:email], 'wrong_password')
end

When('I click on Log out on the navbar') do
  @navbar = Pages::Navbar.new
  @navbar.log_out
end

When('I click on Log out on dashboard page') do
  @dashboard = Pages::Dashboard.new
  @dashboard.log_out
end

When('I click on the avatar icon') do
  @navbar.dropdown
end

When('I update the user with partial details') do
  @edit_page = Pages::Edit.new
  @edit_page.fill_details(first_name: '', last_name: 'rails')
end

Then('I can see inline error') do
  expect(@edit_page).to have_error('can\'t be blank')
end

When('I update the user details') do
  @edit_page = Pages::Edit.new
  @edit_page.fill_details(first_name: 'sushant', last_name: 'rails')
  wait_for_ajax
end

When('I update the user details with avatar') do
  @edit_page = Pages::Edit.new
  @edit_page.fill_details(first_name: 'sushant', last_name: 'rails')
  @edit_page.attach_file('user_avatar', "#{::Rails.root}/spec/dummy_image.jpg")
  wait_for_ajax
end

Then('I can verify the new user details') do
  sleep 2
  @user.reload
  expect(@user.first_name).to eq('sushant')
  expect(@user.last_name).to eq('rails')
end

Then('I should be on the login page') do
  expect(@login_page).to have_heading('Log in')
end

Then('I should see the dashboard page') do
  @dashboard = Pages::Dashboard.new
  @navbar = Pages::Navbar.new
  expect(@dashboard).to have_heading("Hello, #{@user.email}!")
  expect(@dashboard).to have_link('Logout')
  expect(@dashboard).to have_notification('Signed in successfully.')
  expect(@navbar).to have_link('Logout')
end

Then('I should see an invalid login message') do
  expect(@login_page).to have_notification('Invalid Email or password')
end

And(/^I am on the edit user page$/) do
  @navbar = Pages::Navbar.new
  @navbar.profile
  expect(@user.first_name).to eq('something')
  expect(@user.last_name).to eq('web-base')
end

Then('I can not see Users link on navbar') do
  expect(@navbar).to_not have_link('Users')
end

Then('I click on Users link on navbar') do
  @navbar = Pages::Navbar.new
  @navbar.users_list
end

Then('I am on the user list page') do
  @user_page = Pages::User.new
  expect(@user_page).to have_heading('Users')
end

Then(/^I can see (\d+) user(s)?$/) do |num_of_users, _arg2|
  expect(@user_page.user_rows.length).to eq(num_of_users)
  expect(@user_page.user_rows.first).to have_content(User.first.email)
end
