import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Yelena Inventory'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage application setup and master data.'**
  String get settingsSubtitle;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get auditLog;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Application information'**
  String get aboutSubtitle;

  /// No description provided for @inventoryManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management System'**
  String get inventoryManagementSystem;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the application language'**
  String get languageSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @loadingSession.
  ///
  /// In en, this message translates to:
  /// **'Loading session...'**
  String get loadingSession;

  /// No description provided for @phoneLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone'**
  String get phoneLoginTitle;

  /// No description provided for @phoneLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive an SMS verification code.'**
  String get phoneLoginSubtitle;

  /// No description provided for @phoneLoginExample.
  ///
  /// In en, this message translates to:
  /// **'Example: 050-1234567'**
  String get phoneLoginExample;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify SMS code'**
  String get otpVerificationTitle;

  /// No description provided for @otpVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {phone}.'**
  String otpVerificationSubtitle(String phone);

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhone;

  /// No description provided for @otpCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code.'**
  String get otpCodeRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'The phone number is not valid.'**
  String get invalidPhone;

  /// No description provided for @otpRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send a verification code right now.'**
  String get otpRequestFailed;

  /// No description provided for @invalidOrExpiredOtp.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid or expired.'**
  String get invalidOrExpiredOtp;

  /// No description provided for @rateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get rateLimited;

  /// No description provided for @networkFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Please check your internet connection.'**
  String get networkFailure;

  /// No description provided for @authOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the operation right now.'**
  String get authOperationFailed;

  /// No description provided for @noActivePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'No active permission'**
  String get noActivePermissionTitle;

  /// No description provided for @noActivePermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is authenticated, but no active role or branch access was found. If this looks wrong, contact your branch manager.'**
  String get noActivePermissionBody;

  /// No description provided for @employeeNotLinkedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account not linked'**
  String get employeeNotLinkedTitle;

  /// No description provided for @employeeNotLinkedBody.
  ///
  /// In en, this message translates to:
  /// **'The phone number was verified, but this account is not linked to an employee record yet. Contact an administrator to complete the link.'**
  String get employeeNotLinkedBody;

  /// No description provided for @employeeLinkingConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee already linked'**
  String get employeeLinkingConflictTitle;

  /// No description provided for @employeeLinkingConflictBody.
  ///
  /// In en, this message translates to:
  /// **'The matching employee record is already linked to another account. Contact the system administrator.'**
  String get employeeLinkingConflictBody;

  /// No description provided for @sessionLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load session'**
  String get sessionLoadFailedTitle;

  /// No description provided for @sessionLoadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'There was a problem loading your access details. Try again, or sign out and sign in again.'**
  String get sessionLoadFailedBody;

  /// No description provided for @updateReady.
  ///
  /// In en, this message translates to:
  /// **'Update ready'**
  String get updateReady;

  /// No description provided for @updateReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version has been downloaded and is ready to install.'**
  String get updateReadyMessage;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get updateAvailable;

  /// No description provided for @updateAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Do you want to update now?'**
  String get updateAvailableMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @installUpdate.
  ///
  /// In en, this message translates to:
  /// **'Install update'**
  String get installUpdate;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitApplication.
  ///
  /// In en, this message translates to:
  /// **'Exit application?'**
  String get exitApplication;

  /// No description provided for @chooseBranch.
  ///
  /// In en, this message translates to:
  /// **'Choose Branch'**
  String get chooseBranch;

  /// No description provided for @chooseBranchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the branch where the inventory count is being performed.'**
  String get chooseBranchSubtitle;

  /// No description provided for @loadingBranches.
  ///
  /// In en, this message translates to:
  /// **'Loading branches...'**
  String get loadingBranches;

  /// No description provided for @couldNotLoadBranches.
  ///
  /// In en, this message translates to:
  /// **'Could not load branches.'**
  String get couldNotLoadBranches;

  /// No description provided for @noBranchesCreated.
  ///
  /// In en, this message translates to:
  /// **'No branches have been created yet.'**
  String get noBranchesCreated;

  /// No description provided for @manageBranches.
  ///
  /// In en, this message translates to:
  /// **'Manage Branches'**
  String get manageBranches;

  /// No description provided for @manageBranchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, or remove store branches.'**
  String get manageBranchesSubtitle;

  /// No description provided for @noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get noBranchesFound;

  /// No description provided for @addBranch.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get addBranch;

  /// No description provided for @editBranch.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get editBranch;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// No description provided for @branchNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch name is required.'**
  String get branchNameRequired;

  /// No description provided for @branchExists.
  ///
  /// In en, this message translates to:
  /// **'A branch with this name already exists.'**
  String get branchExists;

  /// No description provided for @branchNamePreviouslyUsed.
  ///
  /// In en, this message translates to:
  /// **'This branch name cannot be used for editing because it has already been used before. To use this name again, create it again instead of editing an existing branch.'**
  String get branchNamePreviouslyUsed;

  /// No description provided for @branchCreated.
  ///
  /// In en, this message translates to:
  /// **'Branch created.'**
  String get branchCreated;

  /// No description provided for @branchUpdated.
  ///
  /// In en, this message translates to:
  /// **'Branch updated.'**
  String get branchUpdated;

  /// No description provided for @branchDeleted.
  ///
  /// In en, this message translates to:
  /// **'Branch deleted.'**
  String get branchDeleted;

  /// No description provided for @branchAlreadyInactive.
  ///
  /// In en, this message translates to:
  /// **'This branch is already inactive.'**
  String get branchAlreadyInactive;

  /// No description provided for @couldNotDeleteBranch.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this branch.'**
  String get couldNotDeleteBranch;

  /// No description provided for @deleteBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Branch?'**
  String get deleteBranchTitle;

  /// No description provided for @deleteLastBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Last Branch?'**
  String get deleteLastBranchTitle;

  /// No description provided for @deleteBranchMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete branch \"{name}\"?'**
  String deleteBranchMessage(String name);

  /// No description provided for @branchHasEmployeesWarning.
  ///
  /// In en, this message translates to:
  /// **'This branch contains employees.\n\nDeleting the branch will also delete all employees assigned to this branch.'**
  String get branchHasEmployeesWarning;

  /// No description provided for @lastBranchWarning.
  ///
  /// In en, this message translates to:
  /// **'This is the last branch in the system.\n\nAfter deletion, no branches will remain.'**
  String get lastBranchWarning;

  /// No description provided for @lastBranchWithEmployeesWarning.
  ///
  /// In en, this message translates to:
  /// **'This is the last branch in the system.\n\nAfter deletion, no branches will remain.\n\nThis branch contains employees. Deleting it will also delete all employees assigned to this branch.'**
  String get lastBranchWithEmployeesWarning;

  /// No description provided for @scanProducts.
  ///
  /// In en, this message translates to:
  /// **'Scan Products'**
  String get scanProducts;

  /// No description provided for @employeeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Employee: {name}'**
  String employeeSubtitle(String name);

  /// No description provided for @loadingInventory.
  ///
  /// In en, this message translates to:
  /// **'Loading inventory count...'**
  String get loadingInventory;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @barcodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Barcode is required.'**
  String get barcodeRequired;

  /// No description provided for @quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required.'**
  String get quantityRequired;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully.'**
  String get savedSuccessfully;

  /// No description provided for @couldNotSaveInventory.
  ///
  /// In en, this message translates to:
  /// **'Could not save inventory.'**
  String get couldNotSaveInventory;

  /// No description provided for @inventorySavedImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Inventory was saved, but the product image could not be saved.'**
  String get inventorySavedImageFailed;

  /// No description provided for @inventoryRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Inventory record deleted.'**
  String get inventoryRecordDeleted;

  /// No description provided for @noInventoryItems.
  ///
  /// In en, this message translates to:
  /// **'No inventory items yet.'**
  String get noInventoryItems;

  /// No description provided for @countedProducts.
  ///
  /// In en, this message translates to:
  /// **'Counted {count} products'**
  String countedProducts(int count);

  /// No description provided for @deleteInventoryRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Inventory Record?'**
  String get deleteInventoryRecordTitle;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @editInventoryRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Inventory Record'**
  String get editInventoryRecord;

  /// No description provided for @noProductImage.
  ///
  /// In en, this message translates to:
  /// **'No product image'**
  String get noProductImage;

  /// No description provided for @addProductImage.
  ///
  /// In en, this message translates to:
  /// **'Add Product Image'**
  String get addProductImage;

  /// No description provided for @replaceProductImage.
  ///
  /// In en, this message translates to:
  /// **'Replace Product Image'**
  String get replaceProductImage;

  /// No description provided for @deleteProductImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Product Image'**
  String get deleteProductImage;

  /// No description provided for @deleteProductImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product Image?'**
  String get deleteProductImageTitle;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @loadingEmployees.
  ///
  /// In en, this message translates to:
  /// **'Loading employees...'**
  String get loadingEmployees;

  /// No description provided for @couldNotLoadEmployees.
  ///
  /// In en, this message translates to:
  /// **'Could not load employees.'**
  String get couldNotLoadEmployees;

  /// No description provided for @noEmployeesInBranch.
  ///
  /// In en, this message translates to:
  /// **'No employees in this branch.'**
  String get noEmployeesInBranch;

  /// No description provided for @addEmployeesFromSettings.
  ///
  /// In en, this message translates to:
  /// **'Add employees from Settings.'**
  String get addEmployeesFromSettings;

  /// No description provided for @chooseEmployee.
  ///
  /// In en, this message translates to:
  /// **'Choose Employee'**
  String get chooseEmployee;

  /// No description provided for @chooseEmployeeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose who is performing the inventory count.'**
  String get chooseEmployeeSubtitle;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @manageEmployees.
  ///
  /// In en, this message translates to:
  /// **'Manage Employees'**
  String get manageEmployees;

  /// No description provided for @manageEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and maintain employees by branch.'**
  String get manageEmployeesSubtitle;

  /// No description provided for @companyEmployees.
  ///
  /// In en, this message translates to:
  /// **'Company Employees'**
  String get companyEmployees;

  /// No description provided for @companyEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read-only employee directory based on role assignments.'**
  String get companyEmployeesSubtitle;

  /// No description provided for @employeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Employee Details'**
  String get employeeDetails;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee Code'**
  String get employeeCode;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @authStatus.
  ///
  /// In en, this message translates to:
  /// **'Auth Status'**
  String get authStatus;

  /// No description provided for @linked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get linked;

  /// No description provided for @notLinked.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get notLinked;

  /// No description provided for @effectiveRoles.
  ///
  /// In en, this message translates to:
  /// **'Effective Roles'**
  String get effectiveRoles;

  /// No description provided for @noEffectiveRoles.
  ///
  /// In en, this message translates to:
  /// **'No effective roles.'**
  String get noEffectiveRoles;

  /// No description provided for @accessibleBranches.
  ///
  /// In en, this message translates to:
  /// **'Accessible Branches'**
  String get accessibleBranches;

  /// No description provided for @accessibleAreas.
  ///
  /// In en, this message translates to:
  /// **'Accessible Areas'**
  String get accessibleAreas;

  /// No description provided for @noAccessibleBranches.
  ///
  /// In en, this message translates to:
  /// **'No accessible branches.'**
  String get noAccessibleBranches;

  /// No description provided for @noAccessibleAreas.
  ///
  /// In en, this message translates to:
  /// **'No accessible areas.'**
  String get noAccessibleAreas;

  /// No description provided for @validity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get validity;

  /// No description provided for @alwaysValid.
  ///
  /// In en, this message translates to:
  /// **'No time limit'**
  String get alwaysValid;

  /// No description provided for @noCompanyEmployees.
  ///
  /// In en, this message translates to:
  /// **'No company employees yet.'**
  String get noCompanyEmployees;

  /// No description provided for @createEmployee.
  ///
  /// In en, this message translates to:
  /// **'Create Employee'**
  String get createEmployee;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @employeeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Employee name is required.'**
  String get employeeNameRequired;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get selectBranch;

  /// No description provided for @selectArea.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get selectArea;

  /// No description provided for @scope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get scope;

  /// No description provided for @validFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get validFrom;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get validUntil;

  /// No description provided for @validUntilRequired.
  ///
  /// In en, this message translates to:
  /// **'Valid until is required.'**
  String get validUntilRequired;

  /// No description provided for @validUntilAfterFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid until must be after valid from.'**
  String get validUntilAfterFrom;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @duplicatePhone.
  ///
  /// In en, this message translates to:
  /// **'An employee with this phone number already exists.'**
  String get duplicatePhone;

  /// No description provided for @duplicateEmployeeCode.
  ///
  /// In en, this message translates to:
  /// **'An employee with this employee code already exists.'**
  String get duplicateEmployeeCode;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action.'**
  String get unauthorized;

  /// No description provided for @invalidScope.
  ///
  /// In en, this message translates to:
  /// **'The selected scope is invalid.'**
  String get invalidScope;

  /// No description provided for @invalidRole.
  ///
  /// In en, this message translates to:
  /// **'The selected role is invalid.'**
  String get invalidRole;

  /// No description provided for @employeeCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the employee right now.'**
  String get employeeCreationFailed;

  /// No description provided for @employeeCreatedWithRole.
  ///
  /// In en, this message translates to:
  /// **'Employee created with first role assignment.'**
  String get employeeCreatedWithRole;

  /// No description provided for @addRole.
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get addRole;

  /// No description provided for @editAssignment.
  ///
  /// In en, this message translates to:
  /// **'Edit Assignment'**
  String get editAssignment;

  /// No description provided for @createAssignment.
  ///
  /// In en, this message translates to:
  /// **'Create Assignment'**
  String get createAssignment;

  /// No description provided for @assignmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Role assignment created.'**
  String get assignmentCreated;

  /// No description provided for @assignmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Assignment updated.'**
  String get assignmentUpdated;

  /// No description provided for @noAssignmentChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes were made.'**
  String get noAssignmentChanges;

  /// No description provided for @duplicateAssignment.
  ///
  /// In en, this message translates to:
  /// **'This employee already has the same role assignment.'**
  String get duplicateAssignment;

  /// No description provided for @overlappingAssignment.
  ///
  /// In en, this message translates to:
  /// **'This employee already has an overlapping assignment.'**
  String get overlappingAssignment;

  /// No description provided for @invalidValidity.
  ///
  /// In en, this message translates to:
  /// **'The selected validity period is invalid.'**
  String get invalidValidity;

  /// No description provided for @selfManagementNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You cannot manage your own role assignments.'**
  String get selfManagementNotAllowed;

  /// No description provided for @protectedRole.
  ///
  /// In en, this message translates to:
  /// **'This protected role cannot be changed from this screen.'**
  String get protectedRole;

  /// No description provided for @assignmentEmployeeNotFound.
  ///
  /// In en, this message translates to:
  /// **'The employee could not be found for this assignment.'**
  String get assignmentEmployeeNotFound;

  /// No description provided for @assignmentEmployeeInactive.
  ///
  /// In en, this message translates to:
  /// **'Cannot add a role assignment to an inactive employee.'**
  String get assignmentEmployeeInactive;

  /// No description provided for @assignmentCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the role assignment right now.'**
  String get assignmentCreationFailed;

  /// No description provided for @assignmentUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the assignment right now.'**
  String get assignmentUpdateFailed;

  /// No description provided for @endRole.
  ///
  /// In en, this message translates to:
  /// **'Remove assignment'**
  String get endRole;

  /// No description provided for @endRoleAssignment.
  ///
  /// In en, this message translates to:
  /// **'Remove assignment'**
  String get endRoleAssignment;

  /// No description provided for @endRoleAssignmentMessage.
  ///
  /// In en, this message translates to:
  /// **'This assignment will no longer be active. The employee will not be deleted, and historical information remains available in system logs. If this is the employee\'s final active assignment, they may lose access to the app.'**
  String get endRoleAssignmentMessage;

  /// No description provided for @roleEndedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Assignment removed.'**
  String get roleEndedSuccessfully;

  /// No description provided for @roleAssignmentAlreadyEnded.
  ///
  /// In en, this message translates to:
  /// **'This assignment is already inactive.'**
  String get roleAssignmentAlreadyEnded;

  /// No description provided for @roleAssignmentNotFound.
  ///
  /// In en, this message translates to:
  /// **'The role assignment could not be found.'**
  String get roleAssignmentNotFound;

  /// No description provided for @invalidEndTime.
  ///
  /// In en, this message translates to:
  /// **'The cancellation time is invalid.'**
  String get invalidEndTime;

  /// No description provided for @endRoleAssignmentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the assignment right now.'**
  String get endRoleAssignmentFailed;

  /// No description provided for @currentRoles.
  ///
  /// In en, this message translates to:
  /// **'Current Roles'**
  String get currentRoles;

  /// No description provided for @roleHistory.
  ///
  /// In en, this message translates to:
  /// **'Role History'**
  String get roleHistory;

  /// No description provided for @effective.
  ///
  /// In en, this message translates to:
  /// **'Effective'**
  String get effective;

  /// No description provided for @future.
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get future;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @currentBranch.
  ///
  /// In en, this message translates to:
  /// **'Current Branch'**
  String get currentBranch;

  /// No description provided for @switchBranch.
  ///
  /// In en, this message translates to:
  /// **'Switch Branch'**
  String get switchBranch;

  /// No description provided for @branchSwitchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not switch branch right now.'**
  String get branchSwitchFailed;

  /// No description provided for @noScopeRequired.
  ///
  /// In en, this message translates to:
  /// **'No scope is required for this role.'**
  String get noScopeRequired;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get addEmployee;

  /// No description provided for @editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee'**
  String get editEmployee;

  /// No description provided for @manageAssignments.
  ///
  /// In en, this message translates to:
  /// **'Manage Assignments'**
  String get manageAssignments;

  /// No description provided for @deleteEmployee.
  ///
  /// In en, this message translates to:
  /// **'Delete Employee'**
  String get deleteEmployee;

  /// No description provided for @deleteEmployeeConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting this employee will:\n\n• remove system access if no active assignments remain\n• cancel every active assignment the authenticated actor is authorized to manage\n• keep unauthorized higher or sideways assignments active\n• keep all historical records and audit information\n\nThis action cannot be undone.'**
  String get deleteEmployeeConfirmationMessage;

  /// No description provided for @employeeDeactivated.
  ///
  /// In en, this message translates to:
  /// **'The employee has no active assignments remaining and was deactivated.'**
  String get employeeDeactivated;

  /// No description provided for @employeePartiallyDeactivated.
  ///
  /// In en, this message translates to:
  /// **'One or more authorized assignments were ended, but the employee remains active because other assignments remain.'**
  String get employeePartiallyDeactivated;

  /// No description provided for @employeeNothingToDeactivate.
  ///
  /// In en, this message translates to:
  /// **'No assignment was changed and the employee remains active.'**
  String get employeeNothingToDeactivate;

  /// No description provided for @employeeNotFound.
  ///
  /// In en, this message translates to:
  /// **'The employee does not exist.'**
  String get employeeNotFound;

  /// No description provided for @employeeAlreadyInactive.
  ///
  /// In en, this message translates to:
  /// **'The employee is already inactive.'**
  String get employeeAlreadyInactive;

  /// No description provided for @employeeDeactivateUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'The authenticated user is not authorized.'**
  String get employeeDeactivateUnauthorized;

  /// No description provided for @employeeDeactivateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the employee right now.'**
  String get employeeDeactivateFailed;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required.'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required.'**
  String get lastNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get phoneRequired;

  /// No description provided for @phoneDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone must contain digits only.'**
  String get phoneDigitsOnly;

  /// No description provided for @employeeExists.
  ///
  /// In en, this message translates to:
  /// **'An employee with this name already exists here.'**
  String get employeeExists;

  /// No description provided for @employeeCreated.
  ///
  /// In en, this message translates to:
  /// **'Employee created.'**
  String get employeeCreated;

  /// No description provided for @employeeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Employee updated.'**
  String get employeeUpdated;

  /// No description provided for @employeeUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the employee right now.'**
  String get employeeUpdateFailed;

  /// No description provided for @employeeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Employee deleted.'**
  String get employeeDeleted;

  /// No description provided for @couldNotDeleteEmployee.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this employee.'**
  String get couldNotDeleteEmployee;

  /// No description provided for @deleteEmployeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Employee?'**
  String get deleteEmployeeTitle;

  /// No description provided for @deleteEmployeeMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete employee\n{name}?'**
  String deleteEmployeeMessage(String name);

  /// No description provided for @loadingAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Loading audit log...'**
  String get loadingAuditLog;

  /// No description provided for @couldNotLoadAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Could not load audit log.'**
  String get couldNotLoadAuditLog;

  /// No description provided for @auditLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review important actions performed in the app.'**
  String get auditLogSubtitle;

  /// No description provided for @noLogsYet.
  ///
  /// In en, this message translates to:
  /// **'No logs yet.'**
  String get noLogsYet;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @pointCameraAtBarcode.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a barcode'**
  String get pointCameraAtBarcode;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan barcodes.'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera scanning is not available on this device.'**
  String get cameraUnavailable;

  /// No description provided for @settingsBranchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, and delete branches'**
  String get settingsBranchesSubtitle;

  /// No description provided for @settingsEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, and delete employees'**
  String get settingsEmployeesSubtitle;

  /// No description provided for @settingsAuditLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review important app activity'**
  String get settingsAuditLogSubtitle;

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get allBranches;

  /// No description provided for @roleDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get roleDeveloper;

  /// No description provided for @roleSystemManager.
  ///
  /// In en, this message translates to:
  /// **'System Manager'**
  String get roleSystemManager;

  /// No description provided for @roleAreaManager.
  ///
  /// In en, this message translates to:
  /// **'Area Manager'**
  String get roleAreaManager;

  /// No description provided for @roleBranchManager.
  ///
  /// In en, this message translates to:
  /// **'Branch Manager'**
  String get roleBranchManager;

  /// No description provided for @roleDeputyBranchManager.
  ///
  /// In en, this message translates to:
  /// **'Deputy Branch Manager'**
  String get roleDeputyBranchManager;

  /// No description provided for @roleStoreEmployee.
  ///
  /// In en, this message translates to:
  /// **'Store Employee'**
  String get roleStoreEmployee;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'he', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
