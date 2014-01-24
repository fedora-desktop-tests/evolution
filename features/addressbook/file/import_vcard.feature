@testplan_8333
Feature: Addressbook: File: Import contact from vcard

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Jameson"

    @testcase_240440
    Scenario: Contact with first name only
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      FN:Alex Jameson
      N:Jameson;Alex;;;
      X-EVOLUTION-FILE-AS:Jameson\, Alex
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Alex" contact
      * Open contact editor for selected contact
      Then "Full Name..." property is set to "Alex Jameson"

    @testcase_240441
    Scenario: Create a contact with nickname
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      NICKNAME:Unknown
      FN:Bill Jameson
      N:Jameson;Bill;;;
      X-EVOLUTION-FILE-AS:Jameson\, Bill
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Bill" contact
      * Open contact editor for selected contact
      Then "Nickname:" property is set to "Unknown"

    @testcase_240442
    Scenario: Create a contact with different "file under" field
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      FN:Chris Jameson
      N:Jameson;Chris;;;
      X-EVOLUTION-FILE-AS:Chris Jameson
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Chris Jameson" contact
      * Open contact editor for selected contact
      Then "File under:" property is set to "Chris Jameson"

    @testcase_240443
    Scenario: Create a contact with work email
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      FN:David Jameson
      N:Jameson;David;;;
      X-EVOLUTION-FILE-AS:Jameson\, David
      EMAIL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK:david@jameson.com
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, David" contact
      * Open contact editor for selected contact
      Then  Emails are set to
      | Field | Value             |
      | Work  | david@jameson.com |

    @testcase_240444
    Scenario: Create a contact with work, home and two other emails
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      FN:Evan Jameson
      N:Jameson;Evan;;;
      X-EVOLUTION-FILE-AS:Jameson\, Evan
      EMAIL;X-EVOLUTION-UI-SLOT=1;TYPE=OTHER:evanJameson72@yahoo.com
      EMAIL;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:Jameson_evan_72@gmail.com
      EMAIL;X-EVOLUTION-UI-SLOT=3;TYPE=OTHER:jameson@free_email.com
      EMAIL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK:evan.Jameson@company.com
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Evan" contact
      * Open contact editor for selected contact
      Then  Emails are set to
      | Field | Value |
      | Work  | evan.Jameson@company.com |
      | Home  | Jameson_evan_72@gmail.com |
      | Other | evanJameson72@yahoo.com |
      | Other | jameson@free_email.com |

    @testcase_240445
    Scenario: Create a contact with "Wants to receive HTML mails" set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      FN:Fred Jameson
      N:Jameson;Fred;;;
      X-EVOLUTION-FILE-AS:Jameson\, Fred
      X-MOZILLA-HTML:TRUE
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Fred" contact
      * Open contact editor for selected contact
      Then "Wants to receive HTML mail" checkbox is ticked

    @testcase_240446
    Scenario: Create a contact with business telephone
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      TEL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK,VOICE:123
      FN:George Jameson
      N:Jameson;George;;;
      X-EVOLUTION-FILE-AS:Jameson\, George
      X-MOZILLA-HTML:TRUE
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, George" contact
      * Open contact editor for selected contact
      Then Phones are set to
        | Field          | Value |
        | Business Phone | 123   |

    @testcase_240447
    Scenario: Create a contact with all phones set (part 1)
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      TEL;X-EVOLUTION-UI-SLOT=8;TYPE=CAR:567
      TEL;X-EVOLUTION-UI-SLOT=7;TYPE=HOME,VOICE:789
      TEL;X-EVOLUTION-UI-SLOT=6;TYPE="X-EVOLUTION-COMPANY":678
      TEL;X-EVOLUTION-UI-SLOT=5;TYPE=HOME,FAX:890
      TEL;X-EVOLUTION-UI-SLOT=4;TYPE="X-EVOLUTION-ASSISTANT":123
      TEL;X-EVOLUTION-UI-SLOT=3;TYPE=WORK,FAX:345
      TEL;X-EVOLUTION-UI-SLOT=2;TYPE=WORK,VOICE:234
      TEL;X-EVOLUTION-UI-SLOT=1;TYPE="X-EVOLUTION-CALLBACK":456
      FN:Hanna Jameson
      N:Jameson;Hanna;;;
      X-EVOLUTION-FILE-AS:Jameson\, Hanna
      X-MOZILLA-HTML:TRUE
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Hanna" contact
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

    @testcase_240448
    Scenario: Create a contact with all phones set (part 2)
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      TEL;X-EVOLUTION-UI-SLOT=8;TYPE=PAGER:567
      TEL;X-EVOLUTION-UI-SLOT=7;TYPE="X-EVOLUTION-RADIO":789
      TEL;X-EVOLUTION-UI-SLOT=6;TYPE=PREF:678
      TEL;X-EVOLUTION-UI-SLOT=5;TYPE="X-EVOLUTION-TELEX":890
      TEL;X-EVOLUTION-UI-SLOT=4;TYPE=ISDN:123
      TEL;X-EVOLUTION-UI-SLOT=3;TYPE=VOICE:345
      TEL;X-EVOLUTION-UI-SLOT=2;TYPE=CELL:234
      TEL;X-EVOLUTION-UI-SLOT=1;TYPE=FAX:456
      FN:Ian Jameson
      N:Jameson;Ian;;;
      X-EVOLUTION-FILE-AS:Jameson\, Ian
      X-MOZILLA-HTML:TRUE
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Ian" contact
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

    @testcase_240449
    Scenario: Create a contact with all IM set (part 1)
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      X-AIM;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      X-JABBER;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-YAHOO;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-GADUGADU;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      FN:Jack Jameson
      N:Jameson;Jack;;;
      X-EVOLUTION-FILE-AS:Jameson\, Jack
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Jack" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field     | Value |
        | AIM       | 123   |
        | Jabber    | 234   |
        | Yahoo     | 345   |
        | Gadu-Gadu | 456   |

    @testcase_240450
    Scenario: Create a contact with all IM set (part 2)
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      X-MSN;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      X-ICQ;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-GROUPWISE;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-SKYPE;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      FN:Kyle Jameson
      N:Jameson;Kyle;;;
      X-EVOLUTION-FILE-AS:Jameson\, Kyle
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Kyle" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field     | Value |
        | MSN       | 123   |
        | ICQ       | 234   |
        | GroupWise | 345   |
        | Skype     | 456   |

    @testcase_240451
    Scenario: Create a contact with all IM set (part 3)
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      X-JABBER;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-ICQ;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-SKYPE;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      X-TWITTER;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      FN:Matthew Jameson
      N:Jameson;Matthew;;;
      X-EVOLUTION-FILE-AS:Jameson\, Matthew
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Matthew" contact
      * Open contact editor for selected contact
      Then IMs are set to
        | Field   | Value |
        | Twitter | 123   |
        | ICQ     | 234   |
        | Jabber  | 345   |
        | Skype   | 456   |

    @testcase_240452
    Scenario: Create a contact with all web pages set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:http://nick-jameson.com
      X-EVOLUTION-BLOG-URL:http://blog.nick-jameson.com
      CALURI:caldav://nick-jameson.com/calendar.ics
      FBURL:http://nick-jameson.com/free-busy
      X-EVOLUTION-VIDEO-URL:http://nick-jameson.com/video-chat
      FN:Nick Jameson
      N:Jameson;Nick;;;
      X-EVOLUTION-FILE-AS:Jameson\, Nick
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Nick" contact
      * Open contact editor for selected contact
      * Switch to "Personal Information" tab in contact editor
      Then The following properties in contact editor are set
        | Field | Value |
        | Home Page: | http://nick-jameson.com |
        | Blog: | http://blog.nick-jameson.com |
        | Calendar: | caldav://nick-jameson.com/calendar.ics |
        | Free/Busy: | http://nick-jameson.com/free-busy |
        | Video Chat: | http://nick-jameson.com/video-chat |

    @testcase_240453
    Scenario: Create a contact with all web pages set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      TITLE:Dr.
      ORG:Something Ltd.;Desktop QA;
      ROLE:QA Engineer
      X-EVOLUTION-MANAGER:John Doe
      X-EVOLUTION-ASSISTANT:Anna Doe
      FN:Olaf Jameson
      N:Jameson;Olaf;;;
      X-EVOLUTION-FILE-AS:Jameson\, Olaf
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Olaf" contact
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

    @testcase_240454
    Scenario: Create a contact with all miscellaneous fields set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      X-EVOLUTION-SPOUSE:Jack Doe
      ORG:;;221b
      FN:Pamela Jameson
      N:Jameson;Pamela;;;
      X-EVOLUTION-FILE-AS:Jameson\, Pamela
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Pamela" contact
      * Open contact editor for selected contact
      Then The following properties in contact editor are set
        | Field   | Value    |
        | Office: | 221b     |
        | Spouse: | Jack Doe |

    @testcase_240455
    Scenario: Create a contact with Home address set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      ADR;TYPE=HOME:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech Re
       public
      LABEL;TYPE=HOME:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\nC
       zech Republic
      FN:Quentin Jameson
      N:Jameson;Quentin;;;
      X-EVOLUTION-FILE-AS:Jameson\, Quentin
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Quentin" contact
      * Open contact editor for selected contact
      Then The following properties in "Home" section of contact editor are set
        | Field | Value |
        | City: | Brno |
        | Zip/Postal Code: | 61245 |
        | State/Province: | Brno-Kralovo Pole |
        | Country: | Czech Republic |
        | PO Box: | 123456 |
        | Address: | Purkynova 99/71 |

    @testcase_240456
    Scenario: Create a contact with Work address set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      ADR;TYPE=WORK:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech Re
       public
      LABEL;TYPE=WORK:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\nC
       zech Republic
      FN:Ralph Jameson
      N:Jameson;Ralph;;;
      X-EVOLUTION-FILE-AS:Jameson\, Ralph
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Ralph" contact
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

    @testcase_240457
    Scenario: Create a contact with Other address set
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      ADR;TYPE=OTHER:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech Re
       public
      LABEL;TYPE=OTHER:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\nC
       zech Republic
      FN:Stephen Jameson
      N:Jameson;Stephen;;;
      X-EVOLUTION-FILE-AS:Jameson\, Stephen
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Stephen" contact
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

    @testcase_240458
    Scenario: Create a contact with Notes
      * Save the following text in "/tmp/tempcontact.vcf":
      """
      BEGIN:VCARD
      VERSION:3.0
      NOTE:Lorem ipsum dolor sit amet\, consectetur adipiscing elit. Sed dignissi
       m gravida elit\, nec facilisis augue commodo quis.\n\nSed ac metus quis te
       llus aliquet posuere non quis elit. Quisque non ante congue urna blandit a
       ccumsan.\n\nIn vitae ligula risus. Nunc venenatis leo vel leo facilisis po
       rta. Nam sed magna urna\, venenatis.
      FN:Tim Jameson
      N:Jameson;Tim;;;
      X-EVOLUTION-FILE-AS:Jameson\, Tim
      END:VCARD
      """
      * Import "/tmp/tempcontact.vcf" as a contact card
      * Select "Jameson, Tim" contact
      * Open contact editor for selected contact
      * Switch to "Notes" tab in contact editor
      Then The following note is set for the contact:
      """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim gravida elit, nec facilisis augue commodo quis.

      Sed ac metus quis tellus aliquet posuere non quis elit. Quisque non ante congue urna blandit accumsan.

      In vitae ligula risus. Nunc venenatis leo vel leo facilisis porta. Nam sed magna urna, venenatis.
      """
