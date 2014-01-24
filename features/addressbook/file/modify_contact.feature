@testplan_8286
Feature: Addressbook: File: Modify contacts

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Smith"

    @testcase_238777
    Scenario: Edit contact's nickname
      * Open "Contacts" section
      * Create a new contact
      * Set "Full Name..." in contact editor to "Adam Smith"
      * Save the contact
      * Refresh addressbook
      * Select "Smith, Adam" contact
      * Open contact editor for selected contact
      * Set "Nickname:" in contact editor to "Unknown"
      * Save the contact
      * Refresh addressbook
      * Select "Smith, Adam" contact
      * Open contact editor for selected contact
      Then "Nickname:" property is set to "Unknown"

    @testcase_238778
    Scenario: Delete contact
      * Open "Contacts" section
      * Create a new contact
      * Set "Full Name..." in contact editor to "Bob Smith"
      * Save the contact
      * Refresh addressbook
      * Select "Smith, Bob" contact
      * Delete selected contact
      Then Contact list does not include "Bob Smith"

    @testcase_261055 @wip
    Scenario: Modify contacts photo
      * Download "http://projects.gnome.org/evolution/images/evo-logo.png" to "/tmp/photo.jpg"
      * Download "http://www.gnome.org/wp-content/uploads/2011/04/gnome-3-release1-96x96.jpg" to "/tmp/logo.jpg"
      * Create a new contact
      * Set "Full Name..." in contact editor to "Chris Smith"
      * Set contact picture to "/tmp/logo.jpg"
      * Save the contact
      * Refresh addressbook
      * Select "Smith, Chris" contact
      * Open contact editor for selected contact
      * Set contact picture to "/tmp/photo.jpg"
      * Save the contact and in resize dialog select "Resize"
      * Refresh addressbook
      * Select "Smith, Chris" contact
      Then photo 96x96 is displayed in contact details
