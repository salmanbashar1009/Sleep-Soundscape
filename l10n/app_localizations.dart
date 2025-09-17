import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('nl'),
    Locale('pa'),
    Locale('zh'),
  ];

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

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @invite_friends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get invite_friends;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get personalization;

  /// No description provided for @apple_health.
  ///
  /// In en, this message translates to:
  /// **'Apple Health'**
  String get apple_health;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sign_out;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select a Language'**
  String get select_language;

  /// No description provided for @wake_up_time.
  ///
  /// In en, this message translates to:
  /// **'Wake up time'**
  String get wake_up_time;

  /// No description provided for @alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarm;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @start_button.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start_button;

  /// No description provided for @sleep_setting.
  ///
  /// In en, this message translates to:
  /// **'Sleep Setting'**
  String get sleep_setting;

  /// No description provided for @done_button.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done_button;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @sleep_analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get sleep_analysis;

  /// No description provided for @sound_detection.
  ///
  /// In en, this message translates to:
  /// **'Sounds Detection'**
  String get sound_detection;

  /// No description provided for @sound_detection_description.
  ///
  /// In en, this message translates to:
  /// **'To keep running in low battery, Sleep will stop detection when the battery is below 20% and finish analysis when the battery is below 10%.'**
  String get sound_detection_description;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @soundscape.
  ///
  /// In en, this message translates to:
  /// **'Soundscapes'**
  String get soundscape;

  /// No description provided for @audio_timer.
  ///
  /// In en, this message translates to:
  /// **'Audio timer'**
  String get audio_timer;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @alarm_mode.
  ///
  /// In en, this message translates to:
  /// **'Alarm mode'**
  String get alarm_mode;

  /// No description provided for @get_up_challenge.
  ///
  /// In en, this message translates to:
  /// **'Get-up Challenge'**
  String get get_up_challenge;

  /// No description provided for @get_up.
  ///
  /// In en, this message translates to:
  /// **'Get-up'**
  String get get_up;

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get days_ago;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @healthy_sleep.
  ///
  /// In en, this message translates to:
  /// **'Healthy sleep'**
  String get healthy_sleep;

  /// No description provided for @sleep_quality.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get sleep_quality;

  /// No description provided for @sleep_phase.
  ///
  /// In en, this message translates to:
  /// **'Sleep phase'**
  String get sleep_phase;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_title;

  /// No description provided for @choose_your_image.
  ///
  /// In en, this message translates to:
  /// **'Choose your image'**
  String get choose_your_image;

  /// No description provided for @save_button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_button;

  /// No description provided for @sleep_soundscape.
  ///
  /// In en, this message translates to:
  /// **'Sleep Soundscape'**
  String get sleep_soundscape;

  /// No description provided for @embark_on.
  ///
  /// In en, this message translates to:
  /// **'Embark on a'**
  String get embark_on;

  /// No description provided for @serene_journey.
  ///
  /// In en, this message translates to:
  /// **'Serene Journey'**
  String get serene_journey;

  /// No description provided for @to_dreamland.
  ///
  /// In en, this message translates to:
  /// **'to Dreamland'**
  String get to_dreamland;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @discover_tranquil.
  ///
  /// In en, this message translates to:
  /// **'Discover Tranquil'**
  String get discover_tranquil;

  /// No description provided for @tunes_for_restful.
  ///
  /// In en, this message translates to:
  /// **'Tunes for Restful'**
  String get tunes_for_restful;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nights;

  /// No description provided for @your_peaceful.
  ///
  /// In en, this message translates to:
  /// **'Your Peaceful'**
  String get your_peaceful;

  /// No description provided for @slumber_guide.
  ///
  /// In en, this message translates to:
  /// **'Slumber Guide'**
  String get slumber_guide;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enter_your_name;

  /// No description provided for @enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_your_email;

  /// No description provided for @enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_your_password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Have an account? '**
  String get have_an_account;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @choose_preference.
  ///
  /// In en, this message translates to:
  /// **'Choose preference'**
  String get choose_preference;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @have_no_account.
  ///
  /// In en, this message translates to:
  /// **'Have no account?'**
  String get have_no_account;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your Password?'**
  String get forgot_your_password;

  /// No description provided for @forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail address below to reset your password.'**
  String get forgot_password_description;

  /// No description provided for @recovery_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Recovery email sent!'**
  String get recovery_email_sent;

  /// No description provided for @recovery_email_sent_description.
  ///
  /// In en, this message translates to:
  /// **'We have just sent you a recovery email, This email will help you to reset your password'**
  String get recovery_email_sent_description;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @select_your_goal.
  ///
  /// In en, this message translates to:
  /// **'Select your Goal'**
  String get select_your_goal;

  /// No description provided for @deep_sleep_title.
  ///
  /// In en, this message translates to:
  /// **'Deep Sleep'**
  String get deep_sleep_title;

  /// No description provided for @deep_sleep_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a quality sleep'**
  String get deep_sleep_subtitle;

  /// No description provided for @overcome_stress_title.
  ///
  /// In en, this message translates to:
  /// **'Overcome Stress'**
  String get overcome_stress_title;

  /// No description provided for @overcome_stress_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage stress & Anxiety'**
  String get overcome_stress_subtitle;

  /// No description provided for @feel_nature_title.
  ///
  /// In en, this message translates to:
  /// **'Feel Nature'**
  String get feel_nature_title;

  /// No description provided for @feel_nature_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Hear diverse nature sounds'**
  String get feel_nature_subtitle;

  /// No description provided for @improve_performance_title.
  ///
  /// In en, this message translates to:
  /// **'Improve Performance'**
  String get improve_performance_title;

  /// No description provided for @improve_performance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a better start'**
  String get improve_performance_subtitle;

  /// No description provided for @boost_concentration_title.
  ///
  /// In en, this message translates to:
  /// **'Boost Concentration'**
  String get boost_concentration_title;

  /// No description provided for @boost_concentration_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Improve focus'**
  String get boost_concentration_subtitle;

  /// No description provided for @skip_button.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip_button;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @alarm_off.
  ///
  /// In en, this message translates to:
  /// **'Alarm off'**
  String get alarm_off;

  /// No description provided for @only_analyze_sleep.
  ///
  /// In en, this message translates to:
  /// **'Only analyze sleep'**
  String get only_analyze_sleep;

  /// No description provided for @hold_to_end.
  ///
  /// In en, this message translates to:
  /// **'Hold to end'**
  String get hold_to_end;

  /// No description provided for @ocean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ocean;

  /// No description provided for @nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get nature;

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @set_timer.
  ///
  /// In en, this message translates to:
  /// **'Set Timer'**
  String get set_timer;

  /// No description provided for @autoplay_while_sleeping.
  ///
  /// In en, this message translates to:
  /// **'Autoplay sounds while sleeping'**
  String get autoplay_while_sleeping;

  /// No description provided for @audio_clean_audio_recordings.
  ///
  /// In en, this message translates to:
  /// **'Audio clean audio recordings'**
  String get audio_clean_audio_recordings;

  /// No description provided for @clean_all_audio_recordings.
  ///
  /// In en, this message translates to:
  /// **'Clean all audio recordings'**
  String get clean_all_audio_recordings;

  /// No description provided for @total_audio.
  ///
  /// In en, this message translates to:
  /// **'Total audio'**
  String get total_audio;

  /// No description provided for @mb.
  ///
  /// In en, this message translates to:
  /// **'Mb'**
  String get mb;

  /// No description provided for @off_the_detection.
  ///
  /// In en, this message translates to:
  /// **'Off the detection'**
  String get off_the_detection;

  /// No description provided for @off_only_this_time.
  ///
  /// In en, this message translates to:
  /// **'Off only this time'**
  String get off_only_this_time;

  /// No description provided for @off_only_this_time_description.
  ///
  /// In en, this message translates to:
  /// **'Keep off till finished next sleep session'**
  String get off_only_this_time_description;

  /// No description provided for @preferred_earphones.
  ///
  /// In en, this message translates to:
  /// **'Preferred earphones'**
  String get preferred_earphones;

  /// No description provided for @always_use_speakers.
  ///
  /// In en, this message translates to:
  /// **'Always use speakers'**
  String get always_use_speakers;

  /// No description provided for @shake.
  ///
  /// In en, this message translates to:
  /// **'Shake'**
  String get shake;

  /// No description provided for @shake_times.
  ///
  /// In en, this message translates to:
  /// **'Shake times'**
  String get shake_times;

  /// No description provided for @referral_code.
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get referral_code;

  /// No description provided for @send_or_share_to_your_friends.
  ///
  /// In en, this message translates to:
  /// **'Send or share to your friends'**
  String get send_or_share_to_your_friends;

  /// No description provided for @get_up_challenge_description.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and get reward'**
  String get get_up_challenge_description;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @ring_on_silent.
  ///
  /// In en, this message translates to:
  /// **'Ring on Silent'**
  String get ring_on_silent;

  /// No description provided for @pop_up_alert.
  ///
  /// In en, this message translates to:
  /// **'Pop-up Alert'**
  String get pop_up_alert;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @version_1.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version_1;

  /// No description provided for @build_3.
  ///
  /// In en, this message translates to:
  /// **'Build 3'**
  String get build_3;

  /// No description provided for @made_with_love_from_BD.
  ///
  /// In en, this message translates to:
  /// **'Made with love from Bangladesh'**
  String get made_with_love_from_BD;

  /// No description provided for @sleep_soundscape_2025.
  ///
  /// In en, this message translates to:
  /// **'2025 Sleep Soundscape'**
  String get sleep_soundscape_2025;

  /// No description provided for @ready_to_sleep.
  ///
  /// In en, this message translates to:
  /// **'Ready to Sleep?'**
  String get ready_to_sleep;

  /// No description provided for @ready_to_sleep_description.
  ///
  /// In en, this message translates to:
  /// **'Keep the charger connected Screen down your phone on the bed'**
  String get ready_to_sleep_description;

  /// No description provided for @dont_remind_me.
  ///
  /// In en, this message translates to:
  /// **'Don’t remind me'**
  String get dont_remind_me;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sleep_reminder.
  ///
  /// In en, this message translates to:
  /// **'Sleep reminder'**
  String get sleep_reminder;

  /// No description provided for @focus_reminder.
  ///
  /// In en, this message translates to:
  /// **'Focus Reminder'**
  String get focus_reminder;

  /// No description provided for @add_reminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get add_reminder;

  /// No description provided for @reminder_time.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminder_time;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advance;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @select_reminder_type.
  ///
  /// In en, this message translates to:
  /// **'Select Reminder Type'**
  String get select_reminder_type;

  /// No description provided for @select_repeat.
  ///
  /// In en, this message translates to:
  /// **'Select repeat'**
  String get select_repeat;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @breath.
  ///
  /// In en, this message translates to:
  /// **'Breath'**
  String get breath;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// No description provided for @nap.
  ///
  /// In en, this message translates to:
  /// **'Nap'**
  String get nap;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get everyday;

  /// No description provided for @reminder_deleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder Deleted'**
  String get reminder_deleted;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @help_us_improve.
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get help_us_improve;

  /// No description provided for @provide_feedback.
  ///
  /// In en, this message translates to:
  /// **'Please provide your valuable feedback'**
  String get provide_feedback;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @user_feedback.
  ///
  /// In en, this message translates to:
  /// **'User Feedback'**
  String get user_feedback;

  /// No description provided for @slow_loading.
  ///
  /// In en, this message translates to:
  /// **'Slow loading'**
  String get slow_loading;

  /// No description provided for @app_crash.
  ///
  /// In en, this message translates to:
  /// **'App crash'**
  String get app_crash;

  /// No description provided for @not_functional.
  ///
  /// In en, this message translates to:
  /// **'Not functional'**
  String get not_functional;

  /// No description provided for @security_issues.
  ///
  /// In en, this message translates to:
  /// **'Security Issues'**
  String get security_issues;

  /// No description provided for @customer_service.
  ///
  /// In en, this message translates to:
  /// **'Customer service'**
  String get customer_service;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @not_responsive.
  ///
  /// In en, this message translates to:
  /// **'Not responsive'**
  String get not_responsive;

  /// No description provided for @any_problem_face.
  ///
  /// In en, this message translates to:
  /// **'Any problems faced so far?'**
  String get any_problem_face;

  /// No description provided for @write_a_review_here.
  ///
  /// In en, this message translates to:
  /// **'Write a review here...'**
  String get write_a_review_here;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'nl',
    'pa',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pa':
      return AppLocalizationsPa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
