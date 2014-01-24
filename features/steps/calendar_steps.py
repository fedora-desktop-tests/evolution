# -*- coding: UTF-8 -*-
from behave import step, then
from dogtail.rawinput import click, keyCombo
from dogtail.predicate import GenericPredicate
import pyatspi
from behave_common_steps import wait_until
from time import sleep
from gi.repository import GLib
from __builtin__ import xrange


@step(u'Switch to "{view}" in calendar')
def switch_to_view(context, view):
    context.app.instance.menu('View').click()
    context.app.instance.menu('View').menu('Current View').point()
    context.app.instance.menu('View').menu('Current View').menuItem(view).click()


@step(u'Change calendar month to {month} {year}')
def change_calendar_month_to(context, month, year):
    # Show the context menu with year and a month
    panel = context.app.instance.child('Month Calendar')
    prev_year = panel.child('Previous year').position
    next_year = panel.child('Next year').position
    pos_diff = next_year[0] - prev_year[0]
    click_pos = prev_year[0] + int(pos_diff / 2)
    click(click_pos, next_year[1], button=3)
    # Select the date
    if pyatspi.STATE_FOCUSED not in context.app.instance.menu(year).getState().getStates():
        context.app.instance.menu(year).click()
    context.app.instance.menu(year).menuItem(month).click()


@step(u'Search for events which contain "{summary}"')
def search_for_events(context, summary):
    sleep(0.5)
    for attempts in range(0, 10):
        try:
            context.search_bar.text = summary
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.click()
    context.search_bar.grab_focus()
    keyCombo('<Enter>')
    sleep(0.5)

    # A magic sequence of actions to select the first contact
    context.search_bar.click()
    for i in range(0, 3):
        keyCombo('<Tab>')
    context.search_bar.click()
    for i in range(0, 3):
        keyCombo('<Tab>')


@step(u'Open first "{summary}" appointment')
def open_selected_appointment(context, summary):
    # First event selected, open it in event editor
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem('Open Appointment').click()

    context.execute_steps(u"""
        * Event editor with title "Appointment - %s" is displayed
        """ % summary)


@step(u'Open first "{summary}" meeting')
def open_selected_meeting(context, summary):
    # First event selected, open it in event editor
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem('Open Appointment').click()

    context.execute_steps(u"""
        * Event editor with title "Meeting - %s" is displayed
        """ % summary)


@step(u'Delete the selected event')
def delete_selected_event(context, send_notice=False):
    context.app.instance.menu('Edit').click()
    mnu = context.app.instance.menu('Edit').menuItem('Delete Appointment')
    if pyatspi.STATE_ENABLED in mnu.getState().getStates():
        mnu.click()
        sleep(0.5)
        # Two types of notification may appear here
        if context.app.instance.findChildren(GenericPredicate(roleName='alert', name='Question')):
            context.app.instance.child('Question', roleName='alert').button('OK').click()
        else:
            if context.app.instance.findChildren(GenericPredicate(roleName='dialog', name=' ')):
                context.app.instance.dialog(' ').button('Delete').click()
                btns = []
                if send_notice:
                    btns = context.app.instance.findChildren(GenericPredicate('Send Notice'))
                else:
                    btns = context.app.instance.findChildren(GenericPredicate('Do not Send'))
                if btns != []:
                    btns[0].click()
                    sleep(0.5)


@step(u'Delete the selected event and send notice')
def delete_selected_event_sending_notifications(context):
    delete_selected_event(context, True)


@step(u'Delete all events which contain "{summary}"')
def delele_all_events_for_date(context, summary):
    for attempts in xrange(0, 10):
        # Perform search
        context.execute_steps(u'* Search for events which contain "%s"' % summary)
        # Find the first available appointment
        context.app.instance.menu('Edit').click()
        mnu = context.app.instance.menu('Edit').menuItem('Delete Appointment')
        states = mnu.getState().getStates()
        context.app.instance.menu('Edit').click()
        if pyatspi.STATE_ENABLED in states:
            context.execute_steps(u'* Delete the selected event')
        else:
            break


@then(u'Event list is empty')
def event_list_is_empty(context):
    context.app.instance.menu('File').click()
    mnu = context.app.instance.menu('File').menuItem('Open Appointment')
    states = mnu.getState().getStates()
    context.assertion.assertNotIn(pyatspi.STATE_ENABLED, states, "Event list is expected to be empty")


