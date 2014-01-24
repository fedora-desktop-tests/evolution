# -*- coding: UTF-8 -*-
from behave import step, then

import difflib
from gi.repository import GLib
from dogtail.predicate import GenericPredicate
from dogtail.tree import root, SearchError
from dogtail.rawinput import keyCombo, typeText
from time import sleep, time
import os, subprocess
import pyatspi
from helpers import check_for_errors, get_visible_searchbar
from behave_common_steps import limit_execution_time_to, wait_until


@step(u'Evolution has {num:d} window opened')
@step(u'Evolution has {num:d} windows opened')
def evolution_has_num_windows_opened(context, num):
    windows = context.app.instance.findChildren(GenericPredicate(roleName='frame'))
    context.assertion.assertEqual(len(windows), num)


@step(u'Preferences dialog is opened')
def preferences_dialog_opened(context):
    context.app.instance.window('Evolution Preferences')


@step(u'"{name}" view is opened')
def view_is_opened(context, name):
    if name != 'Mail':
        window_name = context.app.instance.children[0].name
        context.assertion.assertEquals(window_name, "%s - Evolution" % name)
    else:
        # A special case for Mail
        context.assertion.assertTrue(context.app.instance.menu('Message').showing)


@step(u'Open "{section_name}" section')
def open_section_by_name(context, section_name):
    context.app.instance.menu('View').click()
    context.app.instance.menu('View').menu('Window').point()
    context.app.instance.menu('View').menu('Window').menuItem(section_name).click()
    context.search_bar = get_visible_searchbar(context)


@then(u'"{filename}" file contents is')
def file_contents(context, filename):
    with open(filename, 'r') as f:
        expected = context.text.splitlines(1)
        actual = f.readlines()

        def scrub_element(strings, name):
            for x in strings:
                if x.startswith(name):
                    index = strings.index(x)
                    # Remove all the following elements, as attribute value
                    # can be formatted and moved to the next step
                    del strings[index]
                    while 1:
                        if len(strings) == index:
                            break
                        if strings[index].startswith(' '):
                            del strings[index]
                        else:
                            break
            return strings

        # Replace \r\n in file with \n
        actual = [x.replace('\r\n', '\n') for x in actual]

        elements_to_scrub = [
            'UID:', 'REV:', 'DTSTAMP:', 'CREATED:',
            'LAST-MODIFIED:', 'COMPLETED:', 'X-EVOLUTION-CALDAV-HREF:',
            'X-EVOLUTION-CALDAV-ETAG:', 'X-EVOLUTION-WEBDAV-ETAG:']
        for element in elements_to_scrub:
            actual = scrub_element(actual, element)

        error_message = "\n"
        for line in difflib.unified_diff(expected, actual, fromfile='expected', tofile='actual'):
            error_message += line

        context.assertion.assertEqual(expected, actual, error_message)


@step(u'Save the following text in "{filename}"')
def save_the_following_text_in_file(context, filename):
    with open(filename, 'w') as f:
        f.write(context.text)


@step(u'Download "{url}" to "{file_name}"')
def download_file_and_save(context, url, file_name):
    import urllib2
    u = urllib2.urlopen(url)
    localFile = open(file_name, 'w')
    localFile.write(u.read())
    localFile.close()


@limit_execution_time_to(10)
def wait_for_evolution_to_appear(context):
    # Waiting for a window to appear
    try:
        context.app.instance = root.application('evolution')
        context.app.instance.child(roleName='frame')
    except (GLib.GError, SearchError):
        os.system("python cleanup.py")
        os.system("evolution --force-shutdown 2&> /dev/null")
        raise RuntimeError("Evolution cannot be started")


@step(u'Start Evolution via {type:w}')
def start_evo_via_command(context, type):
    for attempt in xrange(0, 10):
        try:
            if type == 'command':
                context.app.startViaCommand()
            if type == 'menu':
                context.app.startViaMenu()
            break
        except GLib.GError:
            sleep(1)
            if attempt == 6:
                # Killall evolution processes if we reached 30 seconds wait
                os.system("evolution --force-shutdown 2&> /dev/null")
            continue
    wait_for_evolution_to_appear(context)


@step(u'Handle authentication window with password "{password}"')
def handle_authentication_window_with_custom_password(context, password):
    handle_authentication_window(context, password)


