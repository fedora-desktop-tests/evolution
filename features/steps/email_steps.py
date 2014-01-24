# -*- coding: UTF-8 -*-
from behave import step, then
from dogtail.rawinput import keyCombo, typeText
from dogtail.predicate import GenericPredicate
from time import sleep
import pyatspi
from behave_common_steps import wait_until
from gi.repository import GLib
from __builtin__ import unicode


@step(u'Create a new email')
def create_a_new_email(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Mail Message').click()
    context.execute_steps(u'* Message composer with title "Compose Message" is opened')


@step(u'Message composer with title "{name}" is opened')
def message_composer_is_opened(context, name):
    context.app.composer = context.app.instance.window(name)


@step(u'Set "{field}" to "{value}" in message composer')
def set_field_to_value_in_message_composer(context, field, value):
    if field in ['To:', 'Cc:', 'Bcc:']:
        #TODO Check that the field is displayed
        context.app.composer.child(field).typeText(value)
        context.app.composer.child(field).text = value
        keyCombo("<Enter>")
        sleep(0.1)

    if field == 'Subject:':
        context.app.composer.childLabelled(field).text = value
        context.app.composer = context.app.instance.window(value)

    if field == 'Text:':
        keyCombo('<Alt>r')
        typeText(value)


@step(u'Set the following values in message composer')
def set_values_in_message_composer(context):
    for row in context.table:
        set_field_to_value_in_message_composer(
            context, row['Field'], row['Value'])


@step(u'Save message as a draft')
def save_message_as_a_draft(context):
    alert = context.app.composer.child(roleName="alert", name='Information')
    context.app.composer.button('Save Draft').click()
    assert wait_until(lambda x: not x.showing, alert),\
        "Draft saving notifications didn't disappear"


@step(u'Close message composer')
def close_message_composer(context):
    context.app.composer.keyCombo('<Ctrl><W>')
    assert wait_until(lambda x: x.dead, context.app.composer),\
        "Message composer dialog was not closed"


@step(u'Open "{name}" folder')
def open_folder(context, name):
    # BUG This selects only the last folder
    mailbox = "On This Computer"
    if "\\" in name:
        mailbox = name.split("\\")[0]
        name = name.split("\\")[1]
    tree = context.app.instance.child('Mail Folder Tree').child(mailbox)
    if not pyatspi.STATE_EXPANDED in tree.getState().getStates():
        tree.doActionNamed('expand or contract')
    all_cells = tree.parent.parent.findChildren(GenericPredicate(roleName='table cell'))
    tree_index = all_cells.index(tree)
    cells_below_tree = all_cells[tree_index:-1]
    matching_cells = [x for x in cells_below_tree if name in x.name]
    if matching_cells == []:
        raise RuntimeError("Cannot find folder '%s'" % name)
    folder_cell = matching_cells[-1]
    # Scroll to the cell
    scroll = context.app.instance.child('Mail Folder Tree').parent.findChildren(GenericPredicate(roleName='scroll bar'))[-1]
    scroll.value = 0
    sleep(0.1)
    while folder_cell.position[0] < 0 and scroll.value < scroll.maxValue:
        scroll.value += 50
        sleep(0.1)
    folder_cell.doActionNamed('activate')


@step(u'Open "{name}" message')
def open_message_editor(context, name):
    search_for_message(context, name)
    context.app.instance.menu('Message').click()
    context.app.instance.menu('Message').menuItem('Open in New Window').click()
    message_composer_is_opened(context, name)
    context.execute_steps(u'* Message viewer "%s" is displayed' % name)


@step(u'Open last message which contains "{name}" message')
def open_last_message_which_contains(context, name):
    frames = context.app.instance.findChildren(GenericPredicate(roleName='frame'))

    search_for_message(context, name)
    keyCombo("<Ctrl><Page_Down>")
    keyCombo("<End>")
    context.app.instance.menu('Message').click()
    mnu = context.app.instance.menu('Message').menuItem('Open in New Window')
    states = mnu.getState().getStates()
    if not pyatspi.STATE_ENABLED in states:
        raise RuntimeError("No messages, containing '%s' found" % name)
    mnu.click()
    assert wait_until(
        lambda x: x.findChildren(GenericPredicate(roleName='frame')) != frames,
        context.app.instance),\
        "New message viewer didn't appear"
    frames = context.app.instance.findChildren(GenericPredicate(roleName='frame'))
    context.app.viewer = [x for x in frames if name in x.name][0]
    assert len(context.app.viewer) > 0, "Message viewer with title containing '%s' didn't appear" % name


@step(u'Field "{name}" is set to "{value}')
def field_is_set_to_in_message_editor(context, field, value):
    actual = None
    if field in ['To:', 'Cc:', 'Bcc:']:
        #TODO Check that the field is displayed
        actual = context.app.composer.child(field).text

    if field == 'Subject:':
        actual = context.app.composer.childLabelled(field).text

    context.assertion.assertEquals(actual, value)


@step(u'message composer has the following fields set')
def message_composer_has_fields_set(context):
    for row in context.table:
        field_is_set_to_in_message_editor(context, row['Field'], row['Value'])


@step('Delete "{name}" message')
def delete_message(context, name):
    search_for_message(context, name)
    context.app.instance.menu('Edit').click()
    context.app.instance.menu('Edit').menuItem('Delete Message').click()


@step(u'Search for "{name}" message')
def search_for_message(context, name):
    # Clear existing search
    for attempts in range(0, 10):
        try:
            context.search_bar.text = ''
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.grab_focus()
    context.search_bar.keyCombo('<Enter>')
    sleep(1)

    # Perform the search
    for attempts in range(0, 10):
        try:
            context.search_bar.text = name
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    context.search_bar.grab_focus()
    sleep(0.5)
    context.search_bar.keyCombo('<Enter>')
    context.app.instance.child(name='Messages', roleName='panel').click()
    keyCombo('<Home>')


@then(u'no message found')
def no_message_found(context):
    heading = context.app.instance.findChild(
        GenericPredicate(roleName='heading'), retry=False, requireResult=False)
    context.assertion.assertIsNone(heading, "Message was unexpectedly found")


@step(u'Select first suggestion as "{field}" typing "{name}"')
def select_first_suggestion_as_field_typing_name(context, field, name):
    context.app.composer.child(field).grab_focus()
    typeText(name)
    sleep(1)
    keyCombo("<Down>")
    keyCombo("<Enter>")
    sleep(0.5)


@step(u'Delete all emails in "{name}" folder')
def delete_all_emails_in_folder(context, name):
    delete_all_emails_with_in_folder(context, '', name)


@step(u'Delete all emails with "{subject}" in "{name}" folder')
def delete_all_emails_with_in_folder(context, subject, name):
    context.execute_steps(u'* Open "%s" folder' % name)
    search_for_message(context, subject)
    keyCombo('<Ctrl>A')
    context.app.instance.menu('Edit').click()
    mnu = context.app.instance.menu('Edit').menuItem('Delete Message')
    if pyatspi.STATE_ENABLED in mnu.getState().getStates():
        mnu.click()
    else:
        context.app.instance.menu('Edit').click()


@step(u'Set email body to')
def set_email_body(context):
    context.app.composer.childLabelled('Subject:').grab_focus()
    keyCombo('<Tab>')
    sleep(0.1)
    typeText(context.text)


@step(u'Send the email')
def send_the_email(context):
    context.app.composer.button('Send').click()
    assert wait_until(lambda x: x.dead, context.app.composer),\
        "Mail composer was not closed"


@step(u'Receive new email')
def receive_new_email(context):
    keyCombo('<F12>')
    assert wait_until(
        lambda x: x._fastFindChild(GenericPredicate(name="Send & Receive Mail")) is None,
        context.app.instance),\
        "Send and Receive Mail dialog didn't disappear"


@step(u'message viewer has the following fields set')
def message_viewer_has_following_fields_set(context):
    subject_row = filter(lambda x: x['Field'] == 'Subject:', context.table.rows)
    assert subject_row is not None, "Subject should be specified to correctly detect message viewer"

    # Save text and table here, as behave rewrites it in execute_steps
    text = context.text
    table = context.table

    cells = context.app.viewer.findChildren(GenericPredicate(roleName='table cell'))
    cell_text = map(lambda x: x.text.strip('\xc2\xa0'), cells)[2:]
    message_body = context.app.viewer.findChildren(
        GenericPredicate(roleName='document frame'))[-1].\
        child(roleName='section').text.strip()
    cell_text.append('Body:')
    cell_text.append(message_body)

    # Convert the list to dict
    import itertools
    cell_values = dict(itertools.izip_longest(*[iter(cell_text)] * 2, fillvalue=""))
    for row in table:
        expected = cell_values[row['Field']]
        actual = row['Value']
        context.assertion.assertEquals(actual, expected)

    if text:
        expected = unicode(cell_values['Body:'], 'utf-8')
        actual = text
        context.assertion.assertMultiLineEqual(actual, expected)


@step(u'Make sure that "{name}" field is displayed in mail composer')
def display_field_in_mail_composer(context, name):
    if not context.app.composer.child(name).showing:
        # Stupid composer has two View menus
        menu_item = context.app.composer.child("%s Field" % name[:-1])
        menu_item.parent.click()
        menu_item.click()


@step(u'Message viewer "{name}" is displayed')
def message_viewer_displayed(context, name):
    context.app.viewer = context.app.instance.window(name)


@step(u'Close message viewer')
def close_message_viewer(context):
    context.app.viewer.grabFocus()
    keyCombo("<Esc>")


@step(u'Save attachment "{name}" in mail viewer to "{filename}"')
def mail_viewer_has_attachment_named(context, name, filename):
    keyCombo('<Alt>a')

    context.execute_steps(u"""
        * file select dialog with name "Save Attachment" is displayed
        * in file save dialog save file to "%s" clicking "Save"
    """ % filename)
        # Handle replace dialog
    alert = context.app.instance.findChild(GenericPredicate(roleName='alert', name='Question'), retry=False, requireResult=False)
    if alert:
        alert.button("Replace").click()


@step(u'Add "{filename}" attachment in mail composer')
def add_file_as_attachment(context, filename):
    context.app.composer.child('Add Attachment...').click()
    context.execute_steps(u"""
        * file select dialog with name "Add Attachment" is displayed
        * in file select dialog I select "%s"
    """ % filename)


@step(u'{action:w} task request')
@step(u'{action:w} meeting request')
def do_action_on_meeting_request(context, action):
    # Focus on viewer
    context.app.viewer.grab_focus()
    # Find Accept button
    btns = context.app.viewer.findChildren(GenericPredicate(roleName='push button'))
    button = [x for x in btns if str(action) in x.name][0]
    # Scroll to the bottom and some to the left
    # FIXME: This is very hacky, but dummy Evo sets 'showing' to true
    scrls = context.app.viewer.findChildren(GenericPredicate(roleName='scroll bar'))
    if len(scrls) > 3:
        scrls[3].value = scrls[3].maxValue
    if len(scrls) > 2:
        scrls[2].value = 150
    sleep(0.5)
    # Clicky-clicky!
    button.click()
    # Wait until button is
    sleep(5)
    keyCombo('<Ctrl>w')


@step(u'Leave meeting request as tentative')
def leave_as_tentative(context):
    context.execute_steps(u"* Tentative meeting request")
