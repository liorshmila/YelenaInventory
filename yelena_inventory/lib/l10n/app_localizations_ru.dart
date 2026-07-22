// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Yelena Inventory';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsSubtitle => 'Управление настройками приложения и справочными данными.';

  @override
  String get branches => 'Филиалы';

  @override
  String get employees => 'Сотрудники';

  @override
  String get auditLog => 'Журнал аудита';

  @override
  String get about => 'О приложении';

  @override
  String get aboutSubtitle => 'Информация о приложении';

  @override
  String get inventoryManagementSystem => 'Система управления инвентаризацией';

  @override
  String get version => 'Версия';

  @override
  String get build => 'Сборка';

  @override
  String get language => 'Язык';

  @override
  String get languageSubtitle => 'Выберите язык приложения';

  @override
  String get chooseLanguage => 'Выбор языка';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get retry => 'Повторить';

  @override
  String get refresh => 'Обновить';

  @override
  String get signOut => 'Выйти';

  @override
  String get loadingSession => 'Загрузка сеанса...';

  @override
  String get phoneLoginTitle => 'Вход по телефону';

  @override
  String get phoneLoginSubtitle => 'Введите номер телефона, чтобы получить SMS-код подтверждения.';

  @override
  String get phoneLoginExample => 'Пример: 050-1234567';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get otpVerificationTitle => 'Подтвердите SMS-код';

  @override
  String otpVerificationSubtitle(String phone) {
    return 'Введите код, отправленный на $phone.';
  }

  @override
  String get otpCode => 'Код подтверждения';

  @override
  String get verifyCode => 'Подтвердить код';

  @override
  String get changePhone => 'Изменить номер телефона';

  @override
  String get otpCodeRequired => 'Введите 6-значный код подтверждения.';

  @override
  String get invalidPhone => 'Номер телефона недействителен.';

  @override
  String get otpRequestFailed => 'Не удалось отправить код подтверждения сейчас.';

  @override
  String get invalidOrExpiredOtp => 'Код подтверждения недействителен или истек.';

  @override
  String get rateLimited => 'Слишком много попыток. Повторите позже.';

  @override
  String get networkFailure => 'Не удалось подключиться. Проверьте подключение к интернету.';

  @override
  String get authOperationFailed => 'Не удалось выполнить операцию сейчас.';

  @override
  String get noActivePermissionTitle => 'Нет активного доступа';

  @override
  String get noActivePermissionBody => 'Ваша учетная запись аутентифицирована, но активная роль или доступ к филиалу не найдены. Если это ошибка, обратитесь к менеджеру филиала.';

  @override
  String get employeeNotLinkedTitle => 'Учетная запись не связана';

  @override
  String get employeeNotLinkedBody => 'Номер телефона подтвержден, но эта учетная запись еще не связана с записью сотрудника. Обратитесь к администратору, чтобы завершить привязку.';

  @override
  String get employeeLinkingConflictTitle => 'Сотрудник уже связан';

  @override
  String get employeeLinkingConflictBody => 'Найденная запись сотрудника уже связана с другой учетной записью. Обратитесь к системному администратору.';

  @override
  String get sessionLoadFailedTitle => 'Не удалось загрузить сеанс';

  @override
  String get sessionLoadFailedBody => 'Возникла проблема при загрузке ваших данных доступа. Повторите попытку или выйдите и войдите снова.';

  @override
  String get updateReady => 'Обновление готово';

  @override
  String get updateReadyMessage => 'Новая версия загружена и готова к установке.';

  @override
  String get updateAvailable => 'Доступна новая версия';

  @override
  String get updateAvailableMessage => 'Доступна новая версия. Хотите обновить сейчас?';

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get later => 'Позже';

  @override
  String get installUpdate => 'Установить обновление';

  @override
  String get exit => 'Выход';

  @override
  String get exitApplication => 'Выйти из приложения?';

  @override
  String get chooseBranch => 'Выберите филиал';

  @override
  String get chooseBranchSubtitle => 'Выберите филиал, в котором выполняется инвентаризация.';

  @override
  String get loadingBranches => 'Загрузка филиалов...';

  @override
  String get couldNotLoadBranches => 'Не удалось загрузить филиалы.';

  @override
  String get noBranchesCreated => 'Филиалы еще не созданы.';

  @override
  String get manageBranches => 'Управление филиалами';

  @override
  String get manageBranchesSubtitle => 'Добавляйте, изменяйте или удаляйте филиалы магазинов.';

  @override
  String get noBranchesFound => 'Филиалы не найдены';

  @override
  String get addBranch => 'Добавить филиал';

  @override
  String get editBranch => 'Изменить филиал';

  @override
  String get branchName => 'Название филиала';

  @override
  String get branchNameRequired => 'Название филиала обязательно.';

  @override
  String get branchExists => 'Филиал с таким названием уже существует.';

  @override
  String get branchNamePreviouslyUsed => 'Нельзя изменить название филиала на название, которое уже использовалось ранее. Чтобы снова использовать это название, создайте филиал заново вместо редактирования существующего филиала.';

  @override
  String get branchCreated => 'Филиал создан.';

  @override
  String get branchUpdated => 'Филиал обновлен.';

  @override
  String get branchDeleted => 'Филиал удален.';

  @override
  String get branchAlreadyInactive => 'Этот филиал уже неактивен.';

  @override
  String get couldNotDeleteBranch => 'Не удалось удалить этот филиал.';

  @override
  String get deleteBranchTitle => 'Удалить филиал?';

  @override
  String get deleteLastBranchTitle => 'Удалить последний филиал?';

  @override
  String deleteBranchMessage(String name) {
    return 'Удалить филиал \"$name\"?';
  }

  @override
  String get branchHasEmployeesWarning => 'В этом филиале есть сотрудники.\n\nУдаление филиала также удалит всех сотрудников, назначенных этому филиалу.';

  @override
  String get lastBranchWarning => 'Это последний филиал в системе.\n\nПосле удаления филиалов не останется.';

  @override
  String get lastBranchWithEmployeesWarning => 'Это последний филиал в системе.\n\nПосле удаления филиалов не останется.\n\nВ этом филиале есть сотрудники. Его удаление также удалит всех сотрудников, назначенных этому филиалу.';

  @override
  String get scanProducts => 'Сканирование товаров';

  @override
  String employeeSubtitle(String name) {
    return 'Сотрудник: $name';
  }

  @override
  String get loadingInventory => 'Загрузка инвентаризационного подсчета...';

  @override
  String get barcode => 'Штрихкод';

  @override
  String get scanBarcode => 'Сканировать штрихкод';

  @override
  String get quantity => 'Количество';

  @override
  String get barcodeRequired => 'Штрихкод обязателен.';

  @override
  String get quantityRequired => 'Количество обязательно.';

  @override
  String get savedSuccessfully => 'Успешно сохранено.';

  @override
  String get couldNotSaveInventory => 'Не удалось сохранить инвентаризацию.';

  @override
  String get inventorySavedImageFailed => 'Инвентаризация сохранена, но изображение товара сохранить не удалось.';

  @override
  String get inventoryRecordDeleted => 'Запись инвентаризации удалена.';

  @override
  String get noInventoryItems => 'Записей инвентаризации пока нет.';

  @override
  String countedProducts(int count) {
    return 'Подсчитано товаров: $count';
  }

  @override
  String get deleteInventoryRecordTitle => 'Удалить запись инвентаризации?';

  @override
  String get actionCannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get editInventoryRecord => 'Изменить запись инвентаризации';

  @override
  String get noProductImage => 'Нет изображения товара';

  @override
  String get addProductImage => 'Добавить изображение товара';

  @override
  String get replaceProductImage => 'Заменить изображение товара';

  @override
  String get deleteProductImage => 'Удалить изображение товара';

  @override
  String get deleteProductImageTitle => 'Удалить изображение товара?';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get loadingEmployees => 'Загрузка сотрудников...';

  @override
  String get couldNotLoadEmployees => 'Не удалось загрузить сотрудников.';

  @override
  String get noEmployeesInBranch => 'В этом филиале нет сотрудников.';

  @override
  String get addEmployeesFromSettings => 'Добавьте сотрудников в настройках.';

  @override
  String get chooseEmployee => 'Выберите сотрудника';

  @override
  String get chooseEmployeeSubtitle => 'Выберите, кто выполняет инвентаризацию.';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get manageEmployees => 'Управление сотрудниками';

  @override
  String get manageEmployeesSubtitle => 'Создавайте и ведите сотрудников по филиалам.';

  @override
  String get companyEmployees => 'Сотрудники компании';

  @override
  String get companyEmployeesSubtitle => 'Справочник сотрудников только для чтения на основе назначений ролей.';

  @override
  String get employeeDetails => 'Данные сотрудника';

  @override
  String get identity => 'Профиль';

  @override
  String get employeeCode => 'Код сотрудника';

  @override
  String get fullName => 'Полное имя';

  @override
  String get status => 'Статус';

  @override
  String get active => 'Активен';

  @override
  String get inactive => 'Неактивен';

  @override
  String get authStatus => 'Статус входа';

  @override
  String get linked => 'Связан';

  @override
  String get notLinked => 'Не связан';

  @override
  String get effectiveRoles => 'Действующие роли';

  @override
  String get noEffectiveRoles => 'Нет действующих ролей.';

  @override
  String get accessibleBranches => 'Доступные филиалы';

  @override
  String get accessibleAreas => 'Доступные регионы';

  @override
  String get noAccessibleBranches => 'Нет доступных филиалов.';

  @override
  String get noAccessibleAreas => 'Нет доступных регионов.';

  @override
  String get validity => 'Срок действия';

  @override
  String get alwaysValid => 'Без ограничения по времени';

  @override
  String get noCompanyEmployees => 'Сотрудники компании еще не созданы.';

  @override
  String get createEmployee => 'Создать сотрудника';

  @override
  String get employeeName => 'Имя сотрудника';

  @override
  String get employeeNameRequired => 'Имя сотрудника обязательно.';

  @override
  String get selectRole => 'Выберите роль';

  @override
  String get selectBranch => 'Выберите филиал';

  @override
  String get selectArea => 'Выберите регион';

  @override
  String get scope => 'Область действия';

  @override
  String get validFrom => 'Действует с';

  @override
  String get validUntil => 'Действует до';

  @override
  String get validUntilRequired => 'Дата окончания обязательна.';

  @override
  String get validUntilAfterFrom => 'Дата окончания должна быть позже даты начала.';

  @override
  String get review => 'Проверка';

  @override
  String get create => 'Создать';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get duplicatePhone => 'Сотрудник с таким номером телефона уже существует.';

  @override
  String get duplicateEmployeeCode => 'Сотрудник с таким кодом уже существует.';

  @override
  String get unauthorized => 'У вас нет прав для выполнения этого действия.';

  @override
  String get invalidScope => 'Выбранная область действия недействительна.';

  @override
  String get invalidRole => 'Выбранная роль недействительна.';

  @override
  String get employeeCreationFailed => 'Не удалось создать сотрудника сейчас.';

  @override
  String get employeeCreatedWithRole => 'Сотрудник создан с первым назначением роли.';

  @override
  String get addRole => 'Добавить роль';

  @override
  String get editAssignment => 'Изменить назначение';

  @override
  String get createAssignment => 'Создать назначение';

  @override
  String get assignmentCreated => 'Назначение роли создано.';

  @override
  String get assignmentUpdated => 'Назначение обновлено.';

  @override
  String get noAssignmentChanges => 'Изменений не было.';

  @override
  String get duplicateAssignment => 'У этого сотрудника уже есть такое же назначение роли.';

  @override
  String get overlappingAssignment => 'У этого сотрудника уже есть пересекающееся назначение.';

  @override
  String get invalidValidity => 'Выбранный срок действия недействителен.';

  @override
  String get selfManagementNotAllowed => 'Вы не можете управлять собственными назначениями ролей.';

  @override
  String get protectedRole => 'Эту защищенную роль нельзя изменить с этого экрана.';

  @override
  String get assignmentEmployeeNotFound => 'Сотрудник для этого назначения не найден.';

  @override
  String get assignmentEmployeeInactive => 'Нельзя добавить назначение роли неактивному сотруднику.';

  @override
  String get assignmentCreationFailed => 'Не удалось создать назначение роли сейчас.';

  @override
  String get assignmentUpdateFailed => 'Не удалось обновить назначение сейчас.';

  @override
  String get endRole => 'Удалить назначение';

  @override
  String get endRoleAssignment => 'Удалить назначение';

  @override
  String get endRoleAssignmentMessage => 'Это назначение больше не будет активным. Сотрудник не будет удален, а историческая информация останется доступной в системных журналах. Если это последнее активное назначение сотрудника, он может потерять доступ к приложению.';

  @override
  String get roleEndedSuccessfully => 'Назначение удалено.';

  @override
  String get roleAssignmentAlreadyEnded => 'Это назначение уже неактивно.';

  @override
  String get roleAssignmentNotFound => 'Назначение роли не найдено.';

  @override
  String get invalidEndTime => 'Время отмены недействительно.';

  @override
  String get endRoleAssignmentFailed => 'Не удалось удалить назначение сейчас.';

  @override
  String get currentRoles => 'Текущие роли';

  @override
  String get roleHistory => 'История ролей';

  @override
  String get effective => 'Действует';

  @override
  String get future => 'Будущее';

  @override
  String get expired => 'Истекло';

  @override
  String get ended => 'Завершено';

  @override
  String get currentBranch => 'Текущий филиал';

  @override
  String get switchBranch => 'Сменить филиал';

  @override
  String get branchSwitchFailed => 'Не удалось сменить филиал сейчас.';

  @override
  String get noScopeRequired => 'Для этой роли область действия не требуется.';

  @override
  String get branch => 'Филиал';

  @override
  String get area => 'Регион';

  @override
  String get addEmployee => 'Добавить сотрудника';

  @override
  String get editEmployee => 'Изменить сотрудника';

  @override
  String get manageAssignments => 'Управление назначениями';

  @override
  String get deleteEmployee => 'Удалить сотрудника';

  @override
  String get deleteEmployeeConfirmationMessage => 'Удаление этого сотрудника приведет к следующему:\n\n• доступ к системе будет удален, если активных назначений не останется\n• каждое активное назначение, которым аутентифицированный пользователь имеет право управлять, будет отменено\n• неавторизованные вышестоящие или параллельные назначения останутся активными\n• все исторические записи и информация аудита будут сохранены\n\nЭто действие нельзя отменить.';

  @override
  String get employeeDeactivated => 'У сотрудника больше нет активных назначений, и он был деактивирован.';

  @override
  String get employeePartiallyDeactivated => 'Одно или несколько разрешенных назначений были завершены, но сотрудник остается активным, потому что другие назначения еще действуют.';

  @override
  String get employeeNothingToDeactivate => 'Ни одно назначение не изменено, сотрудник остается активным.';

  @override
  String get employeeNotFound => 'Сотрудник не существует.';

  @override
  String get employeeAlreadyInactive => 'Сотрудник уже неактивен.';

  @override
  String get employeeDeactivateUnauthorized => 'У аутентифицированного пользователя нет прав.';

  @override
  String get employeeDeactivateFailed => 'Не удалось удалить сотрудника сейчас.';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get firstNameRequired => 'Имя обязательно.';

  @override
  String get lastNameRequired => 'Фамилия обязательна.';

  @override
  String get phoneRequired => 'Номер телефона обязателен.';

  @override
  String get phoneDigitsOnly => 'Телефон должен содержать только цифры.';

  @override
  String get employeeExists => 'Сотрудник с таким именем уже существует здесь.';

  @override
  String get employeeCreated => 'Сотрудник создан.';

  @override
  String get employeeUpdated => 'Сотрудник обновлен.';

  @override
  String get employeeUpdateFailed => 'Не удалось обновить сотрудника сейчас.';

  @override
  String get employeeDeleted => 'Сотрудник удален.';

  @override
  String get couldNotDeleteEmployee => 'Не удалось удалить этого сотрудника.';

  @override
  String get deleteEmployeeTitle => 'Удалить сотрудника?';

  @override
  String deleteEmployeeMessage(String name) {
    return 'Удалить сотрудника\n$name?';
  }

  @override
  String get loadingAuditLog => 'Загрузка журнала аудита...';

  @override
  String get couldNotLoadAuditLog => 'Не удалось загрузить журнал аудита.';

  @override
  String get auditLogSubtitle => 'Просмотр важных действий, выполненных в приложении.';

  @override
  String get noLogsYet => 'Записей пока нет.';

  @override
  String get all => 'Все';

  @override
  String get today => 'Сегодня';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get inventory => 'Инвентаризация';

  @override
  String get close => 'Закрыть';

  @override
  String get pointCameraAtBarcode => 'Наведите камеру на штрихкод';

  @override
  String get cameraPermissionRequired => 'Для сканирования штрихкодов требуется разрешение на камеру.';

  @override
  String get cameraUnavailable => 'Сканирование камерой недоступно на этом устройстве.';

  @override
  String get settingsBranchesSubtitle => 'Создание, изменение и удаление филиалов';

  @override
  String get settingsEmployeesSubtitle => 'Создание, изменение и удаление сотрудников';

  @override
  String get settingsAuditLogSubtitle => 'Просмотр важной активности приложения';

  @override
  String get allBranches => 'Все филиалы';

  @override
  String get roleDeveloper => 'Разработчик';

  @override
  String get roleSystemManager => 'Системный менеджер';

  @override
  String get roleAreaManager => 'Менеджер региона';

  @override
  String get roleBranchManager => 'Менеджер филиала';

  @override
  String get roleDeputyBranchManager => 'Заместитель менеджера филиала';

  @override
  String get roleStoreEmployee => 'Сотрудник филиала';

  @override
  String get roleViewer => 'Наблюдатель';
}
