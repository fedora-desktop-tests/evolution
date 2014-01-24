# -*- coding: UTF-8 -*-
from behave import step, then
from gi.repository import GLib
import dogtail.rawinput
from dogtail.predicate import GenericPredicate
from behave_common_steps.dialogs import *
from helpers import get_combobox_textbox_object
from behave_common_steps import wait_until
from time import sleep, time
import pyatspi


@step(u'Create a new contact')
def create_a_new_contact(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem("Contact").click()
    context.execute_steps(u"Then Contact editor window is opened")


@then(u'"{contact_name}" contact is present in the list')
def contact_with_name_is_present_in_the_list(context, contact_name):
    heading = context.app.instance.child(roleName='table').child(
        roleName='heading', name=contact_name)
    context.assertion.assertIsNotNone(
        heading, "Contact name in preview didn't appear")


@step(u'Refresh addressbook')
def refresh_addressbook(context):
    #Clear the search
    icons = context.search_bar.findChildren(GenericPredicate(roleName='icon'))
    if icons != []:
        icons[-1].click()
    else:
        for attempts in range(0, 10):
            try:
                context.search_bar.text = ''
                break
            except (GLib.GError, AttributeError):
                sleep(0.1)
                continue
        context.search_bar.grab_focus()
        dogtail.rawinput.keyCombo('<Enter>')
    context.execute_steps(u"* Wait for email to synchronize")


@step(u'Search for "{contact_name}" and select first contact')
def search_for_and_select_first_contact(context, contact_name):
    context.search_bar.grab_focus()
    sleep(0.1)
    icons = context.search_bar.findChildren(GenericPredicate(roleName='icon'))
    if icons != []:
        icons[0].click()
        wait_until(lambda x: x.findChildren(
            GenericPredicate(roleName='check menu item', name='Any field contains')) != [],
            context.app.instance)
        context.app.instance.menuItem('Any field contains').click()
        for attempts in range(0, 10):
            try:
                context.search_bar.text = contact_name
                break
            except (GLib.GError, AttributeError):
                sleep(0.1)
                continue
        dogtail.rawinput.keyCombo("<Enter>")
        context.search_bar.grab_focus()

    dogtail.rawinput.keyCombo("<Tab>")
    context.selected_contact_text = context.app.instance.child(roleName='heading').text


@step(u'Select "{contact_name}" contact list')
@step(u'Select "{contact_name}" contact')
def select_contact_with_name(context, contact_name):
    # heading shows the name of currently selected contact
    # We have to keep on pressing Tab to select the next contact
    # Until we meet the first contact
    # WARNING - what if we will have two identical contacts?
    fail = False
    selected_contact = None

    # HACK
    # To make the contact table appear
    # we need to focus on search window
    # and send Tabs to have the first contact focused
    context.search_bar.grab_focus()
    sleep(0.1)
    # Switch to 'Any field contains' (not reachable in 3.6)
    icons = context.search_bar.findChildren(GenericPredicate(roleName='icon'))

    if icons != []:
        icons[0].click()
        wait_until(lambda x: x.findChildren(
            GenericPredicate(roleName='check menu item', name='Any field contains')) != [],
            context.app.instance)
        context.app.instance.menuItem('Any field contains').click()
        for attempts in range(0, 10):
            try:
                context.search_bar.text = contact_name
                break
            except (GLib.GError, AttributeError):
                sleep(0.1)
                continue
        dogtail.rawinput.keyCombo("<Enter>")
        context.search_bar.grab_focus()

    dogtail.rawinput.keyCombo("<Tab>")
    first_contact_name = context.app.instance.child(roleName='heading').text

    while True:
        selected_contact = context.app.instance.child(roleName='heading')
        if selected_contact.text == contact_name:
            fail = False
            break
        dogtail.rawinput.keyCombo("<Tab>")
        # Wait until contact data is being rendered
        sleep(1)
        if first_contact_name == selected_contact.text:
            fail = True
            break

    context.assertion.assertFalse(
        fail, "Can't find contact named '%s'" % contact_name)
    context.selected_contact_text = selected_contact.text


@step(u'Contact list does not include "{contact_name}"')
def contact_list_does_not_include(context, contact_name):
    # Search for contant and make sure no results returned
    context.search_bar.grab_focus()
    # Switch to 'Any field contains'
    context.search_bar.findChildren(GenericPredicate(roleName='icon'))[0].click()
    context.app.instance.menuItem('Any field contains').click()
    for attempts in range(0, 10):
        try:
            context.search_bar.text = contact_name
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    dogtail.rawinput.keyCombo("<Enter>")
    heading = context.app.instance.findChild(
        GenericPredicate(roleName='heading'),
        retry=False, requireResult=False)
    context.assertion.assertIsNone(
        heading, "Contact '%s' was unexpectedly found" % contact_name)


@step(u'Open contact editor for selected contact')
def open_contact_editor_for_selected_contact(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem('Open Contact').click()
    context.execute_steps(u"""
        Then Contact editor window with title "Contact Editor - %s" is opened
        """ % context.selected_contact_text)


@step(u'Delete selected contact')
def delete_selected_contact(context):
    context.app.instance.menu('Edit').click()
    mnu = context.app.instance.menu('Edit').menuItem("Delete Contact")
    if pyatspi.STATE_ENABLED in mnu.getState().getStates():
        context.app.instance.menu('Edit').menuItem("Delete Contact").click()

        alert = context.app.instance.child(roleName='alert', name='Question')
        alert.button('Delete').click()
    context.execute_steps(u"* Wait for email to synchronize")


@step(u'Change categories view to "{category}"')
def change_categories_view(context, category):
    labels = context.app.instance.findChildren(
        GenericPredicate(label='Show:'))
    label = filter(lambda x: x.showing, labels)
    label[0].combovalue = category


@step(u'Save contact as VCard to "{filename}"')
def save_contact_as_vcard_to_file(context, filename):
    # Delete the file in case it already exists
    import os
    os.system("rm -rf %s" % filename)

    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem("Save as vCard...").click()
    context.execute_steps(u"""
        * file select dialog with name "Save as vCard" is displayed
        * in file save dialog save file to "%s" clicking "Save"
        """ % filename)
    # Pause to let the file be really saved
    sleep(0.5)


@step(u'Import "{filename}" as a contact card')
def import_filename_as_contact(context, filename, addressbook=None):
    # TODO Split this into some other steps to ease other import tasks
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem('Import...').click()

    # Additional wait, as the window might take too long to appear
    wait_until(lambda x: x.findChildren(
        GenericPredicate(name='Evolution Import Assistant', roleName='frame')) != [],
        context.app.instance)
    context.app.import_assistant = context.app.instance.window('Evolution Import Assistant')
    context.app.import_assistant.button('Continue').click()
    context.app.import_assistant.child('Import a single file').click()
    context.app.import_assistant.button('Continue').click()
    context.app.import_assistant.child('(None)').click()
    context.execute_steps(u"""
        * file select dialog with name "Select a file" is displayed
        * in file select dialog I select "%s"
    """ % filename)
    context.app.import_assistant.button('Continue').click()
    if addressbook:
        context.app.import_assistant.child(addressbook).click()
    context.app.import_assistant.button('Continue').click()
    context.app.import_assistant.button('Apply').click()


@step(u'Import "{filename}" as a contact card in "{addressbook}" addressbook')
def import_filename_as_contact_in_addressbook(context, filename, addressbook):
    import_filename_as_contact(context, filename, addressbook)


@step(u'Create contact "{name}" with email set to "{email}"')
def create_contact_with_email(context, name, email):
    context.execute_steps(u"""
        * Create a new contact
        * Set "Full Name..." in contact editor to "%s"
    """ % name)
    # As behave cannot into tables in execute_steps, use hacks
    (txt, cmb) = get_combobox_textbox_object(context.app.contact_editor, "emails")
    # clear existing data
    for textbox in txt:
        textbox.text = ""

    txt[0].text = email

    context.execute_steps(u"""
        * Save the contact
    """)


@step(u'Delete all contacts containing "{part}"')
def delete_all_contacts_containing(context, part):
    context.search_bar.grab_focus()
    for attempts in range(0, 10):
        try:
            context.search_bar.text = part
            break
        except (GLib.GError, AttributeError):
            sleep(0.1)
            continue
    dogtail.rawinput.keyCombo("<Enter>")
    context.execute_steps(u"* Wait for email to synchronize")
    context.search_bar.grab_focus()
    dogtail.rawinput.keyCombo("<Tab><Tab>")
    sleep(3)
    heading = context.app.instance.findChild(
        GenericPredicate(roleName='heading'),
        retry=False, requireResult=False)
    if heading:
        dogtail.rawinput.keyCombo("<Control>a")
        delete_selected_contact(context)
        sleep(3)


@step(u'photo {height}x{width} is displayed in contact details')
def photo_is_displayed_for_contact(context, height, width):
    img = context.app.instance.child(roleName='image')
    image_size = img.get_image_size()
    context.assertion.assertEquals(str(image_size.x), height)
    context.assertion.assertEquals(str(image_size.y), width)


@step(u'Select "{name}" addressbook with password "{password}"')
def select_addressbook_with_password(context, name, password):
    select_addressbook(context, name, password)


@step(u'Select "{name}" addressbook')
def select_addressbook(context, name, password=None):
    cells = context.app.instance.findChildren(
        GenericPredicate(name=name, roleName='table cell'))
    visible_cells = filter(lambda x: x.showing, cells)
    if visible_cells == []:
        raise RuntimeError("Cannot find addressbook '%s'" % name)
    visible_cells[0].click()
    if password:
        context.execute_steps(u'* Handle authentication window with password "%s"' % password)
    else:
        context.execute_steps(u"* Handle authentication window")
    # Wait for addressbook to load
    try:
        spinner = context.app.instance.findChild(
            GenericPredicate(name='Spinner'), retry=False, requireResult=False)
        if spinner:
            start_time = time()
            while spinner.showing:
                sleep(1)
                if (time() - start_time) > 180:
                    raise RuntimeError("Contacts take too long to synchronize")
    except (GLib.GError, TypeError):
        pass


@step(u'Add new addressbook')
def add_new_addressbook(context):
    # First, make sure that calendar has not already been added
    name = filter(lambda row: row['Field'] == 'Name:', context.table)[0]['Value']
    books = context.app.instance.findChildren(GenericPredicate(name=name, roleName='table cell'))
    visible_books = filter(lambda x: x.showing, books)
    if visible_books != []:
        # Calendar was already added, move along
        return

    # Open 'new calendar' dialog
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem('Address Book').click()

    # Fill in calendar details
    dialog = context.app.instance.dialog('New Address Book')

    password = None
    for row in context.table:
        field = row['Field']
        value = row['Value']
        if field == 'Password':
            password = value
            continue

        if '\\' in field:
            (tab, field) = field.split('\\')
            dialog.child(name=tab, roleName='page tab').click()

        widget = None
        if field in ['Type:', 'Encryption:', 'Method:', 'Search Scope:']:
            # Type: label doesn't point on a correct label
            widget = dialog.child(name=field).parent.child(roleName='combo box')
            if widget.combovalue != value:
                widget.combovalue = value
        else:
            widget = filter(lambda x: x.showing, dialog.findChildren(GenericPredicate(name=field)))[0]
            widget.parent.textentry('').text = value

    dialog.button('OK').click()

    # Select this addressbook
    if password:
        context.execute_steps(u'* Select "%s" addressbook with password "%s"' % (name, password))
    else:
        context.execute_steps(u'* Select "%s" addressbook' % name)


@step(u'Save "{addressbook}" addressbook as VCard to "{filename}"')
def export_addressbook_as_vcard(context, addressbook, filename):
    import os
    os.system("rm -rf %s" % filename)

    context.execute_steps(u"""
        * Select "%s" addressbook
    """ % addressbook)
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem("Save Address Book as vCard").click()
    context.execute_steps(u"""
        * file select dialog with name "Save as vCard" is displayed
        * in file save dialog save file to "%s" clicking "Save"
        """ % filename)
    # Pause to let the file be really saved
    sleep(0.5)
