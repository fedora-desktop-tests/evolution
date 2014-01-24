@bug @upstream_bug_711198 @testplan_8411
Feature: Task details

  Background:
    * Open Evolution via command and setup fake account
    * Open "Tasks" section
    * Delete all tasks which contain "Task"

    @testcase_241626
    Scenario: Task in progress
      * Add a new task "Task 12" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task 12            |
        | Start date:       | 05/05/2014         |
        | Due date:         | 06/06/2014         |
        | Description:      | In progress task   |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Open "Task 12" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value              |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |

    @testcase_241627
    Scenario: Task completed
      * Add a new task "Task 13" via menu
      * Set the following values in task editor:
        | Field             | Value                 |
        | Summary:          | Task 13               |
        | Start date:       | 06/06/2014            |
        | Due date:         | 07/07/2014            |
        | Description:      | Almost completed task |
        | Status:           | In Progress           |
        | Percent complete: | 25                    |
        | Priority:         | Low                   |
        | Web Page:         | http://example.com    |
      * Save and close task editor
      * Open "Task 13" task in task editor
      * Set the following values in task editor:
        | Field             | Value                |
        | Status:           | Completed            |
        | Priority:         | Normal               |
        | Web Page:         | http://completed.com |
      * Save and close task editor
      * Open "Task 13" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value                |
        | Status:           | Completed            |
        | Percent complete: | 100                  |
        | Priority:         | Normal               |
        | Web Page:         | http://completed.com |

    Scenario: Task cancelled
      * Add a new task "Task 14" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task 14            |
        | Start date:       | 08/08/2014         |
        | Due date:         | 09/09/2014         |
        | Description:      | Canceled task      |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Open "Task 14" task in task editor
      * Set the following values in task editor:
        | Field             | Value              |
        | Status:           | Canceled           |
        | Percent complete: | 25                 |
        | Priority:         | High               |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Open "Task 14" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value              |
        | Status:           | Canceled           |
        | Percent complete: | 25                 |
        | Priority:         | High               |
        | Web Page:         | http://example.com |

    Scenario: Mark task as complete
      * Add a new task "Task 15" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task 15            |
        | Start date:       | 08/08/2014         |
        | Due date:         | 09/09/2014         |
        | Description:      | Completed task     |
        | Status:           | In Progress        |
        | Percent complete: | 25                 |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Search for "Task 15" task
      * Mark task as complete
      * Open "Task 15" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value              |
        | Status:           | Completed          |
        | Percent complete: | 100                |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |

    Scenario: Mark task as incomplete
      * Add a new task "Task 16" via menu
      * Set the following values in task editor:
        | Field             | Value              |
        | Summary:          | Task 16            |
        | Start date:       | 08/08/2014         |
        | Due date:         | 09/09/2014         |
        | Description:      | Completed task     |
        | Status:           | Completed          |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
      * Save and close task editor
      * Search for "Task 16" task
      * Mark task as incomplete
      * Open "Task 16" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value              |
        | Status:           | Not Started        |
        | Percent complete: | 0                  |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
