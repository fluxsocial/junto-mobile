// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(error) => "Something went wrong ${error}";

  static m1(charCount) => "Length must be less than ${charCount} characters";

  static m2(n) => "Your password must be greater than ${n} characters.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "audio_title" : MessageLookupByLibrary.simpleMessage("Title (optional)"),
    "collective_new_perspective" : MessageLookupByLibrary.simpleMessage("New Perspective"),
    "common_accept" : MessageLookupByLibrary.simpleMessage("Accept"),
    "common_close" : MessageLookupByLibrary.simpleMessage("CLOSE"),
    "common_decline" : MessageLookupByLibrary.simpleMessage("Decline"),
    "common_network_error" : MessageLookupByLibrary.simpleMessage("Hmm, something went wrong."),
    "common_ok" : MessageLookupByLibrary.simpleMessage("Ok"),
    "common_reject" : MessageLookupByLibrary.simpleMessage("Reject"),
    "common_try_again_later" : MessageLookupByLibrary.simpleMessage("Try again later"),
    "count_me_in" : MessageLookupByLibrary.simpleMessage("COUNT ME IN"),
    "create_dynamic" : MessageLookupByLibrary.simpleMessage("DYNAMIC"),
    "create_event" : MessageLookupByLibrary.simpleMessage("EVENT"),
    "create_new_channel" : MessageLookupByLibrary.simpleMessage("Add new channel"),
    "create_photo" : MessageLookupByLibrary.simpleMessage("PHOTO"),
    "create_shortform" : MessageLookupByLibrary.simpleMessage("SHORTFORM"),
    "error_already_sent_connection" : MessageLookupByLibrary.simpleMessage("Already sent a connection."),
    "expression_channels" : MessageLookupByLibrary.simpleMessage("CHANNELS"),
    "expression_delete" : MessageLookupByLibrary.simpleMessage("Delete expression"),
    "expression_error" : m0,
    "lotus_collective" : MessageLookupByLibrary.simpleMessage("COLLECTIVE"),
    "lotus_create" : MessageLookupByLibrary.simpleMessage("CREATE"),
    "lotus_groups" : MessageLookupByLibrary.simpleMessage("GROUPS"),
    "lotus_packs" : MessageLookupByLibrary.simpleMessage("PACKS"),
    "menu_are_you_sure_to_logout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to log out?"),
    "menu_logout" : MessageLookupByLibrary.simpleMessage("Log Out"),
    "menu_my_den" : MessageLookupByLibrary.simpleMessage("My Den"),
    "menu_relations" : MessageLookupByLibrary.simpleMessage("Relations"),
    "menu_search" : MessageLookupByLibrary.simpleMessage("Search"),
    "new_password_hint" : MessageLookupByLibrary.simpleMessage("New password"),
    "notification_cat_all" : MessageLookupByLibrary.simpleMessage("ALL"),
    "notification_cat_expression" : MessageLookupByLibrary.simpleMessage("EXPRESSION"),
    "notification_cat_relations" : MessageLookupByLibrary.simpleMessage("RELATIONS"),
    "notifications_connection" : MessageLookupByLibrary.simpleMessage("Connection"),
    "notifications_creator" : MessageLookupByLibrary.simpleMessage("Creator"),
    "notifications_group" : MessageLookupByLibrary.simpleMessage("Group"),
    "notifications_no_new_connection_notif" : MessageLookupByLibrary.simpleMessage("No new connection notifications"),
    "notifications_no_new_group_notif" : MessageLookupByLibrary.simpleMessage("No new group notifications"),
    "notifications_nothing_new_yet" : MessageLookupByLibrary.simpleMessage("Nothing new yet!"),
    "notifications_title" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "packs_my_packs" : MessageLookupByLibrary.simpleMessage("My Packs"),
    "packs_requests" : MessageLookupByLibrary.simpleMessage("Requests"),
    "packs_title" : MessageLookupByLibrary.simpleMessage("Packs"),
    "profile_picture" : MessageLookupByLibrary.simpleMessage("PROFILE PICTURE"),
    "resend_verification_code" : MessageLookupByLibrary.simpleMessage("Resend the code"),
    "reset_password" : MessageLookupByLibrary.simpleMessage("RESET PASSWORD"),
    "themes_light" : MessageLookupByLibrary.simpleMessage("Light"),
    "themes_night" : MessageLookupByLibrary.simpleMessage("Night"),
    "themes_title" : MessageLookupByLibrary.simpleMessage("Themes"),
    "toggle_filter_drawer" : MessageLookupByLibrary.simpleMessage("Toggle filter drawer"),
    "welcome_add_photo" : MessageLookupByLibrary.simpleMessage("Add a profile picture"),
    "welcome_almost_done" : MessageLookupByLibrary.simpleMessage("Almost done!"),
    "welcome_check_email" : MessageLookupByLibrary.simpleMessage("CHECK YOUR EMAIL"),
    "welcome_confirm_password" : MessageLookupByLibrary.simpleMessage("Confirm password"),
    "welcome_email_hint" : MessageLookupByLibrary.simpleMessage("Email"),
    "welcome_feel_free" : MessageLookupByLibrary.simpleMessage("Feel free to share more about yourself (optional)"),
    "welcome_final_step" : MessageLookupByLibrary.simpleMessage("Final step!"),
    "welcome_gender_hints" : MessageLookupByLibrary.simpleMessage("Gender Pronouns"),
    "welcome_gender_label" : MessageLookupByLibrary.simpleMessage("PRONOUNS"),
    "welcome_invalid_email" : MessageLookupByLibrary.simpleMessage("Make sure you entered a correct e-mail"),
    "welcome_invalid_username" : MessageLookupByLibrary.simpleMessage("Make sure you entered a valid username"),
    "welcome_lets_go" : MessageLookupByLibrary.simpleMessage("LET\'S GO"),
    "welcome_location_hint" : MessageLookupByLibrary.simpleMessage("Location"),
    "welcome_location_label" : MessageLookupByLibrary.simpleMessage("LOCATION"),
    "welcome_login_requirements" : m1,
    "welcome_my_name_is" : MessageLookupByLibrary.simpleMessage("My name is..."),
    "welcome_name_hint" : MessageLookupByLibrary.simpleMessage("Hey, what\'s your name?"),
    "welcome_name_label" : MessageLookupByLibrary.simpleMessage("FULL NAME"),
    "welcome_password_hint" : MessageLookupByLibrary.simpleMessage("Password"),
    "welcome_password_length" : m2,
    "welcome_password_rules" : MessageLookupByLibrary.simpleMessage("Passwords must contain at least 1 number, 8 characters, 1 special character, and one uppercase letter."),
    "welcome_passwords_must_match" : MessageLookupByLibrary.simpleMessage("Passwords must match."),
    "welcome_remove_photo" : MessageLookupByLibrary.simpleMessage("REMOVE PHOTO"),
    "welcome_reset_password" : MessageLookupByLibrary.simpleMessage("Reset password"),
    "welcome_sign_in" : MessageLookupByLibrary.simpleMessage("SIGN IN"),
    "welcome_theme" : MessageLookupByLibrary.simpleMessage("Which theme feels best?"),
    "welcome_unable_to_login" : MessageLookupByLibrary.simpleMessage("Unable to login. Please double check your login credentials."),
    "welcome_username_hint" : MessageLookupByLibrary.simpleMessage("Choose a unique username"),
    "welcome_username_hint_sign_in" : MessageLookupByLibrary.simpleMessage("Username"),
    "welcome_username_ill_go" : MessageLookupByLibrary.simpleMessage("I\'ll go by..."),
    "welcome_username_label" : MessageLookupByLibrary.simpleMessage("USERNAME"),
    "welcome_username_requirements" : MessageLookupByLibrary.simpleMessage("Your username can only contain lowercase letters, numbers, and underscores."),
    "welcome_username_taken" : MessageLookupByLibrary.simpleMessage("Sorry, that username is taken."),
    "welcome_verification_code" : MessageLookupByLibrary.simpleMessage("Verification code"),
    "welcome_website_hint" : MessageLookupByLibrary.simpleMessage("Website"),
    "welcome_website_label" : MessageLookupByLibrary.simpleMessage("WEBSITE"),
    "welcome_wrong_email_or_password" : MessageLookupByLibrary.simpleMessage("Wrong email or password")
  };
}
