@testplan_8407
Feature: Memos: File

  Background:
    * Open Evolution via command and setup fake account
    * Open "Memos" section
    * Delete all memos which contain "Memo"

    @testcase_241582
    Scenario: Create a memo
      * Add a new memo "Memo 1"
      * Open "Memo 1" memo in memo editor
      Then Memo editor has the following fields set:
        | Field        | Value  |
        | Summary:     | Memo 1 |
        | Description: |        |

    @testcase_241583
    Scenario: Create memo with all fields filled in
      * Add a new memo "Memo 2" via menu
      * Set the following values in memo editor:
        | Field        | Value           |
        | Summary:     | Memo 2          |
        | Start date:  | 01/01/2014      |
        | Description: | Important memo! |
      * Save and close memo editor
      * Open "Memo 2" memo in memo editor
      Then Memo editor has the following fields set:
        | Field        | Value           |
        | Summary:     | Memo 2          |
        | Start date:  | 01/01/2014      |
        | Description: | Important memo! |

    @testcase_241584
    Scenario: Edit a memo
      * Add a new memo "Memo 3" via menu
      * Set the following values in memo editor:
        | Field        | Value         |
        | Summary:     | Memo 3        |
        | Start date:  | 02/02/2014    |
        | Description: | A normal memo |
      * Save and close memo editor
      * Open "Memo 3" memo in memo editor
      * Set the following values in memo editor:
        | Field        | Value           |
        | Summary:     | Memo 3 updated  |
        | Start date:  | 03/03/2014      |
        | Description: | An updated memo |
      * Save and close memo editor
      * Open "Memo 3 updated" memo in memo editor
      Then Memo editor has the following fields set:
        | Field        | Value           |
        | Summary:     | Memo 3 updated  |
        | Start date:  | 03/03/2014      |
        | Description: | An updated memo |

    @testcase_241585
    Scenario: Delete a memo
      * Add a new memo "Memo 4" via menu
      * Set the following values in memo editor:
        | Field        | Value            |
        | Summary:     | Memo 4           |
        | Start date:  | 04/04/2014       |
        | Description: | Delete this memo |
      * Save and close memo editor
      * Delete "Memo 4" memo
      * Search for "Memo 4" memo
      Then no memos found

    @testcase_317431
    Scenario: Export memo
      * Add a new memo "Memo 5" via menu
      * Set the following values in memo editor:
        | Field        | Value           |
        | Summary:     | Memo 5          |
        | Start date:  | 05/05/2014      |
        | Description: | Important memo! |
      * Save and close memo editor
      * Search for "Memo 5" memo
      * Save memo as "/tmp/memo.ics"
      Then "/tmp/memo.ics" file contents is:
        """
        BEGIN:VCALENDAR
        PRODID:-//Ximian//NONSGML Evolution Calendar//EN
        VERSION:2.0
        METHOD:PUBLISH
        BEGIN:VJOURNAL
        SUMMARY:Memo 5
        DESCRIPTION:Important memo!
        DTSTART;VALUE=DATE:20140505
        CLASS:PUBLIC
        SEQUENCE:1
        END:VJOURNAL
        END:VCALENDAR

        """
