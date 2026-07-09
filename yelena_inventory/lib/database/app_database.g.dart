// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BranchesTable extends Branches with TableInfo<$BranchesTable, Branche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchCodeMeta = const VerificationMeta(
    'branchCode',
  );
  @override
  late final GeneratedColumn<String> branchCode = GeneratedColumn<String>(
    'branch_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, branchCode, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Branche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('branch_code')) {
      context.handle(
        _branchCodeMeta,
        branchCode.isAcceptableOrUnknown(data['branch_code']!, _branchCodeMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Branche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Branche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      branchCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_code'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $BranchesTable createAlias(String alias) {
    return $BranchesTable(attachedDatabase, alias);
  }
}

class Branche extends DataClass implements Insertable<Branche> {
  final int id;
  final String name;
  final String? branchCode;
  final bool active;
  const Branche({
    required this.id,
    required this.name,
    this.branchCode,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || branchCode != null) {
      map['branch_code'] = Variable<String>(branchCode);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  BranchesCompanion toCompanion(bool nullToAbsent) {
    return BranchesCompanion(
      id: Value(id),
      name: Value(name),
      branchCode: branchCode == null && nullToAbsent
          ? const Value.absent()
          : Value(branchCode),
      active: Value(active),
    );
  }

  factory Branche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Branche(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      branchCode: serializer.fromJson<String?>(json['branchCode']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'branchCode': serializer.toJson<String?>(branchCode),
      'active': serializer.toJson<bool>(active),
    };
  }

  Branche copyWith({
    int? id,
    String? name,
    Value<String?> branchCode = const Value.absent(),
    bool? active,
  }) => Branche(
    id: id ?? this.id,
    name: name ?? this.name,
    branchCode: branchCode.present ? branchCode.value : this.branchCode,
    active: active ?? this.active,
  );
  Branche copyWithCompanion(BranchesCompanion data) {
    return Branche(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      branchCode: data.branchCode.present
          ? data.branchCode.value
          : this.branchCode,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Branche(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchCode: $branchCode, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, branchCode, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Branche &&
          other.id == this.id &&
          other.name == this.name &&
          other.branchCode == this.branchCode &&
          other.active == this.active);
}

class BranchesCompanion extends UpdateCompanion<Branche> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> branchCode;
  final Value<bool> active;
  const BranchesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.branchCode = const Value.absent(),
    this.active = const Value.absent(),
  });
  BranchesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.branchCode = const Value.absent(),
    this.active = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Branche> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? branchCode,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (branchCode != null) 'branch_code': branchCode,
      if (active != null) 'active': active,
    });
  }

  BranchesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? branchCode,
    Value<bool>? active,
  }) {
    return BranchesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      branchCode: branchCode ?? this.branchCode,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (branchCode.present) {
      map['branch_code'] = Variable<String>(branchCode.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchCode: $branchCode, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, branchId, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}branch_id'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String name;
  final int branchId;
  final bool active;
  const Employee({
    required this.id,
    required this.name,
    required this.branchId,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['branch_id'] = Variable<int>(branchId);
    map['active'] = Variable<bool>(active);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      branchId: Value(branchId),
      active: Value(active),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      branchId: serializer.fromJson<int>(json['branchId']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'branchId': serializer.toJson<int>(branchId),
      'active': serializer.toJson<bool>(active),
    };
  }

  Employee copyWith({int? id, String? name, int? branchId, bool? active}) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        branchId: branchId ?? this.branchId,
        active: active ?? this.active,
      );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchId: $branchId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, branchId, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.branchId == this.branchId &&
          other.active == this.active);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> branchId;
  final Value<bool> active;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.branchId = const Value.absent(),
    this.active = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int branchId,
    this.active = const Value.absent(),
  }) : name = Value(name),
       branchId = Value(branchId);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? branchId,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (branchId != null) 'branch_id': branchId,
      if (active != null) 'active': active,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? branchId,
    Value<bool>? active,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchId: $branchId, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $InventoryCountsTable extends InventoryCounts
    with TableInfo<$InventoryCountsTable, InventoryCount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryCountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES branches (id)',
    ),
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _countDateMeta = const VerificationMeta(
    'countDate',
  );
  @override
  late final GeneratedColumn<DateTime> countDate = GeneratedColumn<DateTime>(
    'count_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedToScannerMeta = const VerificationMeta(
    'updatedToScanner',
  );
  @override
  late final GeneratedColumn<bool> updatedToScanner = GeneratedColumn<bool>(
    'updated_to_scanner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("updated_to_scanner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scannerUpdateDateMeta = const VerificationMeta(
    'scannerUpdateDate',
  );
  @override
  late final GeneratedColumn<DateTime> scannerUpdateDate =
      GeneratedColumn<DateTime>(
        'scanner_update_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barcode,
    quantity,
    employeeId,
    branchId,
    countDate,
    note,
    updatedToScanner,
    scannerUpdateDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_counts';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryCount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    }
    if (data.containsKey('count_date')) {
      context.handle(
        _countDateMeta,
        countDate.isAcceptableOrUnknown(data['count_date']!, _countDateMeta),
      );
    } else if (isInserting) {
      context.missing(_countDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_to_scanner')) {
      context.handle(
        _updatedToScannerMeta,
        updatedToScanner.isAcceptableOrUnknown(
          data['updated_to_scanner']!,
          _updatedToScannerMeta,
        ),
      );
    }
    if (data.containsKey('scanner_update_date')) {
      context.handle(
        _scannerUpdateDateMeta,
        scannerUpdateDate.isAcceptableOrUnknown(
          data['scanner_update_date']!,
          _scannerUpdateDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryCount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryCount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}branch_id'],
      )!,
      countDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}count_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      updatedToScanner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}updated_to_scanner'],
      )!,
      scannerUpdateDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scanner_update_date'],
      ),
    );
  }

  @override
  $InventoryCountsTable createAlias(String alias) {
    return $InventoryCountsTable(attachedDatabase, alias);
  }
}

