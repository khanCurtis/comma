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
  @override
  late final GeneratedColumnWithTypeConverter<SexActivity?, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SexActivity?>($DayLogsTable.$convertersexn);
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
    date,
    flow,
    mucus,
    bbt,
    bbtDisturbed,
    lhTest,
    pregnancyTest,
    sex,
    note,
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
      sex: $DayLogsTable.$convertersexn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
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
  static JsonTypeConverter2<SexActivity, String, String> $convertersex =
      const EnumNameConverter<SexActivity>(SexActivity.values);
  static JsonTypeConverter2<SexActivity?, String?, String?> $convertersexn =
      JsonTypeConverter2.asNullable($convertersex);
}

class DayLog extends DataClass implements Insertable<DayLog> {
  final DateTime date;
  final FlowLevel flow;
  final Mucus? mucus;
  final double? bbt;
  final bool bbtDisturbed;
  final TestResult? lhTest;
  final TestResult? pregnancyTest;
  final SexActivity? sex;
  final String? note;
  const DayLog({
    required this.date,
    required this.flow,
    this.mucus,
    this.bbt,
    required this.bbtDisturbed,
    this.lhTest,
    this.pregnancyTest,
    this.sex,
    this.note,
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
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>($DayLogsTable.$convertersexn.toSql(sex));
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
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
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
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
      sex: $DayLogsTable.$convertersexn.fromJson(
        serializer.fromJson<String?>(json['sex']),
      ),
      note: serializer.fromJson<String?>(json['note']),
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
      'sex': serializer.toJson<String?>(
        $DayLogsTable.$convertersexn.toJson(sex),
      ),
      'note': serializer.toJson<String?>(note),
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
    Value<SexActivity?> sex = const Value.absent(),
    Value<String?> note = const Value.absent(),
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
    sex: sex.present ? sex.value : this.sex,
    note: note.present ? note.value : this.note,
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
      sex: data.sex.present ? data.sex.value : this.sex,
      note: data.note.present ? data.note.value : this.note,
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
          ..write('sex: $sex, ')
          ..write('note: $note')
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
    sex,
    note,
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
          other.sex == this.sex &&
          other.note == this.note);
}

class DayLogsCompanion extends UpdateCompanion<DayLog> {
  final Value<DateTime> date;
  final Value<FlowLevel> flow;
  final Value<Mucus?> mucus;
  final Value<double?> bbt;
  final Value<bool> bbtDisturbed;
  final Value<TestResult?> lhTest;
  final Value<TestResult?> pregnancyTest;
  final Value<SexActivity?> sex;
  final Value<String?> note;
  final Value<int> rowid;
  const DayLogsCompanion({
    this.date = const Value.absent(),
    this.flow = const Value.absent(),
    this.mucus = const Value.absent(),
    this.bbt = const Value.absent(),
    this.bbtDisturbed = const Value.absent(),
    this.lhTest = const Value.absent(),
    this.pregnancyTest = const Value.absent(),
    this.sex = const Value.absent(),
    this.note = const Value.absent(),
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
    this.sex = const Value.absent(),
    this.note = const Value.absent(),
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
    Expression<String>? sex,
    Expression<String>? note,
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
      if (sex != null) 'sex': sex,
      if (note != null) 'note': note,
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
    Value<SexActivity?>? sex,
    Value<String?>? note,
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
      sex: sex ?? this.sex,
      note: note ?? this.note,
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
    if (sex.present) {
      map['sex'] = Variable<String>(
        $DayLogsTable.$convertersexn.toSql(sex.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
          ..write('sex: $sex, ')
          ..write('note: $note, ')
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
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dayLogs,
    symptomEntries,
    settings,
  ];
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
  Value<SexActivity?> sex,
  Value<String?> note,
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
  Value<SexActivity?> sex,
  Value<String?> note,
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

  ColumnWithTypeConverterFilters<SexActivity?, SexActivity, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  GeneratedColumnWithTypeConverter<SexActivity?, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
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
                Value<SexActivity?> sex = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion(
                date: date,
                flow: flow,
                mucus: mucus,
                bbt: bbt,
                bbtDisturbed: bbtDisturbed,
                lhTest: lhTest,
                pregnancyTest: pregnancyTest,
                sex: sex,
                note: note,
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
                Value<SexActivity?> sex = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayLogsCompanion.insert(
                date: date,
                flow: flow,
                mucus: mucus,
                bbt: bbt,
                bbtDisturbed: bbtDisturbed,
                lhTest: lhTest,
                pregnancyTest: pregnancyTest,
                sex: sex,
                note: note,
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
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
