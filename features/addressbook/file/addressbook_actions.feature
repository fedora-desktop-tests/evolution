@testplan_11328
Feature: Addressbook: Create/Delete/Export Addressbook
  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Add new addressbook:
      | Field | Value            |
      | Type: | On This Computer |
      | Name: | Local Contacts   |
    * Delete all contacts containing "Doe"

    @testcase_317382
    Scenario: Add contact in new addressbook
      * Create a new contact
      * Set "Full Name..." in contact editor to "Adam Doe"
      * Set "Where:" in contact editor to "    Local Contacts"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Adam" contact
      * Open contact editor for selected contact
      Then "Full Name..." property is set to "Adam Doe"

    @testcase_317383
    Scenario: Modify contact in new addressbook
      * Create a new contact
      * Set "Full Name..." in contact editor to "Billy Doe"
      * Set "Where:" in contact editor to "    Local Contacts"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Billy" contact
      * Open contact editor for selected contact
      * Set "Nickname:" in contact editor to "Unknown"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Billy" contact
      * Open contact editor for selected contact
      Then "Nickname:" property is set to "Unknown"

    @testcase_317384
    Scenario: Delete contact
      * Create a new contact
      * Set "Full Name..." in contact editor to "Chris Doe"
      * Set "Where:" in contact editor to "    Local Contacts"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Chris" contact
      * Delete selected contact
      Then Contact list does not include "Chris Smith"

    @testcase_317385
    Scenario: Create a contact list with 3 addresses
      * Create a new contact list
      * Set contact list name to "Group 1"
      * Set contact list addressbook to "    Local Contacts"
      * Add "john@company1.com" to the contact list
      * Add "jack@company1.com" to the contact list
      * Add "jill@company1.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 1" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email             |
        | john@company1.com |
        | jack@company1.com |
        | jill@company1.com |

    @testcase_317386
    Scenario: Remove a contact list
      * Create a new contact list
      * Set contact list name to "Group 2"
      * Set contact list addressbook to "    Local Contacts"
      * Add "john@company4.com" to the contact list
      * Add "jack@company4.com" to the contact list
      * Add "jill@company4.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 2" contact list
      * Delete the selected contact list
      Then Contact list does not include "Group 2"

    @testcase_317387
    Scenario: Export addressbook
      * Create a new contact
      * Set "Full Name..." in contact editor to "David Doe"
      * Set "Where:" in contact editor to "    Local Contacts"
      * Save the contact
      * Create a new contact list
      * Set contact list name to "Group 3"
      * Set contact list addressbook to "    Local Contacts"
      * Add "john@company3.com" to the contact list
      * Add "jack@company3.com" to the contact list
      * Add "jill@company3.com" to the contact list
      * Save the contact list
      * Save "Local Contacts" addressbook as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;X-EVOLUTION-PARENT-UID=0;X-EVOLUTION-DEST-HTML-MAIL=FALSE:john@compan
       y3.com
      EMAIL;X-EVOLUTION-PARENT-UID=0;X-EVOLUTION-DEST-HTML-MAIL=FALSE:jack@compan
       y3.com
      EMAIL;X-EVOLUTION-PARENT-UID=0;X-EVOLUTION-DEST-HTML-MAIL=FALSE:jill@compan
       y3.com
      X-EVOLUTION-FILE-AS:Group 3
      FN:Group 3
      N:3;Group;;;
      X-EVOLUTION-LIST:TRUE
      X-EVOLUTION-LIST-SHOW-ADDRESSES:FALSE
      END:VCARD

      BEGIN:VCARD
      VERSION:3.0
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:David Doe
      N:Doe;David;;;
      X-EVOLUTION-FILE-AS:Doe\, David
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """
