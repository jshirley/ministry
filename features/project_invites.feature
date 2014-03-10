@javascript
Feature: Inviting an unknown user
  In order to get help with projects
  As a normal user
  I want to create and invite others to collaborate

  Scenario:
    When I register a new account as "manager@example.com"
    And create a private project called "Testing Projects"

  Scenario:
    Given a registered user as "owner@example.com"
    Given a registered user as "invitee@example.com"

    When I sign in as "owner@example.com"
    And create a private project called "Testing Invites"
    Then I should edit the project "Testing Projects"
    And I should add 1 role called "Developer"
    And I view the role "Developer" on project "Testing Projects"
    And I invite the user "invitee@example.com"
    Then "invitee@example.com" should receive an email
    And "invitee@example.com" should have a pending invitation to "Testing Projects" as a "Developer"

