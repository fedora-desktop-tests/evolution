@testplan_8334
Feature: Addressbook: File: Merging contacts

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Ford"

    @testcase_240459
    Scenario: Merge two empty contacts
        * Create a new contact
        * Set "Full Name..." in contact editor to "Adam Ford"
        * Save the contact
        * Refresh addressbook
        * Create a new contact
        * Set "Full Name..." in contact editor to "Adam Ford"
        * Save and merge the contacts
        * Select "Ford, Adam" contact
        * Open contact editor for selected contact
        Then "Full Name..." property is set to "Adam Ford"

    @testcase_240460
    Scenario: Merge an empty contact and contact with email
        * Create a new contact
        * Set "Full Name..." in contact editor to "Bill Ford"
        * Save the contact
        * Refresh addressbook
        * Create a new contact
        * Set "Full Name..." in contact editor to "Bill Ford"
        * Set emails in contact editor to
          | Field | Value                        |
          | Work  | bill.ford@company.com        |
          | Home  | billy_ford_72@gmail.com      |
          | Other | billford72@yahoo.com         |
          | Other | xxbill_fordxx@free_email.com |
        * Save and merge the contacts
        * Select "Ford, Bill" contact
        * Open contact editor for selected contact
        Then Emails are set to
          | Field | Value                        |
          | Work  | bill.ford@company.com        |
          | Home  | billy_ford_72@gmail.com      |
          | Other | billford72@yahoo.com         |
          | Other | xxbill_fordxx@free_email.com |

    # @testcase_240461 @wip @rewrite_me
    # Scenario: Merge a contact with email with an empty contact
    #     * Create a new contact
    #     * Set "Full Name..." in contact editor to "Chris Ford"
    #     * Set emails in contact editor to
    #       | Field | Value                  |
    #       | Home  | chris.ford.99@home.com |
    #     * Save the contact
    #     * Refresh addressbook
    #     * Create a new contact
    #     * Set "Full Name..." in contact editor to "Chris Ford"
    #     * Save and add the duplicated contact
    #     Then two "Chris Ford" contacts are displayed
    #     * Select "Ford, Chris" contact
    #     * Open contact editor for selected contact
    #     Then Emails are set to
    #       | Field | Value                  |
    #       | Home  | chris.ford.99@home.com |

    # @testcase_240462 @wip @rewrite_me
    # Scenario: Merge two contacts both have different emails set
    #     * Create a new contact
    #     * Set "Full Name..." in contact editor to "David Ford"
    #     * Set emails in contact editor to
    #       | Field | Value               |
    #       | Home  | david.ford@home.com |
    #     * Save the contact
    #     * Refresh addressbook
    #     * Create a new contact
    #     * Set "Full Name..." in contact editor to "David Ford"
    #     * Set emails in contact editor to
    #       | Field | Value             |
    #       | Work  | dford@company.com |
    #     * Save and merge the contacts
    #     * Select "Ford, David" contact
    #     * Open contact editor for selected contact
    #     Then Emails are set to
    #       | Field | Value               |
    #       | Work  | dford@company.com   |
    #       | Home  | david.ford@home.com |
