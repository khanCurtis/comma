// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DayLogsTable extends DayLogs with TableInfo<$DayLogsTable, DayLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FlowLevel, String> flow =
      GeneratedColumn<String>(
        'flow',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(FlowLevel.none.name),
      ).withConverter<FlowLevel>($DayLogsTable.$converterflow);
  @override
  late final GeneratedColumnWithTypeConverter<Mucus?, String> mucus =
      GeneratedColumn<String>(
        'mucus',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Mucus?>($DayLogsTable.$convertermucusn);
  static const VerificationMeta _bbtMeta = const VerificationMeta('bbt');
  @override
  late final GeneratedColumn<double> bbt = GeneratedColumn<double>(
    'bbt',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bbtDisturbedMeta = const VerificationMeta(
    'bbtDisturbed',
  );
  @override
  late final GeneratedColumn<bool> bbtDisturbed = GeneratedColumn<bool>(
    'bbt_disturbed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bbt_disturbed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TestResult?, String> lhTest =
      GeneratedColumn<String>(
        'lh_test',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<TestResult?>($DayLogsTable.$converterlhTestn);
  @override
  late final GeneratedColumnWithTypeConverter<TestResult?, String>
  pregnancyTest = GeneratedColumn<String>(
    'pregnancy_test',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TestResult?>($DayLogsTable.$converterpregnancyTestn);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productsMeta = const VerificationMeta(
    'products',
  );
  @override
  late final GeneratedColumn<int> products = GeneratedColumn<int>(
    'products',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EnergyLevel?, String> energy =
      GeneratedColumn<String>(
        'energy',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EnergyLevel?>($DayLogsTable.$converterenergyn);
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    flow,
    mucus,
    bbt,
    bbtDisturbed,
    lhTest,
    pregnancyTest,
    note,
    products,
    energy,
    sleepHours,
    weightKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('bbt')) {
      context.handle(
        _bbtMeta,
        bbt.isAcceptableOrUnknown(data['bbt']!, _bbtMeta),
      );
    }
    if (data.containsKey('bbt_disturbed')) {
      context.handle(
        _bbtDisturbedMeta,
        bbtDisturbed.isAcceptableOrUnknown(
          data['bbt_disturbed']!,
          _bbtDisturbedMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('products')) {
      context.handle(
        _productsMeta,
        products.isAcceptableOrUnknown(data['products']!, _productsMeta),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DayLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayLog(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      flow: $DayLogsTable.$converterflow.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flow'],
        )!,
      ),
      mucus: $DayLogsTable.$convertermucusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mucus'],
        ),
      ),
      bbt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbt'],
      ),
      bbtDisturbed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bbt_disturbed'],
      )!,
      lhTest: $DayLogsTable.$converterlhTestn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}lh_test'],
        ),
      ),
      pregnancyTest: $DayLogsTable.$converterpregnancyTestn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pregnancy_test'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      products: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}products'],
      ),
      energy: $DayLogsTable.$converterenergyn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy'],
        ),
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
    );
  }

  @override
  $DayLogsTable createAlias(String alias) {
    return $DayLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FlowLevel, String, String> $converterflow =
      const EnumNameConverter<FlowLevel>(FlowLevel.values);
  static JsonTypeConverter2<Mucus, String, String> $convertermucus =
      const EnumNameConverter<Mucus>(Mucus.values);
  static JsonTypeConverter2<Mucus?, String?, String?> $convertermucusn =
      JsonTypeConverter2.asNullable($convertermucus);
  static JsonTypeConverter2<TestResult, String, String> $converterlhTest =
      const EnumNameConverter<TestResult>(TestResult.values);
  static JsonTypeConverter2<TestResult?, String?, String?> $converterlhTestn =
      JsonTypeConverter2.asNullable($converterlhTest);
  static JsonTypeConverter2<TestResult, String, String>
  $converterpregnancyTest = const EnumNameConverter<TestResult>(
    TestResult.values,
  );
  static JsonTypeConverter2<TestResult?, String?, String?>
  $converterpregnancyTestn = JsonTypeConverter2.asNullable(
    $converterpregnancyTest,
  );
  static JsonTypeConverter2<EnergyLevel, String, String> $converterenergy =
      const EnumNameConverter<EnergyLevel>(EnergyLevel.values);
  static JsonTypeConverter2<EnergyLevel?, String?, String?> $converterenergyn =
      JsonTypeConverter2.asNullable($converterenergy);
}

class DayLog extends DataClass implements Insertable<DayLog> {
  final DateTime date;
  final FlowLevel flow;
  final Mucus? mucus;
  final double? bbt;
  final bool bbtDisturbed;
  final TestResult? lhTest;
  final TestResult? pregnancyTest;
  final String? note;

  /// Pads, tampons, etc. used that day.
  final int? products;
  final EnergyLevel? energy;
  final double? sleepHours;

