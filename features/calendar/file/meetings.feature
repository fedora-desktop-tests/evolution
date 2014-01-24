@testplan_8354
Feature: Calendar: File: Meetings

  Background:
    * Open Evolution via command and setup fake account
    * Open "Calendar" section
    * Disable "Birthdays & Anniversaries" calendar
    * Select "Personal" calendar
    * Switch to "List View" in calendar
    * Change calendar month to February 2014
    * Change categories view to "Any Category"
    * Delete all events which contain "Meeting"

  @testcase_240988
  Scenario: Create an meeting with duration specified
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value             |
      | Calendar: | Personal          |
      | Summary:  | Meeting with Adam |
      | Location: | Room 101          |
      | Time:     | 02/02/2014 19:00  |
      | For:      | 1:50              |
    * Save the event and close the editor
    * Search for events which contain "Adam"
    * Open first "Meeting with Adam" meeting
    Then Event has the following details:
      | Field     | Value               |
      | Calendar: | Personal            |
      | Summary:  | Meeting with Adam   |
      | Location: | Room 101            |
      | Time:     | 02/02/2014  7:00 pm |
      | Until:    | 02/02/2014  8:50 pm |

  # Need to make sure that all test targets will have the same timezone
  # @wip
  # Scenario: Create an meeting with different timezone
  #   * Create new meeting
  #   * Show time zone in event editor
  #   * Set the following fields in event editor:
  #     | Field     | Value             |
  #     | Calendar: | Personal          |
  #     | Summary:  | Meeting with Adam |
  #     | Location: | Room 101          |
  #     | Time:     | 02/02/2014 19:00  |
  #     | For:      | 1:50              |
  #     | Timezone: | Africa/Abidjan    |
  #   * Save the meeting and choose not to send meeting invitations
  #   * Search for events which contain "Adam"
  #   * Open first "Meeting with Adam" meeting
  #   Then Event has the following details:
  #     | Field     | Value             |
  #     | Calendar: | Personal          |
  #     | Summary:  | Meeting with Adam |
  #     | Location: | Room 101          |
  #     | Time:     | 02/02/2014 19:00  |
  #     | Until:    | 02/02/2014 20:50  |
  #     | Timezone: | Africa/Abidjan    |

  @testcase_240989
  Scenario: Create an meeting with attendees
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value             |
      | Calendar: | Personal          |
      | Summary:  | Meeting with Bill |
      | Location: | Room 101          |
      | Time:     | 02/02/2014 19:00  |
      | For:      | 1:50              |
    * Add "Bill Doe" as attendee
    * Save the meeting and choose not to send meeting invitations
    * Search for events which contain "Bill"
    * Open first "Meeting with Bill" meeting
    Then "Bill Doe" as "Required Participant" is present in attendees list

  @testcase_240990 
  Scenario: Contact names are prefilled from addressbook
    * Open "Contacts" section
    * Create contact "Chris Doe" with email set to "chris.doe@company.com"
    * Open "Calendar" section
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value              |
      | Calendar: | Personal           |
      | Summary:  | Meeting with Chris |
      | Location: | Room 101           |
      | Time:     | 02/02/2014 15:00   |
      | For:      | 1:50               |
    * Select first suggestion as attendee typing "Chris"
    * Save the meeting and choose not to send meeting invitations
    * Search for events which contain "Chris"
    * Open first "Meeting with Chris" meeting
    Then "Chris Doe" as "Required Participant" is present in attendees list

  @testcase_240991 
  Scenario: Contact list names are prefilled from addressbook
    * Open "Contacts" section
    * Create a new contact list
    * Set contact list name to "Coworkers"
    * Add "john@company1.com" to the contact list
    * Add "jack@company1.com" to the contact list
    * Add "jill@company1.com" to the contact list
    * Save the contact list
    * Refresh addressbook
    * Open "Calendar" section
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value                  |
      | Calendar: | Personal               |
      | Summary:  | Meeting with coworkers |
      | Location: | Room 101               |
      | Time:     | 02/02/2014 15:00       |
      | For:      | 1:50                   |
    * Select first suggestion as attendee typing "Coworkers"
    * Save the meeting and choose not to send meeting invitations
    * Search for events which contain "coworkers"
    * Open first "Meeting with coworkers" meeting
    Then The following attendees are present in the list:
       | Name              | Role                 |
       | john@company1.com | Required Participant |
       | jack@company1.com | Required Participant |
       | jill@company1.com | Required Participant |

  @testcase_240992
  Scenario: Add contact using Attendees button
    * Open "Contacts" section
    * Create contact "Daniel Doe" with email set to "daniel.doe@company.com"
    * Open "Calendar" section
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value               |
      | Calendar: | Personal            |
      | Summary:  | Meeting with Daniel |
      | Location: | Room 101            |
      | Time:     | 02/02/2014 15:00    |
      | For:      | 1:50                |
    * Add "Daniel Doe <daniel.doe@company.com>" as "Chair Person" using Attendees dialog
    * Save the meeting and choose not to send meeting invitations
    * Search for events which contain "Daniel"
    * Open first "Meeting with Daniel" meeting
    Then "Daniel Doe" as "Chair" is present in attendees list

  @testcase_240993
  Scenario: Add contact list using Attendees button
    * Open "Contacts" section
    * Create a new contact list
    * Set contact list name to "Colleagues"
    * Add "john@company2.com" to the contact list
    * Add "jack@company2.com" to the contact list
    * Add "jill@company2.com" to the contact list
    * Save the contact list
    * Refresh addressbook
    * Open "Calendar" section
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value                   |
      | Calendar: | Personal                |
      | Summary:  | Meeting with colleagues |
      | Location: | Room 101                |
      | Time:     | 02/02/2014 15:00        |
      | For:      | 1:50                    |
    * Add "Colleagues" as "Optional Participant" using Attendees dialog
    * Save the meeting and choose not to send meeting invitations
    * Search for events which contain "colleagues"
    * Open first "Meeting with colleagues" meeting
    Then The following attendees are present in the list:
       | Name              | Role                 |
       | john@company2.com | Optional Participant |
       | jack@company2.com | Optional Participant |
       | jill@company2.com | Optional Participant |

  @testcase_240994
  Scenario: Edit meeting
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value             |
      | Calendar: | Personal          |
      | Summary:  | Meeting with Evan |
      | Location: | Room 101          |
      | Time:     | 02/02/2014 19:00  |
      | For:      | 1:50              |
    * Save the event and close the editor
    * Search for events which contain "Evan"
    * Open first "Meeting with Evan" meeting
    * Set the following fields in event editor:
      | Field     | Value              |
      | Summary:  | Meeting with Edgar |
      | Location: | Room 501           |
      | Time:     | 02/02/2014 15:00   |
    * Save the event and close the editor
    * Search for events which contain "Edgar"
    * Open first "Meeting with Edgar" meeting
    Then Event has the following details:
      | Field     | Value               |
      | Calendar: | Personal            |
      | Summary:  | Meeting with Edgar  |
      | Location: | Room 501            |
      | Time:     | 02/02/2014  3:00 pm |
      | Until:    | 02/02/2014  4:50 pm |

  @testcase_240995
  Scenario: Delete meeting
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value             |
      | Calendar: | Personal          |
      | Summary:  | Meeting with Fitz |
      | Location: | Room 101          |
      | Time:     | 02/02/2014 19:00  |
      | For:      | 1:50              |
    * Save the event and close the editor
    * Search for events which contain "Fitz"
    * Delete the selected event
    * Select "Do not Send" in cancellation notice dialog
    * Search for events which contain "Fitz"
    Then event list is empty

  @testcase_261546
  Scenario: Create a meeting with attachment
    * Save the following text in "/tmp/tempattachment.txt":
    """
    Plain text to be stored as attachment to the appointment
    """
    * Create new meeting
    * Set the following fields in event editor:
      | Field     | Value               |
      | Calendar: | Personal            |
      | Summary:  | Meeting with Vinnie |
      | Location: | Room 101            |
      | Time:     | 02/02/2014 19:00    |
      | For:      | 2:50                |
    * Add "/tmp/tempattachment.txt" attachment in event editor
    * Save the event and close the editor
    * Search for events which contain "Vinnie"
    * Open first "Meeting with Vinnie" meeting
    * Save attachment "tempattachment.txt" in event editor to "/tmp/tempattachment_received.txt"
    Then "/tmp/tempattachment_received.txt" file contents is:
      """
      Plain text to be stored as attachment to the appointment
      """
