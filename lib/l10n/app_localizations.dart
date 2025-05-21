import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('es'),
    Locale('nl'),
    Locale('pt')
  ];

  /// The ranking of institutions based on their exchange rates for credit cards
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'CartaoExpert'**
  String get title;

  /// Settings option in the menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Option to enable dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// Option to change the language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Open data section title
  ///
  /// In en, this message translates to:
  /// **'Open Data'**
  String get open_data;

  /// Languages section title
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Portuguese language option
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// Dutch language option
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// Historical section title
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get historical;

  /// Historical data section title
  ///
  /// In en, this message translates to:
  /// **'Historical Data'**
  String get historical_data;

  /// Title for the section showing credit card usage rates by bank
  ///
  /// In en, this message translates to:
  /// **'Credit card usage rates by bank'**
  String get credit_card_usage_rates;

  /// Description for the section showing credit card usage rates by bank
  ///
  /// In en, this message translates to:
  /// **'Learn about the different rates applied by banks for international purchases using your credit card.'**
  String get credit_card_usage_rates_description;

  /// Label for data over time
  ///
  /// In en, this message translates to:
  /// **'Over time'**
  String get over_time;

  /// Home section title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Label indicating more banks
  ///
  /// In en, this message translates to:
  /// **'more banks'**
  String get more_banks;

  /// Label indicating more banks will be added soon
  ///
  /// In en, this message translates to:
  /// **'more banks soon'**
  String get more_banks_soon;

  /// Label indicating a feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get coming_soon;

  /// Label for the maximum value
  ///
  /// In en, this message translates to:
  /// **'Max.'**
  String get max;

  /// Title for the about section describing the app
  ///
  /// In en, this message translates to:
  /// **'About This App'**
  String get about_this_app;

  /// Description for the about section describing the app
  ///
  /// In en, this message translates to:
  /// **'This app is a showcase of what we do best: building fast, reliable, and visually stunning software. It serves as an example of the quality and creativity we bring to every project and how we turn ideas into impactful digital experiences.'**
  String get about_this_app_description;

  /// Title for the about section describing the company
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us;

  /// Description for the about section describing the company
  ///
  /// In en, this message translates to:
  /// **', we believe technology is more than just code – it’s about crafting experiences that connect people and businesses. We are a software house dedicated to developing super fast, reliable, and visually compelling solutions to our clients. We quickly turn concepts into products that drive success. Our mission is to simplify complexity while delivering applications with impeccable design. Get in touch! We’d love to hear from you and discuss your goals.'**
  String get about_us_description;

  /// Text for the link to visit the company's website
  ///
  /// In en, this message translates to:
  /// **'Visit our Website'**
  String get visit_website;

  /// Title for the definition section
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// Description for the open data definition
  ///
  /// In en, this message translates to:
  /// **'Open data in Brazil helps promoting transparency and innovation by making government data freely available to the public. The government and various institutions provide a wide range of datasets across different areas.'**
  String get open_data_definition;

  /// Title for the government initiatives section
  ///
  /// In en, this message translates to:
  /// **'Government Initiatives'**
  String get government_initiatives;

  /// Description for the government initiatives section
  ///
  /// In en, this message translates to:
  /// **'The platform where the Brazilian government publishes open data is called Portal Brasileiro de Dados Abertos (Brazilian Open Data Portal). It includes datasets from various ministries and agencies, covering topics like health, education, economy, environment, and more.'**
  String get government_initiatives_description;

  /// Text for the link to visit the Brazilian Open Data Portal
  ///
  /// In en, this message translates to:
  /// **'Visit the Brazilian Open Data Portal'**
  String get visit_brazilian_open_data_portal;

  /// Title for the central bank section
  ///
  /// In en, this message translates to:
  /// **'Central Bank'**
  String get central_bank;

  /// Description for the central bank section
  ///
  /// In en, this message translates to:
  /// **'The Central Bank of Brazil also provides open data through its open data portal. The data includes information on the country\'s financial system, foreign exchange, and more.'**
  String get central_bank_description;

  /// Text for the link to visit the Central Bank of Brazil Open Data Portal
  ///
  /// In en, this message translates to:
  /// **'Visit the Central Bank of Brazil Open Data Portal'**
  String get visit_central_bank_open_data_portal;

  /// Text that precedes the company name
  ///
  /// In en, this message translates to:
  /// **'At '**
  String get at;

  /// Title for the section showing the rankings of banks with the cheapest credit card rates
  ///
  /// In en, this message translates to:
  /// **'Cheapest Bank Rankings'**
  String get cheapest_bank_rankings;

  /// Description for the section showing the rankings of banks with the cheapest credit card rates
  ///
  /// In en, this message translates to:
  /// **'See the rankings of banks with the cheapest credit card rates.'**
  String get cheapest_bank_rankings_description;

  /// Title for the section showing historical comparisons
  ///
  /// In en, this message translates to:
  /// **'Historical Comparisons'**
  String get historical_comparisons;

  /// Description for the section showing historical comparisons
  ///
  /// In en, this message translates to:
  /// **'Compare rates historically to make informed decisions.'**
  String get historical_comparisons_description;

  /// Text for the get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// Label for a duration of two weeks
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get period_1;

  /// Label for a duration of the last month
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get period_2;

  /// No description provided for @simulate.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get simulate;

  /// No description provided for @calculate_your_purchase.
  ///
  /// In en, this message translates to:
  /// **'CALCULATE\nYOUR PURCHASE'**
  String get calculate_your_purchase;

  /// No description provided for @purchase_calculator_title.
  ///
  /// In en, this message translates to:
  /// **'Purchase calculator'**
  String get purchase_calculator_title;

  /// No description provided for @you_would_pay.
  ///
  /// In en, this message translates to:
  /// **'You would pay'**
  String get you_would_pay;

  /// Label for the purchase value input in the simulator/calculator.
  ///
  /// In en, this message translates to:
  /// **'Purchase Value'**
  String get purchase_value;

  /// Hint text below the purchase value input in the simulator/calculator.
  ///
  /// In en, this message translates to:
  /// **'Enter the value you want to simulate'**
  String get purchase_value_hint;

  /// Title for the Services section and navigation.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services_title;

  /// Title for the Simulate feature in Services.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get simulate_title;

  /// Title for the Alerts feature in Services.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts_title;

  /// Description for the Simulate feature in Services.
  ///
  /// In en, this message translates to:
  /// **'Simulate currency exchange operations.'**
  String get simulate_description;

  /// Description for the Alerts feature in Services.
  ///
  /// In en, this message translates to:
  /// **'Create and manage exchange alerts.'**
  String get alerts_description;

  /// Title for the More Services card in Services.
  ///
  /// In en, this message translates to:
  /// **'More services'**
  String get more_services_title;

  /// Description for the More Services card in Services.
  ///
  /// In en, this message translates to:
  /// **'More features coming soon.'**
  String get more_services_description;
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
      <String>['en', 'es', 'nl', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
