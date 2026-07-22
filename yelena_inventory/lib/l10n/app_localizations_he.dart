// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'Yelena Inventory';

  @override
  String get settings => 'הגדרות';

  @override
  String get settingsSubtitle => 'ניהול הגדרות ונתוני בסיס של האפליקציה.';

  @override
  String get branches => 'סניפים';

  @override
  String get employees => 'עובדים';

  @override
  String get auditLog => 'יומן פעילות';

  @override
  String get about => 'אודות';

  @override
  String get aboutSubtitle => 'מידע על האפליקציה';

  @override
  String get inventoryManagementSystem => 'מערכת ניהול מלאי';

  @override
  String get version => 'גרסה';

  @override
  String get build => 'בנייה';

  @override
  String get language => 'שפה';

  @override
  String get languageSubtitle => 'בחירת שפת הממשק';

  @override
  String get chooseLanguage => 'בחר שפה';

  @override
  String get cancel => 'ביטול';

  @override
  String get save => 'שמור';

  @override
  String get delete => 'מחק';

  @override
  String get edit => 'ערוך';

  @override
  String get retry => 'נסה שוב';

  @override
  String get refresh => 'רענן';

  @override
  String get signOut => 'התנתקות';

  @override
  String get loadingSession => 'טוען את פרטי המשתמש...';

  @override
  String get phoneLoginTitle => 'כניסה באמצעות טלפון';

  @override
  String get phoneLoginSubtitle => 'הזן את מספר הטלפון כדי לקבל קוד אימות ב-SMS.';

  @override
  String get phoneLoginExample => 'לדוגמה: 050-1234567';

  @override
  String get sendCode => 'שלח קוד';

  @override
  String get otpVerificationTitle => 'אימות קוד SMS';

  @override
  String otpVerificationSubtitle(String phone) {
    return 'הזן את הקוד שנשלח אל $phone.';
  }

  @override
  String get otpCode => 'קוד אימות';

  @override
  String get verifyCode => 'אמת קוד';

  @override
  String get changePhone => 'חזרה להזנת טלפון';

  @override
  String get otpCodeRequired => 'יש להזין קוד אימות בן 6 ספרות.';

  @override
  String get invalidPhone => 'מספר הטלפון אינו תקין.';

  @override
  String get otpRequestFailed => 'לא ניתן לשלוח קוד אימות כרגע.';

  @override
  String get invalidOrExpiredOtp => 'קוד האימות שגוי או פג תוקף.';

  @override
  String get rateLimited => 'בוצעו יותר מדי ניסיונות. נסה שוב מאוחר יותר.';

  @override
  String get networkFailure => 'לא ניתן להתחבר כרגע. בדוק את החיבור לאינטרנט.';

  @override
  String get authOperationFailed => 'לא ניתן להשלים את הפעולה כרגע.';

  @override
  String get noActivePermissionTitle => 'אין לך כרגע הרשאה פעילה';

  @override
  String get noActivePermissionBody => 'החשבון מאומת, אך לא נמצאה הרשאה פעילה או גישה לסניף. אם זה נראה שגוי, פנה למנהל הסניף.';

  @override
  String get employeeNotLinkedTitle => 'החשבון לא מקושר לעובד';

  @override
  String get employeeNotLinkedBody => 'הטלפון אומת, אך החשבון עדיין לא מקושר לרשומת עובד במערכת. פנה למנהל כדי להשלים את הקישור.';

  @override
  String get employeeLinkingConflictTitle => 'העובד כבר מקושר לחשבון אחר';

  @override
  String get employeeLinkingConflictBody => 'רשומת העובד המתאימה כבר מקושרת לחשבון אחר. פנה למנהל המערכת.';

  @override
  String get sessionLoadFailedTitle => 'לא ניתן לטעון את פרטי המשתמש';

  @override
  String get sessionLoadFailedBody => 'אירעה תקלה בטעינת פרטי הגישה. נסה שוב או התנתק והתחבר מחדש.';

  @override
  String get updateReady => 'העדכון מוכן';

  @override
  String get updateReadyMessage => 'גרסה חדשה הורדה ומוכנה להתקנה.';

  @override
  String get updateAvailable => 'גרסה חדשה זמינה';

  @override
  String get updateAvailableMessage => 'גרסה חדשה זמינה. האם לעדכן עכשיו?';

  @override
  String get updateNow => 'עדכן עכשיו';

  @override
  String get later => 'אחר כך';

  @override
  String get installUpdate => 'התקן עדכון';

  @override
  String get exit => 'יציאה';

  @override
  String get exitApplication => 'לצאת מהאפליקציה?';

  @override
  String get chooseBranch => 'בחר סניף';

  @override
  String get chooseBranchSubtitle => 'בחר את הסניף שבו מתבצעת ספירת המלאי.';

  @override
  String get loadingBranches => 'טוען סניפים...';

  @override
  String get couldNotLoadBranches => 'לא הצלחנו לטעון את רשימת הסניפים.';

  @override
  String get noBranchesCreated => 'עדיין לא נוצרו סניפים.';

  @override
  String get manageBranches => 'ניהול סניפים';

  @override
  String get manageBranchesSubtitle => 'הוסף, ערוך או מחק סניפי חנות.';

  @override
  String get noBranchesFound => 'לא נמצאו סניפים';

  @override
  String get addBranch => 'הוסף סניף';

  @override
  String get editBranch => 'ערוך סניף';

  @override
  String get branchName => 'שם הסניף';

  @override
  String get branchNameRequired => 'שם הסניף הוא שדה חובה.';

  @override
  String get branchExists => 'כבר קיים סניף בשם הזה.';

  @override
  String get branchNamePreviouslyUsed => 'אי אפשר לשנות את שם הסניף לשם שהיה כבר בשימוש. אם ברצונך להשתמש בשם זה שוב, יש ליצור אותו מחדש במקום לערוך סניף קיים.';

  @override
  String get branchCreated => 'הסניף נוצר.';

  @override
  String get branchUpdated => 'הסניף עודכן.';

  @override
  String get branchDeleted => 'הסניף נמחק.';

  @override
  String get branchAlreadyInactive => 'הסניף כבר אינו פעיל.';

  @override
  String get couldNotDeleteBranch => 'לא ניתן למחוק את הסניף.';

  @override
  String get deleteBranchTitle => 'למחוק סניף?';

  @override
  String get deleteLastBranchTitle => 'למחוק את הסניף האחרון?';

  @override
  String deleteBranchMessage(String name) {
    return 'למחוק את הסניף \"$name\"?';
  }

  @override
  String get branchHasEmployeesWarning => 'בסניף הזה יש עובדים.\n\nמחיקת הסניף תמחק גם את כל העובדים המשויכים אליו.';

  @override
  String get lastBranchWarning => 'זהו הסניף האחרון במערכת.\n\nלאחר המחיקה לא יישארו סניפים.';

  @override
  String get lastBranchWithEmployeesWarning => 'זהו הסניף האחרון במערכת.\n\nלאחר המחיקה לא יישארו סניפים.\n\nבסניף הזה יש עובדים. מחיקתו תמחק גם את כל העובדים המשויכים אליו.';

  @override
  String get scanProducts => 'סריקת מוצרים';

  @override
  String employeeSubtitle(String name) {
    return 'עובד: $name';
  }

  @override
  String get loadingInventory => 'טוען ספירת מלאי...';

  @override
  String get barcode => 'ברקוד';

  @override
  String get scanBarcode => 'סרוק ברקוד';

  @override
  String get quantity => 'כמות';

  @override
  String get barcodeRequired => 'ברקוד הוא שדה חובה.';

  @override
  String get quantityRequired => 'כמות היא שדה חובה.';

  @override
  String get savedSuccessfully => 'נשמר בהצלחה.';

  @override
  String get couldNotSaveInventory => 'לא ניתן היה לשמור את המלאי.';

  @override
  String get inventorySavedImageFailed => 'המלאי נשמר, אך לא ניתן היה לשמור את תמונת המוצר.';

  @override
  String get inventoryRecordDeleted => 'רשומת המלאי נמחקה.';

  @override
  String get noInventoryItems => 'עדיין אין פריטים בספירה.';

  @override
  String countedProducts(int count) {
    return 'נספרו $count מוצרים';
  }

  @override
  String get deleteInventoryRecordTitle => 'למחוק רשומת מלאי?';

  @override
  String get actionCannotBeUndone => 'אי אפשר לבטל את הפעולה הזו.';

  @override
  String get editInventoryRecord => 'עריכת רשומת מלאי';

  @override
  String get noProductImage => 'אין תמונת מוצר';

  @override
  String get addProductImage => 'הוסף תמונת מוצר';

  @override
  String get replaceProductImage => 'החלף תמונת מוצר';

  @override
  String get deleteProductImage => 'מחק תמונת מוצר';

  @override
  String get deleteProductImageTitle => 'למחוק תמונת מוצר?';

  @override
  String get takePhoto => 'צלם תמונה';

  @override
  String get chooseFromGallery => 'בחר מהגלריה';

  @override
  String get loadingEmployees => 'טוען עובדים...';

  @override
  String get couldNotLoadEmployees => 'לא הצלחנו לטעון עובדים.';

  @override
  String get noEmployeesInBranch => 'אין עובדים בסניף הזה.';

  @override
  String get addEmployeesFromSettings => 'הוסף עובדים מההגדרות.';

  @override
  String get chooseEmployee => 'בחר עובד';

  @override
  String get chooseEmployeeSubtitle => 'בחר מי מבצע את ספירת המלאי.';

  @override
  String get continueLabel => 'המשך';

  @override
  String get manageEmployees => 'ניהול עובדים';

  @override
  String get manageEmployeesSubtitle => 'נהל עובדים לפי סניף.';

  @override
  String get companyEmployees => 'עובדי החברה';

  @override
  String get companyEmployeesSubtitle => 'ספריית עובדים לקריאה בלבד לפי מודל התפקידים.';

  @override
  String get employeeDetails => 'פרטי עובד';

  @override
  String get identity => 'זהות';

  @override
  String get employeeCode => 'מספר עובד';

  @override
  String get fullName => 'שם מלא';

  @override
  String get status => 'סטטוס';

  @override
  String get active => 'פעיל';

  @override
  String get inactive => 'לא פעיל';

  @override
  String get authStatus => 'סטטוס התחברות';

  @override
  String get linked => 'מקושר';

  @override
  String get notLinked => 'לא מקושר';

  @override
  String get effectiveRoles => 'תפקידים פעילים';

  @override
  String get noEffectiveRoles => 'אין תפקידים פעילים.';

  @override
  String get accessibleBranches => 'סניפים נגישים';

  @override
  String get accessibleAreas => 'אזורים נגישים';

  @override
  String get noAccessibleBranches => 'אין סניפים נגישים.';

  @override
  String get noAccessibleAreas => 'אין אזורים נגישים.';

  @override
  String get validity => 'תוקף';

  @override
  String get alwaysValid => 'ללא מגבלת זמן';

  @override
  String get noCompanyEmployees => 'עדיין אין עובדים בחברה.';

  @override
  String get createEmployee => 'צור עובד';

  @override
  String get employeeName => 'שם עובד';

  @override
  String get employeeNameRequired => 'שם עובד הוא שדה חובה.';

  @override
  String get selectRole => 'בחר תפקיד';

  @override
  String get selectBranch => 'בחר סניף';

  @override
  String get selectArea => 'בחר אזור';

  @override
  String get scope => 'סקופ';

  @override
  String get validFrom => 'תקף מ';

  @override
  String get validUntil => 'תקף עד';

  @override
  String get validUntilRequired => 'יש לבחור תאריך סיום.';

  @override
  String get validUntilAfterFrom => 'תאריך הסיום חייב להיות אחרי תאריך ההתחלה.';

  @override
  String get review => 'סקירה';

  @override
  String get create => 'צור';

  @override
  String get back => 'חזרה';

  @override
  String get next => 'הבא';

  @override
  String get duplicatePhone => 'כבר קיים עובד עם מספר הטלפון הזה.';

  @override
  String get duplicateEmployeeCode => 'כבר קיים עובד עם מספר העובד הזה.';

  @override
  String get unauthorized => 'אין לך הרשאה לבצע את הפעולה הזו.';

  @override
  String get invalidScope => 'הסקופ שנבחר אינו תקין.';

  @override
  String get invalidRole => 'התפקיד שנבחר אינו תקין.';

  @override
  String get employeeCreationFailed => 'לא ניתן ליצור את העובד כרגע.';

  @override
  String get employeeCreatedWithRole => 'העובד נוצר עם תפקיד ראשוני.';

  @override
  String get addRole => 'הוסף תפקיד';

  @override
  String get editAssignment => 'עריכת שיוך';

  @override
  String get createAssignment => 'צור שיוך תפקיד';

  @override
  String get assignmentCreated => 'שיוך התפקיד נוצר.';

  @override
  String get assignmentUpdated => 'השיוך עודכן.';

  @override
  String get noAssignmentChanges => 'לא בוצעו שינויים.';

  @override
  String get duplicateAssignment => 'כבר קיים שיוך תפקיד זהה לעובד הזה.';

  @override
  String get overlappingAssignment => 'קיים כבר שיוך חופף לעובד הזה.';

  @override
  String get invalidValidity => 'טווח התוקף שנבחר אינו תקין.';

  @override
  String get selfManagementNotAllowed => 'לא ניתן לנהל תפקידים עבור עצמך.';

  @override
  String get protectedRole => 'לא ניתן לשנות תפקיד מוגן מהמסך הזה.';

  @override
  String get assignmentEmployeeNotFound => 'לא נמצא העובד עבור שיוך התפקיד.';

  @override
  String get assignmentEmployeeInactive => 'לא ניתן להוסיף תפקיד לעובד לא פעיל.';

  @override
  String get assignmentCreationFailed => 'לא ניתן ליצור את שיוך התפקיד כרגע.';

  @override
  String get assignmentUpdateFailed => 'לא ניתן לעדכן את השיוך כרגע.';

  @override
  String get endRole => 'הסר שיוך';

  @override
  String get endRoleAssignment => 'הסר שיוך';

  @override
  String get endRoleAssignmentMessage => 'השיוך לא יהיה פעיל יותר. העובד לא יימחק, והמידע ההיסטורי יישאר זמין ביומני המערכת. אם זהו השיוך הפעיל האחרון של העובד, ייתכן שהוא יאבד גישה למערכת.';

  @override
  String get roleEndedSuccessfully => 'השיוך הוסר.';

  @override
  String get roleAssignmentAlreadyEnded => 'השיוך כבר אינו פעיל.';

  @override
  String get roleAssignmentNotFound => 'שיוך התפקיד לא נמצא.';

  @override
  String get invalidEndTime => 'זמן הביטול אינו תקין.';

  @override
  String get endRoleAssignmentFailed => 'לא ניתן להסיר את השיוך כרגע.';

  @override
  String get currentRoles => 'תפקידים נוכחיים';

  @override
  String get roleHistory => 'היסטוריית תפקידים';

  @override
  String get effective => 'פעיל עכשיו';

  @override
  String get future => 'עתידי';

  @override
  String get expired => 'פג תוקף';

  @override
  String get ended => 'הסתיים';

  @override
  String get currentBranch => 'סניף נוכחי';

  @override
  String get switchBranch => 'החלף סניף';

  @override
  String get branchSwitchFailed => 'לא ניתן להחליף סניף כרגע.';

  @override
  String get noScopeRequired => 'לא נדרש סקופ לתפקיד הזה.';

  @override
  String get branch => 'סניף';

  @override
  String get area => 'אזור';

  @override
  String get addEmployee => 'הוסף עובד';

  @override
  String get editEmployee => 'ערוך עובד';

  @override
  String get manageAssignments => 'ניהול שיוכים';

  @override
  String get deleteEmployee => 'מחיקת עובד';

  @override
  String get deleteEmployeeConfirmationMessage => 'מחיקת העובד תבצע את הפעולות הבאות:\n\n• תסיר גישה למערכת אם לא יישארו שיוכים פעילים\n• תבטל כל שיוך פעיל שהמשתמש המחובר מורשה לנהל\n• תשאיר שיוכים גבוהים או מקבילים ללא שינוי אם אין הרשאה לנהל אותם\n• תשמור את כל הרשומות ההיסטוריות ומידע הביקורת\n\nלא ניתן לבטל פעולה זו.';

  @override
  String get employeeDeactivated => 'לא נשארו לעובד שיוכים פעילים והעובד הושבת.';

  @override
  String get employeePartiallyDeactivated => 'שיוך אחד או יותר בוטלו, אך העובד נשאר פעיל כי קיימים שיוכים נוספים.';

  @override
  String get employeeNothingToDeactivate => 'לא בוצע שינוי והעובד נשאר פעיל.';

  @override
  String get employeeNotFound => 'העובד לא נמצא.';

  @override
  String get employeeAlreadyInactive => 'העובד כבר לא פעיל.';

  @override
  String get employeeDeactivateUnauthorized => 'אין לך הרשאה למחוק את העובד.';

  @override
  String get employeeDeactivateFailed => 'לא ניתן למחוק את העובד כרגע.';

  @override
  String get firstName => 'שם פרטי';

  @override
  String get lastName => 'שם משפחה';

  @override
  String get phoneNumber => 'מספר טלפון';

  @override
  String get firstNameRequired => 'שם פרטי הוא שדה חובה.';

  @override
  String get lastNameRequired => 'שם משפחה הוא שדה חובה.';

  @override
  String get phoneRequired => 'מספר טלפון הוא שדה חובה.';

  @override
  String get phoneDigitsOnly => 'מספר טלפון יכול להכיל ספרות בלבד.';

  @override
  String get employeeExists => 'כבר קיים עובד בשם הזה בסניף.';

  @override
  String get employeeCreated => 'העובד נוצר.';

  @override
  String get employeeUpdated => 'העובד עודכן.';

  @override
  String get employeeUpdateFailed => 'לא ניתן לעדכן את העובד כרגע.';

  @override
  String get employeeDeleted => 'העובד נמחק.';

  @override
  String get couldNotDeleteEmployee => 'לא ניתן למחוק את העובד.';

  @override
  String get deleteEmployeeTitle => 'למחוק עובד?';

  @override
  String deleteEmployeeMessage(String name) {
    return 'למחוק את העובד\n$name?';
  }

  @override
  String get loadingAuditLog => 'טוען יומן פעילות...';

  @override
  String get couldNotLoadAuditLog => 'לא הצלחנו לטעון את יומן הפעילות.';

  @override
  String get auditLogSubtitle => 'סקירת פעולות חשובות באפליקציה.';

  @override
  String get noLogsYet => 'עדיין אין רישומים.';

  @override
  String get all => 'הכל';

  @override
  String get today => 'היום';

  @override
  String get thisWeek => 'השבוע';

  @override
  String get inventory => 'מלאי';

  @override
  String get close => 'סגור';

  @override
  String get pointCameraAtBarcode => 'כוון את המצלמה לברקוד';

  @override
  String get cameraPermissionRequired => 'נדרשת הרשאת מצלמה כדי לסרוק ברקודים.';

  @override
  String get cameraUnavailable => 'סריקת מצלמה אינה זמינה במכשיר הזה.';

  @override
  String get settingsBranchesSubtitle => 'יצירה, עריכה ומחיקה של סניפים';

  @override
  String get settingsEmployeesSubtitle => 'יצירה, עריכה ומחיקה של עובדים';

  @override
  String get settingsAuditLogSubtitle => 'סקירת פעולות חשובות באפליקציה';

  @override
  String get allBranches => 'כל הסניפים';

  @override
  String get roleDeveloper => 'מפתח';

  @override
  String get roleSystemManager => 'מנהל מערכת';

  @override
  String get roleAreaManager => 'מנהל אזור';

  @override
  String get roleBranchManager => 'מנהל סניף';

  @override
  String get roleDeputyBranchManager => 'סגן מנהל סניף';

  @override
  String get roleStoreEmployee => 'עובד סניף';

  @override
  String get roleViewer => 'צופה';
}
