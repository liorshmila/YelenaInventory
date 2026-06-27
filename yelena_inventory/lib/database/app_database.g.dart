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
  List<GeneratedColumn> get $columns => [id, name, active];
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
  final bool active;
  const Branche({required this.id, required this.name, required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['active'] = Variable<bool>(active);
    return map;
  }

  BranchesCompanion toCompanion(bool nullToAbsent) {
    return BranchesCompanion(
      id: Value(id),
      name: Value(name),
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
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
    };
  }

  Branche copyWith({int? id, String? name, bool? active}) => Branche(
    id: id ?? this.id,
    name: name ?? this.name,
    active: active ?? this.active,
  );
  Branche copyWithCompanion(BranchesCompanion data) {
    return Branche(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Branche(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Branche &&
          other.id == this.id &&
          other.name == this.name &&
          other.active == this.active);
}

class BranchesCompanion extends UpdateCompanion<Branche> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> active;
  const BranchesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
  });
  BranchesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.active = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Branche> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
    });
  }

  BranchesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? active,
  }) {
    return BranchesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BranchesTable branches = $BranchesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $InventoryCountsTable inventoryCounts = $InventoryCountsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    branches,
    employees,
    inventoryCounts,
  ];
}

typedef $$BranchesTableCreateCompanionBuilder =
    BranchesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> active,
    });
typedef $$BranchesTableUpdateCompanionBuilder =
    BranchesCompanion Function({
      Value<int> id,
      Value<String> name,
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
                Value<bool> active = const Value.absent(),
              }) => BranchesCompanion(id: id, name: name, active: active),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> active = const Value.absent(),
              }) =>
                  BranchesCompanion.insert(id: id, name: name, active: active),
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BranchesTableTableManager get branches =>
      $$BranchesTableTableManager(_db, _db.branches);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$InventoryCountsTableTableManager get inventoryCounts =>
      $$InventoryCountsTableTableManager(_db, _db.inventoryCounts);
}
