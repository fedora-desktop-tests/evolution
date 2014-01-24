@bug @upstream_bug_711198 @testplan_8410
Feature: Assigned tasks

  Background:
    * Open Evolution via command and setup fake account
    * Open "Tasks" section
    * Delete all tasks which contain "Task"

    @testcase_241619
    Scenario: Create a task with attendee
      * Add a new assigned task "Task 5" via menu
      * Set the following values in task editor:
        | Field        | Value           |
        | Summary:     | Task 5          |
        | Start date:  | 01/01/2014      |
        | Due date:    | 02/02/2014      |
        | Description: | Important task! |
      * Add "Alan Doe" as attendee
      * Save and close task editor
      * Open "Task 5" assigned task in task editor
      Then "Alan Doe" as "Required Participant" is present in attendees list

    @testcase_241620 
    Scenario: Contact names are prefilled from addressbook
      * Open "Contacts" section
      * Create a new contact
      * Set "Full Name..." in contact editor to "Barry Doe"
      * Set emails in contact editor to
        | Field | Value                 |
        | Work  | barry.doe@company.com |
      * Save the contact
      * Refresh addressbook
      * Open "Tasks" section
      * Add a new assigned task "Task 6" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task 6        |
        | Start date:  | 02/02/2014    |
        | Due date:    | 03/03/2014    |
        | Description: | A normal task |
      * Select first suggestion as attendee typing "Barry"
      * Save and close task editor
      * Open "Task 6" assigned task in task editor
      Then "Barry Doe" as "Required Participant" is present in attendees list

    @testcase_241621 
    Scenario: Contact list names are prefilled from addressbook
      * Open "Contacts" section
      * Create a new contact list
      * Set contact list name to "Coworkers"
      * Add "john@company2.com" to the contact list
      * Add "jack@company2.com" to the contact list
      * Add "jill@company2.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Open "Tasks" section
      * Add a new assigned task "Task 7" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task 7        |
        | Start date:  | 03/03/2014    |
        | Due date:    | 04/04/2014    |
        | Description: | A normal task |
      * Select first suggestion as attendee typing "Coworkers"
      * Save and close task editor
      * Open "Task 7" assigned task in task editor
      Then The following attendees are present in the list:
         | Name              | Role                 |
         | john@company2.com | Required Participant |
         | jack@company2.com | Required Participant |
         | jill@company2.com | Required Participant |

    @testcase_241622
    Scenario: Add contact using Attendees button
      * Open "Contacts" section
      * Create a new contact
      * Set "Full Name..." in contact editor to "Cole Doe"
      * Set emails in contact editor to
        | Field | Value                |
        | Work  | cole.doe@company.com |
      * Save the contact
      * Refresh addressbook
      * Open "Tasks" section
      * Add a new assigned task "Task 8" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task 8        |
        | Start date:  | 04/04/2014    |
        | Due date:    | 05/05/2014    |
        | Description: | A normal task |
      * Add "Cole Doe <cole.doe@company.com>" as "Chair Person" using Attendees dialog
      * Save and close task editor
      * Open "Task 8" assigned task in task editor
      Then "Cole Doe" as "Chair" is present in attendees list

    @testcase_241623
    Scenario: Add contact using Attendees button
      * Open "Contacts" section
      * Create a new contact list
      * Set contact list name to "Colleagues"
      * Add "john@company2.com" to the contact list
      * Add "jack@company2.com" to the contact list
      * Add "jill@company2.com" to the contact list
      * Save the contact list
      * Refresh addressbook
      * Open "Tasks" section
      * Add a new assigned task "Task 9" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task 9        |
        | Start date:  | 05/05/2014    |
        | Due date:    | 06/06/2014    |
        | Description: | A normal task |
      * Add "Colleagues" as "Optional Participant" using Attendees dialog
      * Save and close task editor
      * Open "Task 9" assigned task in task editor
      Then The following attendees are present in the list:
        | Name              | Role                 |
        | john@company2.com | Optional Participant |
        | jack@company2.com | Optional Participant |
        | jill@company2.com | Optional Participant |

    @testcase_241624 
    Scenario: Edit an assigned task
      * Open "Contacts" section
      * Create a new contact
      * Set "Full Name..." in contact editor to "Damon Doe"
      * Set emails in contact editor to
        | Field | Value                 |
        | Work  | damon.doe@company.com |
      * Save the contact
      * Refresh addressbook
      * Create a new contact
      * Set "Full Name..." in contact editor to "Edward Doe"
      * Set emails in contact editor to
        | Field | Value                  |
        | Work  | edward.doe@company.com |
      * Save the contact
      * Refresh addressbook
      * Open "Tasks" section
      * Add a new assigned task "Task A" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task A        |
        | Start date:  | 06/06/2014    |
        | Due date:    | 07/07/2014    |
        | Description: | A normal task |
      * Select first suggestion as attendee typing "Damon"
      * Save and close task editor
      * Open "Task A" assigned task in task editor
      * Set the following values in task editor:
        | Field        | Value            |
        | Summary:     | Task A updated   |
        | Start date:  | 03/03/2014       |
        | Due date:    | 04/04/2014       |
        | Description: | An updated task  |
      * Remove "Damon Doe" from attendee list
      * Select first suggestion as attendee typing "Edward"
      * Save and close task editor
      * Open "Task A updated" assigned task in task editor
      Then "Edward Doe" as "Required Participant" is present in attendees list

    @testcase_241625
    Scenario: Delete an assigned task
      * Add a new assigned task "Task 4" via menu
      * Set the following values in task editor:
        | Field        | Value            |
        | Summary:     | Task 11          |
        | Start date:  | 04/04/2014       |
        | Due date:    | 05/05/2014       |
        | Description: | Delete this task |
      * Save and close task editor
      * Delete "Task 11" task
      * Search for "Task 11" task
      Then no tasks found