class InventoryCount extends DataClass implements Insertable<InventoryCount> {
  final int id;
  final String barcode;
  final int quantity;
  final int employeeId;
  final int branchId;
  final DateTime countDate;
  final String note;
  final bool updatedToScanner;
  final DateTime? scannerUpdateDate;
  const InventoryCount({
    required this.id,
    required this.barcode,
    required this.quantity,
    required this.employeeId,
    required this.branchId,
    required this.countDate,
    required this.note,
    required this.updatedToScanner,
    this.scannerUpdateDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['barcode'] = Variable<String>(barcode);
    map['quantity'] = Variable<int>(quantity);
    map['employee_id'] = Variable<int>(employeeId);
    map['branch_id'] = Variable<int>(branchId);
    map['count_date'] = Variable<DateTime>(countDate);
    map['note'] = Variable<String>(note);
    map['updated_to_scanner'] = Variable<bool>(updatedToScanner);
    if (!nullToAbsent || scannerUpdateDate != null) {
      map['scanner_update_date'] = Variable<DateTime>(scannerUpdateDate);
    }
    return map;
  }

  InventoryCountsCompanion toCompanion(bool nullToAbsent) {
    return InventoryCountsCompanion(
      id: Value(id),
      barcode: Value(barcode),
      quantity: Value(quantity),
      employeeId: Value(employeeId),
      branchId: Value(branchId),
      countDate: Value(countDate),
      note: Value(note),
      updatedToScanner: Value(updatedToScanner),
      scannerUpdateDate: scannerUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scannerUpdateDate),
    );
  }

