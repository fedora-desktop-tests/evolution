# -*- coding: UTF-8 -*-
from behave import step
from time import sleep
from dogtail.predicate import GenericPredicate
import dogtail.rawinput
from behave_common_steps import wait_until


@step(u'Open task details editor')
def open_task_details_editor(context):
    context.app.task_editor.button('Status Details').click()
    context.app.task_details_editor = context.app.instance.dialog('Task Details')


@step(u'Close task details editor')
def close_task_details_editor(context):
    context.app.task_details_editor.button('Close').click()
    sleep(0.5)
    assert wait_until(lambda x: not x.showing, context.app.task_details_editor),\
        "Task Details Editor dialog was not closed"


@step(u'Field "{field}" in task details editor is set to "{value}"')
def verify_field_value_in_task_details_editor(context, field, value):
    actual = None
    if field == 'Percent complete:':
        actual = context.app.task_details_editor.childLabelled(field).text
    if field == 'Web Page:':
        actual = context.app.task_details_editor.child('Web Page').text

    # Uncomment this after fix https://bugzilla.gnome.org/show_bug.cgi?id=693660
    #if field in ['Status:', 'Priority:']:
    #    actual = context.app.task_details_editor.childLabelled(field).combovalue
    if field == 'Status:':
        actual = context.app.task_details_editor.findChildren(
            GenericPredicate(roleName='combo box'))[0].combovalue
    if field == 'Priority:':
        actual = context.app.task_details_editor.findChildren(
            GenericPredicate(roleName='combo box'))[1].combovalue

    if field == 'Date completed:':
        date = context.app.task_details_editor.child('Date').text
        time = context.app.task_details_editor.child('Time').textentry('').text
        actual = "%s %s" % (date, time)

    context.assertion.assertEquals(str(actual), value)


@step(u'Task details editor has the following fields set')
def task_details_editor_has_the_following_fields_set(context):
    for row in context.table:
        verify_field_value_in_task_details_editor(context, row['Field'], row['Value'])


@step(u'Set field "{field}" to "{value}" in task details editor')
def set_field_in_task_details_editor(context, field, value):
    if field == 'Percent complete:':
        textbox = context.app.task_details_editor.childLabelled(field)
        textbox.text = value
        textbox.grab_focus()
        dogtail.rawinput.keyCombo("<Enter>")
    if field == 'Web Page:':
        context.app.task_details_editor.child('Web Page').text = value

    # Uncomment this after fix https://bugzilla.gnome.org/show_bug.cgi?id=693660
    #if field in ['Status:', 'Priority:']:
    #    context.app.task_details_editor.childLabelled(field).combovalue = value
    if field == 'Status:':
        context.app.task_details_editor.findChildren(
            GenericPredicate(roleName='combo box'))[0].combovalue = value
    if field == 'Priority:':
        context.app.task_details_editor.findChildren(
            GenericPredicate(roleName='combo box'))[1].combovalue = value

    if field == 'Date completed:':
        (date, time) = value.split(' ')
        context.app.task_details_editor.child('Date').text = date
        context.app.task_details_editor.child('Time').textentry('').text = time


@step(u'Set the following values in task details editor')
def set_fields_in_task_details_editor(context):
    for row in context.table:
        set_field_in_task_details_editor(context, row['Field'], row['Value'])
