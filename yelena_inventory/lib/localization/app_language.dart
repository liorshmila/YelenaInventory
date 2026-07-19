import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

enum AppLanguage {
  he('he', 'עברית', TextDirection.rtl),
  en('en', 'English', TextDirection.ltr),
  ru('ru', 'Русский', TextDirection.ltr);

  final String code;
  final String label;
  final TextDirection textDirection;

  const AppLanguage(this.code, this.label, this.textDirection);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.he,
    );
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, AppLanguage>(
  LanguageNotifier.new,
);

final appStringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(languageProvider));
});

class LanguageNotifier extends Notifier<AppLanguage> {
  static const _preferenceKey = 'app_language';

  @override
  AppLanguage build() {
    _load();
    return AppLanguage.he;
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, language.code);
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final language = AppLanguage.fromCode(
      preferences.getString(_preferenceKey),
    );

    if (state != language) {
      state = language;
    }
  }
}

class AppStrings {
  final AppLanguage appLanguage;

  AppStrings(this.appLanguage)
    : _localizations = lookupAppLocalizations(Locale(appLanguage.code));

  final AppLocalizations _localizations;

  bool get isHebrew => appLanguage == AppLanguage.he;

  String get appTitle => _localizations.appTitle;
  String get settings => _localizations.settings;
  String get settingsSubtitle => _localizations.settingsSubtitle;
  String get branches => _localizations.branches;
  String get employees => _localizations.employees;
  String get auditLog => _localizations.auditLog;
  String get about => _localizations.about;
  String get aboutSubtitle => _localizations.aboutSubtitle;
  String get inventoryManagementSystem =>
      _localizations.inventoryManagementSystem;
  String get version => _localizations.version;
  String get build => _localizations.build;
  String get language => _localizations.language;
  String get languageSubtitle => _localizations.languageSubtitle;
  String get chooseLanguage => _localizations.chooseLanguage;
  String get cancel => _localizations.cancel;
  String get save => _localizations.save;
  String get delete => _localizations.delete;
  String get edit => _localizations.edit;
  String get retry => _localizations.retry;
  String get refresh => _localizations.refresh;
  String get signOut => _localizations.signOut;
  String get loadingSession => _localizations.loadingSession;
  String get phoneLoginTitle => _localizations.phoneLoginTitle;
  String get phoneLoginSubtitle => _localizations.phoneLoginSubtitle;
  String get phoneLoginExample => _localizations.phoneLoginExample;
  String get sendCode => _localizations.sendCode;
  String get otpVerificationTitle => _localizations.otpVerificationTitle;
  String otpVerificationSubtitle(String phone) =>
      _localizations.otpVerificationSubtitle(phone);
  String get otpCode => _localizations.otpCode;
  String get verifyCode => _localizations.verifyCode;
  String get changePhone => _localizations.changePhone;
  String get otpCodeRequired => _localizations.otpCodeRequired;
  String get invalidPhone => _localizations.invalidPhone;
  String get otpRequestFailed => _localizations.otpRequestFailed;
  String get invalidOrExpiredOtp => _localizations.invalidOrExpiredOtp;
  String get rateLimited => _localizations.rateLimited;
  String get networkFailure => _localizations.networkFailure;
  String get authOperationFailed => _localizations.authOperationFailed;
  String get noActivePermissionTitle => _localizations.noActivePermissionTitle;
  String get noActivePermissionBody => _localizations.noActivePermissionBody;
  String get employeeNotLinkedTitle => _localizations.employeeNotLinkedTitle;
  String get employeeNotLinkedBody => _localizations.employeeNotLinkedBody;
  String get employeeLinkingConflictTitle =>
      _localizations.employeeLinkingConflictTitle;
  String get employeeLinkingConflictBody =>
      _localizations.employeeLinkingConflictBody;
  String get sessionLoadFailedTitle => _localizations.sessionLoadFailedTitle;
  String get sessionLoadFailedBody => _localizations.sessionLoadFailedBody;
  String get updateReady => _localizations.updateReady;
  String get updateReadyMessage => _localizations.updateReadyMessage;
  String get updateAvailable => _localizations.updateAvailable;
  String get updateAvailableMessage => _localizations.updateAvailableMessage;
  String get updateNow => _localizations.updateNow;
  String get later => _localizations.later;
  String get installUpdate => _localizations.installUpdate;
  String get exit => _localizations.exit;
  String get exitApplication => _localizations.exitApplication;
  String get chooseBranch => _localizations.chooseBranch;
  String get chooseBranchSubtitle => _localizations.chooseBranchSubtitle;
  String get loadingBranches => _localizations.loadingBranches;
  String get couldNotLoadBranches => _localizations.couldNotLoadBranches;
  String get noBranchesCreated => _localizations.noBranchesCreated;
  String get manageBranches => _localizations.manageBranches;
  String get manageBranchesSubtitle => _localizations.manageBranchesSubtitle;
  String get noBranchesFound => _localizations.noBranchesFound;
  String get addBranch => _localizations.addBranch;
  String get editBranch => _localizations.editBranch;
  String get branchName => _localizations.branchName;
  String get branchNameRequired => _localizations.branchNameRequired;
  String get branchExists => _localizations.branchExists;
  String get branchCreated => _localizations.branchCreated;
  String get branchUpdated => _localizations.branchUpdated;
  String get branchDeleted => _localizations.branchDeleted;
  String get couldNotDeleteBranch => _localizations.couldNotDeleteBranch;
  String get deleteBranchTitle => _localizations.deleteBranchTitle;
  String get deleteLastBranchTitle => _localizations.deleteLastBranchTitle;
  String deleteBranchMessage(String name) =>
      _localizations.deleteBranchMessage(name);
  String get branchHasEmployeesWarning =>
      _localizations.branchHasEmployeesWarning;
  String get lastBranchWarning => _localizations.lastBranchWarning;
  String get lastBranchWithEmployeesWarning =>
      _localizations.lastBranchWithEmployeesWarning;
  String get scanProducts => _localizations.scanProducts;
  String employeeSubtitle(String name) => _localizations.employeeSubtitle(name);
  String get loadingInventory => _localizations.loadingInventory;
  String get barcode => _localizations.barcode;
  String get scanBarcode => _localizations.scanBarcode;
  String get quantity => _localizations.quantity;
  String get barcodeRequired => _localizations.barcodeRequired;
  String get quantityRequired => _localizations.quantityRequired;
  String get savedSuccessfully => _localizations.savedSuccessfully;
  String get couldNotSaveInventory => _localizations.couldNotSaveInventory;
  String get inventorySavedImageFailed =>
      _localizations.inventorySavedImageFailed;
  String get inventoryRecordDeleted => _localizations.inventoryRecordDeleted;
  String get noInventoryItems => _localizations.noInventoryItems;
  String countedProducts(int count) => _localizations.countedProducts(count);
  String get deleteInventoryRecordTitle =>
      _localizations.deleteInventoryRecordTitle;
  String get actionCannotBeUndone => _localizations.actionCannotBeUndone;
  String get editInventoryRecord => _localizations.editInventoryRecord;
  String get noProductImage => _localizations.noProductImage;
  String get addProductImage => _localizations.addProductImage;
  String get replaceProductImage => _localizations.replaceProductImage;
  String get deleteProductImage => _localizations.deleteProductImage;
  String get deleteProductImageTitle => _localizations.deleteProductImageTitle;
  String get takePhoto => _localizations.takePhoto;
  String get chooseFromGallery => _localizations.chooseFromGallery;
  String get loadingEmployees => _localizations.loadingEmployees;
  String get couldNotLoadEmployees => _localizations.couldNotLoadEmployees;
  String get noEmployeesInBranch => _localizations.noEmployeesInBranch;
  String get addEmployeesFromSettings =>
      _localizations.addEmployeesFromSettings;
  String get chooseEmployee => _localizations.chooseEmployee;
  String get chooseEmployeeSubtitle => _localizations.chooseEmployeeSubtitle;
  String get continueLabel => _localizations.continueLabel;
  String get manageEmployees => _localizations.manageEmployees;
  String get manageEmployeesSubtitle => _localizations.manageEmployeesSubtitle;
  String get companyEmployees => _localizations.companyEmployees;
  String get companyEmployeesSubtitle =>
      _localizations.companyEmployeesSubtitle;
  String get employeeDetails => _localizations.employeeDetails;
  String get identity => _localizations.identity;
  String get employeeCode => _localizations.employeeCode;
  String get fullName => _localizations.fullName;
  String get status => _localizations.status;
  String get active => _localizations.active;
  String get inactive => _localizations.inactive;
  String get authStatus => _localizations.authStatus;
  String get linked => _localizations.linked;
  String get notLinked => _localizations.notLinked;
  String get effectiveRoles => _localizations.effectiveRoles;
  String get noEffectiveRoles => _localizations.noEffectiveRoles;
  String get accessibleBranches => _localizations.accessibleBranches;
  String get accessibleAreas => _localizations.accessibleAreas;
  String get noAccessibleBranches => _localizations.noAccessibleBranches;
  String get noAccessibleAreas => _localizations.noAccessibleAreas;
  String get validity => _localizations.validity;
  String get alwaysValid => _localizations.alwaysValid;
  String get noCompanyEmployees => _localizations.noCompanyEmployees;
  String get createEmployee => _localizations.createEmployee;
  String get employeeName => _localizations.employeeName;
  String get employeeNameRequired => _localizations.employeeNameRequired;
  String get selectRole => _localizations.selectRole;
  String get selectBranch => _localizations.selectBranch;
  String get selectArea => _localizations.selectArea;
  String get scope => _localizations.scope;
  String get validFrom => _localizations.validFrom;
  String get validUntil => _localizations.validUntil;
  String get validUntilRequired => _localizations.validUntilRequired;
  String get validUntilAfterFrom => _localizations.validUntilAfterFrom;
  String get review => _localizations.review;
  String get create => _localizations.create;
  String get back => _localizations.back;
  String get next => _localizations.next;
  String get duplicatePhone => _localizations.duplicatePhone;
  String get duplicateEmployeeCode => _localizations.duplicateEmployeeCode;
  String get unauthorized => _localizations.unauthorized;
  String get invalidScope => _localizations.invalidScope;
  String get invalidRole => _localizations.invalidRole;
  String get employeeCreationFailed => _localizations.employeeCreationFailed;
  String get employeeCreatedWithRole => _localizations.employeeCreatedWithRole;
  String get addRole => _localizations.addRole;
  String get editAssignment => _localizations.editAssignment;
  String get createAssignment => _localizations.createAssignment;
  String get assignmentCreated => _localizations.assignmentCreated;
  String get assignmentUpdated => _localizations.assignmentUpdated;
  String get noAssignmentChanges => _localizations.noAssignmentChanges;
  String get duplicateAssignment => _localizations.duplicateAssignment;
  String get overlappingAssignment => _localizations.overlappingAssignment;
  String get invalidValidity => _localizations.invalidValidity;
  String get selfManagementNotAllowed =>
      _localizations.selfManagementNotAllowed;
  String get protectedRole => _localizations.protectedRole;
  String get assignmentEmployeeNotFound =>
      _localizations.assignmentEmployeeNotFound;
  String get assignmentEmployeeInactive =>
      _localizations.assignmentEmployeeInactive;
  String get assignmentCreationFailed =>
      _localizations.assignmentCreationFailed;
  String get assignmentUpdateFailed => _localizations.assignmentUpdateFailed;
  String get endRole => _localizations.endRole;
  String get endRoleAssignment => _localizations.endRoleAssignment;
  String get endRoleAssignmentMessage =>
      _localizations.endRoleAssignmentMessage;
  String get roleEndedSuccessfully => _localizations.roleEndedSuccessfully;
  String get roleAssignmentAlreadyEnded =>
      _localizations.roleAssignmentAlreadyEnded;
  String get roleAssignmentNotFound => _localizations.roleAssignmentNotFound;
  String get invalidEndTime => _localizations.invalidEndTime;
  String get endRoleAssignmentFailed => _localizations.endRoleAssignmentFailed;
  String get currentRoles => _localizations.currentRoles;
  String get roleHistory => _localizations.roleHistory;
  String get effective => _localizations.effective;
  String get future => _localizations.future;
  String get expired => _localizations.expired;
  String get ended => _localizations.ended;
  String get currentBranch => _localizations.currentBranch;
  String get switchBranch => _localizations.switchBranch;
  String get branchSwitchFailed => _localizations.branchSwitchFailed;
  String get noScopeRequired => _localizations.noScopeRequired;
  String get branch => _localizations.branch;
  String get area => _localizations.area;
  String get addEmployee => _localizations.addEmployee;
  String get editEmployee => _localizations.editEmployee;
  String get manageAssignments => _localizations.manageAssignments;
  String get deleteEmployee => _localizations.deleteEmployee;
  String get deleteEmployeeConfirmationMessage =>
      _localizations.deleteEmployeeConfirmationMessage;
  String get employeeDeactivated => _localizations.employeeDeactivated;
  String get employeePartiallyDeactivated =>
      _localizations.employeePartiallyDeactivated;
  String get employeeNothingToDeactivate =>
      _localizations.employeeNothingToDeactivate;
  String get employeeNotFound => _localizations.employeeNotFound;
  String get employeeAlreadyInactive => _localizations.employeeAlreadyInactive;
  String get employeeDeactivateUnauthorized =>
      _localizations.employeeDeactivateUnauthorized;
  String get employeeDeactivateFailed =>
      _localizations.employeeDeactivateFailed;
  String get firstName => _localizations.firstName;
  String get lastName => _localizations.lastName;
  String get phoneNumber => _localizations.phoneNumber;
  String get firstNameRequired => _localizations.firstNameRequired;
  String get lastNameRequired => _localizations.lastNameRequired;
  String get phoneRequired => _localizations.phoneRequired;
  String get phoneDigitsOnly => _localizations.phoneDigitsOnly;
  String get employeeExists => _localizations.employeeExists;
  String get employeeCreated => _localizations.employeeCreated;
  String get employeeUpdated => _localizations.employeeUpdated;
  String get employeeUpdateFailed => _localizations.employeeUpdateFailed;
  String get employeeDeleted => _localizations.employeeDeleted;
  String get couldNotDeleteEmployee => _localizations.couldNotDeleteEmployee;
  String get deleteEmployeeTitle => _localizations.deleteEmployeeTitle;
  String deleteEmployeeMessage(String name) =>
      _localizations.deleteEmployeeMessage(name);
  String get loadingAuditLog => _localizations.loadingAuditLog;
  String get couldNotLoadAuditLog => _localizations.couldNotLoadAuditLog;
  String get auditLogSubtitle => _localizations.auditLogSubtitle;
  String get noLogsYet => _localizations.noLogsYet;
  String get all => _localizations.all;
  String get today => _localizations.today;
  String get thisWeek => _localizations.thisWeek;
  String get inventory => _localizations.inventory;
  String get close => _localizations.close;
  String get pointCameraAtBarcode => _localizations.pointCameraAtBarcode;
  String get cameraPermissionRequired =>
      _localizations.cameraPermissionRequired;
  String get cameraUnavailable => _localizations.cameraUnavailable;
  String get settingsBranchesSubtitle =>
      _localizations.settingsBranchesSubtitle;
  String get settingsEmployeesSubtitle =>
      _localizations.settingsEmployeesSubtitle;
  String get settingsAuditLogSubtitle =>
      _localizations.settingsAuditLogSubtitle;
  String get roleDeveloper => _localizations.roleDeveloper;
  String get roleSystemManager => _localizations.roleSystemManager;
  String get roleAreaManager => _localizations.roleAreaManager;
  String get roleBranchManager => _localizations.roleBranchManager;
  String get roleDeputyBranchManager => _localizations.roleDeputyBranchManager;
  String get roleStoreEmployee => _localizations.roleStoreEmployee;
  String get roleViewer => _localizations.roleViewer;
}