  factory InventoryCount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryCount(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<String>(json['barcode']),
      quantity: serializer.fromJson<int>(json['quantity']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      branchId: serializer.fromJson<int>(json['branchId']),
      countDate: serializer.fromJson<DateTime>(json['countDate']),
      note: serializer.fromJson<String>(json['note']),
      updatedToScanner: serializer.fromJson<bool>(json['updatedToScanner']),
      scannerUpdateDate: serializer.fromJson<DateTime?>(
        json['scannerUpdateDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String>(barcode),
      'quantity': serializer.toJson<int>(quantity),
      'employeeId': serializer.toJson<int>(employeeId),
      'branchId': serializer.toJson<int>(branchId),
      'countDate': serializer.toJson<DateTime>(countDate),
      'note': serializer.toJson<String>(note),
      'updatedToScanner': serializer.toJson<bool>(updatedToScanner),
      'scannerUpdateDate': serializer.toJson<DateTime?>(scannerUpdateDate),
    };
  }

  InventoryCount copyWith({
    int? id,
    String? barcode,
    int? quantity,
    int? employeeId,
    int? branchId,
    DateTime? countDate,
    String? note,
    bool? updatedToScanner,
    Value<DateTime?> scannerUpdateDate = const Value.absent(),
  }) => InventoryCount(
    id: id ?? this.id,
    barcode: barcode ?? this.barcode,
    quantity: quantity ?? this.quantity,
    employeeId: employeeId ?? this.employeeId,
    branchId: branchId ?? this.branchId,
    countDate: countDate ?? this.countDate,
    note: note ?? this.note,
    updatedToScanner: updatedToScanner ?? this.updatedToScanner,
    scannerUpdateDate: scannerUpdateDate.present
        ? scannerUpdateDate.value
        : this.scannerUpdateDate,
  );
  InventoryCount copyWithCompanion(InventoryCountsCompanion data) {
    return InventoryCount(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      countDate: data.countDate.present ? data.countDate.value : this.countDate,
      note: data.note.present ? data.note.value : this.note,
      updatedToScanner: data.updatedToScanner.present
          ? data.updatedToScanner.value
          : this.updatedToScanner,
      scannerUpdateDate: data.scannerUpdateDate.present
          ? data.scannerUpdateDate.value
          : this.scannerUpdateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCount(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('branchId: $branchId, ')
          ..write('countDate: $countDate, ')
          ..write('note: $note, ')
          ..write('updatedToScanner: $updatedToScanner, ')
          ..write('scannerUpdateDate: $scannerUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    barcode,
    quantity,
    employeeId,
    branchId,
    countDate,
    note,
    updatedToScanner,
    scannerUpdateDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryCount &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.quantity == this.quantity &&
          other.employeeId == this.employeeId &&
          other.branchId == this.branchId &&
          other.countDate == this.countDate &&
          other.note == this.note &&
          other.updatedToScanner == this.updatedToScanner &&
          other.scannerUpdateDate == this.scannerUpdateDate);
}

class InventoryCountsCompanion extends UpdateCompanion<InventoryCount> {
  final Value<int> id;
  final Value<String> barcode;
  final Value<int> quantity;
  final Value<int> employeeId;
  final Value<int> branchId;
  final Value<DateTime> countDate;
  final Value<String> note;
  final Value<bool> updatedToScanner;
  final Value<DateTime?> scannerUpdateDate;
  const InventoryCountsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.countDate = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedToScanner = const Value.absent(),
    this.scannerUpdateDate = const Value.absent(),
  });
  InventoryCountsCompanion.insert({
    this.id = const Value.absent(),
    required String barcode,
    required int quantity,
    required int employeeId,
    this.branchId = const Value.absent(),
    required DateTime countDate,
    this.note = const Value.absent(),
    this.updatedToScanner = const Value.absent(),
    this.scannerUpdateDate = const Value.absent(),
  }) : barcode = Value(barcode),
       quantity = Value(quantity),
       employeeId = Value(employeeId),
       countDate = Value(countDate);
  static Insertable<InventoryCount> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<int>? quantity,
    Expression<int>? employeeId,
    Expression<int>? branchId,
    Expression<DateTime>? countDate,
    Expression<String>? note,
    Expression<bool>? updatedToScanner,
    Expression<DateTime>? scannerUpdateDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (quantity != null) 'quantity': quantity,
      if (employeeId != null) 'employee_id': employeeId,
      if (branchId != null) 'branch_id': branchId,
      if (countDate != null) 'count_date': countDate,
      if (note != null) 'note': note,
      if (updatedToScanner != null) 'updated_to_scanner': updatedToScanner,
      if (scannerUpdateDate != null) 'scanner_update_date': scannerUpdateDate,
    });
  }