@step(u'Handle authentication window')
def handle_authentication_window(context, password='gnome'):
    # Get a list of applications
    app_names = []
    for attempt in range(0, 15):
        try:
            app_names = map(lambda x: x.name, root.applications())
            break
        except GLib.GError:
            sleep(1)
            continue
    if 'gcr-prompter' in app_names:
        # Non gnome shell stuf
        passprompt = root.application('gcr-prompter')
        continue_button = passprompt.findChild(
            GenericPredicate(name='Continue'),
            retry=False, requireResult=False)
        if continue_button:
            passprompt.findChildren(GenericPredicate(roleName='password text'))[-1].grab_focus()
            sleep(0.5)
            typeText(password)
            # Don't save passwords to keyring
            keyCombo('<Tab>')
            # Click Continue
            keyCombo('<Tab>')
            keyCombo('<Tab>')
            keyCombo('<Enter>')
    elif 'gnome-shell' in app_names:
        shell = root.application('gnome-shell')
        if shell.findChildren(GenericPredicate(roleName='password text')):
            pswrd = shell.child(roleName='password text')
            pswrd.text = password
            st = shell.child('Add this password to your keyring')
            if not st.parent.parent.checked:
                st.click()
            continue_button = shell.button('Continue')
            shell.button('Continue').click()
            assert wait_until(lambda x: x.dead, continue_button),\
                "Authentication request dialog is still visible"


@step(u'Press "{sequence}"')
def press_button_sequence(context, sequence):
    keyCombo(sequence)
    sleep(0.5)


@then(u'Evolution is closed')
def evolution_is_closed(context):
    assert wait_until(lambda x: x.dead, context.app.instance),\
        "Evolution window is opened"
    context.assertion.assertFalse(context.app.isRunning(), "Evolution is in the process list")


@step(u'Help section "{name}" is displayed')
def help_is_displayed(context, name):
    context.yelp = root.application('yelp')
    frame = context.yelp.child(roleName='frame')
    context.assertion.assertEquals(name, frame.name)


@step(u'"{name}" menu is opened')
def menu_is_opened(context, name):
    sleep(0.5)
    menu = context.app.instance.menu(name)
    children_displayed = [x.showing for x in menu.children]
    context.assertion.assertTrue(True in children_displayed, "Menu '%s' is not opened" % name)


@step(u'Close appointments window if it appears')
def close_appointments_window(context):
    if filter(lambda x: x.name == 'evolution-alarm-notify', root.applications()):
        alarm_notify = root.application('evolution-alarm-notify')
        dialog = alarm_notify.findChild(
            GenericPredicate(name='Appointments'),
            retry=False, requireResult=False)
        if dialog:
            dialog.button('Dismiss All').click()
            assert wait_until(lambda x: x.dead and not x.showing, dialog),\
                "Appointments window didn't disappear"


@step(u'Wait for email to synchronize')
def wait_for_mail_folder_to_synchronize(context):
    # Wait until Google calendar is loaded
    for attempt in range(0, 10):
        start_time = time()
        try:
            spinners = context.app.instance.findChildren(GenericPredicate(name='Spinner'))
            for spinner in spinners:
                try:
                    while spinner.showing:
                        sleep(0.1)
                        if (time() - start_time) > 180:
                            raise RuntimeError("Mail takes too long to synchronize")
                except GLib.GError:
                    continue
        except (GLib.GError, TypeError):
            continue
    check_for_errors(context)


def click_continue(window):
    # As initial wizard dialog creates a bunch of 'Continue' buttons
    # We have to click to the visible and enabled one
    button = None
    for attempt in xrange(0, 50):
        btns = window.findChildren(GenericPredicate(name='Continue'))
        visible_and_enabled = [x for x in btns if x.showing and pyatspi.STATE_SENSITIVE in x.getState().getStates()]
        if visible_and_enabled == []:
            sleep(0.1)
            continue
        else:
            button = visible_and_enabled[0]
            break
    button.click()


@step(u'Complete Done dialog in Evolution Account Assistant')
def evo_account_assistant_done_dialog(context):
    # nothing to do here, skip it
    window = context.app.instance.child('Evolution Account Assistant')
    window.button('Apply').click()


