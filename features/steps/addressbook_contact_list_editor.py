# -*- coding: UTF-8 -*-
from behave import step, then
from dogtail.predicate import GenericPredicate
from dogtail.rawinput import keyCombo
from behave_common_steps import wait_until
from time import sleep


@step(u'Create a new contact list')
def create_new_contact_list(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menu('New').point()
    context.app.instance.menu('File').menu('New').menuItem("Contact List").click()
    context.execute_steps(u"Then Contact List editor window is opened")


@then(u'Contact List editor window is opened')
def contact_list_editor_is_opened(context):
    context.execute_steps(
        u'Then Contact List editor window with title "Contact List Editor" is opened')


@then(u'Contact List editor window with title "{name}" is opened')
def contact_list_editor__with_name_is_opened(context, name):
    context.app.contact_list_editor = context.app.instance.dialog(name)


@step(u'Set contact list name to "{name}"')
def set_contact_list_name(context, name):
    context.app.contact_list_editor.childLabelled('List name:').text = name


@step(u'Set contact list addressbook to "{name}"')
def set_contact_list_addressbook(context, name):
    combo = context.app.contact_list_editor.childLabelled('Where:')
    if combo.combovalue != name:
        combo.combovalue = name


@step(u'Save the contact list')
def save_contact_list(context):
    context.app.contact_list_editor.button('Save').click()
    assert wait_until(lambda x: x.dead, context.app.contact_list_editor),\
        "Contact List Editor dialog was not closed"


@step(u'Open contact list editor')
def open_contact_list_editor(context):
    context.app.instance.menu('File').click()
    context.app.instance.menu('File').menuItem('Open Contact').click()
    context.execute_steps(u"""
        Then Contact List editor window with title "%s" is opened
    """ % context.selected_contact_text)


@step(u'Add "{email}" to the contact list')
def add_email_to_contact_list(context, email):
    context.app.contact_list_editor.textentry('Members').text = email
    context.app.contact_list_editor.button('Add').click()


@step(u'Add first suggestion for "{name}" to the contact list')
def add_first_suggestion_for_name_to_contact_list(context, name):
    context.app.contact_list_editor.textentry('Members').typeText(name)
    sleep(0.5)
    keyCombo('<Down>')
    keyCombo('<Enter>')
    context.app.contact_list_editor.button('Add').click()


@step(u'Remove "{email}" from the contact list')
def remove_email_from_contact_list(context, email):
    context.app.contact_list_editor.child(roleName='table cell', name=email).click()
    context.app.contact_list_editor.button('Remove').click()


def get_emails_in_contact_list(context):
    table = context.app.contact_list_editor.child(roleName='tree table')
    cells = table.findChildren(GenericPredicate(roleName='table cell'))
    return map(lambda c: str(c.text), cells)


@step(u'contact list members list is')
def verify_contact_list_emails(context):
    actual = get_emails_in_contact_list(context)
    expected = [str(row['Email']) for row in context.table.rows]

    context.assertion.assertEqual(actual, expected)


@step(u'contact list members list is empty')
def contact_list_members_list_is_empty(context):
    actual = get_emails_in_contact_list(context)
    context.assertion.assertEqual(actual, [])


@step(u'Delete the selected contact list')
def delete_selected_contact_list(context):
    context.execute_steps(u'* Delete selected contact')


@step(u'Unset "Hide addresses when sending email to this list" in contact list editor')
def unset_hide_addresses_in_contact_list_editor(context):
    child = context.app.contact_list_editor.child("Hide addresses when sending mail to this list")
    if child.checked:
        child.click()
