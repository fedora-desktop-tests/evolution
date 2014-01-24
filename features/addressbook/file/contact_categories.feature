@testplan_8284
Feature: Addressbook: File: Contact categories

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Jones"

    @testcase_238749
    Scenario: Create a contact with categories
      * Create a new contact
      * Set "Full Name..." in contact editor to "Adam Jones"
      * Set "Categories..." in contact editor to "Business,Key Customer"
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Key Customer"
      * Select "Jones, Adam" contact
      * Open contact editor for selected contact
      Then Categories field is set to "Business,Key Customer"

    @testcase_238750
    Scenario: Set categories using Categories dialog
      * Create a new contact
      * Set "Full Name..." in contact editor to "Chris Jones"
      * Open "Categories..." dialog in contact editor
      * Check "Ideas" category
      * Check "Status" category
      * Check "Favorites" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Favorites"
      * Select "Jones, Chris" contact
      * Open contact editor for selected contact
      Then Categories field is set to "Favorites,Ideas,Status"

    @testcase_238751
    Scenario: Contact is not listed in unchecked categories
      * Create a new contact
      * Set "Full Name..." in contact editor to "Danny Jones"
      * Open "Categories..." dialog in contact editor
      * Check "Business" category
      * Check "Holiday" category
      * Check "Personal" category
      * Uncheck "Holiday" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Holiday"
      Then Contact list does not include "Danny Jones"

    @testcase_238752
    Scenario: Create a new category
      * Create a new contact
      * Set "Full Name..." in contact editor to "Edgar Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "New Category"
      * Close new category dialog
      * Check "New Category" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "New Category"
      * Select "Jones, Edgar" contact
      * Open contact editor for selected contact
      Then Categories field is set to "New Category"

    @testcase_261043
    Scenario: Create a new category with icon
      * Create a new contact
      * Set "Full Name..." in contact editor to "Fritz Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "Icon Category"
      * Set "/usr/share/pixmaps/evolution-data-server/category_birthday_16.png" as category icon
      * Close new category dialog
      * Check "Icon Category" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Icon Category"
      * Select "Jones, Fritz" contact
      * Open contact editor for selected contact
      Then Categories field is set to "Icon Category"

    @testcase_261046
    Scenario: Set icon for new category
      * Create a new contact
      * Set "Full Name..." in contact editor to "George Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "Another Category"
      * Close new category dialog
      * Edit "Another Category" category
      * Set "/usr/share/pixmaps/evolution-data-server/category_birthday_16.png" as category icon
      * Close new category dialog
      * Check "Another Category" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Another Category"
      * Select "Jones, George" contact
      * Open contact editor for selected contact
      Then Categories field is set to "Another Category"

    @testcase_261047
    Scenario: Unset icon for new category
      * Create a new contact
      * Set "Full Name..." in contact editor to "Hanz Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "One More Category"
      * Close new category dialog
      * Edit "One More Category" category
      * Set "/usr/share/pixmaps/evolution-data-server/category_birthday_16.png" as category icon
      * Close new category dialog
      * Edit "One More Category" category
      * Unset icon for category
      * Close new category dialog
      * Check "One More Category" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "One More Category"
      * Select "Jones, Hanz" contact
      * Open contact editor for selected contact
      Then Categories field is set to "One More Category"

    @testcase_238753
    Scenario: Delete a new category
      * Create a new contact
      * Set "Full Name..." in contact editor to "Ian Jones"
      * Open "Categories..." dialog in contact editor
      * Check "Business" category
      * Open new category dialog
      * Set category name to "This category should be deleted"
      * Close new category dialog
      * Delete "This category should be deleted" category
      * Uncheck "Business" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "Unmatched"
      * Select "Jones, Ian" contact
      * Open contact editor for selected contact
      Then "Categories..." property is empty

    @testcase_261048
    Scenario: Category completion
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jeremy Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "Suggestion 1"
      * Close new category dialog
      * Open new category dialog
      * Set category name to "Suggestion 2"
      * Close new category dialog
      * Show category suggestions for "Suggestion"
      * Select category 2 from suggestion box in category dialog
      Then currently used categories is set to "Suggestion 2,"

    @send_me_to_tcms
    Scenario: Create a new category from completion text
      * Create a new contact
      * Set "Full Name..." in contact editor to "Kyle Jones"
      * Open "Categories..." dialog in contact editor
      * Show category suggestions for "No Such Category"
      * Select category 1 from suggestion box in category dialog
      * Check "No Such Category" category
      * Close categories dialog
      * Save the contact
      * Refresh addressbook
      * Change categories view to "No Such Category"
      * Select "Jones, Kyle" contact
      * Open contact editor for selected contact
      Then Categories field is set to "No Such Category"

    @testcase_261049
    Scenario: Create duplicate category
      * Create a new contact
      * Set "Full Name..." in contact editor to "Liam Jones"
      * Open "Categories..." dialog in contact editor
      * Open new category dialog
      * Set category name to "Existing category"
      * Close new category dialog
      * Open new category dialog
      * Set category name to "Existing category"
      * Close new category dialog without verification
      Then "This category already exists" dialog appears
