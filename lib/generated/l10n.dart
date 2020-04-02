// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get collective_new_perspective {
    return Intl.message(
      'New Perspective',
      name: 'collective_new_perspective',
      desc: '',
      args: [],
    );
  }

  String get common_accept {
    return Intl.message(
      'Accept',
      name: 'common_accept',
      desc: '',
      args: [],
    );
  }

  String get common_close {
    return Intl.message(
      'CLOSE',
      name: 'common_close',
      desc: '',
      args: [],
    );
  }

  String get common_network_error {
    return Intl.message(
      'Hmm, something went wrong.',
      name: 'common_network_error',
      desc: '',
      args: [],
    );
  }

  String get common_ok {
    return Intl.message(
      'Ok',
      name: 'common_ok',
      desc: '',
      args: [],
    );
  }

  String get common_reject {
    return Intl.message(
      'Reject',
      name: 'common_reject',
      desc: '',
      args: [],
    );
  }

  String get common_try_again_later {
    return Intl.message(
      'Try again later',
      name: 'common_try_again_later',
      desc: '',
      args: [],
    );
  }

  String get create_dynamic {
    return Intl.message(
      'DYNAMIC',
      name: 'create_dynamic',
      desc: '',
      args: [],
    );
  }

  String get create_event {
    return Intl.message(
      'EVENT',
      name: 'create_event',
      desc: '',
      args: [],
    );
  }

  String get create_new_channel {
    return Intl.message(
      'Add new channel',
      name: 'create_new_channel',
      desc: '',
      args: [],
    );
  }

  String get create_photo {
    return Intl.message(
      'PHOTO',
      name: 'create_photo',
      desc: '',
      args: [],
    );
  }

  String get create_shortform {
    return Intl.message(
      'SHORTFORM',
      name: 'create_shortform',
      desc: '',
      args: [],
    );
  }

  String get error_already_sent_connection {
    return Intl.message(
      'Already sent a connection.',
      name: 'error_already_sent_connection',
      desc: '',
      args: [],
    );
  }

  String get expression_channels {
    return Intl.message(
      'CHANNELS',
      name: 'expression_channels',
      desc: '',
      args: [],
    );
  }

  String get expression_delete {
    return Intl.message(
      'Delete expression',
      name: 'expression_delete',
      desc: '',
      args: [],
    );
  }

  String expression_error(Object error) {
    return Intl.message(
      'Something went wrong $error',
      name: 'expression_error',
      desc: '',
      args: [error],
    );
  }

  String get lotus_collective {
    return Intl.message(
      'COLLECTIVE',
      name: 'lotus_collective',
      desc: '',
      args: [],
    );
  }

  String get lotus_create {
    return Intl.message(
      'CREATE',
      name: 'lotus_create',
      desc: '',
      args: [],
    );
  }

  String get lotus_groups {
    return Intl.message(
      'GROUPS',
      name: 'lotus_groups',
      desc: '',
      args: [],
    );
  }

  String get lotus_packs {
    return Intl.message(
      'PACKS',
      name: 'lotus_packs',
      desc: '',
      args: [],
    );
  }

  String get notifications_connection {
    return Intl.message(
      'Connection',
      name: 'notifications_connection',
      desc: '',
      args: [],
    );
  }

  String get notifications_creator {
    return Intl.message(
      'Creator',
      name: 'notifications_creator',
      desc: '',
      args: [],
    );
  }

  String get notifications_group {
    return Intl.message(
      'Group',
      name: 'notifications_group',
      desc: '',
      args: [],
    );
  }

  String get notifications_no_new_connection_notif {
    return Intl.message(
      'No new connection notifications',
      name: 'notifications_no_new_connection_notif',
      desc: '',
      args: [],
    );
  }

  String get notifications_no_new_group_notif {
    return Intl.message(
      'No new group notifications',
      name: 'notifications_no_new_group_notif',
      desc: '',
      args: [],
    );
  }

  String get notifications_title {
    return Intl.message(
      'Notifications',
      name: 'notifications_title',
      desc: '',
      args: [],
    );
  }

  String get packs_my_packs {
    return Intl.message(
      'My Packs',
      name: 'packs_my_packs',
      desc: '',
      args: [],
    );
  }

  String get packs_requests {
    return Intl.message(
      'Requests',
      name: 'packs_requests',
      desc: '',
      args: [],
    );
  }

  String get packs_title {
    return Intl.message(
      'Packs',
      name: 'packs_title',
      desc: '',
      args: [],
    );
  }

  String get welcome_add_photo {
    return Intl.message(
      'Add a profile picture',
      name: 'welcome_add_photo',
      desc: '',
      args: [],
    );
  }

  String get welcome_almost_done {
    return Intl.message(
      'Almost done!',
      name: 'welcome_almost_done',
      desc: '',
      args: [],
    );
  }

  String get welcome_check_email {
    return Intl.message(
      'CHECK EMAIL',
      name: 'welcome_check_email',
      desc: '',
      args: [],
    );
  }

  String get welcome_confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'welcome_confirm_password',
      desc: '',
      args: [],
    );
  }

  String get welcome_email_hint {
    return Intl.message(
      'Email',
      name: 'welcome_email_hint',
      desc: '',
      args: [],
    );
  }

  String get welcome_feel_free {
    return Intl.message(
      'Feel free to share more about yourself (optional)',
      name: 'welcome_feel_free',
      desc: '',
      args: [],
    );
  }

  String get welcome_final_step {
    return Intl.message(
      'Final step!',
      name: 'welcome_final_step',
      desc: '',
      args: [],
    );
  }

  String get welcome_gender_hints {
    return Intl.message(
      'Gender Pronouns',
      name: 'welcome_gender_hints',
      desc: '',
      args: [],
    );
  }

  String get welcome_gender_label {
    return Intl.message(
      'PRONOUNS',
      name: 'welcome_gender_label',
      desc: '',
      args: [],
    );
  }

  String get welcome_lets_go {
    return Intl.message(
      'LET\'S GO',
      name: 'welcome_lets_go',
      desc: '',
      args: [],
    );
  }

  String get welcome_location_hint {
    return Intl.message(
      'Location',
      name: 'welcome_location_hint',
      desc: '',
      args: [],
    );
  }

  String get welcome_location_label {
    return Intl.message(
      'LOCATION',
      name: 'welcome_location_label',
      desc: '',
      args: [],
    );
  }

  String welcome_login_requirements(Object charCount) {
    return Intl.message(
      'Length must be less than $charCount characters',
      name: 'welcome_login_requirements',
      desc: '',
      args: [charCount],
    );
  }

  String get welcome_my_name_is {
    return Intl.message(
      'My name is...',
      name: 'welcome_my_name_is',
      desc: '',
      args: [],
    );
  }

  String get welcome_name_hint {
    return Intl.message(
      'Hey, what\'s your name?',
      name: 'welcome_name_hint',
      desc: '',
      args: [],
    );
  }

  String get welcome_name_label {
    return Intl.message(
      'FULL NAME',
      name: 'welcome_name_label',
      desc: '',
      args: [],
    );
  }

  String get welcome_password_hint {
    return Intl.message(
      'Password',
      name: 'welcome_password_hint',
      desc: '',
      args: [],
    );
  }

  String welcome_password_length(Object n) {
    return Intl.message(
      'Your password must be greater than $n characters.',
      name: 'welcome_password_length',
      desc: '',
      args: [n],
    );
  }

  String get welcome_password_rules {
    return Intl.message(
      'Passwords must contain at least 1 number, 8 characters, 1 special character, and one uppercase letter.',
      name: 'welcome_password_rules',
      desc: '',
      args: [],
    );
  }

  String get welcome_passwords_must_match {
    return Intl.message(
      'Passwords must match.',
      name: 'welcome_passwords_must_match',
      desc: '',
      args: [],
    );
  }

  String get welcome_remove_photo {
    return Intl.message(
      'REMOVE PHOTO',
      name: 'welcome_remove_photo',
      desc: '',
      args: [],
    );
  }

  String get welcome_sign_in {
    return Intl.message(
      'SIGN IN',
      name: 'welcome_sign_in',
      desc: '',
      args: [],
    );
  }

  String get welcome_theme {
    return Intl.message(
      'Which theme feels best?',
      name: 'welcome_theme',
      desc: '',
      args: [],
    );
  }

  String get welcome_unable_to_login {
    return Intl.message(
      'Unable to login. Please double check your login credentials.',
      name: 'welcome_unable_to_login',
      desc: '',
      args: [],
    );
  }

  String get welcome_username_hint {
    return Intl.message(
      'Choose a unique username',
      name: 'welcome_username_hint',
      desc: '',
      args: [],
    );
  }

  String get welcome_username_ill_go {
    return Intl.message(
      'I\'ll go by...',
      name: 'welcome_username_ill_go',
      desc: '',
      args: [],
    );
  }

  String get welcome_username_label {
    return Intl.message(
      'USERNAME',
      name: 'welcome_username_label',
      desc: '',
      args: [],
    );
  }

  String get welcome_username_requirements {
    return Intl.message(
      'Your username can only contain lowercase letters, numbers, and underscores.',
      name: 'welcome_username_requirements',
      desc: '',
      args: [],
    );
  }

  String get welcome_username_taken {
    return Intl.message(
      'Sorry, that username is taken.',
      name: 'welcome_username_taken',
      desc: '',
      args: [],
    );
  }

  String get welcome_verification_code {
    return Intl.message(
      'Verification code',
      name: 'welcome_verification_code',
      desc: '',
      args: [],
    );
  }

  String get welcome_website_hint {
    return Intl.message(
      'Website',
      name: 'welcome_website_hint',
      desc: '',
      args: [],
    );
  }

  String get welcome_website_label {
    return Intl.message(
      'WEBSITE',
      name: 'welcome_website_label',
      desc: '',
      args: [],
    );
  }

  String get welcome_wrong_email_or_password {
    return Intl.message(
      'Wrong email or password',
      name: 'welcome_wrong_email_or_password',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'es'), Locale.fromSubtags(languageCode: 'da'), Locale.fromSubtags(languageCode: 'hu'), Locale.fromSubtags(languageCode: 'km'), Locale.fromSubtags(languageCode: 'pt'), Locale.fromSubtags(languageCode: 'de'), Locale.fromSubtags(languageCode: 'sl'), Locale.fromSubtags(languageCode: 'it'), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), Locale.fromSubtags(languageCode: 'th'), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), Locale.fromSubtags(languageCode: 'tr'), Locale.fromSubtags(languageCode: 'pl'), Locale.fromSubtags(languageCode: 'ja'), Locale.fromSubtags(languageCode: 'fr'),
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
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}