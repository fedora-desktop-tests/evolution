# -*- coding: UTF-8 -*-
from behave import step
from dogtail.predicate import GenericPredicate
import dogtail.rawinput
from time import sleep
from behave_common_steps import wait_until
import pyatspi
from gi.repository import GLib
from __builtin__ import xrange


@step(u'Memo editor with title "{name}" is opened')
def memo_editor_is_opened(context, name):
    context.execute_steps(u'* Task editor with title "%s" is opened' % name)


@step(u'Shared Memo editor with title "{name}" is opened')
def shared_memo_editor_is_opened(context, name):
    context.execute_steps(u'* Task editor with title "%s" is opened' % name)


@step(u'Add a new shared memo "{name}"')
@step(u'Add a new memo "{name}"')
def add_a_new_memo(context, name):
    context.search_bar.grab_focus()
    dogtail.rawinput.keyCombo("<Tab>")
    dogtail.rawinput.typeText(name)
    dogtail.rawinput.keyCombo("<Enter>")


@step(u'Add a new shared memo "{name}" via menu')
def add_new_shared_memo_via_menu(context, name):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Shared Memo').click()
    context.execute_steps(u'* Task editor with title "Memo - No Summary" is opened')


@step(u'Add a new memo "{name}" via menu')
def add_new_memo_via_menu(context, name):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Memo').click()
    context.execute_steps(u'* Task editor with title "Memo - No Summary" is opened')


@step(u'Select memo "{name}"')
def select_memo(context, name):
    context.execute_steps(u'* Search for "%s" memo' % name)

    first_memo_name = context.app.instance.child(roleName='heading').text

    for attempts in xrange(0, 10):
        selected_memo = context.app.instance.child(roleName='heading')
        if selected_memo.text == name:
            fail = False
            break
        dogtail.rawinput.keyCombo("<Down>")
        selected_memo = context.app.instance.child(roleName='heading')
        if first_memo_name == selected_memo.text:
            fail = True
            break

    context.assertion.assertFalse(fail, "Can't find memo named '%s'" % name)
    context.selected_memo = selected_memo


@step(u'Open shared "{name}" memo in memo editor')
@step(u'Open "{name}" memo in memo editor')
def open_memo_in_memo_editor(context, name):
    context.execute_steps(u'* Select memo "%s"' % name)
    context.app.instance.menu("File").click()
    context.app.instance.menu("File").menuItem("Open Memo").click()
    context.execute_steps(u'* Task editor with title "Memo - %s" is opened' % name)


@step(u'Delete "{name}" memo')
def delete_memo(context, name):
    context.execute_steps(u'* Select memo "%s"' % name)
    context.app.instance.menu('Edit').click()
    context.app.instance.menu('Edit').menuItem('Delete Memo').click()
    dialog = context.app.instance.dialog(' ')
    dialog.button('Delete').click()
    sleep(0.5)
    assert wait_until(lambda x: x.dead, dialog),\
        "Delete confirmation dialog didn't disappear"


@step(u'Search for "{name}" memo')
def search_for_memo(context, name):
    # Clear current search
    for attempts in range(0, 10):
        try:
            context.search_bar.text = ""
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.grab_focus()
    dogtail.rawinput.keyCombo("<Enter>")
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
    dogtail.rawinput.keyCombo("<Enter>")
    sleep(0.5)
    # Switch to a first available memo
    context.search_bar.grab_focus()
    dogtail.rawinput.keyCombo("<Tab>")
    sleep(0.1)
    dogtail.rawinput.keyCombo("<Esc>")
    sleep(0.1)
    context.search_bar.grab_focus()
    dogtail.rawinput.keyCombo("<Tab><Esc>")


@step(u'no memos found')
def no_memos_found(context):
    # Check that no heading is displayed after search has been performed
    heading = context.app.instance.findChild(
        GenericPredicate(roleName='heading'), retry=False, requireResult=False)
    context.assertion.assertIsNone(heading, "Memo was unexpectedly found")


@step(u'Add new memo list with discover')
def add_new_memo_list_with_discover(context):
    add_new_memo_list(context, True)


@step(u'Add new memo list')
def add_new_memo_list(context, discover=False):
    password = None
    # First, make sure that memo list has not already been added
    name = filter(lambda row: row['Field'] == 'Name:', context.table)[0]['Value']
    memo_lists = context.app.instance.findChildren(GenericPredicate(name=name, roleName='table cell'))
    visible_memo_lists = filter(lambda x: x.showing, memo_lists)
    if visible_memo_lists != []:
        # Memo List was already added, move along
        return

    # Open 'new calendar' dialog
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Memo List').click()

    # Fill in calendar details
    for row in context.table:
        if row['Field'] == 'Password':
            password = row['Value']
        else:
            context.execute_steps(u"""
                * Set "%s" to "%s" in new memo list window
            """ % (row['Field'], row['Value']))

    if discover:
        context.app.instance.dialog('New Memo List').button('Find Memo Lists').click()
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')

        # Select first available calendar
        dialog = context.app.instance.dialog('Choose a Memo List')
        dialog.child(roleName='table cell').click()
        dialog.button('Apply').click()
        assert wait_until(lambda x: x.dead, dialog),\
            "Choose a Memo List dialog didn't disappear"

        # Reset the calendar name
        context.execute_steps(u'* Set "Name:" to "%s" in new memo list window' % name)
    context.app.instance.dialog('New Memo List').button('OK').click()

    if not discover:
        # Authenticate
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')


@step(u'Set "{field}" to "{value}" in new memo list window')
def set_field_to_value_in_new_task_list_window(context, field, value):
    dialog = context.app.instance.dialog('New Memo List')
    if field == 'Type:':
        # Type: label doesn't point on a correct label
        widget = dialog.child(roleName='combo box')
        if widget.combovalue != value:
            widget.combovalue = value
    else:
        widgets = filter(lambda x: x.showing, dialog.findChildren(GenericPredicate(name=field)))
        if widgets == []:
            raise RuntimeError("Cannot find '%s' field in New Memo List dialog" % field)
        widgets[0].parent.textentry('').text = value


@step(u'Delete all memos which contain "{summary}"')
def delete_all_memos_containing(context, summary):
    for attempts in xrange(0, 10):
        # Perform search
        context.execute_steps(u'* Search for "%s" memo' % summary)
        # Find the first available task
        context.app.instance.menu('Edit').click()
        mnu = context.app.instance.menu('Edit').menuItem('Delete Memo')
        states = mnu.getState().getStates()
        context.app.instance.menu('Edit').click()
        if pyatspi.STATE_ENABLED in states:
            context.app.instance.menu('Edit').click()
            context.app.instance.menu('Edit').menuItem('Delete Memo').click()
            dialog = context.app.instance.dialog(' ')
            dialog.button('Delete').click()
            sleep(0.5)
        else:
            break