@step(u'Complete Receiving Options in Evolution Account Assistant')
@step(u'Complete Account Summary in Evolution Account Assistant')
@step(u'Complete Restore from Backup dialog in Evolution Account Assistant')
@step(u'Complete Welcome dialog in Evolution Account Assistant')
def evo_account_assistant_dummy_dialogs(context):
    # nothing to do here, skip it
    window = context.app.instance.child('Evolution Account Assistant')
    click_continue(window)


@step(u'Complete Identity dialog setting name to "{name}" and email address to "{email}"')
def evo_account_assistant_identity_dialog(context, name, email):
    # nothing to do here, skip it
    window = context.app.instance.child('Evolution Account Assistant')
    window.childLabelled("Full Name:").text = name
    window.childLabelled("Email Address:").text = email
    click_continue(window)


@step(u'Complete {sending_or_receiving} Email dialog of Evolution Account Assistant setting')
def evo_account_assistant_receiving_email_dialog_from_table(context, sending_or_receiving):
    window = context.app.instance.child('Evolution Account Assistant')
    for row in context.table:
        label = str(row['Field'])
        value = str(row['Value'])
        filler = window.child(roleName='filler', name='%s Email' % sending_or_receiving)
        widgets = filler.findChildren(GenericPredicate(label=label))
        visible_widgets = [w for w in widgets if w.showing]
        if len(visible_widgets) == 0:
            raise RuntimeError("Cannot find visible widget labelled '%s'" % label)
        widget = visible_widgets[0]
        if widget.roleName == 'combo box':
            if label != 'Port:':
                widget.click()
                widget.menuItem(value).click()
            else:
                # Port is a combobox, but you can type your port there
                widget.textentry('').text = value
                widget.textentry('').grab_focus()
                widget.textentry('').keyCombo("<Enter>")
        if widget.roleName == 'text':
            widget.text = value

    # Check for password here and accept self-generated certificate (if appears)
    btns = window.findChildren(GenericPredicate(name='Check for Supported Types'))
    visible_btns = [w for w in btns if w.showing]
    if visible_btns == []:
        click_continue(window)
        return
    visible_btns[0].click()

    # Confirm all certificates by clicking 'Accept Permanently' until dialog is visible
    apps = [x.name for x in root.applications()]
    if 'evolution-user-prompter' in apps:
        prompter = root.application('evolution-user-prompter')
        dialog = prompter.findChild(GenericPredicate(roleName='dialog'))
        while dialog.showing:
            if prompter.findChild(
                    GenericPredicate(name='Accept Permanently'),
                    retry=False, requireResult=False):
                prompter.button('Accept Permanently').click()
            else:
                sleep(0.1)

    # Wait until Cancel button disappears
    cancel = filler.findChildren(GenericPredicate(name='Cancel'))[0]
    while cancel.showing:
        sleep(0.1)
    check_for_errors(context)
    click_continue(window)


@step(u"Wait for account is being looked up dialog in Evolution Account Assistant")
def wait_for_account_to_be_looked_up(context):
    window = context.app.instance.child('Evolution Account Assistant')
    skip_lookup = window.findChildren(GenericPredicate(name='Skip Lookup'))
    visible_skip_lookup = [x for x in skip_lookup if x.showing]
    if len(visible_skip_lookup) > 0:
        visible_skip_lookup = visible_skip_lookup[0]
        assert wait_until(lambda x: not x.showing, visible_skip_lookup),\
            "Skip Lookup button didn't dissappear"


@step(u'Complete Evolution Account Assistant for account {account_type} with restart')
def complete_evo_account_assistant_for_account_with_reboot(context, account_type, secondary=False):
    context.execute_steps(u"* Complete Evolution Account Assistant for account {account_type}")


@step(u'Open Evolution via {method} and setup Google account')
def open_evolution_and_setup_google_account(context, method):
    os.system("evolution --force-shutdown 2&> /dev/null")
    context.execute_steps(u"""
        * Try to restore Evolution backup for "Google" account type
        * Start Evolution via %s
    """ % method)
    window = context.app.instance.child(roleName='frame')
    if window.name == 'Evolution Account Assistant':
        context.execute_steps(u"""
            * Complete Welcome dialog in Evolution Account Assistant
            * Complete Restore from Backup dialog in Evolution Account Assistant
            * Complete Identity dialog setting name to "DesktopQE User" and email address to "desktopqe@gmail.com"
            * Wait for account is being looked up dialog in Evolution Account Assistant
            * Complete Account Summary in Evolution Account Assistant
            * Complete Done dialog in Evolution Account Assistant
            * Handle authentication window
            * Save evo backup for "Google" account type
            * Start Evolution via command
        """)
    context.execute_steps(u"""
        * Handle authentication window
        * Close appointments window if it appears
        * Wait for email to synchronize
    """)


