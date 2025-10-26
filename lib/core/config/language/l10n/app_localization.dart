import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_ar.dart';
import 'app_localization_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get user_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'OR continue with'**
  String get or_continue_with;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a guest'**
  String get continue_as_guest;

  /// No description provided for @please_enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get please_enter_your_username;

  /// No description provided for @please_enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get please_enter_your_email;

  /// No description provided for @please_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_your_password;

  /// No description provided for @invalid_email_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalid_email_format;

  /// No description provided for @password_must_be_more_than_8_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be more than 8 characters'**
  String get password_must_be_more_than_8_characters;

  /// No description provided for @password_must_contain_at_least_one_symbol.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one symbol'**
  String get password_must_contain_at_least_one_symbol;

  /// No description provided for @create_new_account.
  ///
  /// In en, this message translates to:
  /// **'Create new account?'**
  String get create_new_account;

  /// No description provided for @an_error_happen.
  ///
  /// In en, this message translates to:
  /// **'An error happen'**
  String get an_error_happen;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_password;

  /// No description provided for @we_will_send_an_email_with_a_reset_link_to_the_entered_address.
  ///
  /// In en, this message translates to:
  /// **'We will send an email with a reset link to the entered address'**
  String get we_will_send_an_email_with_a_reset_link_to_the_entered_address;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password;

  /// No description provided for @the_email_has_been_sent_successfully_to_the_entered_address.
  ///
  /// In en, this message translates to:
  /// **'The email has been sent successfully to the entered address'**
  String get the_email_has_been_sent_successfully_to_the_entered_address;

  /// No description provided for @locale_storage.
  ///
  /// In en, this message translates to:
  /// **'Locale storage'**
  String get locale_storage;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @new_text_file.
  ///
  /// In en, this message translates to:
  /// **'New text file'**
  String get new_text_file;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'The latest'**
  String get latest;

  /// No description provided for @file_name.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get file_name;

  /// No description provided for @error_in_loading_data.
  ///
  /// In en, this message translates to:
  /// **'Error in loading data'**
  String get error_in_loading_data;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @create_folder.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get create_folder;

  /// No description provided for @folder_name_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'Folder name already in use'**
  String get folder_name_already_in_use;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @empty_folder.
  ///
  /// In en, this message translates to:
  /// **'Empty folder'**
  String get empty_folder;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @move_here.
  ///
  /// In en, this message translates to:
  /// **'Move here'**
  String get move_here;

  /// No description provided for @rename_folder_or_replace_existing_one.
  ///
  /// In en, this message translates to:
  /// **'Rename folder or replace existing one?'**
  String get rename_folder_or_replace_existing_one;

  /// No description provided for @you_already_have_a_folder_named.
  ///
  /// In en, this message translates to:
  /// **'You already have a folder named'**
  String get you_already_have_a_folder_named;

  /// No description provided for @in_the_destination_folder.
  ///
  /// In en, this message translates to:
  /// **'in the destination folder.'**
  String get in_the_destination_folder;

  /// No description provided for @do_this_for_all_similar_items.
  ///
  /// In en, this message translates to:
  /// **'Do this for all similar items'**
  String get do_this_for_all_similar_items;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skip;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @move_completed.
  ///
  /// In en, this message translates to:
  /// **'Move completed'**
  String get move_completed;

  /// No description provided for @replace_completed.
  ///
  /// In en, this message translates to:
  /// **'Replace completed'**
  String get replace_completed;

  /// No description provided for @rename_completed.
  ///
  /// In en, this message translates to:
  /// **'Rename completed'**
  String get rename_completed;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @if_you_delete_the_item_you_will_not_be_able_to_restore_it.
  ///
  /// In en, this message translates to:
  /// **'If you delete the item, you will not be able to restore it.'**
  String get if_you_delete_the_item_you_will_not_be_able_to_restore_it;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @some_files_can_not_saved.
  ///
  /// In en, this message translates to:
  /// **'Some files can not be saved. pleas try agen'**
  String get some_files_can_not_saved;

  /// No description provided for @files_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Files saved successfully'**
  String get files_saved_successfully;

  /// No description provided for @delete_completed.
  ///
  /// In en, this message translates to:
  /// **'Delete completed'**
  String get delete_completed;

  /// No description provided for @copy_completed.
  ///
  /// In en, this message translates to:
  /// **'Copy completed'**
  String get copy_completed;

  /// No description provided for @folder_name_cannot_be_empty_or_only_whitespace.
  ///
  /// In en, this message translates to:
  /// **'Folder name cannot be empty or only whitespace'**
  String get folder_name_cannot_be_empty_or_only_whitespace;

  /// No description provided for @folder_name_cannot_start_with_a_dot.
  ///
  /// In en, this message translates to:
  /// **'Folder name cannot start with a dot'**
  String get folder_name_cannot_start_with_a_dot;

  /// No description provided for @folder_name_contains_invalid_characters.
  ///
  /// In en, this message translates to:
  /// **'Folder name contains invalid characters'**
  String get folder_name_contains_invalid_characters;

  /// No description provided for @folder_name_is_too_long.
  ///
  /// In en, this message translates to:
  /// **'Folder name is too long'**
  String get folder_name_is_too_long;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @types.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get types;

  /// No description provided for @recent_searches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recent_searches;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'clear all'**
  String get clear_all;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @audios.
  ///
  /// In en, this message translates to:
  /// **'Audios'**
  String get audios;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @installation_files.
  ///
  /// In en, this message translates to:
  /// **'Installation files'**
  String get installation_files;

  /// No description provided for @other_files.
  ///
  /// In en, this message translates to:
  /// **'Other files'**
  String get other_files;

  /// No description provided for @recent_files.
  ///
  /// In en, this message translates to:
  /// **'Recent files'**
  String get recent_files;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @recycle_bin.
  ///
  /// In en, this message translates to:
  /// **'Recycle bin'**
  String get recycle_bin;

  /// No description provided for @not_connected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get not_connected;

  /// No description provided for @add_file.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get add_file;

  /// No description provided for @clear_recent_files_list.
  ///
  /// In en, this message translates to:
  /// **'Clear recent files list'**
  String get clear_recent_files_list;

  /// No description provided for @recent_files_list_cleared_successfully.
  ///
  /// In en, this message translates to:
  /// **'Recent files list cleared successfully'**
  String get recent_files_list_cleared_successfully;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @initial_date.
  ///
  /// In en, this message translates to:
  /// **'Initial date'**
  String get initial_date;

  /// No description provided for @path.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get path;

  /// No description provided for @select_folder.
  ///
  /// In en, this message translates to:
  /// **'Select folder'**
  String get select_folder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
