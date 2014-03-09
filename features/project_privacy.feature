Feature: Project privacy settings
  In order to protect my projects privacy
  As a normal user
  I want to create private projects

  Scenario:
    When I register a new account as "manager@example.com"
    And create a private project called "Testing Projects"
    And sign out
    And I register a new account as "inviter@example.com"
    Then I should not find the project "Testing Projects"


