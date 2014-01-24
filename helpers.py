#!/usr/bin/python
"""
Evolution test helpers
"""
import os
from dogtail.predicate import GenericPredicate
from gi.repository import GLib


def find_visible_searchbars(context):
    """Get a list of visible searchbars"""
    for attempt in range(0, 5):
        try:
            search_bars = context.app.instance.findChildren(GenericPredicate(label='Search:'))
            showing_searchbars = [bar for bar in search_bars if bar.showing]
            if showing_searchbars == []:
                return False
            else:
                return showing_searchbars[0]
        except (GLib.GError, TypeError):
            continue


def get_visible_searchbar(context):
    """Wait for searchbar to become visible"""
    from behave_common_steps import timeout
    from helpers import find_visible_searchbars
    assert timeout(find_visible_searchbars, context, expected=False, equals=False),\
        "No visible searchbars found"
    return find_visible_searchbars(context)


def check_for_errors(context):
    """Check that no error is displayed on Evolution UI"""
    # Don't try to check for errors on dead app
    if not context.app.instance or context.app.instance.dead:
        return
    alerts = context.app.instance.findChildren(GenericPredicate(roleName='alert'))
    if not alerts:
        # alerts can also return None
        return
    alerts = filter(lambda x: x.showing, alerts)
    if len(alerts) > 0:
        labels = alerts[0].findChildren(GenericPredicate(roleName='label'))
        messages = [x.name for x in labels]

        if alerts[0].name != 'Error' and alerts[0].showing:
            # Erase the configuration and start all over again
            os.system("evolution --force-shutdown &> /dev/null")

            # Remove previous data
            folders = ['~/.local/share/evolution', '~/.cache/evolution', '~/.config/evolution']
            for folder in folders:
                os.system("rm -rf %s > /dev/null" % folder)

            raise RuntimeError("Error occurred: %s" % messages)
        else:
            print("Error occurred: %s" % messages)


def get_combobox_textbox_object(contact_editor, section):
    """Get a list of paired 'combobox-textbox' objects in contact editor"""
    section_names = {
        'Ims': 'Instant Messaging',
        'Phones': 'Telephone',
        'Emails': 'Email'}
    section = section_names[section.capitalize()]
    lbl = contact_editor.child(roleName='label', name=section)
    panel = lbl.findAncestor(GenericPredicate(roleName='panel'))
    textboxes = panel.findChildren(GenericPredicate(roleName='text'))

    # Expand section if button exists
    button = panel.findChild(
        GenericPredicate(roleName='push button', name=section),
        retry=False, requireResult=False)
    # Expand button if any of textboxes is not visible
    if button and (False in [x.showing for x in textboxes]):
        button.click()

    comboboxes = panel.findChildren(GenericPredicate(roleName='combo box'))

    # Rearrange comboboxes and textboxes according to their position
    result = []
    for combo in comboboxes:
        combo_row = combo.position[1]
        matching_textboxes = [
            x for x in textboxes
            if (x.position[1] == combo_row) and (x.position[0] > combo.position[0])]
        correct_textbox = min(matching_textboxes, key=lambda x: x.position[0])
        result.append((combo, correct_textbox))

    comboboxes = [x[0] for x in result]
    textboxes = [x[1] for x in result]

    return (textboxes, comboboxes)
