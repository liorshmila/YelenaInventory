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
  String get branch => isHebrew ? 'סניף' : 'Branch';
  String get addEmployee => isHebrew ? 'הוסף עובד' : 'Add Employee';
  String get editEmployee => isHebrew ? 'ערוך עובד' : 'Edit Employee';
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
