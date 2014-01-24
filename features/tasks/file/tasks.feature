@bug @upstream_bug_711198 @testplan_8409
Feature: Tasks

  Background:
    * Open Evolution via command and setup fake account
    * Open "Tasks" section
    * Delete all tasks which contain "Task"

    @testcase_241614
    Scenario: Create a task
      * Add a new task "Task 1"
      * Open "Task 1" task in task editor
      Then Task editor has the following fields set:
        | Field        | Value  |
        | Summary:     | Task 1 |
        | Start date:  | None   |
        | Due date:    | None   |
        | Description: |        |

    @testcase_241615
    Scenario: Create task with all fields filled in
      * Add a new task "Task 2" via menu
      * Set the following values in task editor:
        | Field        | Value           |
        | Summary:     | Task 2          |
        | Start date:  | 01/01/2014      |
        | Due date:    | 02/02/2014      |
        | Description: | Important task! |
      * Save and close task editor
      * Open "Task 2" task in task editor
      Then Task editor has the following fields set:
        | Field        | Value           |
        | Summary:     | Task 2          |
        | Start date:  | 01/01/2014      |
        | Due date:    | 02/02/2014      |
        | Description: | Important task! |

    @testcase_241616
    Scenario: Edit a task
      * Add a new task "Task 3" via menu
      * Set the following values in task editor:
        | Field        | Value         |
        | Summary:     | Task 3        |
        | Start date:  | 02/02/2014    |
        | Due date:    | 03/03/2014    |
        | Description: | A normal task |
      * Save and close task editor
      * Open "Task 3" task in task editor
      * Set the following values in task editor:
        | Field        | Value           |
        | Summary:     | Task 3 updated  |
        | Start date:  | 03/03/2014      |
        | Due date:    | 04/04/2014      |
        | Description: | An updated task |
      * Save and close task editor
      * Open "Task 3 updated" task in task editor
      Then Task editor has the following fields set:
        | Field        | Value           |
        | Summary:     | Task 3 updated  |
        | Start date:  | 03/03/2014      |
        | Due date:    | 04/04/2014      |
        | Description: | An updated task |

    @testcase_241617
    Scenario: Delete a task
      * Add a new task "Task 4" via menu
      * Set the following values in task editor:
        | Field        | Value            |
        | Summary:     | Task 4           |
        | Start date:  | 04/04/2014       |
        | Due date:    | 05/05/2014       |
        | Description: | Delete this task |
      * Save and close task editor
      * Delete "Task 4" task
      * Search for "Task 4" task
      Then no tasks found

    Scenario: Purge completed tasks
      * Add a new task "Task purged" via menu
      * Set the following values in task editor:
        | Field        | Value              |
        | Summary:     | Task purged        |
        | Start date:  | 08/08/2014         |
        | Due date:    | 09/09/2014         |
        | Description: | Completed task     |
        | Status:      | Completed          |
        | Priority:    | Low                |
        | Web Page:    | http://example.com |
      * Save and close task editor
      * Purge completed tasks and confirm purging
      * Search for "Task purged" task
      Then no tasks found

    Scenario: Purge completed tasks - cancel
      * Add a new task "Task not purged" via menu
      * Set the following values in task editor:
        | Field        | Value              |
        | Summary:     | Task not purged    |
        | Start date:  | 08/08/2014         |
        | Due date:    | 09/09/2014         |
        | Description: | Completed task     |
        | Status:      | Completed          |
        | Priority:    | Low                |
        | Web Page:    | http://example.com |
      * Save and close task editor
      * Purge completed tasks and cancel purging
      * Open "Task not purged" task in task editor
      Then Task editor has the following fields set:
        | Field             | Value              |
        | Status:           | Completed          |
        | Percent complete: | 100                |
        | Priority:         | Low                |
        | Web Page:         | http://example.com |
