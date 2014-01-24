# -*- coding: UTF-8 -*-

import os
from behave_common_steps import dummy, App
from gi.repository import Gio
from dogtail.config import config
import problem
from time import sleep


def before_all(context):
    """Setup evolution stuff
    Being executed before all features
    """

    # Reset GSettings
    schemas = [x for x in Gio.Settings.list_schemas() if 'evolution' in x.lower()]
    for schema in schemas:
        os.system("gsettings reset-recursively %s" % schema)

    # Skip warning dialog
    os.system("gsettings set org.gnome.evolution.shell skip-warning-dialog true")
    # Show switcher buttons as icons (to minimize tree scrolling)
    os.system("gsettings set org.gnome.evolution.shell buttons-style icons")

    # Wait for things to settle
    sleep(0.5)

    # Skip dogtail actions to print to stdout
    config.logDebugToStdOut = False
    config.typingDelay = 0.2

    # Include assertion object
    context.assertion = dummy()

    # Kill initial setup
    os.system("killall /usr/libexec/gnome-initial-setup")

    # Delete existing ABRT problems
    if problem.list():
        [x.delete() for x in problem.list()]

    try:
        from gi.repository import GnomeKeyring
        # Delete originally stored password
        (response, keyring) = GnomeKeyring.get_default_keyring_sync()
        if response == GnomeKeyring.Result.OK:
            if keyring is not None:
                delete_response = GnomeKeyring.delete_sync(keyring)
                assert delete_response == GnomeKeyring.Result.OK, "Delete failed: %s" % delete_response
            create_response = GnomeKeyring.create_sync("login", 'gnome')
            assert create_response == GnomeKeyring.Result.OK, "Create failed: %s" % create_response
            set_default_response = GnomeKeyring.set_default_keyring_sync('login')
            assert set_default_response == GnomeKeyring.Result.OK, "Set default failed: %s" % set_default_response
        unlock_response = GnomeKeyring.unlock_sync("login", 'gnome')
        assert unlock_response == GnomeKeyring.Result.OK, "Unlock failed: %s" % unlock_response
    except Exception as e:
        print("Exception while unlocking a keyring: %s" % e.message)

    context.app = App('evolution')


def after_step(context, step):
    """Teardown after each step.
    Here we make screenshot and embed it (if one of formatters supports it)
    """
    try:
        # Make screnshot if step has failed
        if hasattr(context, "embed"):
            os.system("gnome-screenshot -f /tmp/screenshot.jpg")
            context.embed('image/jpg', open("/tmp/screenshot.jpg", 'r').read())

        if step.status == 'failed' and os.environ.get('DEBUG_ON_FAILURE'):
            import ipdb; ipdb.set_trace()  # flake8: noqa

        # Check for abrt problems
        if problem.list():
            problems = problem.list()
            print("Found %s problem(s)" % len(problems))
            for crash in problems:
                os.system("cat '%s' >> /tmp/evo.log" % crash.reason)
                step.status = 'failed'

    except Exception as e:
        print("Error in after_step: %s" % e.message)


def after_scenario(context, scenario):
    """Teardown for each scenario
    Kill evolution (in order to make this reliable we send sigkill)
    """
    try:
        # Stop evolution
        os.system("evolution --force-shutdown &> /dev/null")

        # Attach logs
        if hasattr(context, "embed"):
            context.embed('text/plain', open("/tmp/evo.log", 'r').read())
            os.system("rm -rf evo.log")

        # Make some pause after scenario
        sleep(1)
    except Exception as e:
        # Stupid behave simply crashes in case exception has occurred
        print("Error in after_scenario: %s" % e.message)
