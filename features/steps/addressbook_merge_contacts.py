# -*- coding: UTF-8 -*-
from behave import step
from behave_common_steps import wait_until
from dogtail.predicate import IsADialogNamed


@step(u'Save and merge the contacts')
def save_and_merge_the_contacts(context):
    context.app.contact_editor.button('Save').click()
    assert wait_until(
        lambda x: x.findChildren(IsADialogNamed('Duplicate Contact Detected')) != [],
        context.app.instance), "Duplicate Contact Detected dialod didn't appear"
    dupl_dialog = context.app.instance.dialog('Duplicate Contact Detected')
    dupl_dialog.button('Merge').click()
    merge_dialog = context.app.instance.dialog('Merge Contact')
    merge_dialog.button('Merge').click()
    assert wait_until(lambda x: x.dead, merge_dialog),\
        "Merge dialog was not closed"
    assert wait_until(lambda x: x.dead and not x.showing, dupl_dialog),\
        "Duplicate Contact dialog was not closed"


@step(u'Save and add the duplicated contact')
def save_and_add_the_duplicated_contact(context):
    context.app.contact_editor.button('Save').click()
    dupl_dialog = context.app.instance.dialog('Duplicate Contact Detected')
    dupl_dialog.button('Add').click()
    assert wait_until(lambda x: x.dead and not x.showing, dupl_dialog),\
        "Duplicate Contact dialog was not closed"
