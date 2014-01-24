@testplan_8287
Feature: Addressbook: File: Complex name parsing

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Doe"

    @testcase_238772
    Scenario: Full name is generated from complex name set
      * Create a new contact
      * Open full name window in contact editor
      * Set the following values in full name window
        | Field   | Value |
        | Title:  | Mr.   |
        | First:  | John  |
        | Middle: | A.    |
        | Last:   | Doe   |
        | Suffix: | Esq.  |

      * Click "OK" in full name window in contact editor
      Then "Full Name..." property is set to "Mr. John A. Doe Esq."

    @testcase_238773
    Scenario: Complex name parameters are parsed from complex full name
      * Create a new contact
      * Set "Full Name..." in contact editor to "Mr. John A. Doe Esq."
      * Open full name window in contact editor
      Then The following values are set in full name window
        | Field   | Value |
        | Title:  | Mr.   |
        | First:  | John  |
        | Middle: | A.    |
        | Last:   | Doe   |
        | Suffix: | Esq.  |

    @testcase_238774
    Scenario: Parse complex full name without the title
      * Create a new contact
      * Set "Full Name..." in contact editor to "John A. Doe Esq."
      * Open full name window in contact editor
      Then The following values are set in full name window
        | Field   | Value |
        | Title:  |       |
        | First:  | John  |
        | Middle: | A.    |
        | Last:   | Doe   |
        | Suffix: | Esq.  |

    @testcase_238775
    Scenario: Parse complex full name without the middle name
      * Create a new contact
      * Set "Full Name..." in contact editor to "Mr. John Doe Esq."
      * Open full name window in contact editor
      Then The following values are set in full name window
        | Field   | Value |
        | Title:  | Mr.   |
        | First:  | John  |
        | Middle: |       |
        | Last:   | Doe   |
        | Suffix: | Esq.  |

    @testcase_238776
    Scenario: Parse complex full name without the suffix name
      * Create a new contact
      * Set "Full Name..." in contact editor to "Mr. John A. Doe"
      * Open full name window in contact editor
      Then The following values are set in full name window
        | Field   | Value |
        | Title:  | Mr.   |
        | First:  | John  |
        | Middle: | A.    |
        | Last:   | Doe   |
        | Suffix: |       |

