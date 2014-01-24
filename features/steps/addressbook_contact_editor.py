# -*- coding: UTF-8 -*-
from behave import step, then
from dogtail.predicate import GenericPredicate
from behave_common_steps import wait_until
from helpers import get_combobox_textbox_object
from __builtin__ import unicode


@then(u'Contact editor window with title "{title}" is opened')
def contact_editor_with_label_is_opened(context, title):
    context.app.contact_editor = context.app.instance.dialog(title)
    context.assertion.assertIsNotNone(
        context.app.contact_editor, "Contact Editor was not found")
    context.assertion.assertTrue(
        context.app.contact_editor.showing, "Contact Editor didn't appear")


@then(u'Contact editor window is opened')
def contact_editor_is_opened(context):
    context.execute_steps(u'Then Contact editor window with title "Contact Editor" is opened')


@step(u'Save the contact')
def save_contact(context):
    context.app.contact_editor.button('Save').click()
    assert wait_until(lambda x: x.dead, context.app.contact_editor),\
        "Contact Editor was not closed"
    context.app.contact_editor = None


@step(u'Switch to "{name}" tab in contact editor')
def switch_to_tab(context, name):
    context.app.contact_editor.tab(name).click()


def get_element_by_name(contact_editor, name, section=None):
    """Get a field object by name in section (if specified)"""
    element = None
    if section:
        panel = contact_editor.findChild(
            GenericPredicate(roleName='panel', name=section), retry=False, requireResult=False)
        if not panel:
            # Other section is not a panel, but a toggle button
            panel = contact_editor.child(roleName='toggle button', name=section)
        element = panel.childLabelled(name)
    else:
        label = contact_editor.findChild(
            GenericPredicate(label=name), retry=False, requireResult=False)
        if not label:
            # In case childLabelled is missing
            # Find a filler with this name and get its text child
            element = contact_editor.child(
                roleName='filler', name=name).child(roleName='text')
        else:
            element = contact_editor.childLabelled(name)
    if element:
        return element
    else:
        raise RuntimeError("Cannot find element named '%s' in section '%s'" % (
            name, section))


@step(u'Set "{field_name}" in contact editor to "{field_value}"')
def set_field_to_value(context, field_name, field_value):
    element = get_element_by_name(context.app.contact_editor, field_name)
    if element.roleName == "text":
        element.text = field_value
    elif element.roleName == "combo box":
        if element.combovalue != field_value:
            element.combovalue = field_value


@step(u'Set the following properties in contact editor')
def set_properties(context):
    for row in context.table.rows:
        context.execute_steps(u"""
            * Set "%s" in contact editor to "%s"
        """ % (row['Field'], row['Value']))


@step(u'Set "{field_name}" in "{section}" section of contact editor to "{field_value}"')
def set_field_in_section_to_value(context, field_name, section, field_value):
    element = get_element_by_name(
        context.app.contact_editor, field_name, section=section)
    if element.roleName == "text":
        element.text = field_value
    elif element.roleName == "combo box":
        element.combovalue = field_value


@step(u'Set the following properties in "{section}" section of contact editor')
def set_properties_in_section(context, section):
    for row in context.table.rows:
        context.execute_steps(u"""
            * Set "%s" in "%s" section of contact editor to "%s"
        """ % (row['Field'], section, row['Value']))


@then(u'"{field}" property is empty')
def property_in_contact_window_is_empty(context, field):
    property_in_contact_window_is_set_to(context, field, "")


@then(u'"{field}" property is set to "{expected}"')
def property_in_contact_window_is_set_to(context, field, expected):
    element = get_element_by_name(context.app.contact_editor, field)
    actual = None
    if element.roleName == "text":
        actual = element.text
    elif element.roleName == "combo box":
        actual = element.combovalue
        if actual == '':
            actual = element.textentry('').text
    context.assertion.assertEquals(unicode(actual), expected)


