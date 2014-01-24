# -*- coding: UTF-8 -*-
from behave import step, then
from dogtail.predicate import GenericPredicate
from dogtail.tree import root
from dogtail.rawinput import keyCombo, typeText
from time import sleep
from behave_common_steps import wait_until
import datetime
import os


@step(u'Create new appointment')
def create_new_appointment(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Appointment').click()
    context.execute_steps(u"""
        * Event editor with title "Appointment - No Summary" is displayed
    """)


@step(u'Create new all day appointment')
def create_new_all_day_appointment(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('All Day Appointment').click()
    context.execute_steps(u"""
        * Event editor with title "Appointment - No Summary" is displayed
    """)


@step(u'Create new meeting')
def create_new_meeting(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Meeting').click()
    context.execute_steps(u"""
        * Event editor with title "Meeting - No Summary" is displayed
    """)


@step(u'Event editor with title "{name}" is displayed')
def event_editor_with_name_displayed(context, name):
    context.app.event_editor = context.app.instance.window(name)


@step(u'Save the meeting and choose not to send meeting invitations')
def save_meeting(context):
    save_meeting_and_send_notifications(context, send=False)


@step(u'Save the meeting and send meeting invitations')
def save_meeting_and_send_notifications(context, send=True):
    context.app.event_editor.button('Save and Close').click()
    sleep(3)
    if context.app.instance.findChildren(GenericPredicate(roleName='dialog', name='')):
        dialog = context.app.instance.dialog(' ')
        dialog.grabFocus()
        if send:
            dialog.button('Send').doActionNamed('click')
        else:
            dialog.button('Do not Send').doActionNamed('click')
        assert wait_until(lambda x: x.dead, dialog),\
            "Meeting invitations dialog was not closed"
    assert wait_until(lambda x: x.dead, context.app.event_editor),\
        "Meeting editor was not closed"


@step(u'Save the event and close the editor')
def save_event(context):
    context.app.event_editor.button('Save and Close').click()
    assert wait_until(lambda x: x.dead and not x.showing, context.app.event_editor),\
        "Meeting editor is still visible"


@step(u'Set "{field}" field in event editor to "{value}"')
def set_field_in_event_editor(context, field, value):
    if field == 'Calendar:':
        # This cmb has no 'click' action, so use a custom set of actions
        cmb = context.app.event_editor.childLabelled('Calendar:')
        cmb.doActionNamed('press')
        # Calendars have 4 spaces before the actual name
        cmb.menuItem('    %s' % value).click()

    text_fields = ['Summary:', 'Location:', 'Description:']
    if field in text_fields:
        context.app.event_editor.childLabelled(field).text = value

    if field == 'Time:':
        if ' ' in value:
            (day, time) = value.split(' ')
            context.app.event_editor.\
                childLabelled('Time:').textentry('').text = time
        else:
            day = value
        context.app.event_editor.child('Date').text = day

    if field in ["For:", "Until:"]:
        combo = context.app.event_editor.\
            child(name='for', roleName='menu item').\
            findAncestor(GenericPredicate(roleName='combo box'))

        field_combovalue = field.lower()[:-1]
        if combo.combovalue != field_combovalue:
            combo.combovalue = field_combovalue

        if field_combovalue == 'for':
            (hours, minutes) = value.split(':')
            spins = context.app.event_editor.findChildren(
                GenericPredicate(roleName='spin button'))
            spins[0].text = hours
            spins[0].grab_focus()
            keyCombo('<Enter>')
            spins[1].text = minutes
            spins[1].grab_focus()
            keyCombo('<Enter>')
        else:
            filler = context.app.event_editor.child('until').parent.\
                findChildren(GenericPredicate(roleName='filler'))[-2]
            if ' ' in value:
                (day, time) = value.split(' ')
                filler.child(roleName='combo box').textentry('').text = time
            else:
                day = value
            filler.child('Date').text = day

    if field == 'Timezone:':
        context.app.event_editor.button('Select Timezone').click()
        dlg = context.app.instance.dialog('Select a Time Zone')
        dlg.child('Timezone drop-down combination box').combovalue = value
        dlg.button('OK').click()
        assert wait_until(lambda x: x.dead, dlg),\
            "'Select Time Zone' dialog was not closed"

    if field == 'Categories:':
        context.app.event_editor.button('Categories...').click()
        context.app.categories = context.app.instance.dialog('Categories')
        for category in value.split(','):
            context.execute_steps(u'* Check "%s" category' % category.strip())
        context.execute_steps(u'* Close categories dialog')


@step(u'Set the following fields in event editor')
def set_several_fields(context):
    for row in context.table:
        set_field_in_event_editor(context, row['Field'], row['Value'])


@step(u'"{field}" field is set to "{value}"')
def field_is_set_to(context, field, value):
    value = value.strip()
    text_fields = ['Summary:', 'Location:', 'Description:']
    if field in text_fields:
        actual = context.app.event_editor.childLabelled(field).text
        context.assertion.assertEquals(actual, value)

    if field == 'Time:':
        day = context.app.event_editor.child('Date').text
        if ' ' in value:
            time = context.app.event_editor.\
                childLabelled('Time:').textentry('').text
            actual = '%s %s' % (day, time)
            context.assertion.assertEquals(actual.lower(), value.lower())
        else:
            # All day event
            context.assertion.assertEquals(day, value)
            time_showing = context.app.event_editor.childLabelled('Time:').showing
            context.assertion.assertFalse(
                time_showing, "Time controls are displayed in all day event")

    if field == 'For:':
        # Ensure that correct value is set in combobox
        combo = context.app.event_editor.child(name='for', roleName='combo box')
        spins = context.app.event_editor.findChildren(GenericPredicate(roleName='spin button'))
        if ' ' in value:
            actual = '%s:%s' % (spins[0], spins[1])
            context.assertion.assertEquals(actual.lower(), value.lower())
        else:
            context.assertion.assertFalse(
                spins[0].showing, "Time controls are displayed in all day event")
            context.assertion.assertFalse(
                spins[1].showing, "Time controls are displayed in all day event")

    if field == 'Until:':
        combo = context.app.event_editor.child(name='until', roleName='combo box')
        filler = combo.parent.findChildren(GenericPredicate(roleName='filler'))[-2]
        day = filler.child('Date').text
        if ' ' in value:
            time = filler.child(roleName='combo box').textentry('').text
            actual = '%s %s' % (day, time)
            context.assertion.assertEquals(actual.lower(), value.lower())
        else:
            # All day event
            context.assertion.assertEquals(day, value)
            time_showing = filler.child(roleName='combo box').textentry('').showing
            context.assertion.assertFalse(
                time_showing, "Time controls are displayed in all day event")

    if field == 'Calendar:':
        cmb = context.app.event_editor.childLabelled('Calendar:')
        actual = cmb.combovalue.strip()
        context.assertion.assertEquals(actual, value)

    if field == 'Timezone:':
        actual = context.app.event_editor.childLabelled('Time zone:').text
        context.assertion.assertEquals(actual, value)

    if field == 'Categories:':
        actual = context.app.event_editor.textentry('Categories').text
        context.assertion.assertEquals(actual, value)


@step(u'Event has the following details')
def event_has_fields_set(context):
    for row in context.table:
        context.execute_steps(u"""
            * "%s" field is set to "%s"
        """ % (row['Field'], row['Value']))


@step(u'Add "{name}" as attendee')
def add_user_as_attendee_with_role(context, name):
    context.app.event_editor.button('Add').click()

    # Input user name
    typeText(name)
    keyCombo('<Enter>')

    # Evolution doesn't have a11y set for cell renderers, so role cannot be set
    #table = context.app.event_editor.child(roleName='table')
    # User will be added as a last row, so last cell is user role selector
    #cell = table.findChildren(GenericPredicate(roleName='table cell'))[-1]
    #cell.click()


@step(u'Remove "{name}" from attendee list')
def remove_user_from_attendee_list(context, name):
    context.app.event_editor.child(name=name, roleName='table cell').click()
    context.app.event_editor.button('Remove').click()


@step(u'Select first suggestion as attendee typing "{name}"')
def select_first_suggestion_as_attendee(context, name):
    context.app.event_editor.button('Add').click()
    typeText(name)
    sleep(1)

    # Again, cell renderer is not avaiable here
    keyCombo("<Down>")
    keyCombo("<Enter>")

    sleep(0.5)


@then(u'"{user}" as "{role}" is present in attendees list')
def user_with_role_is_present_in_attendees_list(context, user, role):
    table = context.app.event_editor.child(roleName='table')
    cells = table.findChildren(GenericPredicate(roleName='table cell'))
    found_indexes = [cells.index(c) for c in cells if c.text == user]
    if found_indexes == []:
        raise AssertionError("User '%s' was not found in attendees list" % user)

    role_cell_index = found_indexes[0] + 1
    if role_cell_index > len(cells):
        raise AssertionError("Cannot find role cell for user '%s'" % user)

    actual = cells[role_cell_index].text
    context.assertion.assertEquals(actual, role)


@step(u'The following attendees are present in the list')
def verify_attendees_list_presence(context):
    for row in context.table:
        context.execute_steps(u"""
            Then "%s" as "%s" is present in attendees list
            """ % (row['Name'], row['Role']))


@step(u'Open attendees dialog')
def open_attendees_dialog(context):
    context.app.event_editor.button('Attendees...').click()
    context.app.attendees = context.app.instance.dialog('Attendees')


@step(u'Close attendees dialog')
def close_attendees_dialog(context):
    context.app.attendees.button('Close').click()
    assert wait_until(lambda x: not x.showing, context.app.attendees),\
        "Attendees dialog was not closed"


@step(u'Change addressbook to "{name}" in attendees dialog')
def change_addressbook_in_attendees_dialog(context, name):
    context.app.attendees.childLabelled('Address Book:').combovalue = '    %s' % name


@step(u'Add "{name}" contact as "{role}" in attendees dialog')
def add_contact_as_role_in_attendees_dialog(context, name, role):
    contacts = context.app.attendees.childLabelled('Contacts').child(roleName='table')
    contact = contacts.child(name)
    contact.select()

    btn = context.app.attendees.child('%ss' % role).parent.parent.parent.button('Add')
    btn.click()


@step(u'Add "{user}" as "{role}" using Attendees dialog')
def add_contact_as_role_using_attendees_dialog(context, user, role):
    context.execute_steps(u"""
        * Open attendees dialog
        * Add "%s" contact as "%s" in attendees dialog
        * Close attendees dialog
        """ % (user, role))


@step(u'Add "{user}" as "{role}" using Attendees dialog from "{addressbook}" addressbook')
def add_contact_from_addressbook_as_role_using_attendees_dialog(context, user, role, addressbook):
    context.execute_steps(u"""
        * Open attendees dialog
        * Change addressbook to "%s" in attendees dialog
        * Add "%s" contact as "%s" in attendees dialog
        * Close attendees dialog
        """ % (addressbook, user, role))


@step(u'Search for "{username}" in Attendees dialog in "{addressbook}" addressbook')
def search_for_user_in_attendees_dialog(context, username, addressbook):
    context.execute_steps(u"""
        * Open attendees dialog
        * Change addressbook to "%s" in attendees dialog
    """ % addressbook)
    context.app.attendees.childLabelled('Search:').text = username
    sleep(1)


@step(u'Show time zone in event editor')
def show_timezone(context):
    if not context.app.event_editor.child('Time zone:').showing:
        context.app.event_editor.menu('View').click()
        context.app.event_editor.menu('View').menuItem('Time Zone').click()


@step(u'Show categories in event editor')
def show_categories(context):
    if not context.app.event_editor.textentry('Categories').showing:
        context.app.event_editor.menu('View').click()
        context.app.event_editor.menu('View').menuItem('Categories').click()


@step(u'Set event start time in {num} minute')
@step(u'Set event start time in {num} minutes')
def set_event_start_time_in(context, num):
    time = context.app.event_editor.childLabelled('Time:').textentry('').text
    time_object = datetime.datetime.strptime(time.strip(), '%H:%M %p')
    new_time_object = time_object + datetime.timedelta(minutes=int(num))
    new_time = new_time_object.strftime('%H:%M %p')
    context.app.event_editor.childLabelled('Time:').textentry('').text = new_time
    context.app.event_editor.childLabelled('Time:').textentry('').keyCombo('<Enter>')


@step(u'Set event start date in {num} day')
@step(u'Set event start date in {num} days')
def set_event_start_date_in(context, num):
    date = context.app.event_editor.child('Date').text
    date_object = datetime.datetime.strptime(date, '%m/%d/%Y')
    new_date_object = date_object + datetime.timedelta(days=int(num))
    new_date = new_date_object.strftime('%m/%d/%Y')
    context.app.event_editor.child('Date').text = ''
    context.app.event_editor.child('Date').typeText(new_date)
    context.app.event_editor.childLabelled('Time:').textentry('').click()


@step(u'Open reminders window')
def open_reminders_window(context):
    context.app.event_editor.button('Reminders').click()
    context.app.reminders = context.app.instance.dialog('Reminders')


@step(u'Select predefined reminder "{name}"')
def select_predefined_reminder(context, name):
    context.app.reminders.child(roleName='combo box').combovalue = name


@step(u'Select custom reminder')
def select_custom_reminder(context):
    context.app.reminders.child(roleName='combo box').combovalue = 'Customize'


@step(u'Add new reminder with "{action}" {num} {period} {before_after} "{start_end}"')
def add_new_custom_reminder(context, action, num, period, before_after, start_end):
    context.app.reminders.button('Add').click()
    dialog = context.app.instance.dialog('Add Reminder')

    for value in [action, period, before_after, start_end]:
        combo = dialog.child(value, roleName='menu item').parent.parent
        if combo.combovalue != value:
            combo.combovalue = value

    spin_button = dialog.child(roleName='spin button')
    spin_button.text = num
    spin_button.grab_focus()
    keyCombo('<Enter>')
    dialog.button('OK').click()

    assert wait_until(lambda x: x.dead, dialog), "Add Reminder dialog was not closed"


@step(u'Add new reminder with the following options')
def add_new_reminder_with_following_options(context):
    context.app.reminders.button('Add').click()
    dialog = context.app.instance.dialog('Add Reminder')

    for row in context.table:
        if row['Field'] in ['Action', 'Period', 'Before/After', 'Start/End']:
            value = row['Value']
            combo = dialog.child(value, roleName='menu item').parent.parent
            if combo.combovalue != value:
                combo.combovalue = value
        elif row['Field'] == 'Num':
            spin_button = dialog.child(roleName='spin button')
            spin_button.text = row['Value']
            spin_button.grab_focus()
            keyCombo('<Enter>')
        elif row['Field'] == 'Message':
            dialog.child('Custom message').click()
            # dialog.childLabelled('Message:').text = row['Value']
            dialog.child(roleName='text').text = row['Value']
        else:
            dialog.childLabelled(row['Field']).text = row['Value']

    dialog.button('OK').click()

    assert wait_until(lambda x: x.dead, dialog), "Add Reminder dialog was not closed"


@step(u'Close reminders window')
def close_reminders_window(context):
    context.app.reminders.button('Close').click()
    assert wait_until(lambda x: not x.showing, context.app.reminders),\
        "Reminders dialog was not closed"


@step(u'Appointment reminders window pops up in {num:d} minute')
@step(u'Appointment reminders window pops up in {num:d} minutes')
def appointment_reminders_window_pops_up(context, num):
    alarm_notify = root.application('evolution-alarm-notify')
    assert wait_until(
        lambda x: x.findChildren(GenericPredicate(name='Appointments')) != [],
        element=alarm_notify, timeout=60 * int(num)),\
        "Appointments window didn't appear"
    context.app.alarm_notify = alarm_notify.child(name='Appointments')


@step(u'Appointment reminders window contains reminder for "{name}" event')
def alarm_notify_contains_event(context, name):
    reminders = context.app.alarm_notify.findChildren(
        GenericPredicate(roleName='table cell'))
    matching_reminders = [x for x in reminders if name in x.text]
    assert matching_reminders != [], "Cannot find reminder '%s'" % name


@step(u'Application trigger warning pops up in {num} minutes')
def application_trigger_warning_pops_up(context, num):
    alarm_notify = root.application('evolution-alarm-notify')
    assert wait_until(
        lambda x: x.findChildren(GenericPredicate(name='Warning', roleName='dialog')) != [],
        element=alarm_notify, timeout=60 * int(num)),\
        "Warning window didn't appear"


@step(u'{action} to run the specified program in application trigger warning window')
def action_to_run_specified_program(context, action):
    alarm_notify = root.application('evolution-alarm-notify')
    dialog = alarm_notify.dialog('Warning')
    if action == 'Agree':
        dialog.button('Yes').click()
    else:
        dialog.button('No').click()


@step(u'"{app}" is present in process list')
def app_is_present_in_process_list(context, app):
    try:
        assert root.application(app)
    finally:
        os.system("killall gnome-screenshot")


@step(u'"{app}" is not present in process list')
def app_is_not_present_in_process_list(context, app):
    try:
        app_names = map(lambda x: x.name, root.applications())
        assert app not in app_names
    finally:
        os.system("killall %s" % app)


@step(u'Add "{filepath}" attachment in event editor')
def add_attachement_in_event_editor(context, filepath):
    context.app.event_editor.button("Add Attachment...").click()
    context.execute_steps(u"""
        * file select dialog with name "Add Attachment" is displayed
        * in file select dialog I select "%s"
    """ % filepath)


@step(u'Save attachment "{name}" in event editor to "{file}"')
def save_attachment_to_file(context, name, file):
    # Switch to List View
    combo = context.app.event_editor.child(roleName='menu item', name='List View').parent.parent
    if combo.name != 'List View':
        combo.combovalue = 'List View'

    # Right-click on the cell
    cells = context.app.event_editor.findChildren(GenericPredicate(roleName='table cell'))
    matching_cells = [x for x in cells if name in x.name]
    if matching_cells == []:
        raise RuntimeError("Cannot find attachment containing '%s'" % name)
    cell = matching_cells[0]
    cell.click(button=3)

    # Get popup menu
    popup_menu = context.app.instance.child(name='Add Attachment...', roleName='menu item').parent
    popup_menu.child('Save As').click()

    context.execute_steps(u"""
        * Save attachment "%s" in mail viewer to "%s"
    """ % (name, file))


@step(u'Display attendee {field}')
def show_attendee_field(context, field):
    context.app.event_editor.menu('View').click()
    menuItem = context.app.event_editor.menu('View').menuItem('%s Field' % field.capitalize())
    if not menuItem.checked:
        menuItem.click()
    else:
        keyCombo('<Esc>')


def get_contact_parameter_by_name(context, contact_name, column):
    # Get attendees table
    table = context.app.event_editor.child(roleName='table')
    # Get header offset
    headers = table.findChildren(GenericPredicate(roleName='table column header'))
    header_names = [x.name for x in headers]
    offset = header_names.index(column)
    # Get table cells
    cells = table.findChildren(GenericPredicate(roleName='table cell'))
    found_indexes = [cells.index(c) for c in cells if c.text == str(contact_name)]
    if found_indexes == []:
        raise AssertionError("User '%s' was not found in attendees list" % contact_name)
    cell_index = found_indexes[0] + offset
    if cell_index > len(cells):
        raise AssertionError("Cannot find '%s' cell for user '%s'" % (column, contact_name))
    return cells[cell_index]


@step(u'Attendee "{name}" has "{status}" status')
def attendee_has_status(context, name, status):
    actual = get_contact_parameter_by_name(context, name, 'Status').text
    context.assertion.assertEquals(actual, status)
