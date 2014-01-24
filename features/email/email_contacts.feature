@testplan_8644
Feature: Addressbook contacts in emails

  Background:
    * Open Evolution via command and setup fake account
    * Open "Mail" section
    * Delete all emails in "Drafts" folder

    @testcase_244072
    Scenario: Create an email to existing contact
      * Open "Contacts" section
      * Create contact "Adam Doe" with email set to "adam.doe@company.com"
      * Open "Mail" section
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value        |
        | Subject: | Hello there  |
      * Select first suggestion as "To:" typing "Adam"
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Hello there" message
      Then message composer has the following fields set:
        | Field    | Value                           |
        | To:      | Adam Doe <adam.doe@company.com> |
        | Subject: | Hello there                     |

    @testcase_244073
    Scenario: Create an email to existing contact list
      * Open "Contacts" section
      * Create a new contact list
      * Set contact list name to "Coworkers"
      * Add "john@company1.com" to the contact list
      * Add "jack@company1.com" to the contact list
      * Add "jill@company1.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Open "Mail" section
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value           |
        | Subject: | Important topic |
      * Select first suggestion as "To:" typing "Coworkers"
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Important topic" message
      Then message composer has the following fields set:
        | Field    | Value                                                   |
        | To:      |                                                         |
        | Bcc:     | john@company1.com, jack@company1.com, jill@company1.com |
        | Subject: | Important topic                                         |

    @testcase_244074
    Scenario: Edit an email with contacts
      * Open "Contacts" section
      * Create contact "Bill Doe" with email set to "bill.doe@company.com"
      * Create contact "Chris Doe" with email set to "chris.doe@company.com"
      * Open "Mail" section
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value           |
        | Subject: | Message to Bill |
      * Select first suggestion as "To:" typing "Chris"
      * Select first suggestion as "Cc:" typing "Bill"
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Message to Bill" message
      * Select first suggestion as "To:" typing "Bill"
      * Select first suggestion as "Cc:" typing "Chris"
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Message to Bill" message
      Then message composer has the following fields set:
        | Field    | Value                             |
        | To:      | Bill Doe <bill.doe@company.com>   |
        | Cc:      | Chris Doe <chris.doe@company.com> |
        | Subject: | Message to Bill                   |