  InventoryCountsCompanion copyWith({
    Value<int>? id,
    Value<String>? barcode,
    Value<int>? quantity,
    Value<int>? employeeId,
    Value<int>? branchId,
    Value<DateTime>? countDate,
    Value<String>? note,
    Value<bool>? updatedToScanner,
    Value<DateTime?>? scannerUpdateDate,
  }) {
    return InventoryCountsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      branchId: branchId ?? this.branchId,
      countDate: countDate ?? this.countDate,
      note: note ?? this.note,
      updatedToScanner: updatedToScanner ?? this.updatedToScanner,
      scannerUpdateDate: scannerUpdateDate ?? this.scannerUpdateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (countDate.present) {
      map['count_date'] = Variable<DateTime>(countDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedToScanner.present) {
      map['updated_to_scanner'] = Variable<bool>(updatedToScanner.value);
    }
    if (scannerUpdateDate.present) {
      map['scanner_update_date'] = Variable<DateTime>(scannerUpdateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCountsCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('branchId: $branchId, ')
          ..write('countDate: $countDate, ')
          ..write('note: $note, ')
          ..write('updatedToScanner: $updatedToScanner, ')
          ..write('scannerUpdateDate: $scannerUpdateDate')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeNameMeta = const VerificationMeta(
    'employeeName',
  );
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
    'employee_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchNameMeta = const VerificationMeta(
    'branchName',
  );
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
    'branch_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('LocalOnly'),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    action,
    entityType,
    entityId,
    description,
    employeeName,
    branchName,
    deviceId,
    syncStatus,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('employee_name')) {
      context.handle(
        _employeeNameMeta,
        employeeName.isAcceptableOrUnknown(
          data['employee_name']!,
          _employeeNameMeta,
        ),
      );
    }
    if (data.containsKey('branch_name')) {
      context.handle(
        _branchNameMeta,
        branchName.isAcceptableOrUnknown(data['branch_name']!, _branchNameMeta),
      );
    } else if (isInserting) {
      context.missing(_branchNameMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      employeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_name'],
      ),
      branchName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_name'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final DateTime timestamp;
  final String action;
  final String entityType;
  final int? entityId;
  final String description;
  final String? employeeName;
  final String branchName;
  final String? deviceId;
  final String syncStatus;
  final int? serverId;
  const AuditLog({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.entityType,
    this.entityId,
    required this.description,
    this.employeeName,
    required this.branchName,
    this.deviceId,
    required this.syncStatus,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || employeeName != null) {
      map['employee_name'] = Variable<String>(employeeName);
    }
    map['branch_name'] = Variable<String>(branchName);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      action: Value(action),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      description: Value(description),
      employeeName: employeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeName),
      branchName: Value(branchName),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncStatus: Value(syncStatus),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      description: serializer.fromJson<String>(json['description']),
      employeeName: serializer.fromJson<String?>(json['employeeName']),
      branchName: serializer.fromJson<String>(json['branchName']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int?>(entityId),
      'description': serializer.toJson<String>(description),
      'employeeName': serializer.toJson<String?>(employeeName),
      'branchName': serializer.toJson<String>(branchName),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  AuditLog copyWith({
    int? id,
    DateTime? timestamp,
    String? action,
    String? entityType,
    Value<int?> entityId = const Value.absent(),
    String? description,
    Value<String?> employeeName = const Value.absent(),
    String? branchName,
    Value<String?> deviceId = const Value.absent(),
    String? syncStatus,
    Value<int?> serverId = const Value.absent(),
  }) => AuditLog(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    description: description ?? this.description,
    employeeName: employeeName.present ? employeeName.value : this.employeeName,
    branchName: branchName ?? this.branchName,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      description: data.description.present
          ? data.description.value
          : this.description,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      branchName: data.branchName.present
          ? data.branchName.value
          : this.branchName,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('employeeName: $employeeName, ')
          ..write('branchName: $branchName, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    action,
    entityType,
    entityId,
    description,
    employeeName,
    branchName,
    deviceId,
    syncStatus,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.description == this.description &&
          other.employeeName == this.employeeName &&
          other.branchName == this.branchName &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.serverId == this.serverId);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> action;
  final Value<String> entityType;
  final Value<int?> entityId;
  final Value<String> description;
  final Value<String?> employeeName;
  final Value<String> branchName;
  final Value<String?> deviceId;
  final Value<String> syncStatus;
  final Value<int?> serverId;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.description = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.branchName = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    required String description,
    this.employeeName = const Value.absent(),
    required String branchName,
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverId = const Value.absent(),
  }) : timestamp = Value(timestamp),
       action = Value(action),
       entityType = Value(entityType),
       description = Value(description),
       branchName = Value(branchName);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? description,
    Expression<String>? employeeName,
    Expression<String>? branchName,
    Expression<String>? deviceId,
    Expression<String>? syncStatus,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (description != null) 'description': description,
      if (employeeName != null) 'employee_name': employeeName,
      if (branchName != null) 'branch_name': branchName,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverId != null) 'server_id': serverId,
    });
  }

  AuditLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? action,
    Value<String>? entityType,
    Value<int?>? entityId,
    Value<String>? description,
    Value<String?>? employeeName,
    Value<String>? branchName,
    Value<String?>? deviceId,
    Value<String>? syncStatus,
    Value<int?>? serverId,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      description: description ?? this.description,
      employeeName: employeeName ?? this.employeeName,
      branchName: branchName ?? this.branchName,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('employeeName: $employeeName, ')
          ..write('branchName: $branchName, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ProductImagesTable extends ProductImages
    with TableInfo<$ProductImagesTable, ProductImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, barcode, imagePath, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductImagesTable createAlias(String alias) {
    return $ProductImagesTable(attachedDatabase, alias);
  }
}

