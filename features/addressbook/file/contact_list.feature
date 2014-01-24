@testplan_8332
Feature: Addressbook: File: Contact lists operations

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Group"

    @testcase_240429
    Scenario: Create an empty contact list
      * Create a new contact list
      * Set contact list name to "Group 1"
      * Save the contact list
      * Refresh addressbook
      * Select "Group 1" contact list
      * Open contact list editor
      Then contact list members list is empty

    @testcase_240430
    Scenario: Create a contact list with 3 addresses
      * Create a new contact list
      * Set contact list name to "Group 2"
      * Add "john@company1.com" to the contact list
      * Add "jack@company1.com" to the contact list
      * Add "jill@company1.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 2" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email             |
        | john@company1.com |
        | jack@company1.com |
        | jill@company1.com |

    @testcase_317388
    Scenario: Add existing contact to the contact list
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jack Doe"
      * Set emails in contact editor to
        | Field | Value             |
        | Work  | jack@company2.com |
      * Save the contact
      * Refresh addressbook
      * Create a new contact list
      * Set contact list name to "Group 2"
      * Add "john@company2.com" to the contact list
      * Add "jill@company2.com" to the contact list
      * Add first suggestion for "Jack" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 2" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email                        |
        | john@company2.com            |
        | jill@company2.com            |
        | Jack Doe <jack@company2.com> |

    @testcase_317389
    Scenario: Add existing contact list to the contact list
      * Create a new contact list
      * Set contact list name to "Sublist"
      * Add "jack@subcompany.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Create a new contact list
      * Set contact list name to "Main list"
      * Add "john@maincompany.com" to the contact list
      * Add first suggestion for "Sublist" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Main list" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email                |
        | john@maincompany.com |
        | Sublist              |
        | jack@subcompany.com  |

    @testcase_240431
    Scenario: Edit contact list's name
      * Create a new contact list
      * Set contact list name to "Group 3"
      * Add "john@company2.com" to the contact list
      * Add "jack@company2.com" to the contact list
      * Add "jill@company2.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 3" contact list
      * Open contact list editor
      * Set contact list name to "Group 3 - updated"
      * Save the contact list
      * Refresh addressbook
      * Select "Group 3 - updated" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email             |
        | john@company2.com |
        | jack@company2.com |
        | jill@company2.com |

    @testcase_240432
    Scenario: Add a contact to existing contact list
      * Create a new contact list
      * Set contact list name to "Group 4"
      * Add "john@company3.com" to the contact list
      * Add "jack@company3.com" to the contact list
      * Add "jill@company3.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 4" contact list
      * Open contact list editor
      * Add "james@company3.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 4" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email              |
        | john@company3.com  |
        | jack@company3.com  |
        | jill@company3.com  |
        | james@company3.com |

    @testcase_240433
    Scenario: Remove contact from existing contact list
      * Create a new contact list
      * Set contact list name to "Group 5"
      * Add "john@company4.com" to the contact list
      * Add "jack@company4.com" to the contact list
      * Add "jill@company4.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 5" contact list
      * Open contact list editor
      * Remove "jack@company4.com" from the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 5" contact list
      * Open contact list editor
      Then contact list members list is:
        | Email              |
        | john@company4.com  |
        | jill@company4.com  |

    @testcase_240434
    Scenario: Remove a contact list
      * Create a new contact list
      * Set contact list name to "Group 6"
      * Add "john@company4.com" to the contact list
      * Add "jack@company4.com" to the contact list
      * Add "jill@company4.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 6" contact list
      * Delete the selected contact list
      Then Contact list does not include "Group 6"

    @testcase_317397
    Scenario: Export a contact list
      * Create a new contact list
      * Set contact list name to "Group 7"
      * Add "john@company5.com" to the contact list
      * Add "jack@company5.com" to the contact list
      * Add "jill@company5.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Select "Group 7" contact list
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:john@compan
       y5.com
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:jack@compan
       y5.com
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:jill@compan
       y5.com
      X-EVOLUTION-FILE-AS:Group 7
      FN:Group 7
      N:7;Group;;;
      X-EVOLUTION-LIST:TRUE
      X-EVOLUTION-LIST-SHOW-ADDRESSES:FALSE
      END:VCARD
      """

    @testcase_317398
    Scenario: Export a contact list with addresses shown
      * Create a new contact list
      * Set contact list name to "Group 8"
      * Add "john@company6.com" to the contact list
      * Add "jack@company6.com" to the contact list
      * Add "jill@company6.com" to the contact list
      * Unset "Hide addresses when sending email to this list" in contact list editor
      * Save the contact list
      * Refresh addressbook
      * Select "Group 8" contact list
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:john@compan
       y6.com
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:jack@compan
       y6.com
      EMAIL;X-EVOLUTION-DEST-HTML-MAIL=FALSE;X-EVOLUTION-PARENT-UID=0:jill@compan
       y6.com
      X-EVOLUTION-FILE-AS:Group 8
      FN:Group 8
      N:8;Group;;;
      X-EVOLUTION-LIST:TRUE
      X-EVOLUTION-LIST-SHOW-ADDRESSES:TRUE
      END:VCARD
      """
