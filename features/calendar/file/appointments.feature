@testplan_8353
Feature: Calendar: File: Appointments

  Background:
    * Open Evolution via command and setup fake account
    * Open "Calendar" section
    * Disable "Birthdays & Anniversaries" calendar
    * Select "Personal" calendar
    * Switch to "List View" in calendar
    * Change calendar month to January 2014
    * Change categories view to "Any Category"
    * Delete all events which contain "Appointment"

  @testcase_240983
  Scenario: Create an appointment with duration specified
    * Create new appointment
    * Set the following fields in event editor:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with John |
      | Location: | Room 101              |
      | Time:     | 01/01/2014 19:00      |
      | For:      | 2:50                  |
    * Save the event and close the editor
    * Search for events which contain "John"
    * Open first "Appointment with John" appointment
    Then Event has the following details:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with John |
      | Location: | Room 101              |
      | Time:     | 01/01/2014  7:00 pm   |
      | Until:    | 01/01/2014  9:50 pm   |

  @testcase_240984
  Scenario: Create an appointment with end date specified
    * Create new appointment
    * Set the following fields in event editor:
      | Field     | Value                |
      | Calendar: | Personal             |
      | Summary:  | Appointment with Jim |
      | Location: | Room 201             |
      | Time:     | 01/01/2014 19:00     |
      | Until:    | 01/01/2014 20:00     |
    * Save the event and close the editor
    * Search for events which contain "Jim"
    * Open first "Appointment with Jim" appointment
    Then Event has the following details:
      | Field     | Value                |
      | Calendar: | Personal             |
      | Summary:  | Appointment with Jim |
      | Location: | Room 201             |
      | Time:     | 01/01/2014  7:00 pm  |
      | Until:    | 01/01/2014  8:00 pm  |

  @testcase_240985
  Scenario: Create all day appointment
    * Create new all day appointment
    * Set the following fields in event editor:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with Jeff |
      | Location: | Room 205              |
      | Time:     | 01/01/2014            |
    * Save the event and close the editor
    * Search for events which contain "Jeff"
    * Open first "Appointment with Jeff" appointment
    Then Event has the following details:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with Jeff |
      | Location: | Room 205              |
      | Time:     | 01/01/2014            |
      | Until:    | 01/01/2014            |

  # Need to make sure that all test targets will have the same timezone
  # @wip
  # Scenario: Create appointment in another timezone
  #   * Create new appointment
  #   * Show time zone in event editor
  #   * Set the following fields in event editor:
  #     | Field     | Value                 |
  #     | Calendar: | Personal              |
  #     | Summary:  | Appointment with Mike |
  #     | Location: | Room 207              |
  #     | Time:     | 01/01/2014 19:00      |
  #     | Until:    | 01/01/2014 20:00      |
  #     | Timezone: | Africa/Abidjan        |
  #   * Save the event and close the editor
  #   * Search for events which contain "Mike"
  #   * Open first "Appointment with Mike" appointment
  #   Then Event has the following details:
  #     | Field     | Value                 |
  #     | Calendar: | Personal              |
  #     | Summary:  | Appointment with Mike |
  #     | Location: | Room 207              |
  #     | Time:     | 01/01/2014 19:00      |
  #     | Until:    | 01/01/2014 20:00      |
  #     | Timezone: | Africa/Abidjan        |

  @testcase_261541
  Scenario: Create appointment with categories
    * Create new appointment
    * Show categories in event editor
    * Set the following fields in event editor:
      | Field       | Value                  |
      | Calendar:   | Personal               |
      | Summary:    | Appointment with Kevin |
      | Location:   | Room 208               |
      | Time:       | 01/01/2014 19:00       |
      | Until:      | 01/01/2014 20:00       |
      | Categories: | Business, Key Customer |
    * Save the event and close the editor
    * Change categories view to "Business"
    * Search for events which contain "Kevin"
    * Open first "Appointment with Kevin" appointment
    Then Event has the following details:
      | Field       | Value                  |
      | Calendar:   | Personal               |
      | Summary:    | Appointment with Kevin |
      | Location:   | Room 208               |
      | Time:       | 01/01/2014  7:00 pm    |
      | Until:      | 01/01/2014  8:00 pm    |
      | Categories: | Business,Key Customer  |

  @testcase_240986
  Scenario: Edit created appoinment
    * Create new appointment
    * Set the following fields in event editor:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with Bill |
      | Location: | Room 101              |
      | Time:     | 01/01/2014 19:00      |
      | For:      | 2:50                  |
    * Save the event and close the editor
    * Search for events which contain "Bill"
    * Open first "Appointment with Bill" appointment
    * Set the following fields in event editor:
      | Field     | Value            |
      | Location: | Room 301         |
      | Time:     | 01/01/2014 17:00 |
      | For:      | 00:30            |
    * Save the event and close the editor
    * Search for events which contain "Bill"
    * Open first "Appointment with Bill" appointment
    Then Event has the following details:
      | Field     | Value                 |
      | Calendar: | Personal              |
      | Summary:  | Appointment with Bill |
      | Location: | Room 301              |
      | Time:     | 01/01/2014  5:00 pm   |
      | Until:    | 01/01/2014  5:30 pm   |

  @testcase_240987
  Scenario: Delete appoinment
    * Create new appointment
    * Set the following fields in event editor:
      | Field     | Value                |
      | Calendar: | Personal             |
      | Summary:  | Appointment with Tim |
      | Location: | Room 401             |
      | Time:     | 01/01/2014 19:00     |
      | Until:    | 01/01/2014 20:00     |
    * Save the event and close the editor
    * Search for events which contain "Tim"
    * Delete the selected event
    * Search for events which contain "Tim"
    Then event list is empty

  @testcase_261543
  Scenario: Create an appointment with attachment
    * Save the following text in "/tmp/tempattachment.txt":
    """
    Plain text to be stored as attachment to the appointment
    """
    * Create new appointment
    * Set the following fields in event editor:
      | Field     | Value                   |
      | Calendar: | Personal                |
      | Summary:  | Appointment with Vinnie |
      | Location: | Room 101                |
      | Time:     | 01/01/2014 19:00        |
      | For:      | 2:50                    |
    * Add "/tmp/tempattachment.txt" attachment in event editor
    * Save the event and close the editor
    * Search for events which contain "Vinnie"
    * Open first "Appointment with Vinnie" appointment
    * Save attachment "tempattachment.txt" in event editor to "/tmp/tempattachment_received.txt"
    Then "/tmp/tempattachment_received.txt" file contents is:
      """
      Plain text to be stored as attachment to the appointment
      """
