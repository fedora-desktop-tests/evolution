# -*- coding: UTF-8 -*-
from behave import step
from dogtail.predicate import GenericPredicate
from dogtail.rawinput import keyCombo, typeText
from time import sleep
from behave_common_steps import wait_until
import pyatspi
from gi.repository import GLib
from __builtin__ import xrange


@step(u'Add a new task "{name}"')
def add_a_new_task(context, name):
    context.search_bar.grab_focus()
    keyCombo("<Tab>")
    typeText(name)
    keyCombo("<Enter>")


@step(u'Add a new task "{name}" via menu')
def add_new_task_via_menu(context, name):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Task').click()
    context.execute_steps(u'* Task editor with title "Task - No Summary" is opened')


@step(u'Add a new assigned task "{name}" via menu')
def add_new_assigned_task_via_menu(context, name):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Assigned Task').click()
    context.execute_steps(u'* Task editor with title "Assigned Task - No Summary" is opened')


@step(u'Select task "{name}"')
def select_task(context, name):
    context.execute_steps(u'* Search for "%s" task' % name)

    first_task_name = context.app.instance.child(roleName='heading').text

    for attempt in xrange(0, 10):
        selected_task = context.app.instance.child(roleName='heading')
        if selected_task.text == name:
            fail = False
            break
        keyCombo("<Down>")
        selected_task = context.app.instance.child(roleName='heading')
        if first_task_name == selected_task.text:
            fail = True
            break

    assert fail is not True, "Can't find task named '%s'" % name
    context.selected_task = selected_task


@step(u'Open "{name}" task in task editor')
def open_task_in_task_editor(context, name):
    context.execute_steps(u'* Select task "%s"' % name)
    context.app.instance.menu("File").click()
    context.app.instance.menu("File").menuItem("Open Task").click()
    context.execute_steps(u'* Task editor with title "Task - %s" is opened' % name)


@step(u'Open "{name}" assigned task in task editor')
def open_assigned_task_in_task_editor(context, name):
    context.execute_steps(u'* Select task "%s"' % name)
    context.app.instance.menu("File").click()
    context.app.instance.menu("File").menuItem("Open Task").click()
    context.execute_steps(u'* Task editor with title "Assigned Task - %s" is opened' % name)


@step(u'Delete "{name}" task')
def delete_task(context, name):
    context.execute_steps(u'* Select task "%s"' % name)
    context.app.instance.menu('Edit').click()
    context.app.instance.menu('Edit').menuItem('Delete Task').click()
    sleep(0.5)
    dialog = context.app.instance.findChild(GenericPredicate(roleName='dialog', name=' '), retry=False, requireResult=False)
    if dialog:
        dialog.button('Delete').click()
        sleep(0.5)
    else:
        dialog = context.app.instance.child(roleName='alert', name='Question')
        dialog.button('OK').click()
    assert wait_until(lambda x: x.dead, dialog), "Delete confirmation dialog didn't disappear"


@step(u'Search for "{name}" task')
def search_for_task(context, name):
    # Clear current search
    for attempts in range(0, 10):
        try:
            context.search_bar.text = ""
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.grab_focus()
    keyCombo("<Enter>")
    sleep(0.5)
    # Input new search term
    for attempts in range(0, 10):
        try:
            context.search_bar.text = name
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.grab_focus()
    keyCombo("<Enter>")
    sleep(0.5)
    # Switch to a first available task
    context.search_bar.grab_focus()
    keyCombo("<Tab>")
    sleep(0.1)
    keyCombo("<Esc>")
    sleep(0.1)
    context.search_bar.grab_focus()
    keyCombo("<Tab><Esc>")


@step(u'no tasks found')
def no_tasks_found(context):
    # Check that no heading is displayed after search has been performed
    heading = context.app.instance.findChild(
        GenericPredicate(roleName='heading'),
        retry=False, requireResult=False)
    context.assertion.assertIsNone(heading, "Task was unexpectedly found")


@step(u'Add new task list with discover')
def add_new_task_list_with_discover(context):
    add_new_task_list(context, True)


