@bug @upstream_bug_711198
Feature: Tasks: Export

  Background:
    * Open Evolution via command and setup fake account
    * Open "Tasks" section
    * Delete all tasks which contain "Task"

   
    Scenario: Create task with all fields filled in
      * Add a new task "Task with all fields set" via menu
      * Set the following values in task editor:
        | Field        | Value                    |
        | Summary:     | Task with all fields set |
        | Start date:  | 01/01/2014               |
        | Due date:    | 02/02/2014               |
        | Description: | Important task!          |
      * Save and close task editor
      * Search for "Task with all fields set" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
        """
        BEGIN:VCALENDAR
        PRODID:-//Ximian//NONSGML Evolution Calendar//EN
        VERSION:2.0
        METHOD:PUBLISH
        BEGIN:VTODO
        SUMMARY:Task with all fields set
        DESCRIPTION:Important task!
        DUE;VALUE=DATE:20140202
        DTSTART;VALUE=DATE:20140101
        CLASS:PUBLIC
        PERCENT-COMPLETE:0
        PRIORITY:0
        SEQUENCE:1
        END:VTODO
        END:VCALENDAR

        """

    Scenario: Create an assigned task with dummy attendee
      * Add a new assigned task "Task 5" via menu
      * Set the following values in task editor:
        | Field    | Value         |
        | Summary: | Task assigned |
      * Add "Alan Doe" as attendee
      * Save and close task editor
      * Search for "Task assigned" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
        """
        BEGIN:VCALENDAR
        PRODID:-//Ximian//NONSGML Evolution Calendar//EN
        VERSION:2.0
        METHOD:PUBLISH
        BEGIN:VTODO
        SUMMARY:Task assigned
        CLASS:PUBLIC
        ORGANIZER;CN=DesktopQE User:MAILTO:test@test
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;
         RSVP=TRUE;CN=DesktopQE User;LANGUAGE=en:MAILTO:test@test
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;
         RSVP=TRUE;LANGUAGE=en:MAILTO:Alan Doe
        PERCENT-COMPLETE:0
        PRIORITY:0
        SEQUENCE:1
        END:VTODO
        END:VCALENDAR

        """

    Scenario: Create an assigned task with real contact
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
        | Field    | Value                    |
        | Summary: | Task assigned to contact |
      * Add "Cole Doe <cole.doe@company.com>" as "Chair Person" using Attendees dialog
      * Save and close task editor
      * Search for "Task assigned to contact" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
        """
        BEGIN:VCALENDAR
        PRODID:-//Ximian//NONSGML Evolution Calendar//EN
        VERSION:2.0
        METHOD:PUBLISH
        BEGIN:VTODO
        SUMMARY:Task assigned to contact
        CLASS:PUBLIC
        ORGANIZER;CN=DesktopQE User:MAILTO:test@test
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;
         RSVP=TRUE;CN=DesktopQE User;LANGUAGE=en:MAILTO:test@test
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=CHAIR;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;
         CN=Cole Doe;LANGUAGE=en:MAILTO:cole.doe@company.com
        PERCENT-COMPLETE:0
        PRIORITY:0
        SEQUENCE:1
        END:VTODO
        END:VCALENDAR

        """

    Scenario: Task in progress
      * Add a new task "Task in progress" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task in progress   |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Search for "Task in progress" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
          """
          BEGIN:VCALENDAR
          PRODID:-//Ximian//NONSGML Evolution Calendar//EN
          VERSION:2.0
          METHOD:PUBLISH
          BEGIN:VTODO
          SUMMARY:Task in progress
          CLASS:PUBLIC
          PERCENT-COMPLETE:25
          STATUS:IN-PROCESS
          PRIORITY:7
          URL:http://example.com
          SEQUENCE:1
          END:VTODO
          END:VCALENDAR

          """

    Scenario: Task completed
      * Add a new task "Task completed" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task completed     |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Open "Task completed" task in task editor
      * Set the following values in task editor:
        | Field     | Value                |
        | Status:   | Completed            |
        | Priority: | Normal               |
        | Web Page: | http://completed.com |
      * Save and close task editor
      * Search for "Task completed" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
          """
          BEGIN:VCALENDAR
          PRODID:-//Ximian//NONSGML Evolution Calendar//EN
          VERSION:2.0
          METHOD:PUBLISH
          BEGIN:VTODO
          SUMMARY:Task completed
          CLASS:PUBLIC
          PERCENT-COMPLETE:100
          STATUS:COMPLETED
          PRIORITY:5
          URL:http://completed.com
          SEQUENCE:2
          END:VTODO
          END:VCALENDAR

          """

    Scenario: Task cancelled
      * Add a new task "Task cancelled" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task cancelled     |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Open "Task cancelled" task in task editor
      * Set the following values in task editor:
        | Field     | Value                |
        | Status:   | Canceled             |
        | Priority: | Normal               |
        | Web Page: | http://completed.com |
      * Save and close task editor
      * Search for "Task cancelled" task
      * Save task as "/tmp/task.ics"
      Then "/tmp/task.ics" file contents is:
          """
          BEGIN:VCALENDAR
          PRODID:-//Ximian//NONSGML Evolution Calendar//EN
          VERSION:2.0
          METHOD:PUBLISH
          BEGIN:VTODO
          SUMMARY:Task cancelled
          CLASS:PUBLIC
          PERCENT-COMPLETE:25
          STATUS:CANCELLED
          PRIORITY:5
          URL:http://completed.com
          SEQUENCE:2
          END:VTODO
          END:VCALENDAR

          """