@step(u'Open Evolution via {method} and setup fake account')
def open_evolution_and_setup_fake_account(context, method):
    os.system("evolution --force-shutdown 2&> /dev/null")
    context.execute_steps(u"""
        * Try to restore Evolution backup for "fake" account type
        * Start Evolution via %s
    """ % method)
    window = context.app.instance.child(roleName='frame')
    if window.name == 'Evolution Account Assistant':
        context.execute_steps(u"""
            * Complete Welcome dialog in Evolution Account Assistant
            * Complete Restore from Backup dialog in Evolution Account Assistant
            * Complete Identity dialog setting name to "DesktopQE User" and email address to "test@test"
            * Wait for account is being looked up dialog in Evolution Account Assistant
            * Complete Receiving Email dialog of Evolution Account Assistant setting
              | Field        | Value |
              | Server Type: | None  |
            * Complete Sending Email dialog of Evolution Account Assistant setting
              | Field        | Value    |
              | Server Type: | Sendmail |
            * Complete Account Summary in Evolution Account Assistant
            * Complete Done dialog in Evolution Account Assistant
            """)
        # Evo doesn't create default addressbook immidiately
        # We should restart it
        os.system("evolution --force-shutdown 2&> /dev/null")
        context.execute_steps(u"""
            * Save evo backup for "fake" account type
            * Start Evolution via command
        """)


@step(u'Try to restore Evolution backup for "{account_type}" account type')
def restore_evo_backup(context, account_type):
    # Check that backup file exists
    backup_path = "/tmp/backups/evo_backup_%s.tar.gz" % account_type
    if os.path.exists(backup_path):
        os.system("python cleanup.py")
        subprocess.check_output("/usr/libexec/evolution/*/evolution-backup --restore %s" % backup_path, stderr=subprocess.STDOUT, shell=True)
        os.system("rm ~/.cache/evolution -rf")
        os.system("pkill -9 'evolution*'")


@step(u'Save evo backup for "{account_type}" account type')
def save_evo_backup(context, account_type):
    dir_path = os.path.abspath("/tmp/backups")
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    backup_path = os.path.join(dir_path, "evo_backup_%s.tar.gz" % account_type)
    subprocess.check_output("/usr/libexec/evolution/*/evolution-backup --backup %s" % backup_path, stderr=subprocess.STDOUT, shell=True)


@step(u'Open Evolution via {method} and setup secondary {account_type:w} account')
def open_evolution_and_setup_secondary_account(context, method, account_type):
    context.execute_steps(u"""
        * Try to restore Evolution backup for "secondary_%s" account type
        * Start Evolution via %s
    """ % (account_type, method))

    window = context.app.instance.child(roleName='frame')
    if window.name == 'Evolution Account Assistant':
        if account_type == 'Google':
            context.execute_steps(u"""
                * Complete Welcome dialog in Evolution Account Assistant
                * Complete Restore from Backup dialog in Evolution Account Assistant
                * Complete Identity dialog setting name to "DesktopQE User 1" and email address to "desktopqe1@gmail.com"
                * Wait for account is being looked up dialog in Evolution Account Assistant
                * Complete Account Summary in Evolution Account Assistant
                * Complete Done dialog in Evolution Account Assistant
                * Handle authentication window
                * Close appointments window if it appears
                * Save evo backup for "secondary_%s" account type
            """ % account_type)
            os.system("evolution --force-shutdown 2&> /dev/null")
            context.execute_steps(u"""
                * Save evo backup for "secondary_%s" account type
                * Start Evolution via command
            """ % account_type)
    else:
        context.execute_steps(u"""
            * Handle authentication window
            * Close appointments window if it appears
            * Wait for email to synchronize
        """)


@step(u'Close Evolution and cleanup data')
def close_evolution_and_cleanup(context):
    os.system("python cleanup.py 2&> /dev/null")
    os.system("evolution --force-shutdown 2&> /dev/null")
    sleep(5)
