Feature: Sign In User
  In order to login and logout of the system
  A user
  Should be able to sign in and sign out

  Scenario: User should be able to login
    Given I exist as a student
    And I am on the login page
    When I sign in with valid credentials
    Then I should see the dashboard page

  Scenario: User enters the wrong email
    Given I exist as a student
    And I am on the login page
    When I sign in with wrong email
    Then I should see an invalid login message

  Scenario: User enters the wrong password
    Given I exist as a student
    And I am on the login page
    When I sign in with wrong password
    Then I should see an invalid login message

  Scenario: User logs out of the system via navbar logout button
    Given I am signed in as a student
    When I click on Log out on the navbar
    Then I should be on the login page

  Scenario: User logs out of the system via dashboard logout button
    Given I am signed in as a student
    When I click on Log out on dashboard page
    Then I should be on the login page

  Scenario: User can navigate to user list from nav bar
    Given I am signed in as a student
    Then I should see the dashboard page
    And I can not see Users link on navbar

  Scenario: User can navigate to user list from nav bar
    Given I am signed in as an admin
    When I click on Users link on navbar
    Then I am on the user list page

  Scenario: User should see users in the user list
    Given I am signed in as an admin
    And there are 5 preloaded users in the system
    When I click on Users link on navbar
    Then I am on the user list page
    And I can see 6 users

  Scenario: User see inline error when a mandatory field is not filled
    Given I am signed in as a student
    And I am on the edit user page
    When I update the user with partial details
    Then I can see inline error
    When I update the user details
    Then I can verify the new user details

  Scenario: Instructor can update the first name
    Given I am signed in as an instructor
    And I am on the edit user page
    When I update the user with partial details
    Then I can see inline error
    When I update the user details
    Then I can verify the new user details

  Scenario: Admin can update the first name
    Given I am signed in as an admin
    And I am on the edit user page
    When I update the user with partial details
    Then I can see inline error
    When I update the user details
    Then I can verify the new user details

  Scenario: User can update the avatar
    Given I am signed in as a student
    And I am on the edit user page
    When I update the user details with avatar
    Then I can verify the new user details