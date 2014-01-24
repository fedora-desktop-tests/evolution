@testplan_9166
Feature: Calendar: File: Reminders

  Background:
    * Open Evolution via command and setup fake account
    * Close appointments window if it appears
    * Open "Calendar" section
    * Disable "Birthdays & Anniversaries" calendar
    * Select "Personal" calendar
    * Switch to "List View" in calendar
    * Change categories view to "Any Category"
    * Delete all events which contain "Reminder"

    @testcase_261547
    Scenario: Appointment: predefined: 15 minutes before start
      * Create new appointment
      * Set "Summary:" field in event editor to "Predefined reminders: 15 minutes before"
      * Open reminders window
      * Select predefined reminder "15 minutes before appointment"
      * Close reminders window
      * Set event start time in 16 minutes
      * Save the event and close the editor
      * Appointment reminders window pops up in 1 minute
      * Appointment reminders window contains reminder for "Predefined reminders: 15 minutes before" event

    @testcase_261548
    Scenario: Appointment: predefined: 1 hour before appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Predefined reminders: 1 hour before"
      * Open reminders window
      * Select predefined reminder "1 hour before appointment"
      * Close reminders window
      * Set event start time in 61 minutes
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Predefined reminders: 1 hour before" event

    @testcase_261549 @bug @type_text_fuck_up
    Scenario: Appointment: predefined: 1 day before appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Predefined reminders: 1 day before"
      * Open reminders window
      * Select predefined reminder "1 day before appointment"
      * Close reminders window
      * Set event start time in 1 minute
      * Set event start date in 1 day
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Predefined reminders: 1 day before" event

    @testcase_261550
    Scenario: Appointment: custom: alert 3 minutes before start of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: alert 3 minutes before"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with "Pop up an alert" 3 minute(s) before "start of appointment"
      * Close reminders window
      * Set event start time in 5 minutes
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom reminders: alert 3 minutes before" event

    @testcase_261551
    Scenario: Appointment: custom: alert 2 hour before start of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: alert 2 hours before"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with "Pop up an alert" 2 hour(s) before "start of appointment"
      * Close reminders window
      * Set event start time in 121 minutes
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom reminders: alert 2 hours before" event

    @testcase_261552 @bug @type_text_fuck_up
    Scenario: Appointment: custom: alert 2 days before start of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: alert 2 days before"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with "Pop up an alert" 2 day(s) before "start of appointment"
      * Close reminders window
      * Set event start time in 1 minute
      * Set event start date in 2 days
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom reminders: alert 2 days before" event

    @testcase_261553
    Scenario: Appointment: custom: alert 1 minute after start of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: alert 1 minute after start"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with "Pop up an alert" 1 minute(s) after "start of appointment"
      * Close reminders window
      * Set event start time in 1 minute
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom reminders: alert 1 minute after start" event

    @testcase_261554
    Scenario: Appointment: custom: alert 1 minute before end of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: alert 1 minute before end"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with "Pop up an alert" 1 minute(s) before "end of appointment"
      * Close reminders window
      * Set "For:" field in event editor to "00:02"
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom reminders: alert 1 minute before end" event

    @testcase_261555
    Scenario: Appointment: custom: run 1 minute after start of appointment
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: after start 1 minute before end"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with the following options:
       | Field        | Value              |
       | Action       | Run a program      |
       | Num          | 1                  |
       | Period       | minute(s)          |
       | Before/After | before             |
       | Start/End    | end of appointment |
       | Program:     | gnome-screenshot   |
       | Arguments:   | -i                 |
      * Close reminders window
      * Set "For:" field in event editor to "00:02"
      * Save the event and close the editor
      * Application trigger warning pops up in 3 minutes
      * Agree to run the specified program in application trigger warning window
      * "gnome-screenshot" is present in process list

    @testcase_261556
    Scenario: Appointment: custom: run 1 minute after start of appointment, don't start app
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: after start 1 minute before end"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with the following options:
       | Field        | Value              |
       | Action       | Run a program      |
       | Num          | 1                  |
       | Period       | minute(s)          |
       | Before/After | before             |
       | Start/End    | end of appointment |
       | Program:     | gnome-screenshot   |
       | Arguments:   | -i                 |
      * Close reminders window
      * Set "For:" field in event editor to "00:02"
      * Save the event and close the editor
      * Application trigger warning pops up in 3 minutes
      * Disagree to run the specified program in application trigger warning window
      * "gnome-screenshot" is not present in process list

    @testcase_261557
    Scenario: Appointment: custom message
      * Create new appointment
      * Set "Summary:" field in event editor to "Custom reminders: custom message"
      * Open reminders window
      * Select custom reminder
      * Add new reminder with the following options:
       | Field        | Value               |
       | Action       | Pop up an alert     |
       | Num          | 1                   |
       | Period       | minute(s)           |
       | Before/After | before              |
       | Start/End    | end of appointment  |
       | Message      | Custom message here |
      * Close reminders window
      * Set "For:" field in event editor to "00:02"
      * Save the event and close the editor
      * Appointment reminders window pops up in 3 minutes
      * Appointment reminders window contains reminder for "Custom message here" event
