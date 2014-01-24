@testplan_8285
Feature: Addressbook: File: Create contacts

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Doe"

    @testcase_238754
    Scenario: Create a simple contact
      * Create a new contact
      * Set "Full Name..." in contact editor to "John Doe"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, John" contact
      * Open contact editor for selected contact
      Then "Full Name..." property is set to "John Doe"

    @testcase_238755
    Scenario: Create a contact with nickname
      * Create a new contact
      * Set "Full Name..." in contact editor to "Joe Doe"
      * Set "Nickname:" in contact editor to "Unknown"
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Joe" contact
      * Open contact editor for selected contact
      Then "Nickname:" property is set to "Unknown"

    @testcase_238756
    Scenario: Create a contact with different "file under" field
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jackie Doe"
      * Set "File under:" in contact editor to "Jackie Doe"
      * Save the contact
      * Refresh addressbook
      * Select "Jackie Doe" contact
      * Open contact editor for selected contact
      Then "Full Name..." property is set to "Jackie Doe"

    @testcase_238757
    Scenario: Create a contact with work email
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jack Doe"
      * Set emails in contact editor to
        | Field | Value        |
        | Work  | jack@doe.com |
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Jack" contact
      * Open contact editor for selected contact
      Then Emails are set to
        | Field | Value        |
        | Work  | jack@doe.com |

    @testcase_238758
    Scenario: Create a contact with work, home and two other emails
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jimmy Doe"
      * Set emails in contact editor to
        | Field | Value |
        | Work  | jimmy.doe@company.com |
        | Home  | jimmy_doe_72@gmail.com |
        | Other | jimmydoe72@yahoo.com |
        | Other | xxjimmyxx@free_email.com |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Jimmy" contact
      * Open contact editor for selected contact
      Then Emails are set to
        | Field | Value |
        | Work | jimmy.doe@company.com |
        | Home | jimmy_doe_72@gmail.com |
        | Other | jimmydoe72@yahoo.com |
        | Other | xxjimmyxx@free_email.com |

    @testcase_238759
    Scenario: Create a contact with "Wants to receive HTML mails" set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Michael Doe"
      * Tick "Wants to receive HTML mail" checkbox
      * Save the contact
      * Refresh addressbook
      * Select "Doe, Michael" contact
      * Open contact editor for selected contact
      Then "Wants to receive HTML mail" checkbox is ticked

    @testcase_238760
    Scenario: Create a contact with business telephone
      * Create a new contact
      * Set "Full Name..." in contact editor to "Sam Doe"
      * Set phones in contact editor to
        | Field | Value |
        | Business Phone | 123 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Sam" contact
      * Open contact editor for selected contact
      Then Phones are set to
        | Field | Value |
        | Business Phone | 123 |

    @testcase_238761
    Scenario: Create a contact with all phones set (part 1)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Noah Doe"
      * Set phones in contact editor to
        | Field | Value |
        | Assistant Phone | 123 |
        | Business Phone | 234 |
        | Business Fax | 345 |
        | Callback Phone | 456 |
        | Car Phone | 567 |
        | Company Phone | 678 |
        | Home Phone | 789 |
        | Home Fax | 890 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Noah" contact
      * Open contact editor for selected contact
      Then Phones are set to
        | Field | Value |
        | Assistant Phone | 123 |
        | Business Phone | 234 |
        | Business Fax | 345 |
        | Callback Phone | 456 |
        | Car Phone | 567 |
        | Company Phone | 678 |
        | Home Phone | 789 |
        | Home Fax | 890 |

    @testcase_238762
    Scenario: Create a contact with all phones set (part 2)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Kevin Doe"
      * Set phones in contact editor to
        | Field | Value |
        | ISDN | 123 |
        | Mobile Phone | 234 |
        | Other Phone | 345 |
        | Other Fax | 456 |
        | Pager | 567 |
        | Primary Phone | 678 |
        | Radio | 789 |
        | Telex | 890 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Kevin" contact
      * Open contact editor for selected contact
      Then Phones are set to
        | Field | Value |
        | ISDN | 123 |
        | Mobile Phone | 234 |
        | Other Phone | 345 |
        | Other Fax | 456 |
        | Pager | 567 |
        | Primary Phone | 678 |
        | Radio | 789 |
        | Telex | 890 |

    @testcase_238763
    Scenario: Create a contact with all IM set (part 1)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Kyle Doe"
      * Set IMs in contact editor to
        | Field | Value |
        | AIM | 123 |
        | Jabber | 234 |
        | Yahoo | 345 |
        | Gadu-Gadu | 456 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Kyle" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field | Value |
        | AIM | 123 |
        | Jabber | 234 |
        | Yahoo | 345 |
        | Gadu-Gadu | 456 |

    @testcase_238764
    Scenario: Create a contact with all IM set (part 2)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jacob Doe"
      * Set IMs in contact editor to
        | Field | Value |
        | MSN | 123 |
        | ICQ | 234 |
        | GroupWise | 345 |
        | Skype | 456 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Jacob" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field | Value |
        | MSN | 123 |
        | ICQ | 234 |
        | GroupWise | 345 |
        | Skype | 456 |

    @testcase_238765
    Scenario: Create a contact with all IM set (part 3)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Mary Doe"
      * Set IMs in contact editor to
        | Field | Value |
        | Twitter | 123 |
        | ICQ | 234 |
        | Jabber | 345 |
        | Skype | 456 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Mary" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field | Value |
        | Twitter | 123 |
        | ICQ | 234 |
        | Jabber | 345 |
        | Skype | 456 |

    @testcase_238766
    Scenario: Create a contact with all web pages set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Anna Doe"
      * Switch to "Personal Information" tab in contact editor
      * Set the following properties in contact editor
        | Field | Value |
        | Home Page: | http://anna-doe.com |
        | Blog: | http://blog.anna-doe.com |
        | Calendar: | caldav://anna-doe.com/calendar.ics |
        | Free/Busy: | http://anna-doe.com/free-busy |
        | Video Chat: | http://anna-doe.com/video-chat |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Anna" contact
      * Open contact editor for selected contact
      * Switch to "Personal Information" tab in contact editor
      Then The following properties in contact editor are set
        | Field | Value |
        | Home Page: | http://anna-doe.com |
        | Blog: | http://blog.anna-doe.com |
        | Calendar: | caldav://anna-doe.com/calendar.ics |
        | Free/Busy: | http://anna-doe.com/free-busy |
        | Video Chat: | http://anna-doe.com/video-chat |

    @testcase_238767
    Scenario: Create a contact with all job fields set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Betka Doe"
      * Switch to "Personal Information" tab in contact editor
      * Set the following properties in contact editor
        | Field | Value |
        | Profession: | QA Engineer |
        | Title: | Dr. |
        | Company: | Something Ltd. |
        | Department: | Desktop QA |
        | Manager: | John Doe |
        | Assistant: | Anna Doe |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Betka" contact
      * Open contact editor for selected contact
      * Switch to "Personal Information" tab in contact editor
      Then The following properties in contact editor are set
        | Field | Value |
        | Profession: | QA Engineer |
        | Title: | Dr. |
        | Company: | Something Ltd. |
        | Department: | Desktop QA |
        | Manager: | John Doe |
        | Assistant: | Anna Doe |

    @testcase_238768
    Scenario: Create a contact with all miscellaneous fields set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Clara Doe"
      * Switch to "Personal Information" tab in contact editor
      * Set the following properties in contact editor
        | Field | Value |
        | Office: | 221b |
        | Spouse: | Jack Doe |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Clara" contact
      * Open contact editor for selected contact
      * Switch to "Personal Information" tab in contact editor
      Then The following properties in contact editor are set
        | Field | Value |
        | Office: | 221b |
        | Spouse: | Jack Doe |

    @testcase_238769
    Scenario: Create a contact with Home address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Diana Doe"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Home" section of contact editor
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Diana" contact
      * Open contact editor for selected contact
      * Switch to "Mailing Address" tab in contact editor
      Then The following properties in "Home" section of contact editor are set
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

    @testcase_238770
    Scenario: Create a contact with Work address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Elisa Doe"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Work" section of contact editor
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Elisa" contact
      * Open contact editor for selected contact
      * Switch to "Mailing Address" tab in contact editor
      Then The following properties in "Work" section of contact editor are set
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

    @testcase_238771
    Scenario: Create a contact with Other address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Elma Doe"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Other" section of contact editor
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Elma" contact
      * Open contact editor for selected contact
      * Switch to "Mailing Address" tab in contact editor
      Then The following properties in "Other" section of contact editor are set
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

    @testcase_241632
    Scenario: Create a contact with Notes
      * Create a new contact
      * Set "Full Name..." in contact editor to "Frida Doe"
      * Switch to "Notes" tab in contact editor
      * Set the following note for the contact:
      """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim gravida elit, nec facilisis augue commodo quis.

      Sed ac metus quis tellus aliquet posuere non quis elit. Quisque non ante congue urna blandit accumsan.

      In vitae ligula risus. Nunc venenatis leo vel leo facilisis porta. Nam sed magna urna, venenatis.
      """

      * Save the contact
      * Refresh addressbook
      * Select "Doe, Frida" contact
      * Open contact editor for selected contact
      * Switch to "Notes" tab in contact editor
      Then The following note is set for the contact:
      """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim gravida elit, nec facilisis augue commodo quis.

      Sed ac metus quis tellus aliquet posuere non quis elit. Quisque non ante congue urna blandit accumsan.

      In vitae ligula risus. Nunc venenatis leo vel leo facilisis porta. Nam sed magna urna, venenatis.
      """

    @testcase_261052 @wip
    Scenario: Create a contact with photo
      * Download "http://projects.gnome.org/evolution/images/evo-logo.png" to "/tmp/photo.jpg"
      * Create a new contact
      * Set "Full Name..." in contact editor to "George Doe"
      * Set contact picture to "/tmp/photo.jpg"
      * Save the contact and in resize dialog select "Use as it is"
      * Refresh addressbook
      * Select "Doe, George" contact
      Then photo 150x150 is displayed in contact details
