// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yelena Inventory';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Manage application setup and master data.';

  @override
  String get branches => 'Branches';

  @override
  String get employees => 'Employees';

  @override
  String get auditLog => 'Audit Log';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'Application information';

  @override
  String get inventoryManagementSystem => 'Inventory Management System';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose the application language';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get signOut => 'Sign out';

  @override
  String get loadingSession => 'Loading session...';

  @override
  String get phoneLoginTitle => 'Sign in with phone';

  @override
  String get phoneLoginSubtitle => 'Enter your phone number to receive an SMS verification code.';

  @override
  String get phoneLoginExample => 'Example: 050-1234567';

  @override
  String get sendCode => 'Send code';

  @override
  String get otpVerificationTitle => 'Verify SMS code';

  @override
  String otpVerificationSubtitle(String phone) {
    return 'Enter the code sent to $phone.';
  }

  @override
  String get otpCode => 'Verification code';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get changePhone => 'Change phone number';

  @override
  String get otpCodeRequired => 'Enter the 6-digit verification code.';

  @override
  String get invalidPhone => 'The phone number is not valid.';

  @override
  String get otpRequestFailed => 'Could not send a verification code right now.';

  @override
  String get invalidOrExpiredOtp => 'The verification code is invalid or expired.';

  @override
  String get rateLimited => 'Too many attempts. Please try again later.';

  @override
  String get networkFailure => 'Could not connect. Please check your internet connection.';

  @override
  String get authOperationFailed => 'Could not complete the operation right now.';

  @override
  String get noActivePermissionTitle => 'No active permission';

  @override
  String get noActivePermissionBody => 'Your account is authenticated, but no active role or branch access was found. If this looks wrong, contact your branch manager.';

  @override
  String get employeeNotLinkedTitle => 'Account not linked';

  @override
  String get employeeNotLinkedBody => 'The phone number was verified, but this account is not linked to an employee record yet. Contact an administrator to complete the link.';

  @override
  String get employeeLinkingConflictTitle => 'Employee already linked';

  @override
  String get employeeLinkingConflictBody => 'The matching employee record is already linked to another account. Contact the system administrator.';

  @override
  String get sessionLoadFailedTitle => 'Could not load session';

  @override
  String get sessionLoadFailedBody => 'There was a problem loading your access details. Try again, or sign out and sign in again.';

  @override
  String get updateReady => 'Update ready';

  @override
  String get updateReadyMessage => 'A new version has been downloaded and is ready to install.';

  @override
  String get updateAvailable => 'New version available';

  @override
  String get updateAvailableMessage => 'A new version is available. Do you want to update now?';

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get installUpdate => 'Install update';

  @override
  String get exit => 'Exit';

  @override
  String get exitApplication => 'Exit application?';

  @override
  String get chooseBranch => 'Choose Branch';

  @override
  String get chooseBranchSubtitle => 'Choose the branch where the inventory count is being performed.';

  @override
  String get loadingBranches => 'Loading branches...';

  @override
  String get couldNotLoadBranches => 'Could not load branches.';

  @override
  String get noBranchesCreated => 'No branches have been created yet.';

  @override
  String get manageBranches => 'Manage Branches';

  @override
  String get manageBranchesSubtitle => 'Add, edit, or remove store branches.';

  @override
  String get noBranchesFound => 'No branches found';

  @override
  String get addBranch => 'Add Branch';

  @override
  String get editBranch => 'Edit Branch';

  @override
  String get branchName => 'Branch Name';

  @override
  String get branchNameRequired => 'Branch name is required.';

  @override
  String get branchExists => 'A branch with this name already exists.';

  @override
  String get branchNamePreviouslyUsed => 'This branch name cannot be used for editing because it has already been used before. To use this name again, create it again instead of editing an existing branch.';

  @override
  String get branchCreated => 'Branch created.';

  @override
  String get branchUpdated => 'Branch updated.';

  @override
  String get branchDeleted => 'Branch deleted.';

  @override
  String get branchAlreadyInactive => 'This branch is already inactive.';

  @override
  String get couldNotDeleteBranch => 'Could not delete this branch.';

  @override
  String get deleteBranchTitle => 'Delete Branch?';

  @override
  String get deleteLastBranchTitle => 'Delete Last Branch?';

  @override
  String deleteBranchMessage(String name) {
    return 'Delete branch \"$name\"?';
  }

  @override
  String get branchHasEmployeesWarning => 'This branch contains employees.\n\nDeleting the branch will also delete all employees assigned to this branch.';

  @override
  String get lastBranchWarning => 'This is the last branch in the system.\n\nAfter deletion, no branches will remain.';

  @override
  String get lastBranchWithEmployeesWarning => 'This is the last branch in the system.\n\nAfter deletion, no branches will remain.\n\nThis branch contains employees. Deleting it will also delete all employees assigned to this branch.';

  @override
  String get scanProducts => 'Scan Products';

  @override
  String employeeSubtitle(String name) {
    return 'Employee: $name';
  }

  @override
  String get loadingInventory => 'Loading inventory count...';

  @override
  String get barcode => 'Barcode';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get quantity => 'Quantity';

  @override
  String get barcodeRequired => 'Barcode is required.';

  @override
  String get quantityRequired => 'Quantity is required.';

  @override
  String get savedSuccessfully => 'Saved successfully.';

  @override
  String get couldNotSaveInventory => 'Could not save inventory.';

  @override
  String get inventorySavedImageFailed => 'Inventory was saved, but the product image could not be saved.';

  @override
  String get inventoryRecordDeleted => 'Inventory record deleted.';

  @override
  String get noInventoryItems => 'No inventory items yet.';

  @override
  String countedProducts(int count) {
    return 'Counted $count products';
  }

  @override
  String get deleteInventoryRecordTitle => 'Delete Inventory Record?';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get editInventoryRecord => 'Edit Inventory Record';

  @override
  String get noProductImage => 'No product image';

  @override
  String get addProductImage => 'Add Product Image';

  @override
  String get replaceProductImage => 'Replace Product Image';

  @override
  String get deleteProductImage => 'Delete Product Image';

  @override
  String get deleteProductImageTitle => 'Delete Product Image?';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get loadingEmployees => 'Loading employees...';

  @override
  String get couldNotLoadEmployees => 'Could not load employees.';

  @override
  String get noEmployeesInBranch => 'No employees in this branch.';

  @override
  String get addEmployeesFromSettings => 'Add employees from Settings.';

  @override
  String get chooseEmployee => 'Choose Employee';

  @override
  String get chooseEmployeeSubtitle => 'Choose who is performing the inventory count.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get manageEmployees => 'Manage Employees';

  @override
  String get manageEmployeesSubtitle => 'Create and maintain employees by branch.';

  @override
  String get companyEmployees => 'Company Employees';

  @override
  String get companyEmployeesSubtitle => 'Read-only employee directory based on role assignments.';

  @override
  String get employeeDetails => 'Employee Details';

  @override
  String get identity => 'Identity';

  @override
  String get employeeCode => 'Employee Code';

  @override
  String get fullName => 'Full Name';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get authStatus => 'Auth Status';

  @override
  String get linked => 'Linked';

  @override
  String get notLinked => 'Not linked';

  @override
  String get effectiveRoles => 'Effective Roles';

  @override
  String get noEffectiveRoles => 'No effective roles.';

  @override
  String get accessibleBranches => 'Accessible Branches';

  @override
  String get accessibleAreas => 'Accessible Areas';

  @override
  String get noAccessibleBranches => 'No accessible branches.';

  @override
  String get noAccessibleAreas => 'No accessible areas.';

  @override
  String get validity => 'Validity';

  @override
  String get alwaysValid => 'No time limit';

  @override
  String get noCompanyEmployees => 'No company employees yet.';

  @override
  String get createEmployee => 'Create Employee';

  @override
  String get employeeName => 'Employee Name';

  @override
  String get employeeNameRequired => 'Employee name is required.';

  @override
  String get selectRole => 'Select Role';

  @override
  String get selectBranch => 'Select Branch';

  @override
  String get selectArea => 'Select Area';

  @override
  String get scope => 'Scope';

  @override
  String get validFrom => 'Valid from';

  @override
  String get validUntil => 'Valid until';

  @override
  String get validUntilRequired => 'Valid until is required.';

  @override
  String get validUntilAfterFrom => 'Valid until must be after valid from.';

  @override
  String get review => 'Review';

  @override
  String get create => 'Create';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get duplicatePhone => 'An employee with this phone number already exists.';

  @override
  String get duplicateEmployeeCode => 'An employee with this employee code already exists.';

  @override
  String get unauthorized => 'You are not authorized to perform this action.';

  @override
  String get invalidScope => 'The selected scope is invalid.';

  @override
  String get invalidRole => 'The selected role is invalid.';

  @override
  String get employeeCreationFailed => 'Could not create the employee right now.';

  @override
  String get employeeCreatedWithRole => 'Employee created with first role assignment.';

  @override
  String get addRole => 'Add Role';

  @override
  String get editAssignment => 'Edit Assignment';

  @override
  String get createAssignment => 'Create Assignment';

  @override
  String get assignmentCreated => 'Role assignment created.';

  @override
  String get assignmentUpdated => 'Assignment updated.';

  @override
  String get noAssignmentChanges => 'No changes were made.';

  @override
  String get duplicateAssignment => 'This employee already has the same role assignment.';

  @override
  String get overlappingAssignment => 'This employee already has an overlapping assignment.';

  @override
  String get invalidValidity => 'The selected validity period is invalid.';

  @override
  String get selfManagementNotAllowed => 'You cannot manage your own role assignments.';

  @override
  String get protectedRole => 'This protected role cannot be changed from this screen.';

  @override
  String get assignmentEmployeeNotFound => 'The employee could not be found for this assignment.';

  @override
  String get assignmentEmployeeInactive => 'Cannot add a role assignment to an inactive employee.';

  @override
  String get assignmentCreationFailed => 'Could not create the role assignment right now.';

  @override
  String get assignmentUpdateFailed => 'Could not update the assignment right now.';

  @override
  String get endRole => 'Remove assignment';

  @override
  String get endRoleAssignment => 'Remove assignment';

  @override
  String get endRoleAssignmentMessage => 'This assignment will no longer be active. The employee will not be deleted, and historical information remains available in system logs. If this is the employee\'s final active assignment, they may lose access to the app.';

  @override
  String get roleEndedSuccessfully => 'Assignment removed.';

  @override
  String get roleAssignmentAlreadyEnded => 'This assignment is already inactive.';

  @override
  String get roleAssignmentNotFound => 'The role assignment could not be found.';

  @override
  String get invalidEndTime => 'The cancellation time is invalid.';

  @override
  String get endRoleAssignmentFailed => 'Could not remove the assignment right now.';

  @override
  String get currentRoles => 'Current Roles';

  @override
  String get roleHistory => 'Role History';

  @override
  String get effective => 'Effective';

  @override
  String get future => 'Future';

  @override
  String get expired => 'Expired';

  @override
  String get ended => 'Ended';

  @override
  String get currentBranch => 'Current Branch';

  @override
  String get switchBranch => 'Switch Branch';

  @override
  String get branchSwitchFailed => 'Could not switch branch right now.';

  @override
  String get noScopeRequired => 'No scope is required for this role.';

  @override
  String get branch => 'Branch';

  @override
  String get area => 'Area';

  @override
  String get addEmployee => 'Add Employee';

  @override
  String get editEmployee => 'Edit Employee';

  @override
  String get manageAssignments => 'Manage Assignments';

  @override
  String get deleteEmployee => 'Delete Employee';

  @override
  String get deleteEmployeeConfirmationMessage => 'Deleting this employee will:\n\n• remove system access if no active assignments remain\n• cancel every active assignment the authenticated actor is authorized to manage\n• keep unauthorized higher or sideways assignments active\n• keep all historical records and audit information\n\nThis action cannot be undone.';

  @override
  String get employeeDeactivated => 'The employee has no active assignments remaining and was deactivated.';

  @override
  String get employeePartiallyDeactivated => 'One or more authorized assignments were ended, but the employee remains active because other assignments remain.';

  @override
  String get employeeNothingToDeactivate => 'No assignment was changed and the employee remains active.';

  @override
  String get employeeNotFound => 'The employee does not exist.';

  @override
  String get employeeAlreadyInactive => 'The employee is already inactive.';

  @override
  String get employeeDeactivateUnauthorized => 'The authenticated user is not authorized.';

  @override
  String get employeeDeactivateFailed => 'Could not delete the employee right now.';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get firstNameRequired => 'First name is required.';

  @override
  String get lastNameRequired => 'Last name is required.';

  @override
  String get phoneRequired => 'Phone number is required.';

  @override
  String get phoneDigitsOnly => 'Phone must contain digits only.';

  @override
  String get employeeExists => 'An employee with this name already exists here.';

  @override
  String get employeeCreated => 'Employee created.';

  @override
  String get employeeUpdated => 'Employee updated.';

  @override
  String get employeeUpdateFailed => 'Could not update the employee right now.';

  @override
  String get employeeDeleted => 'Employee deleted.';

  @override
  String get couldNotDeleteEmployee => 'Could not delete this employee.';

  @override
  String get deleteEmployeeTitle => 'Delete Employee?';

  @override
  String deleteEmployeeMessage(String name) {
    return 'Delete employee\n$name?';
  }

  @override
  String get loadingAuditLog => 'Loading audit log...';

  @override
  String get couldNotLoadAuditLog => 'Could not load audit log.';

  @override
  String get auditLogSubtitle => 'Review important actions performed in the app.';

  @override
  String get noLogsYet => 'No logs yet.';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get inventory => 'Inventory';

  @override
  String get close => 'Close';

  @override
  String get pointCameraAtBarcode => 'Point the camera at a barcode';

  @override
  String get cameraPermissionRequired => 'Camera permission is required to scan barcodes.';

  @override
  String get cameraUnavailable => 'Camera scanning is not available on this device.';

  @override
  String get settingsBranchesSubtitle => 'Create, edit, and delete branches';

  @override
  String get settingsEmployeesSubtitle => 'Create, edit, and delete employees';

  @override
  String get settingsAuditLogSubtitle => 'Review important app activity';

  @override
  String get allBranches => 'All Branches';

  @override
  String get roleDeveloper => 'Developer';

  @override
  String get roleSystemManager => 'System Manager';

  @override
  String get roleAreaManager => 'Area Manager';

  @override
  String get roleBranchManager => 'Branch Manager';

  @override
  String get roleDeputyBranchManager => 'Deputy Branch Manager';

  @override
  String get roleStoreEmployee => 'Store Employee';

  @override
  String get roleViewer => 'Viewer';
}
