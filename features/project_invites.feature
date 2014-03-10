@javascript
Feature: Inviting users to collaborate
  In order to get help with projects
  As a normal user
  I want to create and invite others to collaborate

  Scenario:
    When I register a new account as "manager@example.com"
    And create a private project called "Testing Projects"

  @javascript
  Scenario:
    Given a registered user as "owner@example.com"
    Given a registered user as "invitee@example.com"

    When I sign in as "owner@example.com"
    And create a private project called "Testing Invites"
    Then I edit the project "Testing Invites"
    And I should add 1 role called "Developer"
    And I view the role "Developer" on project "Testing Invites"
    And I invite the user "invitee@example.com"
    Then I should see a translated message "role_invited_notice"
    Then "invitee@example.com" should receive 1 email
    And I sign out
    And I sign in as "inviter@example.com"
    Then I should have a pending invitation to "Testing Invites" as a "Developer"

