@testplan_8335
Feature: Addressbook: File: Save contact as a vcard

  Background:
    * Open Evolution via command and setup fake account
    * Open "Contacts" section
    * Select "Personal" addressbook
    * Change categories view to "Any Category"
    * Delete all contacts containing "Johnson"

    @testcase_240463
    Scenario: Contact with first name only
      * Create a new contact
      * Set "Full Name..." in contact editor to "Alex Johnson"
      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Alex" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Alex Johnson
      N:Johnson;Alex;;;
      X-EVOLUTION-FILE-AS:Johnson\, Alex
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240464
    Scenario: Create a contact with nickname
      * Create a new contact
      * Set "Full Name..." in contact editor to "Bill Johnson"
      * Set "Nickname:" in contact editor to "Unknown"
      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Bill" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:Unknown
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:Bill Johnson
      N:Johnson;Bill;;;
      X-EVOLUTION-FILE-AS:Johnson\, Bill
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240465
    Scenario: Create a contact with different "file under" field
      * Create a new contact
      * Set "Full Name..." in contact editor to "Chris Johnson"
      * Set "File under:" in contact editor to "Chris Johnson"
      * Save the contact
      * Refresh addressbook
      * Select "Chris Johnson" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Chris Johnson
      N:Johnson;Chris;;;
      X-EVOLUTION-FILE-AS:Chris Johnson
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240466
    Scenario: Create a contact with work email
      * Create a new contact
      * Set "Full Name..." in contact editor to "David Johnson"
      * Set emails in contact editor to
        | Field | Value             |
        | Work  | david@johnson.com |
      * Save the contact
      * Refresh addressbook
      * Select "Johnson, David" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:David Johnson
      N:Johnson;David;;;
      X-EVOLUTION-FILE-AS:Johnson\, David
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      EMAIL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK:david@johnson.com
      END:VCARD
      """

    @testcase_240467
    Scenario: Create a contact with work, home and two other emails
      * Create a new contact
      * Set "Full Name..." in contact editor to "Evan Johnson"
      * Set emails in contact editor to
        | Field | Value |
        | Work  | evan.johnson@company.com |
        | Home  | johnson_evan_72@gmail.com |
        | Other | evanjohnson72@yahoo.com |
        | Other | johnson@free_email.com |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Evan" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Evan Johnson
      N:Johnson;Evan;;;
      X-EVOLUTION-FILE-AS:Johnson\, Evan
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      EMAIL;X-EVOLUTION-UI-SLOT=1;TYPE=OTHER:johnson@free_email.com
      EMAIL;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:johnson_evan_72@gmail.com
      EMAIL;X-EVOLUTION-UI-SLOT=3;TYPE=OTHER:evanjohnson72@yahoo.com
      EMAIL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK:evan.johnson@company.com
      END:VCARD
      """

    @testcase_240468
    Scenario: Create a contact with "Wants to receive HTML mails" set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Fred Johnson"
      * Tick "Wants to receive HTML mail" checkbox
      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Fred" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Fred Johnson
      N:Johnson;Fred;;;
      X-EVOLUTION-FILE-AS:Johnson\, Fred
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:TRUE
      END:VCARD
      """

    @testcase_240469
    Scenario: Create a contact with business telephone
      * Create a new contact
      * Set "Full Name..." in contact editor to "George Johnson"
      * Set phones in contact editor to
        | Field          | Value |
        | Business Phone | 123   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, George" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      TEL;X-EVOLUTION-UI-SLOT=4;TYPE=WORK,VOICE:123
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:George Johnson
      N:Johnson;George;;;
      X-EVOLUTION-FILE-AS:Johnson\, George
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240470
    Scenario: Create a contact with all phones set (part 1)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Hanna Johnson"
      * Set phones in contact editor to
        | Field           | Value |
        | Assistant Phone | 123 |
        | Business Phone  | 234 |
        | Business Fax    | 345 |
        | Callback Phone  | 456 |
        | Car Phone       | 567 |
        | Company Phone   | 678 |
        | Home Phone      | 789 |
        | Home Fax        | 890 |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Hanna" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
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
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:Hanna Johnson
      N:Johnson;Hanna;;;
      X-EVOLUTION-FILE-AS:Johnson\, Hanna
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240471
    Scenario: Create a contact with all phones set (part 2)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Ian Johnson"
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
      * Select "Johnson, Ian" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
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
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:Ian Johnson
      N:Johnson;Ian;;;
      X-EVOLUTION-FILE-AS:Johnson\, Ian
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240472
    Scenario: Create a contact with all IM set (part 1)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Jack Johnson"
      * Set IMs in contact editor to
        | Field     | Value |
        | AIM       | 123   |
        | Jabber    | 234   |
        | Yahoo     | 345   |
        | Gadu-Gadu | 456   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Jack" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Jack Johnson
      N:Johnson;Jack;;;
      X-EVOLUTION-FILE-AS:Johnson\, Jack
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      X-AIM;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      X-JABBER;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-YAHOO;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-GADUGADU;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      END:VCARD
      """

    @testcase_240473
    Scenario: Create a contact with all IM set (part 2)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Kyle Johnson"
      * Set IMs in contact editor to
        | Field     | Value |
        | MSN       | 123   |
        | ICQ       | 234   |
        | GroupWise | 345   |
        | Skype     | 456   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Kyle" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Kyle Johnson
      N:Johnson;Kyle;;;
      X-EVOLUTION-FILE-AS:Johnson\, Kyle
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      X-MSN;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      X-ICQ;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-GROUPWISE;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-SKYPE;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      END:VCARD
      """

    @testcase_240474
    Scenario: Create a contact with all IM set (part 3)
      * Create a new contact
      * Set "Full Name..." in contact editor to "Matthew Johnson"
      * Set IMs in contact editor to
        | Field   | Value |
        | Twitter | 123   |
        | ICQ     | 234   |
        | Jabber  | 345   |
        | Skype   | 456   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Matthew" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Matthew Johnson
      N:Johnson;Matthew;;;
      X-EVOLUTION-FILE-AS:Johnson\, Matthew
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      X-JABBER;X-EVOLUTION-UI-SLOT=3;TYPE=HOME:345
      X-ICQ;X-EVOLUTION-UI-SLOT=2;TYPE=HOME:234
      X-SKYPE;X-EVOLUTION-UI-SLOT=1;TYPE=HOME:456
      X-TWITTER;X-EVOLUTION-UI-SLOT=4;TYPE=HOME:123
      END:VCARD
      """

    @testcase_240475
    Scenario: Create a contact with all web pages set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Nick Johnson"
      * Switch to "Personal Information" tab in contact editor
      * Set the following properties in contact editor
        | Field | Value |
        | Home Page: | http://nick-johnson.com |
        | Blog: | http://blog.nick-johnson.com |
        | Calendar: | caldav://nick-johnson.com/calendar.ics |
        | Free/Busy: | http://nick-johnson.com/free-busy |
        | Video Chat: | http://nick-johnson.com/video-chat |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Nick" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:http://nick-johnson.com
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:Nick Johnson
      N:Johnson;Nick;;;
      X-EVOLUTION-FILE-AS:Johnson\, Nick
      X-EVOLUTION-BLOG-URL:http://blog.nick-johnson.com
      CALURI:caldav://nick-johnson.com/calendar.ics
      FBURL:http://nick-johnson.com/free-busy
      X-EVOLUTION-VIDEO-URL:http://nick-johnson.com/video-chat
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240476
    Scenario: Create a contact with all job fields set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Olaf Johnson"
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
      * Select "Johnson, Olaf" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:
      TITLE:Dr.
      ORG:Something Ltd.;Desktop QA;
      ROLE:QA Engineer
      X-EVOLUTION-MANAGER:John Doe
      X-EVOLUTION-ASSISTANT:Anna Doe
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:
      FN:Olaf Johnson
      N:Johnson;Olaf;;;
      X-EVOLUTION-FILE-AS:Johnson\, Olaf
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240477
    Scenario: Create a contact with all miscellaneous fields set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Pamela Johnson"
      * Switch to "Personal Information" tab in contact editor
      * Set the following properties in contact editor
        | Field   | Value    |
        | Office: | 221b     |
        | Spouse: | Jack Doe |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Pamela" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:Jack Doe
      ORG:;;221b
      NOTE:
      FN:Pamela Johnson
      N:Johnson;Pamela;;;
      X-EVOLUTION-FILE-AS:Johnson\, Pamela
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """

    @testcase_240478
    Scenario: Create a contact with Home address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Quentin Johnson"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Home" section of contact editor
        | Field            | Value             |
        | City:            | Brno              |
        | Zip/Postal Code: | 61245             |
        | State/Province:  | Brno-Kralovo Pole |
        | Country:         | Czech Republic    |
        | PO Box:          | 123456            |
        | Address:         | Purkynova 99/71   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Quentin" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Quentin Johnson
      N:Johnson;Quentin;;;
      X-EVOLUTION-FILE-AS:Johnson\, Quentin
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      ADR;TYPE=HOME:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech Re
       public
      LABEL;TYPE=HOME:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\nC
       zech Republic
      END:VCARD
      """

    @testcase_240479
    Scenario: Create a contact with Work address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Ralph Johnson"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Work" section of contact editor
        | Field            | Value             |
        | City:            | Brno              |
        | Zip/Postal Code: | 61245             |
        | State/Province:  | Brno-Kralovo Pole |
        | Country:         | Czech Republic    |
        | PO Box:          | 123456            |
        | Address:         | Purkynova 99/71   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Ralph" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Ralph Johnson
      N:Johnson;Ralph;;;
      X-EVOLUTION-FILE-AS:Johnson\, Ralph
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      ADR;TYPE=WORK:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech Re
       public
      LABEL;TYPE=WORK:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\nC
       zech Republic
      END:VCARD
      """

    @testcase_240480
    Scenario: Create a contact with Other address set
      * Create a new contact
      * Set "Full Name..." in contact editor to "Stephen Johnson"
      * Switch to "Mailing Address" tab in contact editor
      * Set the following properties in "Other" section of contact editor
        | Field            | Value             |
        | City:            | Brno              |
        | Zip/Postal Code: | 61245             |
        | State/Province:  | Brno-Kralovo Pole |
        | Country:         | Czech Republic    |
        | PO Box:          | 123456            |
        | Address:         | Purkynova 99/71   |

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Stephen" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
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
      FN:Stephen Johnson
      N:Johnson;Stephen;;;
      X-EVOLUTION-FILE-AS:Johnson\, Stephen
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      ADR;TYPE=OTHER:123456;;Purkynova 99/71;Brno;Brno-Kralovo Pole;61245;Czech R
       epublic
      LABEL;TYPE=OTHER:Purkynova 99/71\nBrno\, Brno-Kralovo Pole\n61245\n123456\n
       Czech Republic
      END:VCARD
      """

    @testcase_240481
    Scenario: Create a contact with Notes
      * Create a new contact
      * Set "Full Name..." in contact editor to "Tim Johnson"
      * Switch to "Notes" tab in contact editor
      * Set the following note for the contact:
      """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim gravida elit, nec facilisis augue commodo quis.

      Sed ac metus quis tellus aliquet posuere non quis elit. Quisque non ante congue urna blandit accumsan.

      In vitae ligula risus. Nunc venenatis leo vel leo facilisis porta. Nam sed magna urna, venenatis.
      """

      * Save the contact
      * Refresh addressbook
      * Select "Johnson, Tim" contact
      * Save contact as VCard to "/tmp/tempcontact.vcf"
      Then "/tmp/tempcontact.vcf" file contents is:
      """
      BEGIN:VCARD
      VERSION:3.0
      URL:
      TITLE:
      ROLE:
      X-EVOLUTION-MANAGER:
      X-EVOLUTION-ASSISTANT:
      NICKNAME:
      X-EVOLUTION-SPOUSE:
      NOTE:Lorem ipsum dolor sit amet\, consectetur adipiscing elit. Sed dignissi
       m gravida elit\, nec facilisis augue commodo quis.\n\nSed ac metus quis te
       llus aliquet posuere non quis elit. Quisque non ante congue urna blandit a
       ccumsan.\n\nIn vitae ligula risus. Nunc venenatis leo vel leo facilisis po
       rta. Nam sed magna urna\, venenatis.
      FN:Tim Johnson
      N:Johnson;Tim;;;
      X-EVOLUTION-FILE-AS:Johnson\, Tim
      X-EVOLUTION-BLOG-URL:
      CALURI:
      FBURL:
      X-EVOLUTION-VIDEO-URL:
      X-MOZILLA-HTML:FALSE
      END:VCARD
      """
