@testplan_8412
Feature: Emails

  Background:
    * Open Evolution via command and setup fake account
    * Open "Mail" section
    * Delete all emails in "Drafts" folder

    @testcase_241629
    Scenario: Create email
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value        |
        | To:      | adam@doe.com |
        | Cc:      | bill@doe.com |
        | Subject: | Hello there  |
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Hello there" message
      Then message composer has the following fields set:
        | Field    | Value        |
        | To:      | adam@doe.com |
        | Cc:      | bill@doe.com |
        | Subject: | Hello there  |

    @testcase_241630
    Scenario: Edit email
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value               |
        | To:      | chris@doe.com       |
        | Cc:      | david@doe.com       |
        | Subject: | Important notice    |
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Open "Important notice" message
      * Set the following values in message composer:
        | Field    | Value               |
        | To:      | evan@doe.com        |
        | Cc:      | fred@doe.com        |
        | Subject: | Foo bar             |
      * Save message as a draft
      * Close message composer
      * Open "Foo bar" message
      Then message composer has the following fields set:
        | Field    | Value               |
        | To:      | evan@doe.com        |
        | Cc:      | fred@doe.com        |
        | Subject: | Foo bar             |

    @testcase_241631
    Scenario: Delete email
      * Create a new email
      * Set the following values in message composer:
        | Field    | Value            |
        | To:      | gene@doe.com     |
        | Cc:      | henry@doe.com    |
        | Subject: | Roses are red    |
      * Save message as a draft
      * Close message composer
      * Open "Drafts" folder
      * Delete "Roses are red" message
      * Search for "Roses are red" message
      Then no message found
