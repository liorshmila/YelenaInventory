import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  he('he', 'עברית', TextDirection.rtl),
  en('en', 'English', TextDirection.ltr);

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

  const AppStrings(this.appLanguage);

  bool get isHebrew => appLanguage == AppLanguage.he;

  String get appTitle => 'Yelena Inventory';
  String get settings => isHebrew ? 'הגדרות' : 'Settings';
  String get settingsSubtitle => isHebrew
      ? 'ניהול הגדרות ונתוני בסיס של האפליקציה.'
      : 'Manage application setup and master data.';
  String get branches => isHebrew ? 'סניפים' : 'Branches';
  String get employees => isHebrew ? 'עובדים' : 'Employees';
  String get auditLog => isHebrew ? 'יומן פעילות' : 'Audit Log';
  String get about => isHebrew ? 'אודות' : 'About';
  String get aboutSubtitle =>
      isHebrew ? 'מידע על האפליקציה' : 'Application information';
  String get inventoryManagementSystem =>
      isHebrew ? 'מערכת ניהול מלאי' : 'Inventory Management System';
  String get version => isHebrew ? 'גרסה' : 'Version';
  String get build => isHebrew ? 'בנייה' : 'Build';
  String get language => isHebrew ? 'שפה' : 'Language';
  String get languageSubtitle =>
      isHebrew ? 'בחירת שפת הממשק' : 'Choose the application language';
  String get chooseLanguage => isHebrew ? 'בחר שפה' : 'Choose Language';
  String get cancel => isHebrew ? 'ביטול' : 'Cancel';
  String get save => isHebrew ? 'שמור' : 'Save';
  String get delete => isHebrew ? 'מחק' : 'Delete';
  String get edit => isHebrew ? 'ערוך' : 'Edit';
  String get retry => isHebrew ? 'נסה שוב' : 'Retry';
  String get refresh => isHebrew ? 'רענן' : 'Refresh';
  String get signOut => isHebrew ? 'התנתקות' : 'Sign out';
  String get loadingSession =>
      isHebrew ? 'טוען את פרטי המשתמש...' : 'Loading session...';
  String get phoneLoginTitle =>
      isHebrew ? 'כניסה באמצעות טלפון' : 'Sign in with phone';
  String get phoneLoginSubtitle => isHebrew
      ? 'הזן את מספר הטלפון כדי לקבל קוד אימות ב-SMS.'
      : 'Enter your phone number to receive an SMS verification code.';
  String get phoneLoginExample =>
      isHebrew ? 'לדוגמה: 050-1234567' : 'Example: 050-1234567';
  String get sendCode => isHebrew ? 'שלח קוד' : 'Send code';
  String get otpVerificationTitle =>
      isHebrew ? 'אימות קוד SMS' : 'Verify SMS code';
  String otpVerificationSubtitle(String phone) => isHebrew
      ? 'הזן את הקוד שנשלח אל $phone.'
      : 'Enter the code sent to $phone.';
  String get otpCode => isHebrew ? 'קוד אימות' : 'Verification code';
  String get verifyCode => isHebrew ? 'אמת קוד' : 'Verify code';
  String get changePhone =>
      isHebrew ? 'חזרה להזנת טלפון' : 'Change phone number';
  String get otpCodeRequired => isHebrew
      ? 'יש להזין קוד אימות בן 6 ספרות.'
      : 'Enter the 6-digit verification code.';
  String get invalidPhone =>
      isHebrew ? 'מספר הטלפון אינו תקין.' : 'The phone number is not valid.';
  String get otpRequestFailed => isHebrew
      ? 'לא ניתן לשלוח קוד אימות כרגע.'
      : 'Could not send a verification code right now.';
  String get invalidOrExpiredOtp => isHebrew
      ? 'קוד האימות שגוי או פג תוקף.'
      : 'The verification code is invalid or expired.';
  String get rateLimited => isHebrew
      ? 'בוצעו יותר מדי ניסיונות. נסה שוב מאוחר יותר.'
      : 'Too many attempts. Please try again later.';
  String get networkFailure => isHebrew
      ? 'לא ניתן להתחבר כרגע. בדוק את החיבור לאינטרנט.'
      : 'Could not connect. Please check your internet connection.';
  String get authOperationFailed => isHebrew
      ? 'לא ניתן להשלים את הפעולה כרגע.'
      : 'Could not complete the operation right now.';
  String get noActivePermissionTitle =>
      isHebrew ? 'אין לך כרגע הרשאה פעילה' : 'No active permission';
  String get noActivePermissionBody => isHebrew
      ? 'החשבון מאומת, אך לא נמצאה הרשאה פעילה או גישה לסניף. אם זה נראה שגוי, פנה למנהל הסניף.'
      : 'Your account is authenticated, but no active role or branch access was found. If this looks wrong, contact your branch manager.';
  String get employeeNotLinkedTitle =>
      isHebrew ? 'החשבון לא מקושר לעובד' : 'Account not linked';
  String get employeeNotLinkedBody => isHebrew
      ? 'הטלפון אומת, אך החשבון עדיין לא מקושר לרשומת עובד במערכת. פנה למנהל כדי להשלים את הקישור.'
      : 'The phone number was verified, but this account is not linked to an employee record yet. Contact an administrator to complete the link.';
  String get employeeLinkingConflictTitle =>
      isHebrew ? 'העובד כבר מקושר לחשבון אחר' : 'Employee already linked';
  String get employeeLinkingConflictBody => isHebrew
      ? 'רשומת העובד המתאימה כבר מקושרת לחשבון אחר. פנה למנהל המערכת.'
      : 'The matching employee record is already linked to another account. Contact the system administrator.';
  String get sessionLoadFailedTitle =>
      isHebrew ? 'לא ניתן לטעון את פרטי המשתמש' : 'Could not load session';
  String get sessionLoadFailedBody => isHebrew
      ? 'אירעה תקלה בטעינת פרטי הגישה. נסה שוב או התנתק והתחבר מחדש.'
      : 'There was a problem loading your access details. Try again, or sign out and sign in again.';
  String get updateReady => isHebrew ? 'העדכון מוכן' : 'Update ready';
  String get updateReadyMessage => isHebrew
      ? 'גרסה חדשה הורדה ומוכנה להתקנה.'
      : 'A new version has been downloaded and is ready to install.';
  String get updateAvailable =>
      isHebrew ? 'גרסה חדשה זמינה' : 'New version available';
  String get updateAvailableMessage => isHebrew
      ? 'גרסה חדשה זמינה. האם לעדכן עכשיו?'
      : 'A new version is available. Do you want to update now?';
  String get updateNow => isHebrew ? 'עדכן עכשיו' : 'Update now';
  String get later => isHebrew ? 'אחר כך' : 'Later';
  String get installUpdate => isHebrew ? 'התקן עדכון' : 'Install update';
  String get exit => isHebrew ? 'יציאה' : 'Exit';
  String get exitApplication =>
      isHebrew ? 'לצאת מהאפליקציה?' : 'Exit application?';
  String get chooseBranch => isHebrew ? 'בחר סניף' : 'Choose Branch';
  String get chooseBranchSubtitle => isHebrew
      ? 'בחר את הסניף שבו מתבצעת ספירת המלאי.'
      : 'Choose the branch where the inventory count is being performed.';
  String get loadingBranches =>
      isHebrew ? 'טוען סניפים...' : 'Loading branches...';
  String get couldNotLoadBranches => isHebrew
      ? 'לא הצלחנו לטעון את רשימת הסניפים.'
      : 'Could not load branches.';
  String get noBranchesCreated => isHebrew
      ? 'עדיין לא נוצרו סניפים.'
      : 'No branches have been created yet.';
  String get manageBranches => isHebrew ? 'ניהול סניפים' : 'Manage Branches';
  String get manageBranchesSubtitle => isHebrew
      ? 'הוסף, ערוך או מחק סניפי חנות.'
      : 'Add, edit, or remove store branches.';
  String get noBranchesFound =>
      isHebrew ? 'לא נמצאו סניפים' : 'No branches found';
  String get addBranch => isHebrew ? 'הוסף סניף' : 'Add Branch';
  String get editBranch => isHebrew ? 'ערוך סניף' : 'Edit Branch';
  String get branchName => isHebrew ? 'שם הסניף' : 'Branch Name';
  String get branchNameRequired =>
      isHebrew ? 'שם הסניף הוא שדה חובה.' : 'Branch name is required.';
  String get branchExists => isHebrew
      ? 'כבר קיים סניף בשם הזה.'
      : 'A branch with this name already exists.';
  String get branchCreated => isHebrew ? 'הסניף נוצר.' : 'Branch created.';
  String get branchUpdated => isHebrew ? 'הסניף עודכן.' : 'Branch updated.';
  String get branchDeleted => isHebrew ? 'הסניף נמחק.' : 'Branch deleted.';
  String get couldNotDeleteBranch =>
      isHebrew ? 'לא ניתן למחוק את הסניף.' : 'Could not delete this branch.';
  String get deleteBranchTitle => isHebrew ? 'למחוק סניף?' : 'Delete Branch?';
  String get deleteLastBranchTitle =>
      isHebrew ? 'למחוק את הסניף האחרון?' : 'Delete Last Branch?';
  String deleteBranchMessage(String name) =>
      isHebrew ? 'למחוק את הסניף "$name"?' : 'Delete branch "$name"?';
  String get branchHasEmployeesWarning => isHebrew
      ? 'בסניף הזה יש עובדים.\n\nמחיקת הסניף תמחק גם את כל העובדים המשויכים אליו.'
      : 'This branch contains employees.\n\nDeleting the branch will also delete all employees assigned to this branch.';
  String get lastBranchWarning => isHebrew
      ? 'זהו הסניף האחרון במערכת.\n\nלאחר המחיקה לא יישארו סניפים.'
      : 'This is the last branch in the system.\n\nAfter deletion, no branches will remain.';
  String get lastBranchWithEmployeesWarning => isHebrew
      ? 'זהו הסניף האחרון במערכת.\n\nלאחר המחיקה לא יישארו סניפים.\n\nבסניף הזה יש עובדים. מחיקתו תמחק גם את כל העובדים המשויכים אליו.'
      : 'This is the last branch in the system.\n\nAfter deletion, no branches will remain.\n\nThis branch contains employees. Deleting it will also delete all employees assigned to this branch.';
  String get scanProducts => isHebrew ? 'סריקת מוצרים' : 'Scan Products';
  String employeeSubtitle(String name) =>
      isHebrew ? 'עובד: $name' : 'Employee: $name';
  String get loadingInventory =>
      isHebrew ? 'טוען ספירת מלאי...' : 'Loading inventory count...';
  String get barcode => isHebrew ? 'ברקוד' : 'Barcode';
  String get scanBarcode => isHebrew ? 'סרוק ברקוד' : 'Scan barcode';
  String get quantity => isHebrew ? 'כמות' : 'Quantity';
  String get barcodeRequired =>
      isHebrew ? 'ברקוד הוא שדה חובה.' : 'Barcode is required.';
  String get quantityRequired =>
      isHebrew ? 'כמות היא שדה חובה.' : 'Quantity is required.';
  String get savedSuccessfully =>
      isHebrew ? 'נשמר בהצלחה.' : 'Saved successfully.';
  String get couldNotSaveInventory =>
      isHebrew ? 'לא ניתן היה לשמור את המלאי.' : 'Could not save inventory.';
  String get inventorySavedImageFailed => isHebrew
      ? 'המלאי נשמר, אך לא ניתן היה לשמור את תמונת המוצר.'
      : 'Inventory was saved, but the product image could not be saved.';
  String get inventoryRecordDeleted =>
      isHebrew ? 'רשומת המלאי נמחקה.' : 'Inventory record deleted.';
  String get noInventoryItems =>
      isHebrew ? 'עדיין אין פריטים בספירה.' : 'No inventory items yet.';
  String countedProducts(int count) =>
      isHebrew ? 'נספרו $count מוצרים' : 'Counted $count products';
  String get deleteInventoryRecordTitle =>
      isHebrew ? 'למחוק רשומת מלאי?' : 'Delete Inventory Record?';
  String get actionCannotBeUndone => isHebrew
      ? 'אי אפשר לבטל את הפעולה הזו.'
      : 'This action cannot be undone.';
  String get editInventoryRecord =>
      isHebrew ? 'עריכת רשומת מלאי' : 'Edit Inventory Record';
  String get noProductImage => isHebrew ? 'אין תמונת מוצר' : 'No product image';
  String get addProductImage =>
      isHebrew ? 'הוסף תמונת מוצר' : 'Add Product Image';
  String get replaceProductImage =>
      isHebrew ? 'החלף תמונת מוצר' : 'Replace Product Image';
  String get deleteProductImage =>
      isHebrew ? 'מחק תמונת מוצר' : 'Delete Product Image';
  String get deleteProductImageTitle =>
      isHebrew ? 'למחוק תמונת מוצר?' : 'Delete Product Image?';
  String get takePhoto => isHebrew ? 'צלם תמונה' : 'Take Photo';
  String get chooseFromGallery =>
      isHebrew ? 'בחר מהגלריה' : 'Choose from Gallery';
  String get loadingEmployees =>
      isHebrew ? 'טוען עובדים...' : 'Loading employees...';
  String get couldNotLoadEmployees =>
      isHebrew ? 'לא הצלחנו לטעון עובדים.' : 'Could not load employees.';
  String get noEmployeesInBranch =>
      isHebrew ? 'אין עובדים בסניף הזה.' : 'No employees in this branch.';
  String get addEmployeesFromSettings =>
      isHebrew ? 'הוסף עובדים מההגדרות.' : 'Add employees from Settings.';
  String get chooseEmployee => isHebrew ? 'בחר עובד' : 'Choose Employee';
  String get chooseEmployeeSubtitle => isHebrew
      ? 'בחר מי מבצע את ספירת המלאי.'
      : 'Choose who is performing the inventory count.';
  String get continueLabel => isHebrew ? 'המשך' : 'Continue';
  String get manageEmployees => isHebrew ? 'ניהול עובדים' : 'Manage Employees';
  String get manageEmployeesSubtitle => isHebrew
      ? 'נהל עובדים לפי סניף.'
      : 'Create and maintain employees by branch.';
  String get companyEmployees => isHebrew ? 'עובדי החברה' : 'Company Employees';
  String get companyEmployeesSubtitle => isHebrew
      ? 'ספריית עובדים לקריאה בלבד לפי מודל התפקידים.'
      : 'Read-only employee directory based on role assignments.';
  String get employeeDetails => isHebrew ? 'פרטי עובד' : 'Employee Details';
  String get identity => isHebrew ? 'זהות' : 'Identity';
  String get employeeCode => isHebrew ? 'מספר עובד' : 'Employee Code';
  String get fullName => isHebrew ? 'שם מלא' : 'Full Name';
  String get status => isHebrew ? 'סטטוס' : 'Status';
  String get active => isHebrew ? 'פעיל' : 'Active';
  String get inactive => isHebrew ? 'לא פעיל' : 'Inactive';
  String get authStatus => isHebrew ? 'סטטוס התחברות' : 'Auth Status';
  String get linked => isHebrew ? 'מקושר' : 'Linked';
  String get notLinked => isHebrew ? 'לא מקושר' : 'Not linked';
  String get effectiveRoles => isHebrew ? 'תפקידים פעילים' : 'Effective Roles';
  String get noEffectiveRoles =>
      isHebrew ? 'אין תפקידים פעילים.' : 'No effective roles.';
  String get accessibleBranches =>
      isHebrew ? 'סניפים נגישים' : 'Accessible Branches';
  String get accessibleAreas => isHebrew ? 'אזורים נגישים' : 'Accessible Areas';
  String get noAccessibleBranches =>
      isHebrew ? 'אין סניפים נגישים.' : 'No accessible branches.';
  String get noAccessibleAreas =>
      isHebrew ? 'אין אזורים נגישים.' : 'No accessible areas.';
  String get validity => isHebrew ? 'תוקף' : 'Validity';
  String get alwaysValid => isHebrew ? 'ללא מגבלת זמן' : 'No time limit';
  String get noCompanyEmployees =>
      isHebrew ? 'עדיין אין עובדים בחברה.' : 'No company employees yet.';
  String get createEmployee => isHebrew ? 'צור עובד' : 'Create Employee';
  String get employeeName => isHebrew ? 'שם עובד' : 'Employee Name';
  String get employeeNameRequired =>
      isHebrew ? 'שם עובד הוא שדה חובה.' : 'Employee name is required.';
  String get selectRole => isHebrew ? 'בחר תפקיד' : 'Select Role';
  String get selectBranch => isHebrew ? 'בחר סניף' : 'Select Branch';
  String get selectArea => isHebrew ? 'בחר אזור' : 'Select Area';
  String get scope => isHebrew ? 'סקופ' : 'Scope';
  String get validFrom => isHebrew ? 'תקף מ' : 'Valid from';
  String get validUntil => isHebrew ? 'תקף עד' : 'Valid until';
  String get validUntilRequired =>
      isHebrew ? 'יש לבחור תאריך סיום.' : 'Valid until is required.';
  String get validUntilAfterFrom => isHebrew
      ? 'תאריך הסיום חייב להיות אחרי תאריך ההתחלה.'
      : 'Valid until must be after valid from.';
  String get review => isHebrew ? 'סקירה' : 'Review';
  String get create => isHebrew ? 'צור' : 'Create';
  String get back => isHebrew ? 'חזרה' : 'Back';
  String get next => isHebrew ? 'הבא' : 'Next';
  String get duplicatePhone => isHebrew
      ? 'כבר קיים עובד עם מספר הטלפון הזה.'
      : 'An employee with this phone number already exists.';
  String get duplicateEmployeeCode => isHebrew
      ? 'כבר קיים עובד עם מספר העובד הזה.'
      : 'An employee with this employee code already exists.';
  String get unauthorized => isHebrew
      ? 'אין לך הרשאה לבצע את הפעולה הזו.'
      : 'You are not authorized to perform this action.';
  String get invalidScope =>
      isHebrew ? 'הסקופ שנבחר אינו תקין.' : 'The selected scope is invalid.';
  String get invalidRole =>
      isHebrew ? 'התפקיד שנבחר אינו תקין.' : 'The selected role is invalid.';
  String get employeeCreationFailed => isHebrew
      ? 'לא ניתן ליצור את העובד כרגע.'
      : 'Could not create the employee right now.';
  String get employeeCreatedWithRole => isHebrew
      ? 'העובד נוצר עם תפקיד ראשוני.'
      : 'Employee created with first role assignment.';
  String get addRole => isHebrew ? 'הוסף תפקיד' : 'Add Role';
  String get editAssignment => isHebrew ? 'עריכת שיוך' : 'Edit Assignment';
  String get createAssignment =>
      isHebrew ? 'צור שיוך תפקיד' : 'Create Assignment';
  String get assignmentCreated =>
      isHebrew ? 'שיוך התפקיד נוצר.' : 'Role assignment created.';
  String get assignmentUpdated =>
      isHebrew ? 'השיוך עודכן.' : 'Assignment updated.';
  String get noAssignmentChanges =>
      isHebrew ? 'לא בוצעו שינויים.' : 'No changes were made.';
  String get duplicateAssignment => isHebrew
      ? 'כבר קיים שיוך תפקיד זהה לעובד הזה.'
      : 'This employee already has the same role assignment.';
  String get overlappingAssignment => isHebrew
      ? 'קיים כבר שיוך חופף לעובד הזה.'
      : 'This employee already has an overlapping assignment.';
  String get invalidValidity => isHebrew
      ? 'טווח התוקף שנבחר אינו תקין.'
      : 'The selected validity period is invalid.';
  String get selfManagementNotAllowed => isHebrew
      ? 'לא ניתן לנהל תפקידים עבור עצמך.'
      : 'You cannot manage your own role assignments.';
  String get protectedRole => isHebrew
      ? 'לא ניתן לשנות תפקיד מוגן מהמסך הזה.'
      : 'This protected role cannot be changed from this screen.';
  String get assignmentEmployeeNotFound => isHebrew
      ? 'לא נמצא העובד עבור שיוך התפקיד.'
      : 'The employee could not be found for this assignment.';
  String get assignmentEmployeeInactive => isHebrew
      ? 'לא ניתן להוסיף תפקיד לעובד לא פעיל.'
      : 'Cannot add a role assignment to an inactive employee.';
  String get assignmentCreationFailed => isHebrew
      ? 'לא ניתן ליצור את שיוך התפקיד כרגע.'
      : 'Could not create the role assignment right now.';
  String get assignmentUpdateFailed => isHebrew
      ? 'לא ניתן לעדכן את השיוך כרגע.'
      : 'Could not update the assignment right now.';
  String get endRole => isHebrew ? 'בטל שיוך' : 'Cancel Assignment';
  String get endRoleAssignment => isHebrew ? 'ביטול שיוך' : 'Cancel Assignment';
  String get endRoleAssignmentMessage => isHebrew
      ? 'השיוך לא יהיה פעיל יותר. העובד לא יימחק, והמידע ההיסטורי יישאר זמין ביומני המערכת. אם זהו השיוך הפעיל האחרון של העובד, ייתכן שהוא יאבד גישה למערכת.'
      : 'This assignment will no longer be active. The employee will not be deleted, and historical information remains available in system logs. If this is the employee\'s final active assignment, they may lose access to the app.';
  String get roleEndedSuccessfully =>
      isHebrew ? 'השיוך בוטל.' : 'Assignment canceled.';
  String get roleAssignmentAlreadyEnded => isHebrew
      ? 'השיוך כבר אינו פעיל.'
      : 'This assignment is already inactive.';
  String get roleAssignmentNotFound => isHebrew
      ? 'שיוך התפקיד לא נמצא.'
      : 'The role assignment could not be found.';
  String get invalidEndTime =>
      isHebrew ? 'זמן הביטול אינו תקין.' : 'The cancellation time is invalid.';
  String get endRoleAssignmentFailed => isHebrew
      ? 'לא ניתן לבטל את השיוך כרגע.'
      : 'Could not cancel the assignment right now.';
  String get currentRoles => isHebrew ? 'תפקידים נוכחיים' : 'Current Roles';
  String get roleHistory => isHebrew ? 'היסטוריית תפקידים' : 'Role History';
  String get effective => isHebrew ? 'פעיל עכשיו' : 'Effective';
  String get future => isHebrew ? 'עתידי' : 'Future';
  String get expired => isHebrew ? 'פג תוקף' : 'Expired';
  String get ended => isHebrew ? 'הסתיים' : 'Ended';
  String get currentBranch => isHebrew ? 'סניף נוכחי' : 'Current Branch';
  String get switchBranch => isHebrew ? 'החלף סניף' : 'Switch Branch';
  String get branchSwitchFailed => isHebrew
      ? 'לא ניתן להחליף סניף כרגע.'
      : 'Could not switch branch right now.';
  String get noScopeRequired => isHebrew
      ? 'לא נדרש סקופ לתפקיד הזה.'
      : 'No scope is required for this role.';
  String get branch => isHebrew ? 'סניף' : 'Branch';
  String get area => isHebrew ? 'אזור' : 'Area';
  String get addEmployee => isHebrew ? 'הוסף עובד' : 'Add Employee';
  String get editEmployee => isHebrew ? 'ערוך עובד' : 'Edit Employee';
  String get manageAssignments =>
      isHebrew ? 'ניהול שיוכים' : 'Manage Assignments';
  String get deleteEmployee => isHebrew ? 'מחיקת עובד' : 'Delete Employee';
  String get deleteEmployeeConfirmationMessage => isHebrew
      ? 'מחיקת העובד תבצע את הפעולות הבאות:\n\n'
            '• תסיר גישה למערכת אם לא יישארו שיוכים פעילים\n'
            '• תבטל כל שיוך פעיל שהמשתמש המחובר מורשה לנהל\n'
            '• תשאיר שיוכים גבוהים או מקבילים ללא שינוי אם אין הרשאה לנהל אותם\n'
            '• תשמור את כל הרשומות ההיסטוריות ומידע הביקורת\n\n'
            'לא ניתן לבטל פעולה זו.'
      : 'Deleting this employee will:\n\n'
            '• remove system access if no active assignments remain\n'
            '• cancel every active assignment the authenticated actor is authorized to manage\n'
            '• keep unauthorized higher or sideways assignments active\n'
            '• keep all historical records and audit information\n\n'
            'This action cannot be undone.';
  String get employeeDeactivated => isHebrew
      ? 'לא נשארו לעובד שיוכים פעילים והעובד הושבת.'
      : 'The employee has no active assignments remaining and was deactivated.';
  String get employeePartiallyDeactivated => isHebrew
      ? 'שיוך אחד או יותר בוטלו, אך העובד נשאר פעיל כי קיימים שיוכים נוספים.'
      : 'One or more authorized assignments were ended, but the employee remains active because other assignments remain.';
  String get employeeNothingToDeactivate => isHebrew
      ? 'לא בוצע שינוי והעובד נשאר פעיל.'
      : 'No assignment was changed and the employee remains active.';
  String get employeeNotFound =>
      isHebrew ? 'העובד לא נמצא.' : 'The employee does not exist.';
  String get employeeAlreadyInactive =>
      isHebrew ? 'העובד כבר לא פעיל.' : 'The employee is already inactive.';
  String get employeeDeactivateUnauthorized => isHebrew
      ? 'אין לך הרשאה למחוק את העובד.'
      : 'The authenticated user is not authorized.';
  String get employeeDeactivateFailed => isHebrew
      ? 'לא ניתן למחוק את העובד כרגע.'
      : 'Could not delete the employee right now.';
  String get firstName => isHebrew ? 'שם פרטי' : 'First Name';
  String get lastName => isHebrew ? 'שם משפחה' : 'Last Name';
  String get phoneNumber => isHebrew ? 'מספר טלפון' : 'Phone Number';
  String get firstNameRequired =>
      isHebrew ? 'שם פרטי הוא שדה חובה.' : 'First name is required.';
  String get lastNameRequired =>
      isHebrew ? 'שם משפחה הוא שדה חובה.' : 'Last name is required.';
  String get phoneRequired =>
      isHebrew ? 'מספר טלפון הוא שדה חובה.' : 'Phone number is required.';
  String get phoneDigitsOnly => isHebrew
      ? 'מספר טלפון יכול להכיל ספרות בלבד.'
      : 'Phone must contain digits only.';
  String get employeeExists => isHebrew
      ? 'כבר קיים עובד בשם הזה בסניף.'
      : 'An employee with this name already exists here.';
  String get employeeCreated => isHebrew ? 'העובד נוצר.' : 'Employee created.';
  String get employeeUpdated => isHebrew ? 'העובד עודכן.' : 'Employee updated.';
  String get employeeUpdateFailed => isHebrew
      ? 'לא ניתן לעדכן את העובד כרגע.'
      : 'Could not update the employee right now.';
  String get employeeDeleted => isHebrew ? 'העובד נמחק.' : 'Employee deleted.';
  String get couldNotDeleteEmployee =>
      isHebrew ? 'לא ניתן למחוק את העובד.' : 'Could not delete this employee.';
  String get deleteEmployeeTitle =>
      isHebrew ? 'למחוק עובד?' : 'Delete Employee?';
  String deleteEmployeeMessage(String name) =>
      isHebrew ? 'למחוק את העובד\n$name?' : 'Delete employee\n$name?';
  String get loadingAuditLog =>
      isHebrew ? 'טוען יומן פעילות...' : 'Loading audit log...';
  String get couldNotLoadAuditLog => isHebrew
      ? 'לא הצלחנו לטעון את יומן הפעילות.'
      : 'Could not load audit log.';
  String get auditLogSubtitle => isHebrew
      ? 'סקירת פעולות חשובות באפליקציה.'
      : 'Review important actions performed in the app.';
  String get noLogsYet => isHebrew ? 'עדיין אין רישומים.' : 'No logs yet.';
  String get all => isHebrew ? 'הכל' : 'All';
  String get today => isHebrew ? 'היום' : 'Today';
  String get thisWeek => isHebrew ? 'השבוע' : 'This Week';
  String get inventory => isHebrew ? 'מלאי' : 'Inventory';
  String get close => isHebrew ? 'סגור' : 'Close';
  String get pointCameraAtBarcode =>
      isHebrew ? 'כוון את המצלמה לברקוד' : 'Point the camera at a barcode';
  String get cameraPermissionRequired => isHebrew
      ? 'נדרשת הרשאת מצלמה כדי לסרוק ברקודים.'
      : 'Camera permission is required to scan barcodes.';
  String get cameraUnavailable => isHebrew
      ? 'סריקת מצלמה אינה זמינה במכשיר הזה.'
      : 'Camera scanning is not available on this device.';
}