@step(u'Select "{option}" in cancellation notice dialog')
def select_option_in_cancellation_notice_dialog(context, option):
    dialog = context.app.instance.findChild(
        GenericPredicate(roleName='dialog', name=' '),
        retry=False, requireResult=False)
    if dialog:
        dialog.button(option).click()
        assert wait_until(lambda x: x.dead, dialog.attendees),\
            "Meeting invitations dialog was not closed"


@step(u'{action:w} "{name}" task list')
def do_action_on_task_list(context, action, name):
    do_action_on_calendar(context, action, name, control_name='Task List Selector')


@step(u'{action:w} "{name}" memo list')
def do_action_on_memo_list(context, action, name):
    do_action_on_calendar(context, action, name, control_name='Memo List Selector')


@step(u'{action:w} "{name}" calendar')
def do_action_on_calendar(context, action, name, control_name='Calendar Selector'):
    # Parse complex account name
    mailbox = "On This Computer"
    if "\\" in name:
        mailbox = name.split("\\")[0]
        name = name.split("\\")[1]

    tree = context.app.instance.child(control_name).child(mailbox)
    if not pyatspi.STATE_EXPANDED in tree.getState().getStates():
        tree.doActionNamed('expand or contract')
    calendar = tree.parent.parent.child(name)
    scrollpane = calendar.findAncestor(GenericPredicate(roleName='scroll pane'))
    scroll = scrollpane.findChildren(GenericPredicate(roleName='scroll bar'))[1]
    # Should we leave it checked?
    cell_checkbox = calendar.parent.findChildren(GenericPredicate(roleName='table cell'))[1]
    checked = cell_checkbox.checked
    # Scroll to the checkbox
    scroll.value = 0
    sleep(0.1)
    while (cell_checkbox.position[0] < 0) or (scroll.value < scroll.maxValue):
        scroll.value += 5
        sleep(0.1)
    if cell_checkbox.position[0] < 0:
        raise RuntimeError("Cannot scroll to calendar '%s'" % name)
    if (checked and action == 'Disable') or (not checked and action == 'Enable'):
        calendar.parent.findChildren(GenericPredicate(roleName='table cell'))[0].click()
    if action == 'Select':
        # Select the calendar if we are enabling it
        click_cell = calendar.parent.findChildren(GenericPredicate(roleName='table cell'))[2]
        click_cell.click()
    context.execute_steps(u"""
        * Handle authentication window
        * Wait for email to synchronize
    """)


@step(u'Add new calendar with discover')
def add_new_calendar_with_discover(context):
    add_new_calendar(context, True)


@step(u'Add new calendar')
def add_new_calendar(context, discover=False):
    password = None
    # First, make sure that calendar has not already been added
    name = filter(lambda row: row['Field'] == 'Name:', context.table)[0]['Value']
    calendars = context.app.instance.findChildren(GenericPredicate(name=name, roleName='table cell'))
    visible_calendars = filter(lambda x: x.showing, calendars)
    if visible_calendars != []:
        # Calendar was already added, move along
        return

    # Open 'new calendar' dialog
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Calendar').click()

    # Fill in calendar details
    for row in context.table:
        if row['Field'] == 'Password':
            password = row['Value']
        else:
            context.execute_steps(u"""
                * Set "%s" to "%s" in new calendar window
            """ % (row['Field'], row['Value']))

    if discover:
        context.app.instance.dialog('New Calendar').button('Find Calendars').click()
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')

        # Select first available calendar
        dialog = context.app.instance.dialog('Choose a Calendar')
        dialog.child(roleName='table cell').click()
        dialog.button('Apply').click()
        assert wait_until(lambda x: x.dead, dialog),\
            "Choose a Calendar dialog didn't disappear"

        # Reset the calendar name
        context.execute_steps(u'* Set "Name:" to "%s" in new calendar window' % name)
    context.app.instance.dialog('New Calendar').button('OK').click()

    if not discover:
        if password:
            context.execute_steps(u'* Handle authentication window with password "%s"' % password)
        else:
            context.execute_steps(u'* Handle authentication window')


@step(u'Set "{field}" to "{value}" in new calendar window')
def set_field_to_value_in_new_calendar_window(context, field, value):
    dialog = context.app.instance.dialog('New Calendar')
    if field == 'Type:':
        # Type: label doesn't point on a correct label
        widget = dialog.child(roleName='combo box')
        if widget.combovalue != value:
            widget.combovalue = value
    else:
        widgets = filter(lambda x: x.showing, dialog.findChildren(GenericPredicate(name=field)))
        if widgets == []:
            raise RuntimeError("Cannot find '%s' field in Add New Calendar dialog" % field)
        widgets[0].parent.textentry('').text = value