  /// Always stored in kilograms; converted for display.
  final double? weightKg;
  const DayLog({
    required this.date,
    required this.flow,
    this.mucus,
    this.bbt,
    required this.bbtDisturbed,
    this.lhTest,
    this.pregnancyTest,
    this.note,
    this.products,
    this.energy,
    this.sleepHours,
    this.weightKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    {
      map['flow'] = Variable<String>($DayLogsTable.$converterflow.toSql(flow));
    }
    if (!nullToAbsent || mucus != null) {
      map['mucus'] = Variable<String>(
        $DayLogsTable.$convertermucusn.toSql(mucus),
      );
    }
    if (!nullToAbsent || bbt != null) {
      map['bbt'] = Variable<double>(bbt);
    }
    map['bbt_disturbed'] = Variable<bool>(bbtDisturbed);
    if (!nullToAbsent || lhTest != null) {
      map['lh_test'] = Variable<String>(
        $DayLogsTable.$converterlhTestn.toSql(lhTest),
      );
    }
    if (!nullToAbsent || pregnancyTest != null) {
      map['pregnancy_test'] = Variable<String>(
        $DayLogsTable.$converterpregnancyTestn.toSql(pregnancyTest),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || products != null) {
      map['products'] = Variable<int>(products);
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<String>(
        $DayLogsTable.$converterenergyn.toSql(energy),
      );
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    return map;
  }

  DayLogsCompanion toCompanion(bool nullToAbsent) {
    return DayLogsCompanion(
      date: Value(date),
      flow: Value(flow),
      mucus: mucus == null && nullToAbsent
          ? const Value.absent()
          : Value(mucus),
      bbt: bbt == null && nullToAbsent ? const Value.absent() : Value(bbt),
      bbtDisturbed: Value(bbtDisturbed),
      lhTest: lhTest == null && nullToAbsent
          ? const Value.absent()
          : Value(lhTest),
      pregnancyTest: pregnancyTest == null && nullToAbsent
          ? const Value.absent()
          : Value(pregnancyTest),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      products: products == null && nullToAbsent
          ? const Value.absent()
          : Value(products),
      energy: energy == null && nullToAbsent
          ? const Value.absent()
          : Value(energy),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
    );
  }

  factory DayLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayLog(
      date: serializer.fromJson<DateTime>(json['date']),
      flow: $DayLogsTable.$converterflow.fromJson(
        serializer.fromJson<String>(json['flow']),
      ),
      mucus: $DayLogsTable.$convertermucusn.fromJson(
        serializer.fromJson<String?>(json['mucus']),
      ),
      bbt: serializer.fromJson<double?>(json['bbt']),
      bbtDisturbed: serializer.fromJson<bool>(json['bbtDisturbed']),
      lhTest: $DayLogsTable.$converterlhTestn.fromJson(
        serializer.fromJson<String?>(json['lhTest']),
      ),
      pregnancyTest: $DayLogsTable.$converterpregnancyTestn.fromJson(
        serializer.fromJson<String?>(json['pregnancyTest']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      products: serializer.fromJson<int?>(json['products']),
      energy: $DayLogsTable.$converterenergyn.fromJson(
        serializer.fromJson<String?>(json['energy']),
      ),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'flow': serializer.toJson<String>(
        $DayLogsTable.$converterflow.toJson(flow),
      ),
      'mucus': serializer.toJson<String?>(
        $DayLogsTable.$convertermucusn.toJson(mucus),
      ),
      'bbt': serializer.toJson<double?>(bbt),
      'bbtDisturbed': serializer.toJson<bool>(bbtDisturbed),
      'lhTest': serializer.toJson<String?>(
        $DayLogsTable.$converterlhTestn.toJson(lhTest),
      ),
      'pregnancyTest': serializer.toJson<String?>(
        $DayLogsTable.$converterpregnancyTestn.toJson(pregnancyTest),
      ),
      'note': serializer.toJson<String?>(note),
      'products': serializer.toJson<int?>(products),
      'energy': serializer.toJson<String?>(
        $DayLogsTable.$converterenergyn.toJson(energy),
      ),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'weightKg': serializer.toJson<double?>(weightKg),
    };
  }

  DayLog copyWith({
    DateTime? date,
    FlowLevel? flow,
    Value<Mucus?> mucus = const Value.absent(),
    Value<double?> bbt = const Value.absent(),
    bool? bbtDisturbed,
    Value<TestResult?> lhTest = const Value.absent(),
    Value<TestResult?> pregnancyTest = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<int?> products = const Value.absent(),
    Value<EnergyLevel?> energy = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
  }) => DayLog(
    date: date ?? this.date,
    flow: flow ?? this.flow,
    mucus: mucus.present ? mucus.value : this.mucus,
    bbt: bbt.present ? bbt.value : this.bbt,
    bbtDisturbed: bbtDisturbed ?? this.bbtDisturbed,
    lhTest: lhTest.present ? lhTest.value : this.lhTest,
    pregnancyTest: pregnancyTest.present
        ? pregnancyTest.value
        : this.pregnancyTest,
    note: note.present ? note.value : this.note,
    products: products.present ? products.value : this.products,
    energy: energy.present ? energy.value : this.energy,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
  );
  DayLog copyWithCompanion(DayLogsCompanion data) {
    return DayLog(
      date: data.date.present ? data.date.value : this.date,
      flow: data.flow.present ? data.flow.value : this.flow,
      mucus: data.mucus.present ? data.mucus.value : this.mucus,
      bbt: data.bbt.present ? data.bbt.value : this.bbt,
      bbtDisturbed: data.bbtDisturbed.present
          ? data.bbtDisturbed.value
          : this.bbtDisturbed,
      lhTest: data.lhTest.present ? data.lhTest.value : this.lhTest,
      pregnancyTest: data.pregnancyTest.present
          ? data.pregnancyTest.value
          : this.pregnancyTest,
      note: data.note.present ? data.note.value : this.note,
      products: data.products.present ? data.products.value : this.products,
      energy: data.energy.present ? data.energy.value : this.energy,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayLog(')
          ..write('date: $date, ')
          ..write('flow: $flow, ')
          ..write('mucus: $mucus, ')
          ..write('bbt: $bbt, ')
          ..write('bbtDisturbed: $bbtDisturbed, ')
          ..write('lhTest: $lhTest, ')
          ..write('pregnancyTest: $pregnancyTest, ')
          ..write('note: $note, ')
          ..write('products: $products, ')
          ..write('energy: $energy, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    flow,
    mucus,
    bbt,
    bbtDisturbed,
    lhTest,
    pregnancyTest,
    note,
    products,
    energy,
    sleepHours,
    weightKg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayLog &&
          other.date == this.date &&
          other.flow == this.flow &&
          other.mucus == this.mucus &&
          other.bbt == this.bbt &&
          other.bbtDisturbed == this.bbtDisturbed &&
          other.lhTest == this.lhTest &&
          other.pregnancyTest == this.pregnancyTest &&
          other.note == this.note &&
          other.products == this.products &&
          other.energy == this.energy &&
          other.sleepHours == this.sleepHours &&
          other.weightKg == this.weightKg);
}

class DayLogsCompanion extends UpdateCompanion<DayLog> {
  final Value<DateTime> date;
  final Value<FlowLevel> flow;
  final Value<Mucus?> mucus;
  final Value<double?> bbt;
  final Value<bool> bbtDisturbed;
  final Value<TestResult?> lhTest;
  final Value<TestResult?> pregnancyTest;
  final Value<String?> note;
  final Value<int?> products;
  final Value<EnergyLevel?> energy;
  final Value<double?> sleepHours;
  final Value<double?> weightKg;
  final Value<int> rowid;
  const DayLogsCompanion({
    this.date = const Value.absent(),
    this.flow = const Value.absent(),
    this.mucus = const Value.absent(),
    this.bbt = const Value.absent(),
    this.bbtDisturbed = const Value.absent(),
    this.lhTest = const Value.absent(),
    this.pregnancyTest = const Value.absent(),
    this.note = const Value.absent(),
    this.products = const Value.absent(),
    this.energy = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayLogsCompanion.insert({
    required DateTime date,
    this.flow = const Value.absent(),
    this.mucus = const Value.absent(),
    this.bbt = const Value.absent(),
    this.bbtDisturbed = const Value.absent(),
    this.lhTest = const Value.absent(),
    this.pregnancyTest = const Value.absent(),
    this.note = const Value.absent(),
    this.products = const Value.absent(),
    this.energy = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DayLog> custom({
    Expression<DateTime>? date,
    Expression<String>? flow,
    Expression<String>? mucus,
    Expression<double>? bbt,
    Expression<bool>? bbtDisturbed,
    Expression<String>? lhTest,
    Expression<String>? pregnancyTest,
    Expression<String>? note,
    Expression<int>? products,
    Expression<String>? energy,
    Expression<double>? sleepHours,
    Expression<double>? weightKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (flow != null) 'flow': flow,
      if (mucus != null) 'mucus': mucus,
      if (bbt != null) 'bbt': bbt,
      if (bbtDisturbed != null) 'bbt_disturbed': bbtDisturbed,
      if (lhTest != null) 'lh_test': lhTest,
      if (pregnancyTest != null) 'pregnancy_test': pregnancyTest,
      if (note != null) 'note': note,
      if (products != null) 'products': products,
      if (energy != null) 'energy': energy,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (weightKg != null) 'weight_kg': weightKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayLogsCompanion copyWith({
    Value<DateTime>? date,
    Value<FlowLevel>? flow,
    Value<Mucus?>? mucus,
    Value<double?>? bbt,
    Value<bool>? bbtDisturbed,
    Value<TestResult?>? lhTest,
    Value<TestResult?>? pregnancyTest,
    Value<String?>? note,
    Value<int?>? products,
    Value<EnergyLevel?>? energy,
    Value<double?>? sleepHours,
    Value<double?>? weightKg,
    Value<int>? rowid,
  }) {
    return DayLogsCompanion(
      date: date ?? this.date,
      flow: flow ?? this.flow,
      mucus: mucus ?? this.mucus,
      bbt: bbt ?? this.bbt,
      bbtDisturbed: bbtDisturbed ?? this.bbtDisturbed,
      lhTest: lhTest ?? this.lhTest,
      pregnancyTest: pregnancyTest ?? this.pregnancyTest,
      note: note ?? this.note,
      products: products ?? this.products,
      energy: energy ?? this.energy,
      sleepHours: sleepHours ?? this.sleepHours,
      weightKg: weightKg ?? this.weightKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (flow.present) {
      map['flow'] = Variable<String>(
        $DayLogsTable.$converterflow.toSql(flow.value),
      );
    }
    if (mucus.present) {
      map['mucus'] = Variable<String>(
        $DayLogsTable.$convertermucusn.toSql(mucus.value),
      );
    }
    if (bbt.present) {
      map['bbt'] = Variable<double>(bbt.value);
    }
    if (bbtDisturbed.present) {
      map['bbt_disturbed'] = Variable<bool>(bbtDisturbed.value);
    }
    if (lhTest.present) {
      map['lh_test'] = Variable<String>(
        $DayLogsTable.$converterlhTestn.toSql(lhTest.value),
      );
    }
    if (pregnancyTest.present) {
      map['pregnancy_test'] = Variable<String>(
        $DayLogsTable.$converterpregnancyTestn.toSql(pregnancyTest.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (products.present) {
      map['products'] = Variable<int>(products.value);
    }
    if (energy.present) {
      map['energy'] = Variable<String>(
        $DayLogsTable.$converterenergyn.toSql(energy.value),
      );
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayLogsCompanion(')
          ..write('date: $date, ')
          ..write('flow: $flow, ')
          ..write('mucus: $mucus, ')
          ..write('bbt: $bbt, ')
          ..write('bbtDisturbed: $bbtDisturbed, ')
          ..write('lhTest: $lhTest, ')
          ..write('pregnancyTest: $pregnancyTest, ')
          ..write('note: $note, ')
          ..write('products: $products, ')
          ..write('energy: $energy, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('weightKg: $weightKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomEntriesTable extends SymptomEntries
    with TableInfo<$SymptomEntriesTable, SymptomEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomMeta = const VerificationMeta(
    'symptom',
  );
  @override
  late final GeneratedColumn<String> symptom = GeneratedColumn<String>(
    'symptom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [date, symptom, severity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('symptom')) {
      context.handle(
        _symptomMeta,
        symptom.isAcceptableOrUnknown(data['symptom']!, _symptomMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, symptom};
  @override
  SymptomEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      symptom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      )!,
    );
  }

  @override
  $SymptomEntriesTable createAlias(String alias) {
    return $SymptomEntriesTable(attachedDatabase, alias);
  }
}

class SymptomEntry extends DataClass implements Insertable<SymptomEntry> {
  final DateTime date;
  final String symptom;
  final int severity;
  const SymptomEntry({
    required this.date,
    required this.symptom,
    required this.severity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['symptom'] = Variable<String>(symptom);
    map['severity'] = Variable<int>(severity);
    return map;
  }

  SymptomEntriesCompanion toCompanion(bool nullToAbsent) {
    return SymptomEntriesCompanion(
      date: Value(date),
      symptom: Value(symptom),
      severity: Value(severity),
    );
  }

  factory SymptomEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomEntry(
      date: serializer.fromJson<DateTime>(json['date']),
      symptom: serializer.fromJson<String>(json['symptom']),
      severity: serializer.fromJson<int>(json['severity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'symptom': serializer.toJson<String>(symptom),
      'severity': serializer.toJson<int>(severity),
    };
  }

  SymptomEntry copyWith({DateTime? date, String? symptom, int? severity}) =>
      SymptomEntry(
        date: date ?? this.date,
        symptom: symptom ?? this.symptom,
        severity: severity ?? this.severity,
      );
  SymptomEntry copyWithCompanion(SymptomEntriesCompanion data) {
    return SymptomEntry(
      date: data.date.present ? data.date.value : this.date,
      symptom: data.symptom.present ? data.symptom.value : this.symptom,
      severity: data.severity.present ? data.severity.value : this.severity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomEntry(')
          ..write('date: $date, ')
          ..write('symptom: $symptom, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, symptom, severity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomEntry &&
          other.date == this.date &&
          other.symptom == this.symptom &&
          other.severity == this.severity);
}

class SymptomEntriesCompanion extends UpdateCompanion<SymptomEntry> {
  final Value<DateTime> date;
  final Value<String> symptom;
  final Value<int> severity;
  final Value<int> rowid;
  const SymptomEntriesCompanion({
    this.date = const Value.absent(),
    this.symptom = const Value.absent(),
    this.severity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomEntriesCompanion.insert({
    required DateTime date,
    required String symptom,
    this.severity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       symptom = Value(symptom);
  static Insertable<SymptomEntry> custom({
    Expression<DateTime>? date,
    Expression<String>? symptom,
    Expression<int>? severity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (symptom != null) 'symptom': symptom,
      if (severity != null) 'severity': severity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomEntriesCompanion copyWith({
    Value<DateTime>? date,
    Value<String>? symptom,
    Value<int>? severity,
    Value<int>? rowid,
  }) {
    return SymptomEntriesCompanion(
      date: date ?? this.date,
      symptom: symptom ?? this.symptom,
      severity: severity ?? this.severity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (symptom.present) {
      map['symptom'] = Variable<String>(symptom.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomEntriesCompanion(')
          ..write('date: $date, ')
          ..write('symptom: $symptom, ')
          ..write('severity: $severity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SexEntriesTable extends SexEntries
    with TableInfo<$SexEntriesTable, SexEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SexEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SexKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SexKind.partnered.name),
      ).withConverter<SexKind>($SexEntriesTable.$converterkind);
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta(
    'minuteOfDay',
  );
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SexProtection?, String>
  protection = GeneratedColumn<String>(
    'protection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<SexProtection?>($SexEntriesTable.$converterprotectionn);
  static const VerificationMeta _orgasmMeta = const VerificationMeta('orgasm');
  @override
  late final GeneratedColumn<bool> orgasm = GeneratedColumn<bool>(
    'orgasm',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("orgasm" IN (0, 1))',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    kind,
    minuteOfDay,
    protection,
    orgasm,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sex_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SexEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
        _minuteOfDayMeta,
        minuteOfDay.isAcceptableOrUnknown(
          data['minute_of_day']!,
          _minuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('orgasm')) {
      context.handle(
        _orgasmMeta,
        orgasm.isAcceptableOrUnknown(data['orgasm']!, _orgasmMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SexEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SexEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kind: $SexEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      minuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute_of_day'],
      ),
      protection: $SexEntriesTable.$converterprotectionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}protection'],
        ),
      ),
      orgasm: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}orgasm'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SexEntriesTable createAlias(String alias) {
    return $SexEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SexKind, String, String> $converterkind =
      const EnumNameConverter<SexKind>(SexKind.values);
  static JsonTypeConverter2<SexProtection, String, String>
  $converterprotection = const EnumNameConverter<SexProtection>(
    SexProtection.values,
  );
  static JsonTypeConverter2<SexProtection?, String?, String?>
  $converterprotectionn = JsonTypeConverter2.asNullable($converterprotection);
}

class SexEntry extends DataClass implements Insertable<SexEntry> {
  final int id;
  final DateTime date;
  final SexKind kind;

  /// Minutes after midnight, if the user recorded a time.
  final int? minuteOfDay;

  /// Only meaningful for partnered sex.
  final SexProtection? protection;
  final bool? orgasm;
  final String? note;
  const SexEntry({
    required this.id,
    required this.date,
    required this.kind,
    this.minuteOfDay,
    this.protection,
    this.orgasm,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['kind'] = Variable<String>(
        $SexEntriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || minuteOfDay != null) {
      map['minute_of_day'] = Variable<int>(minuteOfDay);
    }
    if (!nullToAbsent || protection != null) {
      map['protection'] = Variable<String>(
        $SexEntriesTable.$converterprotectionn.toSql(protection),
      );
    }
    if (!nullToAbsent || orgasm != null) {
      map['orgasm'] = Variable<bool>(orgasm);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SexEntriesCompanion toCompanion(bool nullToAbsent) {
    return SexEntriesCompanion(
      id: Value(id),
      date: Value(date),
      kind: Value(kind),
      minuteOfDay: minuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(minuteOfDay),
      protection: protection == null && nullToAbsent
          ? const Value.absent()
          : Value(protection),
      orgasm: orgasm == null && nullToAbsent
          ? const Value.absent()
          : Value(orgasm),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SexEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SexEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      kind: $SexEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      minuteOfDay: serializer.fromJson<int?>(json['minuteOfDay']),
      protection: $SexEntriesTable.$converterprotectionn.fromJson(
        serializer.fromJson<String?>(json['protection']),
      ),
      orgasm: serializer.fromJson<bool?>(json['orgasm']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'kind': serializer.toJson<String>(
        $SexEntriesTable.$converterkind.toJson(kind),
      ),
      'minuteOfDay': serializer.toJson<int?>(minuteOfDay),
      'protection': serializer.toJson<String?>(
        $SexEntriesTable.$converterprotectionn.toJson(protection),
      ),
      'orgasm': serializer.toJson<bool?>(orgasm),
      'note': serializer.toJson<String?>(note),
    };
  }

  SexEntry copyWith({
    int? id,
    DateTime? date,
    SexKind? kind,
    Value<int?> minuteOfDay = const Value.absent(),
    Value<SexProtection?> protection = const Value.absent(),
    Value<bool?> orgasm = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SexEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    kind: kind ?? this.kind,
    minuteOfDay: minuteOfDay.present ? minuteOfDay.value : this.minuteOfDay,
    protection: protection.present ? protection.value : this.protection,
    orgasm: orgasm.present ? orgasm.value : this.orgasm,
    note: note.present ? note.value : this.note,
  );
  SexEntry copyWithCompanion(SexEntriesCompanion data) {
    return SexEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      kind: data.kind.present ? data.kind.value : this.kind,
      minuteOfDay: data.minuteOfDay.present
          ? data.minuteOfDay.value
          : this.minuteOfDay,
      protection: data.protection.present
          ? data.protection.value
          : this.protection,
      orgasm: data.orgasm.present ? data.orgasm.value : this.orgasm,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SexEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('protection: $protection, ')
          ..write('orgasm: $orgasm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, kind, minuteOfDay, protection, orgasm, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SexEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.kind == this.kind &&
          other.minuteOfDay == this.minuteOfDay &&
          other.protection == this.protection &&
          other.orgasm == this.orgasm &&
          other.note == this.note);
}

class SexEntriesCompanion extends UpdateCompanion<SexEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<SexKind> kind;
  final Value<int?> minuteOfDay;
  final Value<SexProtection?> protection;
  final Value<bool?> orgasm;
  final Value<String?> note;
  const SexEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.kind = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.protection = const Value.absent(),
    this.orgasm = const Value.absent(),
    this.note = const Value.absent(),
  });
  SexEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.kind = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.protection = const Value.absent(),
    this.orgasm = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date);
  static Insertable<SexEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? kind,
    Expression<int>? minuteOfDay,
    Expression<String>? protection,
    Expression<bool>? orgasm,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (kind != null) 'kind': kind,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (protection != null) 'protection': protection,
      if (orgasm != null) 'orgasm': orgasm,
      if (note != null) 'note': note,
    });
  }

  SexEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<SexKind>? kind,
    Value<int?>? minuteOfDay,
    Value<SexProtection?>? protection,
    Value<bool?>? orgasm,
    Value<String?>? note,
  }) {
    return SexEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      protection: protection ?? this.protection,
      orgasm: orgasm ?? this.orgasm,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SexEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (protection.present) {
      map['protection'] = Variable<String>(
        $SexEntriesTable.$converterprotectionn.toSql(protection.value),
      );
    }
    if (orgasm.present) {
      map['orgasm'] = Variable<bool>(orgasm.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SexEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('protection: $protection, ')
          ..write('orgasm: $orgasm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CustomTagsTable extends CustomTags
    with TableInfo<$CustomTagsTable, CustomTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CustomTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomTag(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $CustomTagsTable createAlias(String alias) {
    return $CustomTagsTable(attachedDatabase, alias);
  }
}

class CustomTag extends DataClass implements Insertable<CustomTag> {
  final String key;
  final String label;
  const CustomTag({required this.key, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['label'] = Variable<String>(label);
    return map;
  }

  CustomTagsCompanion toCompanion(bool nullToAbsent) {
    return CustomTagsCompanion(key: Value(key), label: Value(label));
  }

  factory CustomTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomTag(
      key: serializer.fromJson<String>(json['key']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'label': serializer.toJson<String>(label),
    };
  }

  CustomTag copyWith({String? key, String? label}) =>
      CustomTag(key: key ?? this.key, label: label ?? this.label);
  CustomTag copyWithCompanion(CustomTagsCompanion data) {
    return CustomTag(
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomTag(')
          ..write('key: $key, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomTag &&
          other.key == this.key &&
          other.label == this.label);
}

class CustomTagsCompanion extends UpdateCompanion<CustomTag> {
  final Value<String> key;
  final Value<String> label;
  final Value<int> rowid;
  const CustomTagsCompanion({
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomTagsCompanion.insert({
    required String key,
    required String label,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       label = Value(label);
  static Insertable<CustomTag> custom({
    Expression<String>? key,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomTagsCompanion copyWith({
    Value<String>? key,
    Value<String>? label,
    Value<int>? rowid,
  }) {
    return CustomTagsCompanion(
      key: key ?? this.key,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomTagsCompanion(')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isContraceptiveMeta = const VerificationMeta(
    'isContraceptive',
  );
  @override
  late final GeneratedColumn<bool> isContraceptive = GeneratedColumn<bool>(
    'is_contraceptive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_contraceptive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeDaysMeta = const VerificationMeta(
    'activeDays',
  );
  @override
  late final GeneratedColumn<int> activeDays = GeneratedColumn<int>(
    'active_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _breakDaysMeta = const VerificationMeta(
    'breakDays',
  );
  @override
  late final GeneratedColumn<int> breakDays = GeneratedColumn<int>(
    'break_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dose,
    isContraceptive,
    reminderMinute,
    startDate,
    endDate,
    activeDays,
    breakDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
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
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('is_contraceptive')) {
      context.handle(
        _isContraceptiveMeta,
        isContraceptive.isAcceptableOrUnknown(
          data['is_contraceptive']!,
          _isContraceptiveMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('active_days')) {
      context.handle(
        _activeDaysMeta,
        activeDays.isAcceptableOrUnknown(data['active_days']!, _activeDaysMeta),
      );
    }
    if (data.containsKey('break_days')) {
      context.handle(
        _breakDaysMeta,
        breakDays.isAcceptableOrUnknown(data['break_days']!, _breakDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      ),
      isContraceptive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_contraceptive'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      activeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_days'],
      )!,
      breakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_days'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final String name;
  final String? dose;
  final bool isContraceptive;

  /// Daily reminder time in minutes after midnight, or null for none.
  final int? reminderMinute;

  /// First day of taking it. With a pill pack, day 1 of the first pack.
  final DateTime startDate;

  /// Last day of taking it, or null while ongoing.
  final DateTime? endDate;

  /// Pill-pack pattern: [activeDays] on, then [breakDays] off, repeating.
  /// A [breakDays] of 0 means taken every day.
  final int activeDays;
  final int breakDays;
  const Medication({
    required this.id,
    required this.name,
    this.dose,
    required this.isContraceptive,
    this.reminderMinute,
    required this.startDate,
    this.endDate,
    required this.activeDays,
    required this.breakDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    map['is_contraceptive'] = Variable<bool>(isContraceptive);
    if (!nullToAbsent || reminderMinute != null) {
      map['reminder_minute'] = Variable<int>(reminderMinute);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['active_days'] = Variable<int>(activeDays);
    map['break_days'] = Variable<int>(breakDays);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      isContraceptive: Value(isContraceptive),
      reminderMinute: reminderMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinute),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      activeDays: Value(activeDays),
      breakDays: Value(breakDays),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String?>(json['dose']),
      isContraceptive: serializer.fromJson<bool>(json['isContraceptive']),
      reminderMinute: serializer.fromJson<int?>(json['reminderMinute']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      activeDays: serializer.fromJson<int>(json['activeDays']),
      breakDays: serializer.fromJson<int>(json['breakDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String?>(dose),
      'isContraceptive': serializer.toJson<bool>(isContraceptive),
      'reminderMinute': serializer.toJson<int?>(reminderMinute),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'activeDays': serializer.toJson<int>(activeDays),
      'breakDays': serializer.toJson<int>(breakDays),
    };
  }

  Medication copyWith({
    int? id,
    String? name,
    Value<String?> dose = const Value.absent(),
    bool? isContraceptive,
    Value<int?> reminderMinute = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    int? activeDays,
    int? breakDays,
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    dose: dose.present ? dose.value : this.dose,
    isContraceptive: isContraceptive ?? this.isContraceptive,
    reminderMinute: reminderMinute.present
        ? reminderMinute.value
        : this.reminderMinute,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    activeDays: activeDays ?? this.activeDays,
    breakDays: breakDays ?? this.breakDays,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      isContraceptive: data.isContraceptive.present
          ? data.isContraceptive.value
          : this.isContraceptive,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      activeDays: data.activeDays.present
          ? data.activeDays.value
          : this.activeDays,
      breakDays: data.breakDays.present ? data.breakDays.value : this.breakDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('isContraceptive: $isContraceptive, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('activeDays: $activeDays, ')
          ..write('breakDays: $breakDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dose,
    isContraceptive,
    reminderMinute,
    startDate,
    endDate,
    activeDays,
    breakDays,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.isContraceptive == this.isContraceptive &&
          other.reminderMinute == this.reminderMinute &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.activeDays == this.activeDays &&
          other.breakDays == this.breakDays);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> dose;
  final Value<bool> isContraceptive;
  final Value<int?> reminderMinute;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int> activeDays;
  final Value<int> breakDays;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.isContraceptive = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.activeDays = const Value.absent(),
    this.breakDays = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dose = const Value.absent(),
    this.isContraceptive = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.activeDays = const Value.absent(),
    this.breakDays = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<bool>? isContraceptive,
    Expression<int>? reminderMinute,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? activeDays,
    Expression<int>? breakDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (isContraceptive != null) 'is_contraceptive': isContraceptive,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (activeDays != null) 'active_days': activeDays,
      if (breakDays != null) 'break_days': breakDays,
    });
  }

  MedicationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? dose,
    Value<bool>? isContraceptive,
    Value<int?>? reminderMinute,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int>? activeDays,
    Value<int>? breakDays,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      isContraceptive: isContraceptive ?? this.isContraceptive,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activeDays: activeDays ?? this.activeDays,
      breakDays: breakDays ?? this.breakDays,
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
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (isContraceptive.present) {
      map['is_contraceptive'] = Variable<bool>(isContraceptive.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (activeDays.present) {
      map['active_days'] = Variable<int>(activeDays.value);
    }
    if (breakDays.present) {
      map['break_days'] = Variable<int>(breakDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('isContraceptive: $isContraceptive, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('activeDays: $activeDays, ')
          ..write('breakDays: $breakDays')
          ..write(')'))
        .toString();
  }
}

class $MedicationLogsTable extends MedicationLogs
    with TableInfo<$MedicationLogsTable, MedicationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [date, medicationId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, medicationId};
  @override
  MedicationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationLog(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
    );
  }

  @override
  $MedicationLogsTable createAlias(String alias) {
    return $MedicationLogsTable(attachedDatabase, alias);
  }
}

class MedicationLog extends DataClass implements Insertable<MedicationLog> {
  final DateTime date;
  final int medicationId;
  const MedicationLog({required this.date, required this.medicationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['medication_id'] = Variable<int>(medicationId);
    return map;
  }

  MedicationLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicationLogsCompanion(
      date: Value(date),
      medicationId: Value(medicationId),
    );
  }

  factory MedicationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationLog(
      date: serializer.fromJson<DateTime>(json['date']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'medicationId': serializer.toJson<int>(medicationId),
    };
  }

  MedicationLog copyWith({DateTime? date, int? medicationId}) => MedicationLog(
    date: date ?? this.date,
    medicationId: medicationId ?? this.medicationId,
  );
  MedicationLog copyWithCompanion(MedicationLogsCompanion data) {
    return MedicationLog(
      date: data.date.present ? data.date.value : this.date,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLog(')
          ..write('date: $date, ')
          ..write('medicationId: $medicationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, medicationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationLog &&
          other.date == this.date &&
          other.medicationId == this.medicationId);
}

class MedicationLogsCompanion extends UpdateCompanion<MedicationLog> {
  final Value<DateTime> date;
  final Value<int> medicationId;
  final Value<int> rowid;
  const MedicationLogsCompanion({
    this.date = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationLogsCompanion.insert({
    required DateTime date,
    required int medicationId,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       medicationId = Value(medicationId);
  static Insertable<MedicationLog> custom({
    Expression<DateTime>? date,
    Expression<int>? medicationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (medicationId != null) 'medication_id': medicationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationLogsCompanion copyWith({
    Value<DateTime>? date,
    Value<int>? medicationId,
    Value<int>? rowid,
  }) {
    return MedicationLogsCompanion(
      date: date ?? this.date,
      medicationId: medicationId ?? this.medicationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsCompanion(')
          ..write('date: $date, ')
          ..write('medicationId: $medicationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DayLogsTable dayLogs = $DayLogsTable(this);
  late final $SymptomEntriesTable symptomEntries = $SymptomEntriesTable(this);
  late final $SexEntriesTable sexEntries = $SexEntriesTable(this);
  late final $CustomTagsTable customTags = $CustomTagsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationLogsTable medicationLogs = $MedicationLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dayLogs,
    symptomEntries,
    sexEntries,
    customTags,
    medications,
    medicationLogs,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medication_logs', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$DayLogsTableCreateCompanionBuilder = DayLogsCompanion Function({
  required DateTime date,
  Value<FlowLevel> flow,
  Value<Mucus?> mucus,
  Value<double?> bbt,
  Value<bool> bbtDisturbed,
  Value<TestResult?> lhTest,
  Value<TestResult?> pregnancyTest,
  Value<String?> note,
  Value<int?> products,
  Value<EnergyLevel?> energy,
  Value<double?> sleepHours,
  Value<double?> weightKg,
  Value<int> rowid,
});
typedef $$DayLogsTableUpdateCompanionBuilder = DayLogsCompanion Function({
  Value<DateTime> date,
  Value<FlowLevel> flow,
  Value<Mucus?> mucus,
  Value<double?> bbt,
  Value<bool> bbtDisturbed,
  Value<TestResult?> lhTest,
  Value<TestResult?> pregnancyTest,
  Value<String?> note,
  Value<int?> products,
  Value<EnergyLevel?> energy,
  Value<double?> sleepHours,
  Value<double?> weightKg,
  Value<int> rowid,
});

class $$DayLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FlowLevel, FlowLevel, String> get flow =>
      $composableBuilder(
        column: $table.flow,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Mucus?, Mucus, String> get mucus =>
      $composableBuilder(
        column: $table.mucus,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get bbt => $composableBuilder(
    column: $table.bbt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bbtDisturbed => $composableBuilder(
    column: $table.bbtDisturbed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TestResult?, TestResult, String> get lhTest =>
      $composableBuilder(
        column: $table.lhTest,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TestResult?, TestResult, String>
  get pregnancyTest => $composableBuilder(
    column: $table.pregnancyTest,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get products => $composableBuilder(
    column: $table.products,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EnergyLevel?, EnergyLevel, String>
  get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mucus => $composableBuilder(
    column: $table.mucus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bbt => $composableBuilder(
    column: $table.bbt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bbtDisturbed => $composableBuilder(
    column: $table.bbtDisturbed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lhTest => $composableBuilder(
    column: $table.lhTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pregnancyTest => $composableBuilder(
    column: $table.pregnancyTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get products => $composableBuilder(
    column: $table.products,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayLogsTable> {
  $$DayLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FlowLevel, String> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Mucus?, String> get mucus =>
      $composableBuilder(column: $table.mucus, builder: (column) => column);

  GeneratedColumn<double> get bbt =>
      $composableBuilder(column: $table.bbt, builder: (column) => column);

  GeneratedColumn<bool> get bbtDisturbed => $composableBuilder(
    column: $table.bbtDisturbed,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TestResult?, String> get lhTest =>
      $composableBuilder(column: $table.lhTest, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TestResult?, String> get pregnancyTest =>
      $composableBuilder(
        column: $table.pregnancyTest,
        builder: (column) => column,
      );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get products =>
      $composableBuilder(column: $table.products, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EnergyLevel?, String> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);
}

class $$DayLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayLogsTable,
          DayLog,
          $$DayLogsTableFilterComposer,
          $$DayLogsTableOrderingComposer,
          $$DayLogsTableAnnotationComposer,
          $$DayLogsTableCreateCompanionBuilder,
          $$DayLogsTableUpdateCompanionBuilder,
          (DayLog, BaseReferences<_$AppDatabase, $DayLogsTable, DayLog>),
          DayLog,
          PrefetchHooks Function()
        > {
  $$DayLogsTableTableManager(_$AppDatabase db, $DayLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<FlowLevel> flow = const Value.absent(),
                Value<Mucus?> mucus = const Value.absent(),
                Value<double?> bbt = const Value.absent(),
                Value<bool> bbtDisturbed = const Value.absent(),
                Value<TestResult?> lhTest = const Value.absent(),
                Value<TestResult?> pregnancyTest = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> products = const Value.absent(),
                Value<EnergyLevel?> energy = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion(
                date: date,
                flow: flow,
                mucus: mucus,
                bbt: bbt,
                bbtDisturbed: bbtDisturbed,
                lhTest: lhTest,
                pregnancyTest: pregnancyTest,
                note: note,
                products: products,
                energy: energy,
                sleepHours: sleepHours,
                weightKg: weightKg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<FlowLevel> flow = const Value.absent(),
                Value<Mucus?> mucus = const Value.absent(),
                Value<double?> bbt = const Value.absent(),
                Value<bool> bbtDisturbed = const Value.absent(),
                Value<TestResult?> lhTest = const Value.absent(),
                Value<TestResult?> pregnancyTest = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> products = const Value.absent(),
                Value<EnergyLevel?> energy = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion.insert(
                date: date,
                flow: flow,
                mucus: mucus,
                bbt: bbt,
                bbtDisturbed: bbtDisturbed,
                lhTest: lhTest,
                pregnancyTest: pregnancyTest,
                note: note,
                products: products,
                energy: energy,
                sleepHours: sleepHours,
                weightKg: weightKg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayLogsTable, DayLog>(table),
                  BaseReferences<_$AppDatabase, $DayLogsTable, DayLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayLogsTable,
      DayLog,
      $$DayLogsTableFilterComposer,
      $$DayLogsTableOrderingComposer,
      $$DayLogsTableAnnotationComposer,
      $$DayLogsTableCreateCompanionBuilder,
      $$DayLogsTableUpdateCompanionBuilder,
      (DayLog, BaseReferences<_$AppDatabase, $DayLogsTable, DayLog>),
      DayLog,
      PrefetchHooks Function()
    >;
typedef $$SymptomEntriesTableCreateCompanionBuilder =
    SymptomEntriesCompanion Function({
      required DateTime date,
      required String symptom,
      Value<int> severity,
      Value<int> rowid,
    });
typedef $$SymptomEntriesTableUpdateCompanionBuilder =
    SymptomEntriesCompanion Function({
      Value<DateTime> date,
      Value<String> symptom,
      Value<int> severity,
      Value<int> rowid,
    });

class $$SymptomEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptom => $composableBuilder(
    column: $table.symptom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SymptomEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptom => $composableBuilder(
    column: $table.symptom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SymptomEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomEntriesTable> {
  $$SymptomEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get symptom =>
      $composableBuilder(column: $table.symptom, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);
}

class $$SymptomEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomEntriesTable,
          SymptomEntry,
          $$SymptomEntriesTableFilterComposer,
          $$SymptomEntriesTableOrderingComposer,
          $$SymptomEntriesTableAnnotationComposer,
          $$SymptomEntriesTableCreateCompanionBuilder,
          $$SymptomEntriesTableUpdateCompanionBuilder,
          (
            SymptomEntry,
            BaseReferences<_$AppDatabase, $SymptomEntriesTable, SymptomEntry>,
          ),
          SymptomEntry,
          PrefetchHooks Function()
        > {
  $$SymptomEntriesTableTableManager(
    _$AppDatabase db,
    $SymptomEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<String> symptom = const Value.absent(),
                Value<int> severity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomEntriesCompanion(
                date: date,
                symptom: symptom,
                severity: severity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required String symptom,
                Value<int> severity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomEntriesCompanion.insert(
                date: date,
                symptom: symptom,
                severity: severity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SymptomEntriesTable, SymptomEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SymptomEntriesTable,
                    SymptomEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SymptomEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomEntriesTable,
      SymptomEntry,
      $$SymptomEntriesTableFilterComposer,
      $$SymptomEntriesTableOrderingComposer,
      $$SymptomEntriesTableAnnotationComposer,
      $$SymptomEntriesTableCreateCompanionBuilder,
      $$SymptomEntriesTableUpdateCompanionBuilder,
      (
        SymptomEntry,
        BaseReferences<_$AppDatabase, $SymptomEntriesTable, SymptomEntry>,
      ),
      SymptomEntry,
      PrefetchHooks Function()
    >;
typedef $$SexEntriesTableCreateCompanionBuilder = SexEntriesCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<SexKind> kind,
  Value<int?> minuteOfDay,
  Value<SexProtection?> protection,
  Value<bool?> orgasm,
  Value<String?> note,
});
typedef $$SexEntriesTableUpdateCompanionBuilder = SexEntriesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<SexKind> kind,
  Value<int?> minuteOfDay,
  Value<SexProtection?> protection,
  Value<bool?> orgasm,
  Value<String?> note,
});

class $$SexEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SexEntriesTable> {
  $$SexEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SexKind, SexKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SexProtection?, SexProtection, String>
  get protection => $composableBuilder(
    column: $table.protection,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get orgasm => $composableBuilder(
    column: $table.orgasm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SexEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SexEntriesTable> {
  $$SexEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protection => $composableBuilder(
    column: $table.protection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get orgasm => $composableBuilder(
    column: $table.orgasm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SexEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SexEntriesTable> {
  $$SexEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SexKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SexProtection?, String> get protection =>
      $composableBuilder(
        column: $table.protection,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get orgasm =>
      $composableBuilder(column: $table.orgasm, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SexEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SexEntriesTable,
          SexEntry,
          $$SexEntriesTableFilterComposer,
          $$SexEntriesTableOrderingComposer,
          $$SexEntriesTableAnnotationComposer,
          $$SexEntriesTableCreateCompanionBuilder,
          $$SexEntriesTableUpdateCompanionBuilder,
          (SexEntry, BaseReferences<_$AppDatabase, $SexEntriesTable, SexEntry>),
          SexEntry,
          PrefetchHooks Function()
        > {
  $$SexEntriesTableTableManager(_$AppDatabase db, $SexEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SexEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SexEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SexEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<SexKind> kind = const Value.absent(),
                Value<int?> minuteOfDay = const Value.absent(),
                Value<SexProtection?> protection = const Value.absent(),
                Value<bool?> orgasm = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SexEntriesCompanion(
                id: id,
                date: date,
                kind: kind,
                minuteOfDay: minuteOfDay,
                protection: protection,
                orgasm: orgasm,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<SexKind> kind = const Value.absent(),
                Value<int?> minuteOfDay = const Value.absent(),
                Value<SexProtection?> protection = const Value.absent(),
                Value<bool?> orgasm = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SexEntriesCompanion.insert(
                id: id,
                date: date,
                kind: kind,
                minuteOfDay: minuteOfDay,
                protection: protection,
                orgasm: orgasm,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SexEntriesTable, SexEntry>(table),
                  BaseReferences<_$AppDatabase, $SexEntriesTable, SexEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SexEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SexEntriesTable,
      SexEntry,
      $$SexEntriesTableFilterComposer,
      $$SexEntriesTableOrderingComposer,
      $$SexEntriesTableAnnotationComposer,
      $$SexEntriesTableCreateCompanionBuilder,
      $$SexEntriesTableUpdateCompanionBuilder,
      (SexEntry, BaseReferences<_$AppDatabase, $SexEntriesTable, SexEntry>),
      SexEntry,
      PrefetchHooks Function()
    >;
typedef $$CustomTagsTableCreateCompanionBuilder = CustomTagsCompanion Function({
  required String key,
  required String label,
  Value<int> rowid,
});
typedef $$CustomTagsTableUpdateCompanionBuilder = CustomTagsCompanion Function({
  Value<String> key,
  Value<String> label,
  Value<int> rowid,
});

class $$CustomTagsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomTagsTable> {
  $$CustomTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomTagsTable> {
  $$CustomTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomTagsTable> {
  $$CustomTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$CustomTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomTagsTable,
          CustomTag,
          $$CustomTagsTableFilterComposer,
          $$CustomTagsTableOrderingComposer,
          $$CustomTagsTableAnnotationComposer,
          $$CustomTagsTableCreateCompanionBuilder,
          $$CustomTagsTableUpdateCompanionBuilder,
          (
            CustomTag,
            BaseReferences<_$AppDatabase, $CustomTagsTable, CustomTag>,
          ),
          CustomTag,
          PrefetchHooks Function()
        > {
  $$CustomTagsTableTableManager(_$AppDatabase db, $CustomTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CustomTagsCompanion(key: key, label: label, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String label,
                Value<int> rowid = const Value.absent(),
              }) => CustomTagsCompanion.insert(
                key: key,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomTagsTable, CustomTag>(table),
                  BaseReferences<_$AppDatabase, $CustomTagsTable, CustomTag>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomTagsTable,
      CustomTag,
      $$CustomTagsTableFilterComposer,
      $$CustomTagsTableOrderingComposer,
      $$CustomTagsTableAnnotationComposer,
      $$CustomTagsTableCreateCompanionBuilder,
      $$CustomTagsTableUpdateCompanionBuilder,
      (CustomTag, BaseReferences<_$AppDatabase, $CustomTagsTable, CustomTag>),
      CustomTag,
      PrefetchHooks Function()
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> dose,
      Value<bool> isContraceptive,
      Value<int?> reminderMinute,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<int> activeDays,
      Value<int> breakDays,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> dose,
      Value<bool> isContraceptive,
      Value<int?> reminderMinute,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int> activeDays,
      Value<int> breakDays,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationLogsTable, List<MedicationLog>>
  _medicationLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationLogs,
    aliasName: 'medications__id__medication_logs__medication_id',
  );

  $$MedicationLogsTableProcessedTableManager get medicationLogsRefs {
    final manager = $$MedicationLogsTableTableManager(
      $_db,
      $_db.medicationLogs,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
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

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isContraceptive => $composableBuilder(
    column: $table.isContraceptive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakDays => $composableBuilder(
    column: $table.breakDays,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationLogsRefs(
    Expression<bool> Function($$MedicationLogsTableFilterComposer f) f,
  ) {
    final $$MedicationLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationLogsTableFilterComposer(
            $db: $db,
            $table: $db.medicationLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
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

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isContraceptive => $composableBuilder(
    column: $table.isContraceptive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakDays => $composableBuilder(
    column: $table.breakDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
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

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<bool> get isContraceptive => $composableBuilder(
    column: $table.isContraceptive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breakDays =>
      $composableBuilder(column: $table.breakDays, builder: (column) => column);

  Expression<T> medicationLogsRefs<T extends Object>(
    Expression<T> Function($$MedicationLogsTableAnnotationComposer a) f,
  ) {
    final $$MedicationLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationLogs,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool medicationLogsRefs})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dose = const Value.absent(),
                Value<bool> isContraceptive = const Value.absent(),
                Value<int?> reminderMinute = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int> activeDays = const Value.absent(),
                Value<int> breakDays = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                dose: dose,
                isContraceptive: isContraceptive,
                reminderMinute: reminderMinute,
                startDate: startDate,
                endDate: endDate,
                activeDays: activeDays,
                breakDays: breakDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> dose = const Value.absent(),
                Value<bool> isContraceptive = const Value.absent(),
                Value<int?> reminderMinute = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<int> activeDays = const Value.absent(),
                Value<int> breakDays = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                dose: dose,
                isContraceptive: isContraceptive,
                reminderMinute: reminderMinute,
                startDate: startDate,
                endDate: endDate,
                activeDays: activeDays,
                breakDays: breakDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationLogsRefs) db.medicationLogs,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationLogsRefs)
                    await $_getPrefetchedData<
                      Medication,
                      $MedicationsTable,
                      MedicationLog
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._medicationLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicationsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool medicationLogsRefs})
    >;
typedef $$MedicationLogsTableCreateCompanionBuilder =
    MedicationLogsCompanion Function({
      required DateTime date,
      required int medicationId,
      Value<int> rowid,
    });
typedef $$MedicationLogsTableUpdateCompanionBuilder =
    MedicationLogsCompanion Function({
      Value<DateTime> date,
      Value<int> medicationId,
      Value<int> rowid,
    });

final class $$MedicationLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog> {
  $$MedicationLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_logs__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationLogsTable,
          MedicationLog,
          $$MedicationLogsTableFilterComposer,
          $$MedicationLogsTableOrderingComposer,
          $$MedicationLogsTableAnnotationComposer,
          $$MedicationLogsTableCreateCompanionBuilder,
          $$MedicationLogsTableUpdateCompanionBuilder,
          (MedicationLog, $$MedicationLogsTableReferences),
          MedicationLog,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationLogsTableTableManager(
    _$AppDatabase db,
    $MedicationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion(
                date: date,
                medicationId: medicationId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required int medicationId,
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion.insert(
                date: date,
                medicationId: medicationId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationLogsTable, MedicationLog>(table),
                  $$MedicationLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
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
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationLogsTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationLogsTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MedicationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationLogsTable,
      MedicationLog,
      $$MedicationLogsTableFilterComposer,
      $$MedicationLogsTableOrderingComposer,
      $$MedicationLogsTableAnnotationComposer,
      $$MedicationLogsTableCreateCompanionBuilder,
      $$MedicationLogsTableUpdateCompanionBuilder,
      (MedicationLog, $$MedicationLogsTableReferences),
      MedicationLog,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DayLogsTableTableManager get dayLogs =>
      $$DayLogsTableTableManager(_db, _db.dayLogs);
  $$SymptomEntriesTableTableManager get symptomEntries =>
      $$SymptomEntriesTableTableManager(_db, _db.symptomEntries);
  $$SexEntriesTableTableManager get sexEntries =>
      $$SexEntriesTableTableManager(_db, _db.sexEntries);
  $$CustomTagsTableTableManager get customTags =>
      $$CustomTagsTableTableManager(_db, _db.customTags);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(_db, _db.medicationLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