@step(u'Add new task list')
def add_new_task_list(context, discover=False):
    password = None
    # First, make sure that memo list has not already been added
    name = filter(lambda row: row['Field'] == 'Name:', context.table)[0]['Value']
    task_lists = context.app.instance.findChildren(GenericPredicate(name=name, roleName='table cell'))
    visible_task_lists = filter(lambda x: x.showing, task_lists)
    if visible_task_lists != []:
        # Task List was already added, move along
        return

    # Open 'new calendar' dialog
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Task List').click()

    # Fill in calendar details
    for row in context.table:
        if row['Field'] == 'Password':
            password = row['Value']
        else:
            context.execute_steps(u"""
                * Set "%s" to "%s" in new task list window
            """ % (row['Field'], row['Value']))

    if discover:
        context.app.instance.dialog('New Task List').button('Find Task Lists').click()
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')

        # Select first available calendar
        dialog = context.app.instance.dialog('Choose a Task List')
        dialog.child(roleName='table cell').click()
        dialog.button('Apply').click()
        assert wait_until(lambda x: x.dead, dialog), "Choose a Task List dialog didn't disappear"

        # Reset the calendar name
        context.execute_steps(u'* Set "Name:" to "%s" in new task list window' % name)
    context.app.instance.dialog('New Task List').button('OK').click()

    if not discover:
        # Authenticate
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')


@step(u'Set "{field}" to "{value}" in new task list window')
def set_field_to_value_in_new_task_list_window(context, field, value):
    dialog = context.app.instance.dialog('New Task List')
    if field == 'Type:':
        # Type: label doesn't point on a correct label
        widget = dialog.child(roleName='combo box')
        if widget.combovalue != value:
            widget.combovalue = value
    else:
        widgets = filter(lambda x: x.showing, dialog.findChildren(GenericPredicate(name=field)))
        if widgets == []:
            raise RuntimeError("Cannot find '%s' field in New Task List dialog" % field)
        widgets[0].parent.textentry('').text = value


@step(u'Delete all tasks which contain "{summary}"')
def delele_all_tasks_for_date(context, summary):
    for attempt in xrange(0, 10):
        # Perform search
        context.execute_steps(u'* Search for "%s" task' % summary)
        # Find the first available task
        if pyatspi.STATE_ENABLED in context.app.instance.button('Delete').getState().getStates():
            context.app.instance.button('Delete').click()
            sleep(0.5)
            dialog = context.app.instance.findChild(GenericPredicate(roleName='dialog', name=' '), retry=False, requireResult=False)
            if dialog:
                dialog.button('Delete').click()
                sleep(0.5)
            else:
                dialog = context.app.instance.child(roleName='alert', name='Question')
                dialog.button('OK').click()
            assert wait_until(lambda x: x.dead, dialog), "Delete confirmation dialog didn't disappear"
        else:
            break


@step(u'Mark task as {state}')
def mark_task_as_complete_incomplete(context, state):
    context.app.instance.menu('Edit').click()
    context.app.instance.menu('Edit').menuItem("Mark as %s" % state.capitalize()).click()


@step(u'Purge completed tasks and {action} purging')
def purge_completed(context, action):
    context.app.instance.menu('Actions').click()
    context.app.instance.menu('Actions').menuItem('Purge').click()
    dialog = context.app.instance.child(roleName='alert', name='Warning')
    if action == 'confirm':
        dialog.button('Yes').click()
    else:
        dialog.button('No').click()

    assert wait_until(lambda x: x.dead, dialog), "Erase confirmation dialog didn't disappear"


@step(u'Save memo as "{filename}"')
@step(u'Save task as "{filename}"')
def save_task_as_file(context, filename):
    import os
    os.system("rm -rf %s" % filename)

    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem("Save as iCalendar...").click()
    context.execute_steps(u"""
        * file select dialog with name "Save as iCalendar" is displayed
        * in file save dialog save file to "%s" clicking "Save"
        """ % filename)