@then(u'Categories field is set to "{expected}"')
def categories_field_is_set_to(context, expected):
    """ Categories field may output categories in random order
    So they should be handled as a list"""
    element = get_element_by_name(context.app.contact_editor, 'Categories...')
    actual_text = element.text
    actual_list = actual_text.split(',').sort()
    expected_list = str(expected).split(',').sort()
    context.assertion.assertEquals(actual_list, expected_list)


@then(u'"{field}" property in "{section}" section is set to "{expected}"')
def property_in_section_is_set_to(context, field, section, expected):
    element = get_element_by_name(
        context.app.contact_editor, field, section=section)
    if element.roleName == "text":
        actual = element.text
    elif element.roleName == "combo box":
        actual = element.combovalue
        if actual == '':
            actual = element.textentry('').text
    context.assertion.assertEquals(unicode(actual), expected)


@step(u'The following properties in contact editor are set')
def verify_properties(context):
    for row in context.table.rows:
        context.execute_steps(u"""
            Then "%s" property is set to "%s"
        """ % (row['Field'], row['Value']))


@step(u'The following properties in "{section}" section of contact editor are set')
def verify_properties_in_section(context, section):
    for row in context.table.rows:
        context.execute_steps(u"""
            Then "%s" property in "%s" section is set to "%s"
        """ % (row['Field'], section, row['Value']))


@step(u'Set {section} in contact editor to')
def set_contact_emails_to_value(context, section):
    (textboxes, comboboxes) = get_combobox_textbox_object(
        context.app.contact_editor, section)

    # clear existing data
    for textbox in textboxes:
        textbox.text = ""

    for index, row in enumerate(context.table.rows):
        textboxes[index].text = row['Value']
        if comboboxes[index].combovalue != row['Field']:
            comboboxes[index].combovalue = row['Field']


@then(u'{section} are set to')
def emails_are_set_to(context, section):
    (textboxes, comboboxes) = get_combobox_textbox_object(
        context.app.contact_editor, section)

    actual = []
    for index, textbox in enumerate(textboxes):
        combo_value = textbox.text
        if combo_value.strip() != '':
            type_value = comboboxes[index].combovalue
            actual.append({'Field': unicode(type_value), 'Value': unicode(combo_value)})
    actual = sorted(actual)

    expected = []
    for row in context.table:
        expected.append({'Field': row['Field'], 'Value': row['Value']})
    expected = sorted(expected)

    context.assertion.assertEqual(actual, expected)


@step(u'Set the following note for the contact')
def set_note_for_contact(context):
    context.app.contact_editor.child(
        roleName='page tab', name='Notes').textentry('').text = context.text


@then(u'The following note is set for the contact')
def verify_note_set_for_contact(context):
    actual = context.app.contact_editor.child(
        roleName='page tab', name='Notes').textentry('').text
    expected = context.text
    context.assertion.assertEquals(unicode(actual), expected)


@step(u'Tick "Wants to receive HTML mail" checkbox')
def tick_checkbox(context):
    context.app.contact_editor.childNamed("Wants to receive HTML mail").click()


@step(u'"Wants to receive HTML mail" checkbox is ticked')
def checkbox_is_ticked(context):
    check_state = context.app.instance.childNamed("Wants to receive HTML mail").checked
    context.assertion.assertTrue(check_state)


@step(u'Set contact picture to "{file_name}"')
def set_contact_picture(context, file_name):
    context.app.contact_editor.button('Image').click()
    context.execute_steps(u"""
        * file select dialog with name "Please select an image for this contact" is displayed
        * in file select dialog I select "%s"
    """ % file_name)


@step(u'Save the contact and in resize dialog select "{option}"')
def save_and_do_not_resize(context, option):
    context.app.contact_editor.button('Save').click()
    dlg = context.app.instance.dialog(' ')
    dlg.button(option).click()
    assert wait_until(lambda x: x.dead, dlg), "Resize dialog was not closed"
    assert wait_until(lambda x: x.dead, context.app.contact_editor),\
        "Contact Editor dialog was not closed"
