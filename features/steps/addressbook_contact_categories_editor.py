# -*- coding: UTF-8 -*-
from behave import step
from dogtail.predicate import GenericPredicate
from dogtail.rawinput import keyCombo, typeText
from time import sleep
from behave_common_steps import wait_until


@step(u'Open "Categories..." dialog in contact editor')
def open_categories_dialog(context):
    context.app.contact_editor.button('Categories...').click()
    context.app.categories = context.app.instance.dialog('Categories')


@step(u'Close categories dialog')
def close_categories_dialog(context):
    context.app.categories.button('OK').click()
    assert wait_until(lambda x: x.dead, context.app.categories),\
        "New category dialog is opened"


@step(u'Set currently used categories to "{categories}"')
def set_currently_used_categories(context, categories):
    textbox = context.app.categories.childLabelled('Currently used categories:')
    textbox.text = categories
    textbox.grab_focus()
    keyCombo('<Enter>')


def scroll_to_cell_named(context, name):
    table = context.app.categories.child(roleName='table')

    # Find the required cell
    cells = table.findChildren(GenericPredicate(roleName='table cell'))
    cell_names = map(lambda c: c.text, cells)
    index = cell_names.index(name)
    cell = cells[index]
    # Scroll down to the cell
    sb = context.app.categories.findChildren(
        GenericPredicate(roleName='scroll bar'))[1]
    sb.value = 0
    # Cell can be clicked?
    while cell.position[1] + cell.size[1] / 2 < 0:
        if sb.value == sb.maxValue:
            raise RuntimeError("Cell '%s' cannot be scrolled to!" % name)
        else:
            sb.value += 20
    sb.value += 20
    return cells[index - 2:index]


@step(u'Check "{category}" category')
def check_category(context, category):
    cells = scroll_to_cell_named(context, category)
    cells[0].click()


@step(u'Uncheck "{category}" category')
def uncheck_category(context, category):
    # TODO Merge me with check function
    check_category(context, category)


@step(u'Open new category dialog')
def open_new_category_dialog(context):
    context.app.categories.button('New').click()
    context.app.new_category = context.app.instance.dialog('Category Properties')


@step(u'Close new category dialog')
def close_new_category_dialog(context):
    context.app.new_category.button('OK').click()
    assert wait_until(lambda x: x.dead, context.app.new_category),\
        "New category dialog is opened"


@step(u'Close new category dialog without verification')
def close_new_category_dialog_without_verification(context):
    context.app.new_category.button('OK').click()


@step(u'Set category name to "{name}"')
def set_new_category_name_to(context, name):
    context.app.new_category.childLabelled('Category Name').text = name


@step(u'Edit "{name}" category')
def edit_category(context, name):
    cells = scroll_to_cell_named(context, name)
    cells[1].click()
    context.app.categories.button('Edit').click()
    context.app.new_category = context.app.instance.dialog('Category Properties')


@step(u'Delete "{name}" category')
def delete_category(context, name):
    cells = scroll_to_cell_named(context, name)
    cells[1].click()
    context.app.categories.button('Delete').click()


@step(u'Set "{filename}" as category icon')
def set_category_icon(context, filename):
    context.app.new_category.childLabelled('Category Icon').parent.child(roleName='push button').click()
    context.execute_steps(u"""
        * file select dialog with name "Category Icon" is displayed
        * in file select dialog I select "%s"
    """ % filename)


@step(u'Unset icon for category')
def unset_icon_for_category(context):
    context.app.new_category.childLabelled('Category Icon').parent.child(roleName='push button').click()
    context.execute_steps(u"""
        * file select dialog with name "Category Icon" is displayed
    """)
    context.app.dialog.button("No Image").click()


@step(u'Show category suggestions for "{string}"')
def show_category_suggestions_for_string(context, string):
    context.app.categories.childLabelled('Currently used categories:').grab_focus()
    typeText(string)
    sleep(1)


@step(u'Select category {index} from suggestion box in category dialog')
def select_category_from_suggection_box(context, index):
    context.app.categories.childLabelled('Currently used categories:').grab_focus()
    for i in range(0, int(index)):
        keyCombo("<Down>")
    keyCombo("<Enter>")


@step(u'currently used categories is set to "{value}"')
def currently_used_categories_text_is(context, value):
    context.assertion.assertEquals(
        context.app.categories.childLabelled('Currently used categories:').text,
        value)


@step(u'"This category already exists" dialog appears')
def this_categoty_already_exists_dialog(context):
    alert = context.app.instance.child(roleName='alert', name='Error')
    context.assertion.assertIn(
        "Please use another name", alert.child(roleName='label').text)
