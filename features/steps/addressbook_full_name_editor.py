# -*- coding: UTF-8 -*-
from behave import step


@step(u'Open full name window in contact editor')
def open_full_name_window(context):
    context.app.contact_editor.button('Full Name...').click()
    context.app.full_name_window = context.app.instance.dialog('Full Name')


@step(u'Set the following values in full name window')
def set_values_in_full_name_window(context):
    for row in context.table:
        element = context.app.full_name_window.childLabelled(row['Field'])
        if element.roleName == 'text':
            element.text = row['Value']
        else:
            element.combovalue = row['Value']


@step(u'Click "OK" in full name window in contact editor')
def close_full_name_window(context):
    context.app.full_name_window.button('OK').click()


@step(u'The following values are set in full name window')
def verify_values_in_full_name_window(context):
    for row in context.table:
        element = context.app.full_name_window.childLabelled(row['Field'])
        actual = None
        if element.roleName == 'text':
            actual = element.text
        else:
            actual = element.child(roleName='text').text

        context.assertion.assertEqual(actual, row['Value'])
