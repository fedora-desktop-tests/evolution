# -*- coding: UTF-8 -*-
from behave import step
from time import sleep
from dogtail.predicate import GenericPredicate
from behave_common_steps import wait_until


@step(u'Task editor with title "{title}" is opened')
def task_editor_with_title_is_opened(context, title):
    context.app.task_editor = context.app.instance.window(title)
    # Spoof event_editor for assigned tasks
    if 'Assigned' in title:
        context.app.event_editor = context.app.task_editor


@step(u'Field "{field}" in task editor is set to "{value}"')
def verify_field_value(context, field, value):
    if field in ['Start date:', 'Due date:']:
        textbox = context.app.task_editor.child(field).labelee
        if textbox:
            actual = textbox.textentry('Date').text
        else:
            actual = context.app.task_editor.textentry('Date').text
    elif field in ['List:', 'Status:', 'Priority:', 'Classification:']:
        actual = context.app.task_editor.childLabelled(field).combovalue.strip()
    elif field == 'To:':
        actual = context.app.task_editor.textentry('To').text
    else:
        if field == 'Web Page:':
            actual = context.app.task_editor.child(field).labelee.textentry('').text
        else:
            actual = context.app.task_editor.childLabelled(field).text

    context.assertion.assertEquals(str(actual), value)


@step(u'Memo editor has the following fields set')
@step(u'Task editor has the following fields set')
def task_editor_has_the_following_fields_set(context):
    for row in context.table:
        verify_field_value(context, row['Field'], row['Value'])


@step(u'Set field "{field}" to "{value}" in task editor')
def set_field_in_task_editor(context, field, value):
    if field in ['Start date:', 'Due date:']:
        textbox = context.app.task_editor.child(field).labelee
        if textbox:
            textbox.textentry('Date').text = value
        else:
            context.app.task_editor.textentry('Date').text = value
    elif field in ['List:', 'Status:', 'Priority:', 'Classification:']:
        actual = context.app.task_editor.childLabelled(field).combovalue.strip()
        if actual != value:
            if field == 'List:':
                new_value = '    ' + value
            else:
                new_value = value
            context.app.task_editor.childLabelled(field).combovalue = new_value
    elif field == 'To:':
        context.app.task_editor.textentry('To').text = value
    else:
        if field == 'Web Page:':
            context.app.task_editor.child(field).labelee.textentry('').text = value
        else:
            context.app.task_editor.childLabelled(field).text = value
            if field != 'Description:':
                context.app.task_editor.childLabelled(field).keyCombo("<Enter>")


@step(u'Set the following values in memo editor')
@step(u'Set the following values in task editor')
def set_fields_in_task_editor(context):
    for row in context.table:
        set_field_in_task_editor(context, row['Field'], row['Value'])


@step(u'Save and close memo editor')
@step(u'Save and close task editor')
def save_and_close_task_editor(context):
    context.app.task_editor.button('Save and Close').click()
    if wait_until(
            lambda x: x.findChildren(GenericPredicate(roleName='dialog', name=' ')) != [],
            context.app.instance):
        dialog = context.app.instance.findChild(
            GenericPredicate(roleName='dialog', name=' '))
        dialog.button('Do not Send').click()
        assert wait_until(lambda x: x.dead, dialog),\
            "Meeting invitations dialog was not closed"
    assert wait_until(lambda x: x.dead and not x.showing, context.app.task_editor),\
        "Task Editor dialog was not closed"


@step(u'Save changes, send notifications and close task editor')
@step(u'Save changes, send notifications and close memo editor')
def save_send_notifications_and_close_task_editor(context):
    context.app.task_editor.button('Save and Close').click()
    sleep(1)
    dialog = context.app.instance.findChild(
        GenericPredicate(roleName='dialog', name=' '),
        retry=False, requireResult=False)
    if dialog:
        dialog = context.app.instance.dialog(' ')
        dialog.button('Send').click()
        assert wait_until(lambda x: x.dead, dialog),\
            "Meeting invitations dialog was not closed"
    assert wait_until(lambda x: x.dead, context.app.task_editor),\
        "Task Editor dialog was not closed"