class ProductImage extends DataClass implements Insertable<ProductImage> {
  final int id;
  final String barcode;
  final String imagePath;
  final DateTime updatedAt;
  const ProductImage({
    required this.id,
    required this.barcode,
    required this.imagePath,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['barcode'] = Variable<String>(barcode);
    map['image_path'] = Variable<String>(imagePath);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductImagesCompanion toCompanion(bool nullToAbsent) {
    return ProductImagesCompanion(
      id: Value(id),
      barcode: Value(barcode),
      imagePath: Value(imagePath),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductImage(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<String>(json['barcode']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String>(barcode),
      'imagePath': serializer.toJson<String>(imagePath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductImage copyWith({
    int? id,
    String? barcode,
    String? imagePath,
    DateTime? updatedAt,
  }) => ProductImage(
    id: id ?? this.id,
    barcode: barcode ?? this.barcode,
    imagePath: imagePath ?? this.imagePath,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductImage copyWithCompanion(ProductImagesCompanion data) {
    return ProductImage(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductImage(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('imagePath: $imagePath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, barcode, imagePath, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductImage &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.imagePath == this.imagePath &&
          other.updatedAt == this.updatedAt);
}

class ProductImagesCompanion extends UpdateCompanion<ProductImage> {
  final Value<int> id;
  final Value<String> barcode;
  final Value<String> imagePath;
  final Value<DateTime> updatedAt;
  const ProductImagesCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductImagesCompanion.insert({
    this.id = const Value.absent(),
    required String barcode,
    required String imagePath,
    required DateTime updatedAt,
  }) : barcode = Value(barcode),
       imagePath = Value(imagePath),
       updatedAt = Value(updatedAt);
  static Insertable<ProductImage> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<String>? imagePath,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (imagePath != null) 'image_path': imagePath,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductImagesCompanion copyWith({
    Value<int>? id,
    Value<String>? barcode,
    Value<String>? imagePath,
    Value<DateTime>? updatedAt,
  }) {
    return ProductImagesCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      imagePath: imagePath ?? this.imagePath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductImagesCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('imagePath: $imagePath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BranchesTable branches = $BranchesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $InventoryCountsTable inventoryCounts = $InventoryCountsTable(
    this,
  );
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $ProductImagesTable productImages = $ProductImagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    branches,
    employees,
    inventoryCounts,
    auditLogs,
    productImages,
  ];
}

typedef $$BranchesTableCreateCompanionBuilder =
    BranchesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> branchCode,
      Value<bool> active,
    });
typedef $$BranchesTableUpdateCompanionBuilder =
    BranchesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> branchCode,
      Value<bool> active,
    });

final class $$BranchesTableReferences
    extends BaseReferences<_$AppDatabase, $BranchesTable, Branche> {
  $$BranchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryCountsTable, List<InventoryCount>>
  _inventoryCountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryCounts,
    aliasName: 'branches__id__inventory_counts__branch_id',
  );

  $$InventoryCountsTableProcessedTableManager get inventoryCountsRefs {
    final manager = $$InventoryCountsTableTableManager(
      $_db,
      $_db.inventoryCounts,
    ).filter((f) => f.branchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryCountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BranchesTableFilterComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryCountsRefs(
    Expression<bool> Function($$InventoryCountsTableFilterComposer f) f,
  ) {
    final $$InventoryCountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryCounts,
      getReferencedColumn: (t) => t.branchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryCountsTableFilterComposer(
            $db: $db,
            $table: $db.inventoryCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BranchesTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BranchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> inventoryCountsRefs<T extends Object>(
    Expression<T> Function($$InventoryCountsTableAnnotationComposer a) f,
  ) {
    final $$InventoryCountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryCounts,
      getReferencedColumn: (t) => t.branchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryCountsTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BranchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BranchesTable,
          Branche,
          $$BranchesTableFilterComposer,
          $$BranchesTableOrderingComposer,
          $$BranchesTableAnnotationComposer,
          $$BranchesTableCreateCompanionBuilder,
          $$BranchesTableUpdateCompanionBuilder,
          (Branche, $$BranchesTableReferences),
          Branche,
          PrefetchHooks Function({bool inventoryCountsRefs})
        > {
  $$BranchesTableTableManager(_$AppDatabase db, $BranchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> branchCode = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => BranchesCompanion(
                id: id,
                name: name,
                branchCode: branchCode,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> branchCode = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => BranchesCompanion.insert(
                id: id,
                name: name,
                branchCode: branchCode,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BranchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inventoryCountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryCountsRefs) db.inventoryCounts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryCountsRefs)
                    await $_getPrefetchedData<
                      Branche,
                      $BranchesTable,
                      InventoryCount
                    >(
                      currentTable: table,
                      referencedTable: $$BranchesTableReferences
                          ._inventoryCountsRefsTable(db),
                      managerFromTypedResult: (p0) => $$BranchesTableReferences(
                        db,
                        table,
                        p0,
                      ).inventoryCountsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.branchId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BranchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BranchesTable,
      Branche,
      $$BranchesTableFilterComposer,
      $$BranchesTableOrderingComposer,
      $$BranchesTableAnnotationComposer,
      $$BranchesTableCreateCompanionBuilder,
      $$BranchesTableUpdateCompanionBuilder,
      (Branche, $$BranchesTableReferences),
      Branche,
      PrefetchHooks Function({bool inventoryCountsRefs})
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String name,
      required int branchId,
      Value<bool> active,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> branchId,
      Value<bool> active,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryCountsTable, List<InventoryCount>>
  _inventoryCountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryCounts,
    aliasName: 'employees__id__inventory_counts__employee_id',
  );

  $$InventoryCountsTableProcessedTableManager get inventoryCountsRefs {
    final manager = $$InventoryCountsTableTableManager(
      $_db,
      $_db.inventoryCounts,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryCountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryCountsRefs(
    Expression<bool> Function($$InventoryCountsTableFilterComposer f) f,
  ) {
    final $$InventoryCountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryCounts,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryCountsTableFilterComposer(
            $db: $db,
            $table: $db.inventoryCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> inventoryCountsRefs<T extends Object>(
    Expression<T> Function($$InventoryCountsTableAnnotationComposer a) f,
  ) {
    final $$InventoryCountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryCounts,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryCountsTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({bool inventoryCountsRefs})
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> branchId = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                name: name,
                branchId: branchId,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int branchId,
                Value<bool> active = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                name: name,
                branchId: branchId,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inventoryCountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryCountsRefs) db.inventoryCounts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryCountsRefs)
                    await $_getPrefetchedData<
                      Employee,
                      $EmployeesTable,
                      InventoryCount
                    >(
                      currentTable: table,
                      referencedTable: $$EmployeesTableReferences
                          ._inventoryCountsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmployeesTableReferences(
                            db,
                            table,
                            p0,
                          ).inventoryCountsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.employeeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({bool inventoryCountsRefs})
    >;
typedef $$InventoryCountsTableCreateCompanionBuilder =
    InventoryCountsCompanion Function({
      Value<int> id,
      required String barcode,
      required int quantity,
      required int employeeId,
      Value<int> branchId,
      required DateTime countDate,
      Value<String> note,
      Value<bool> updatedToScanner,
      Value<DateTime?> scannerUpdateDate,
    });
typedef $$InventoryCountsTableUpdateCompanionBuilder =
    InventoryCountsCompanion Function({
      Value<int> id,
      Value<String> barcode,
      Value<int> quantity,
      Value<int> employeeId,
      Value<int> branchId,
      Value<DateTime> countDate,
      Value<String> note,
      Value<bool> updatedToScanner,
      Value<DateTime?> scannerUpdateDate,
    });

final class $$InventoryCountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $InventoryCountsTable, InventoryCount> {
  $$InventoryCountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias('inventory_counts__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BranchesTable _branchIdTable(_$AppDatabase db) =>
      db.branches.createAlias('inventory_counts__branch_id__branches__id');

  $$BranchesTableProcessedTableManager get branchId {
    final $_column = $_itemColumn<int>('branch_id')!;

    final manager = $$BranchesTableTableManager(
      $_db,
      $_db.branches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_branchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryCountsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryCountsTable> {
  $$InventoryCountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get countDate => $composableBuilder(
    column: $table.countDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get updatedToScanner => $composableBuilder(
    column: $table.updatedToScanner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scannerUpdateDate => $composableBuilder(
    column: $table.scannerUpdateDate,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BranchesTableFilterComposer get branchId {
    final $$BranchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.branchId,
      referencedTable: $db.branches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BranchesTableFilterComposer(
            $db: $db,
            $table: $db.branches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryCountsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryCountsTable> {
  $$InventoryCountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get countDate => $composableBuilder(
    column: $table.countDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get updatedToScanner => $composableBuilder(
    column: $table.updatedToScanner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scannerUpdateDate => $composableBuilder(
    column: $table.scannerUpdateDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BranchesTableOrderingComposer get branchId {
    final $$BranchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.branchId,
      referencedTable: $db.branches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BranchesTableOrderingComposer(
            $db: $db,
            $table: $db.branches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryCountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryCountsTable> {
  $$InventoryCountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get countDate =>
      $composableBuilder(column: $table.countDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get updatedToScanner => $composableBuilder(
    column: $table.updatedToScanner,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scannerUpdateDate => $composableBuilder(
    column: $table.scannerUpdateDate,
    builder: (column) => column,
  );

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BranchesTableAnnotationComposer get branchId {
    final $$BranchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.branchId,
      referencedTable: $db.branches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BranchesTableAnnotationComposer(
            $db: $db,
            $table: $db.branches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryCountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryCountsTable,
          InventoryCount,
          $$InventoryCountsTableFilterComposer,
          $$InventoryCountsTableOrderingComposer,
          $$InventoryCountsTableAnnotationComposer,
          $$InventoryCountsTableCreateCompanionBuilder,
          $$InventoryCountsTableUpdateCompanionBuilder,
          (InventoryCount, $$InventoryCountsTableReferences),
          InventoryCount,
          PrefetchHooks Function({bool employeeId, bool branchId})
        > {
  $$InventoryCountsTableTableManager(
    _$AppDatabase db,
    $InventoryCountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryCountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryCountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryCountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<int> branchId = const Value.absent(),
                Value<DateTime> countDate = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> updatedToScanner = const Value.absent(),
                Value<DateTime?> scannerUpdateDate = const Value.absent(),
              }) => InventoryCountsCompanion(
                id: id,
                barcode: barcode,
                quantity: quantity,
                employeeId: employeeId,
                branchId: branchId,
                countDate: countDate,
                note: note,
                updatedToScanner: updatedToScanner,
                scannerUpdateDate: scannerUpdateDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String barcode,
                required int quantity,
                required int employeeId,
                Value<int> branchId = const Value.absent(),
                required DateTime countDate,
                Value<String> note = const Value.absent(),
                Value<bool> updatedToScanner = const Value.absent(),
                Value<DateTime?> scannerUpdateDate = const Value.absent(),
              }) => InventoryCountsCompanion.insert(
                id: id,
                barcode: barcode,
                quantity: quantity,
                employeeId: employeeId,
                branchId: branchId,
                countDate: countDate,
                note: note,
                updatedToScanner: updatedToScanner,
                scannerUpdateDate: scannerUpdateDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryCountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false, branchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$InventoryCountsTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$InventoryCountsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (branchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.branchId,
                                referencedTable:
                                    $$InventoryCountsTableReferences
                                        ._branchIdTable(db),
                                referencedColumn:
                                    $$InventoryCountsTableReferences
                                        ._branchIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryCountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryCountsTable,
      InventoryCount,
      $$InventoryCountsTableFilterComposer,
      $$InventoryCountsTableOrderingComposer,
      $$InventoryCountsTableAnnotationComposer,
      $$InventoryCountsTableCreateCompanionBuilder,
      $$InventoryCountsTableUpdateCompanionBuilder,
      (InventoryCount, $$InventoryCountsTableReferences),
      InventoryCount,
      PrefetchHooks Function({bool employeeId, bool branchId})
    >;
typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required String action,
      required String entityType,
      Value<int?> entityId,
      required String description,
      Value<String?> employeeName,
      required String branchName,
      Value<String?> deviceId,
      Value<String> syncStatus,
      Value<int?> serverId,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> action,
      Value<String> entityType,
      Value<int?> entityId,
      Value<String> description,
      Value<String?> employeeName,
      Value<String> branchName,
      Value<String?> deviceId,
      Value<String> syncStatus,
      Value<int?> serverId,
    });

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$AuditLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogsTable,
          AuditLog,
          $$AuditLogsTableFilterComposer,
          $$AuditLogsTableOrderingComposer,
          $$AuditLogsTableAnnotationComposer,
          $$AuditLogsTableCreateCompanionBuilder,
          $$AuditLogsTableUpdateCompanionBuilder,
          (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
          AuditLog,
          PrefetchHooks Function()
        > {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int?> entityId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> employeeName = const Value.absent(),
                Value<String> branchName = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                timestamp: timestamp,
                action: action,
                entityType: entityType,
                entityId: entityId,
                description: description,
                employeeName: employeeName,
                branchName: branchName,
                deviceId: deviceId,
                syncStatus: syncStatus,
                serverId: serverId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required String action,
                required String entityType,
                Value<int?> entityId = const Value.absent(),
                required String description,
                Value<String?> employeeName = const Value.absent(),
                required String branchName,
                Value<String?> deviceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
              }) => AuditLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                action: action,
                entityType: entityType,
                entityId: entityId,
                description: description,
                employeeName: employeeName,
                branchName: branchName,
                deviceId: deviceId,
                syncStatus: syncStatus,
                serverId: serverId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogsTable,
      AuditLog,
      $$AuditLogsTableFilterComposer,
      $$AuditLogsTableOrderingComposer,
      $$AuditLogsTableAnnotationComposer,
      $$AuditLogsTableCreateCompanionBuilder,
      $$AuditLogsTableUpdateCompanionBuilder,
      (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
      AuditLog,
      PrefetchHooks Function()
    >;
typedef $$ProductImagesTableCreateCompanionBuilder =
    ProductImagesCompanion Function({
      Value<int> id,
      required String barcode,
      required String imagePath,
      required DateTime updatedAt,
    });
typedef $$ProductImagesTableUpdateCompanionBuilder =
    ProductImagesCompanion Function({
      Value<int> id,
      Value<String> barcode,
      Value<String> imagePath,
      Value<DateTime> updatedAt,
    });

class $$ProductImagesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductImagesTable> {
  $$ProductImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductImagesTable> {
  $$ProductImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductImagesTable> {
  $$ProductImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductImagesTable,
          ProductImage,
          $$ProductImagesTableFilterComposer,
          $$ProductImagesTableOrderingComposer,
          $$ProductImagesTableAnnotationComposer,
          $$ProductImagesTableCreateCompanionBuilder,
          $$ProductImagesTableUpdateCompanionBuilder,
          (
            ProductImage,
            BaseReferences<_$AppDatabase, $ProductImagesTable, ProductImage>,
          ),
          ProductImage,
          PrefetchHooks Function()
        > {
  $$ProductImagesTableTableManager(_$AppDatabase db, $ProductImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductImagesCompanion(
                id: id,
                barcode: barcode,
                imagePath: imagePath,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String barcode,
                required String imagePath,
                required DateTime updatedAt,
              }) => ProductImagesCompanion.insert(
                id: id,
                barcode: barcode,
                imagePath: imagePath,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductImagesTable,
      ProductImage,
      $$ProductImagesTableFilterComposer,
      $$ProductImagesTableOrderingComposer,
      $$ProductImagesTableAnnotationComposer,
      $$ProductImagesTableCreateCompanionBuilder,
      $$ProductImagesTableUpdateCompanionBuilder,
      (
        ProductImage,
        BaseReferences<_$AppDatabase, $ProductImagesTable, ProductImage>,
      ),
      ProductImage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BranchesTableTableManager get branches =>
      $$BranchesTableTableManager(_db, _db.branches);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$InventoryCountsTableTableManager get inventoryCounts =>
      $$InventoryCountsTableTableManager(_db, _db.inventoryCounts);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$ProductImagesTableTableManager get productImages =>
      $$ProductImagesTableTableManager(_db, _db.productImages);
}
