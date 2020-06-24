// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Title (optional)`
  String get audio_title {
    return Intl.message(
      'Title (optional)',
      name: 'audio_title',
      desc: '',
      args: [],
    );
  }

  /// `New Perspective`
  String get collective_new_perspective {
    return Intl.message(
      'New Perspective',
      name: 'collective_new_perspective',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get common_accept {
    return Intl.message(
      'Accept',
      name: 'common_accept',
      desc: '',
      args: [],
    );
  }

  /// `CLOSE`
  String get common_close {
    return Intl.message(
      'CLOSE',
      name: 'common_close',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get common_decline {
    return Intl.message(
      'Decline',
      name: 'common_decline',
      desc: '',
      args: [],
    );
  }

  /// `Hmm, something went wrong.`
  String get common_network_error {
    return Intl.message(
      'Hmm, something went wrong.',
      name: 'common_network_error',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get common_ok {
    return Intl.message(
      'Ok',
      name: 'common_ok',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get common_reject {
    return Intl.message(
      'Reject',
      name: 'common_reject',
      desc: '',
      args: [],
    );
  }

  /// `Try again later`
  String get common_try_again_later {
    return Intl.message(
      'Try again later',
      name: 'common_try_again_later',
      desc: '',
      args: [],
    );
  }

  /// `COUNT ME IN`
  String get count_me_in {
    return Intl.message(
      'COUNT ME IN',
      name: 'count_me_in',
      desc: '',
      args: [],
    );
  }

  /// `DYNAMIC`
  String get create_dynamic {
    return Intl.message(
      'DYNAMIC',
      name: 'create_dynamic',
      desc: '',
      args: [],
    );
  }

  /// `EVENT`
  String get create_event {
    return Intl.message(
      'EVENT',
      name: 'create_event',
      desc: '',
      args: [],
    );
  }

  /// `Add new channel`
  String get create_new_channel {
    return Intl.message(
      'Add new channel',
      name: 'create_new_channel',
      desc: '',
      args: [],
    );
  }

  /// `PHOTO`
  String get create_photo {
    return Intl.message(
      'PHOTO',
      name: 'create_photo',
      desc: '',
      args: [],
    );
  }

  /// `SHORTFORM`
  String get create_shortform {
    return Intl.message(
      'SHORTFORM',
      name: 'create_shortform',
      desc: '',
      args: [],
    );
  }

  /// `Already sent a connection.`
  String get error_already_sent_connection {
    return Intl.message(
      'Already sent a connection.',
      name: 'error_already_sent_connection',
      desc: '',
      args: [],
    );
  }

  /// `CHANNELS`
  String get expression_channels {
    return Intl.message(
      'CHANNELS',
      name: 'expression_channels',
      desc: '',
      args: [],
    );
  }

  /// `Delete expression`
  String get expression_delete {
    return Intl.message(
      'Delete expression',
      name: 'expression_delete',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong {error}`
  String expression_error(Object error) {
    return Intl.message(
      'Something went wrong $error',
      name: 'expression_error',
      desc: '',
      args: [error],
    );
  }

  /// `COLLECTIVE`
  String get lotus_collective {
    return Intl.message(
      'COLLECTIVE',
      name: 'lotus_collective',
      desc: '',
      args: [],
    );
  }

  /// `CREATE`
  String get lotus_create {
    return Intl.message(
      'CREATE',
      name: 'lotus_create',
      desc: '',
      args: [],
    );
  }

  /// `GROUPS`
  String get lotus_groups {
    return Intl.message(
      'GROUPS',
      name: 'lotus_groups',
      desc: '',
      args: [],
    );
  }

  /// `PACKS`
  String get lotus_packs {
    return Intl.message(
      'PACKS',
      name: 'lotus_packs',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password_hint {
    return Intl.message(
      'New password',
      name: 'new_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `ALL`
  String get notification_cat_all {
    return Intl.message(
      'ALL',
      name: 'notification_cat_all',
      desc: '',
      args: [],
    );
  }

  /// `EXPRESSION`
  String get notification_cat_expression {
    return Intl.message(
      'EXPRESSION',
      name: 'notification_cat_expression',
      desc: '',
      args: [],
    );
  }

  /// `RELATIONS`
  String get notification_cat_relations {
    return Intl.message(
      'RELATIONS',
      name: 'notification_cat_relations',
      desc: '',
      args: [],
    );
  }

  /// `Connection`
  String get notifications_connection {
    return Intl.message(
      'Connection',
      name: 'notifications_connection',
      desc: '',
      args: [],
    );
  }

  /// `Creator`
  String get notifications_creator {
    return Intl.message(
      'Creator',
      name: 'notifications_creator',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get notifications_group {
    return Intl.message(
      'Group',
      name: 'notifications_group',
      desc: '',
      args: [],
    );
  }

  /// `No new connection notifications`
  String get notifications_no_new_connection_notif {
    return Intl.message(
      'No new connection notifications',
      name: 'notifications_no_new_connection_notif',
      desc: '',
      args: [],
    );
  }

  /// `No new group notifications`
  String get notifications_no_new_group_notif {
    return Intl.message(
      'No new group notifications',
      name: 'notifications_no_new_group_notif',
      desc: '',
      args: [],
    );
  }

  /// `Nothing new yet!`
  String get notifications_nothing_new_yet {
    return Intl.message(
      'Nothing new yet!',
      name: 'notifications_nothing_new_yet',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications_title {
    return Intl.message(
      'Notifications',
      name: 'notifications_title',
      desc: '',
      args: [],
    );
  }

  /// `My Packs`
  String get packs_my_packs {
    return Intl.message(
      'My Packs',
      name: 'packs_my_packs',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get packs_requests {
    return Intl.message(
      'Requests',
      name: 'packs_requests',
      desc: '',
      args: [],
    );
  }

  /// `Packs`
  String get packs_title {
    return Intl.message(
      'Packs',
      name: 'packs_title',
      desc: '',
      args: [],
    );
  }

  /// `PROFILE PICTURE`
  String get profile_picture {
    return Intl.message(
      'PROFILE PICTURE',
      name: 'profile_picture',
      desc: '',
      args: [],
    );
  }

  /// `RESET PASSWORD`
  String get reset_password {
    return Intl.message(
      'RESET PASSWORD',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Toggle filter drawer`
  String get toggle_filter_drawer {
    return Intl.message(
      'Toggle filter drawer',
      name: 'toggle_filter_drawer',
      desc: '',
      args: [],
    );
  }

  /// `Add a profile picture`
  String get welcome_add_photo {
    return Intl.message(
      'Add a profile picture',
      name: 'welcome_add_photo',
      desc: '',
      args: [],
    );
  }

  /// `Almost done!`
  String get welcome_almost_done {
    return Intl.message(
      'Almost done!',
      name: 'welcome_almost_done',
      desc: '',
      args: [],
    );
  }

  /// `CHECK YOUR EMAIL`
  String get welcome_check_email {
    return Intl.message(
      'CHECK YOUR EMAIL',
      name: 'welcome_check_email',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get welcome_confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'welcome_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get welcome_email_hint {
    return Intl.message(
      'Email',
      name: 'welcome_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Feel free to share more about yourself (optional)`
  String get welcome_feel_free {
    return Intl.message(
      'Feel free to share more about yourself (optional)',
      name: 'welcome_feel_free',
      desc: '',
      args: [],
    );
  }

  /// `Final step!`
  String get welcome_final_step {
    return Intl.message(
      'Final step!',
      name: 'welcome_final_step',
      desc: '',
      args: [],
    );
  }

  /// `Gender Pronouns`
  String get welcome_gender_hints {
    return Intl.message(
      'Gender Pronouns',
      name: 'welcome_gender_hints',
      desc: '',
      args: [],
    );
  }

  /// `PRONOUNS`
  String get welcome_gender_label {
    return Intl.message(
      'PRONOUNS',
      name: 'welcome_gender_label',
      desc: '',
      args: [],
    );
  }

  /// `LET'S GO`
  String get welcome_lets_go {
    return Intl.message(
      'LET\'S GO',
      name: 'welcome_lets_go',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get welcome_location_hint {
    return Intl.message(
      'Location',
      name: 'welcome_location_hint',
      desc: '',
      args: [],
    );
  }

  /// `LOCATION`
  String get welcome_location_label {
    return Intl.message(
      'LOCATION',
      name: 'welcome_location_label',
      desc: '',
      args: [],
    );
  }

  /// `Length must be less than {charCount} characters`
  String welcome_login_requirements(Object charCount) {
    return Intl.message(
      'Length must be less than $charCount characters',
      name: 'welcome_login_requirements',
      desc: '',
      args: [charCount],
    );
  }

  /// `My name is...`
  String get welcome_my_name_is {
    return Intl.message(
      'My name is...',
      name: 'welcome_my_name_is',
      desc: '',
      args: [],
    );
  }

  /// `Hey, what's your name?`
  String get welcome_name_hint {
    return Intl.message(
      'Hey, what\'s your name?',
      name: 'welcome_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `FULL NAME`
  String get welcome_name_label {
    return Intl.message(
      'FULL NAME',
      name: 'welcome_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get welcome_password_hint {
    return Intl.message(
      'Password',
      name: 'welcome_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Your password must be greater than {n} characters.`
  String welcome_password_length(Object n) {
    return Intl.message(
      'Your password must be greater than $n characters.',
      name: 'welcome_password_length',
      desc: '',
      args: [n],
    );
  }

  /// `Passwords must contain at least 1 number, 8 characters, 1 special character, and one uppercase letter.`
  String get welcome_password_rules {
    return Intl.message(
      'Passwords must contain at least 1 number, 8 characters, 1 special character, and one uppercase letter.',
      name: 'welcome_password_rules',
      desc: '',
      args: [],
    );
  }

  /// `Passwords must match.`
  String get welcome_passwords_must_match {
    return Intl.message(
      'Passwords must match.',
      name: 'welcome_passwords_must_match',
      desc: '',
      args: [],
    );
  }

  /// `REMOVE PHOTO`
  String get welcome_remove_photo {
    return Intl.message(
      'REMOVE PHOTO',
      name: 'welcome_remove_photo',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get welcome_reset_password {
    return Intl.message(
      'Reset password',
      name: 'welcome_reset_password',
      desc: '',
      args: [],
    );
  }

  String get resend_verification_code {
    return Intl.message(
      'Resend verification code',
      name: 'resend_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get welcome_sign_in {
    return Intl.message(
      'SIGN IN',
      name: 'welcome_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Which theme feels best?`
  String get welcome_theme {
    return Intl.message(
      'Which theme feels best?',
      name: 'welcome_theme',
      desc: '',
      args: [],
    );
  }

  /// `Unable to login. Please double check your login credentials.`
  String get welcome_unable_to_login {
    return Intl.message(
      'Unable to login. Please double check your login credentials.',
      name: 'welcome_unable_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Choose a unique username`
  String get welcome_username_hint {
    return Intl.message(
      'Choose a unique username',
      name: 'welcome_username_hint',
      desc: '',
      args: [],
    );
  }

  /// `I'll go by...`
  String get welcome_username_ill_go {
    return Intl.message(
      'I\'ll go by...',
      name: 'welcome_username_ill_go',
      desc: '',
      args: [],
    );
  }

  /// `USERNAME`
  String get welcome_username_label {
    return Intl.message(
      'USERNAME',
      name: 'welcome_username_label',
      desc: '',
      args: [],
    );
  }

  /// `Your username can only contain lowercase letters, numbers, and underscores.`
  String get welcome_username_requirements {
    return Intl.message(
      'Your username can only contain lowercase letters, numbers, and underscores.',
      name: 'welcome_username_requirements',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, that username is taken.`
  String get welcome_username_taken {
    return Intl.message(
      'Sorry, that username is taken.',
      name: 'welcome_username_taken',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get welcome_verification_code {
    return Intl.message(
      'Verification code',
      name: 'welcome_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get welcome_website_hint {
    return Intl.message(
      'Website',
      name: 'welcome_website_hint',
      desc: '',
      args: [],
    );
  }

  /// `WEBSITE`
  String get welcome_website_label {
    return Intl.message(
      'WEBSITE',
      name: 'welcome_website_label',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get welcome_wrong_email_or_password {
    return Intl.message(
      'Wrong email or password',
      name: 'welcome_wrong_email_or_password',
      desc: '',
      args: [],
    );
  }

  /// `Night`
  String get themes_night {
    return Intl.message(
      'Night',
      name: 'themes_night',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get themes_light {
    return Intl.message(
      'Light',
      name: 'themes_light',
      desc: '',
      args: [],
    );
  }

  /// `Themes`
  String get themes_title {
    return Intl.message(
      'Themes',
      name: 'themes_title',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get menu_logout {
    return Intl.message(
      'Log Out',
      name: 'menu_logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get menu_are_you_sure_to_logout {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'menu_are_you_sure_to_logout',
      desc: '',
      args: [],
    );
  }

  /// `Relations`
  String get menu_relations {
    return Intl.message(
      'Relations',
      name: 'menu_relations',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get menu_search {
    return Intl.message(
      'Search',
      name: 'menu_search',
      desc: '',
      args: [],
    );
  }

  /// `My Den`
  String get menu_my_den {
    return Intl.message(
      'My Den',
      name: 'menu_my_den',
      desc: '',
      args: [],
    );
  }

  /// `Make sure you entered a correct e-mail`
  String get welcome_invalid_email {
    return Intl.message(
      'Make sure you entered a correct e-mail',
      name: 'welcome_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Make sure you entered a valid username`
  String get welcome_invalid_username {
    return Intl.message(
      'Make sure you entered a valid username',
      name: 'welcome_invalid_username',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get welcome_username_hint_sign_in {
    return Intl.message(
      'Username',
      name: 'welcome_username_hint_sign_in',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}