// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TopicsDriftTable extends TopicsDrift
    with TableInfo<$TopicsDriftTable, TopicsDriftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsDriftTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingsMeta = const VerificationMeta(
    'settings',
  );
  @override
  late final GeneratedColumn<String> settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    iconKey,
    colorHex,
    settings,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics_drift';
  @override
  VerificationContext validateIntegrity(
    Insertable<TopicsDriftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('settings')) {
      context.handle(
        _settingsMeta,
        settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta),
      );
    } else if (isInserting) {
      context.missing(_settingsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TopicsDriftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopicsDriftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      settings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TopicsDriftTable createAlias(String alias) {
    return $TopicsDriftTable(attachedDatabase, alias);
  }
}

class TopicsDriftData extends DataClass implements Insertable<TopicsDriftData> {
  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String colorHex;
  final String settings;
  final DateTime createdAt;
  const TopicsDriftData({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.colorHex,
    required this.settings,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['icon_key'] = Variable<String>(iconKey);
    map['color_hex'] = Variable<String>(colorHex);
    map['settings'] = Variable<String>(settings);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TopicsDriftCompanion toCompanion(bool nullToAbsent) {
    return TopicsDriftCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      iconKey: Value(iconKey),
      colorHex: Value(colorHex),
      settings: Value(settings),
      createdAt: Value(createdAt),
    );
  }

  factory TopicsDriftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopicsDriftData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      settings: serializer.fromJson<String>(json['settings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorHex': serializer.toJson<String>(colorHex),
      'settings': serializer.toJson<String>(settings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TopicsDriftData copyWith({
    String? id,
    String? title,
    String? description,
    String? iconKey,
    String? colorHex,
    String? settings,
    DateTime? createdAt,
  }) => TopicsDriftData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    iconKey: iconKey ?? this.iconKey,
    colorHex: colorHex ?? this.colorHex,
    settings: settings ?? this.settings,
    createdAt: createdAt ?? this.createdAt,
  );
  TopicsDriftData copyWithCompanion(TopicsDriftCompanion data) {
    return TopicsDriftData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      settings: data.settings.present ? data.settings.value : this.settings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TopicsDriftData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('settings: $settings, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    iconKey,
    colorHex,
    settings,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TopicsDriftData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.iconKey == this.iconKey &&
          other.colorHex == this.colorHex &&
          other.settings == this.settings &&
          other.createdAt == this.createdAt);
}

class TopicsDriftCompanion extends UpdateCompanion<TopicsDriftData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> iconKey;
  final Value<String> colorHex;
  final Value<String> settings;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TopicsDriftCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.settings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsDriftCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String iconKey,
    required String colorHex,
    required String settings,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       iconKey = Value(iconKey),
       colorHex = Value(colorHex),
       settings = Value(settings),
       createdAt = Value(createdAt);
  static Insertable<TopicsDriftData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? iconKey,
    Expression<String>? colorHex,
    Expression<String>? settings,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorHex != null) 'color_hex': colorHex,
      if (settings != null) 'settings': settings,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsDriftCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? iconKey,
    Value<String>? colorHex,
    Value<String>? settings,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TopicsDriftCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      colorHex: colorHex ?? this.colorHex,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsDriftCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('settings: $settings, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearnedItemsDriftTable extends LearnedItemsDrift
    with TableInfo<$LearnedItemsDriftTable, LearnedItemsDriftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnedItemsDriftTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics_drift (id)',
    ),
  );
  static const VerificationMeta _conceptTitleMeta = const VerificationMeta(
    'conceptTitle',
  );
  @override
  late final GeneratedColumn<String> conceptTitle = GeneratedColumn<String>(
    'concept_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentBodyMeta = const VerificationMeta(
    'contentBody',
  );
  @override
  late final GeneratedColumn<String> contentBody = GeneratedColumn<String>(
    'content_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnderstoodMeta = const VerificationMeta(
    'isUnderstood',
  );
  @override
  late final GeneratedColumn<bool> isUnderstood = GeneratedColumn<bool>(
    'is_understood',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_understood" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _learnedAtMeta = const VerificationMeta(
    'learnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> learnedAt = GeneratedColumn<DateTime>(
    'learned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topicId,
    conceptTitle,
    contentBody,
    isUnderstood,
    learnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learned_items_drift';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnedItemsDriftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('concept_title')) {
      context.handle(
        _conceptTitleMeta,
        conceptTitle.isAcceptableOrUnknown(
          data['concept_title']!,
          _conceptTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conceptTitleMeta);
    }
    if (data.containsKey('content_body')) {
      context.handle(
        _contentBodyMeta,
        contentBody.isAcceptableOrUnknown(
          data['content_body']!,
          _contentBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentBodyMeta);
    }
    if (data.containsKey('is_understood')) {
      context.handle(
        _isUnderstoodMeta,
        isUnderstood.isAcceptableOrUnknown(
          data['is_understood']!,
          _isUnderstoodMeta,
        ),
      );
    }
    if (data.containsKey('learned_at')) {
      context.handle(
        _learnedAtMeta,
        learnedAt.isAcceptableOrUnknown(data['learned_at']!, _learnedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearnedItemsDriftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnedItemsDriftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      conceptTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_title'],
      )!,
      contentBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_body'],
      )!,
      isUnderstood: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_understood'],
      )!,
      learnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}learned_at'],
      ),
    );
  }

  @override
  $LearnedItemsDriftTable createAlias(String alias) {
    return $LearnedItemsDriftTable(attachedDatabase, alias);
  }
}

class LearnedItemsDriftData extends DataClass
    implements Insertable<LearnedItemsDriftData> {
  final String id;
  final String topicId;
  final String conceptTitle;
  final String contentBody;
  final bool isUnderstood;
  final DateTime? learnedAt;
  const LearnedItemsDriftData({
    required this.id,
    required this.topicId,
    required this.conceptTitle,
    required this.contentBody,
    required this.isUnderstood,
    this.learnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['concept_title'] = Variable<String>(conceptTitle);
    map['content_body'] = Variable<String>(contentBody);
    map['is_understood'] = Variable<bool>(isUnderstood);
    if (!nullToAbsent || learnedAt != null) {
      map['learned_at'] = Variable<DateTime>(learnedAt);
    }
    return map;
  }

  LearnedItemsDriftCompanion toCompanion(bool nullToAbsent) {
    return LearnedItemsDriftCompanion(
      id: Value(id),
      topicId: Value(topicId),
      conceptTitle: Value(conceptTitle),
      contentBody: Value(contentBody),
      isUnderstood: Value(isUnderstood),
      learnedAt: learnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(learnedAt),
    );
  }

  factory LearnedItemsDriftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnedItemsDriftData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      conceptTitle: serializer.fromJson<String>(json['conceptTitle']),
      contentBody: serializer.fromJson<String>(json['contentBody']),
      isUnderstood: serializer.fromJson<bool>(json['isUnderstood']),
      learnedAt: serializer.fromJson<DateTime?>(json['learnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'conceptTitle': serializer.toJson<String>(conceptTitle),
      'contentBody': serializer.toJson<String>(contentBody),
      'isUnderstood': serializer.toJson<bool>(isUnderstood),
      'learnedAt': serializer.toJson<DateTime?>(learnedAt),
    };
  }

  LearnedItemsDriftData copyWith({
    String? id,
    String? topicId,
    String? conceptTitle,
    String? contentBody,
    bool? isUnderstood,
    Value<DateTime?> learnedAt = const Value.absent(),
  }) => LearnedItemsDriftData(
    id: id ?? this.id,
    topicId: topicId ?? this.topicId,
    conceptTitle: conceptTitle ?? this.conceptTitle,
    contentBody: contentBody ?? this.contentBody,
    isUnderstood: isUnderstood ?? this.isUnderstood,
    learnedAt: learnedAt.present ? learnedAt.value : this.learnedAt,
  );
  LearnedItemsDriftData copyWithCompanion(LearnedItemsDriftCompanion data) {
    return LearnedItemsDriftData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      conceptTitle: data.conceptTitle.present
          ? data.conceptTitle.value
          : this.conceptTitle,
      contentBody: data.contentBody.present
          ? data.contentBody.value
          : this.contentBody,
      isUnderstood: data.isUnderstood.present
          ? data.isUnderstood.value
          : this.isUnderstood,
      learnedAt: data.learnedAt.present ? data.learnedAt.value : this.learnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnedItemsDriftData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('conceptTitle: $conceptTitle, ')
          ..write('contentBody: $contentBody, ')
          ..write('isUnderstood: $isUnderstood, ')
          ..write('learnedAt: $learnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    topicId,
    conceptTitle,
    contentBody,
    isUnderstood,
    learnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnedItemsDriftData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.conceptTitle == this.conceptTitle &&
          other.contentBody == this.contentBody &&
          other.isUnderstood == this.isUnderstood &&
          other.learnedAt == this.learnedAt);
}

class LearnedItemsDriftCompanion
    extends UpdateCompanion<LearnedItemsDriftData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<String> conceptTitle;
  final Value<String> contentBody;
  final Value<bool> isUnderstood;
  final Value<DateTime?> learnedAt;
  final Value<int> rowid;
  const LearnedItemsDriftCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.conceptTitle = const Value.absent(),
    this.contentBody = const Value.absent(),
    this.isUnderstood = const Value.absent(),
    this.learnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnedItemsDriftCompanion.insert({
    required String id,
    required String topicId,
    required String conceptTitle,
    required String contentBody,
    this.isUnderstood = const Value.absent(),
    this.learnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       topicId = Value(topicId),
       conceptTitle = Value(conceptTitle),
       contentBody = Value(contentBody);
  static Insertable<LearnedItemsDriftData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<String>? conceptTitle,
    Expression<String>? contentBody,
    Expression<bool>? isUnderstood,
    Expression<DateTime>? learnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (conceptTitle != null) 'concept_title': conceptTitle,
      if (contentBody != null) 'content_body': contentBody,
      if (isUnderstood != null) 'is_understood': isUnderstood,
      if (learnedAt != null) 'learned_at': learnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnedItemsDriftCompanion copyWith({
    Value<String>? id,
    Value<String>? topicId,
    Value<String>? conceptTitle,
    Value<String>? contentBody,
    Value<bool>? isUnderstood,
    Value<DateTime?>? learnedAt,
    Value<int>? rowid,
  }) {
    return LearnedItemsDriftCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      conceptTitle: conceptTitle ?? this.conceptTitle,
      contentBody: contentBody ?? this.contentBody,
      isUnderstood: isUnderstood ?? this.isUnderstood,
      learnedAt: learnedAt ?? this.learnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (conceptTitle.present) {
      map['concept_title'] = Variable<String>(conceptTitle.value);
    }
    if (contentBody.present) {
      map['content_body'] = Variable<String>(contentBody.value);
    }
    if (isUnderstood.present) {
      map['is_understood'] = Variable<bool>(isUnderstood.value);
    }
    if (learnedAt.present) {
      map['learned_at'] = Variable<DateTime>(learnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnedItemsDriftCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('conceptTitle: $conceptTitle, ')
          ..write('contentBody: $contentBody, ')
          ..write('isUnderstood: $isUnderstood, ')
          ..write('learnedAt: $learnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscussionMessagesDriftTable extends DiscussionMessagesDrift
    with TableInfo<$DiscussionMessagesDriftTable, DiscussionMessagesDriftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscussionMessagesDriftTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learnedItemIdMeta = const VerificationMeta(
    'learnedItemId',
  );
  @override
  late final GeneratedColumn<String> learnedItemId = GeneratedColumn<String>(
    'learned_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES learned_items_drift (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    learnedItemId,
    role,
    content,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discussion_messages_drift';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscussionMessagesDriftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('learned_item_id')) {
      context.handle(
        _learnedItemIdMeta,
        learnedItemId.isAcceptableOrUnknown(
          data['learned_item_id']!,
          _learnedItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learnedItemIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscussionMessagesDriftData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscussionMessagesDriftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      learnedItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learned_item_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $DiscussionMessagesDriftTable createAlias(String alias) {
    return $DiscussionMessagesDriftTable(attachedDatabase, alias);
  }
}

class DiscussionMessagesDriftData extends DataClass
    implements Insertable<DiscussionMessagesDriftData> {
  final String id;
  final String learnedItemId;
  final String role;
  final String content;
  final DateTime timestamp;
  const DiscussionMessagesDriftData({
    required this.id,
    required this.learnedItemId,
    required this.role,
    required this.content,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['learned_item_id'] = Variable<String>(learnedItemId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  DiscussionMessagesDriftCompanion toCompanion(bool nullToAbsent) {
    return DiscussionMessagesDriftCompanion(
      id: Value(id),
      learnedItemId: Value(learnedItemId),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
    );
  }

  factory DiscussionMessagesDriftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscussionMessagesDriftData(
      id: serializer.fromJson<String>(json['id']),
      learnedItemId: serializer.fromJson<String>(json['learnedItemId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learnedItemId': serializer.toJson<String>(learnedItemId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  DiscussionMessagesDriftData copyWith({
    String? id,
    String? learnedItemId,
    String? role,
    String? content,
    DateTime? timestamp,
  }) => DiscussionMessagesDriftData(
    id: id ?? this.id,
    learnedItemId: learnedItemId ?? this.learnedItemId,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
  );
  DiscussionMessagesDriftData copyWithCompanion(
    DiscussionMessagesDriftCompanion data,
  ) {
    return DiscussionMessagesDriftData(
      id: data.id.present ? data.id.value : this.id,
      learnedItemId: data.learnedItemId.present
          ? data.learnedItemId.value
          : this.learnedItemId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionMessagesDriftData(')
          ..write('id: $id, ')
          ..write('learnedItemId: $learnedItemId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, learnedItemId, role, content, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscussionMessagesDriftData &&
          other.id == this.id &&
          other.learnedItemId == this.learnedItemId &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp);
}

class DiscussionMessagesDriftCompanion
    extends UpdateCompanion<DiscussionMessagesDriftData> {
  final Value<String> id;
  final Value<String> learnedItemId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const DiscussionMessagesDriftCompanion({
    this.id = const Value.absent(),
    this.learnedItemId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscussionMessagesDriftCompanion.insert({
    required String id,
    required String learnedItemId,
    required String role,
    required String content,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       learnedItemId = Value(learnedItemId),
       role = Value(role),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<DiscussionMessagesDriftData> custom({
    Expression<String>? id,
    Expression<String>? learnedItemId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learnedItemId != null) 'learned_item_id': learnedItemId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscussionMessagesDriftCompanion copyWith({
    Value<String>? id,
    Value<String>? learnedItemId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return DiscussionMessagesDriftCompanion(
      id: id ?? this.id,
      learnedItemId: learnedItemId ?? this.learnedItemId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (learnedItemId.present) {
      map['learned_item_id'] = Variable<String>(learnedItemId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscussionMessagesDriftCompanion(')
          ..write('id: $id, ')
          ..write('learnedItemId: $learnedItemId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TriviaFactsDriftTable extends TriviaFactsDrift
    with TableInfo<$TriviaFactsDriftTable, TriviaFactsDriftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriviaFactsDriftTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics_drift (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isShownMeta = const VerificationMeta(
    'isShown',
  );
  @override
  late final GeneratedColumn<bool> isShown = GeneratedColumn<bool>(
    'is_shown',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_shown" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topicId,
    content,
    isShown,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trivia_facts_drift';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriviaFactsDriftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_shown')) {
      context.handle(
        _isShownMeta,
        isShown.isAcceptableOrUnknown(data['is_shown']!, _isShownMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriviaFactsDriftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriviaFactsDriftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isShown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_shown'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TriviaFactsDriftTable createAlias(String alias) {
    return $TriviaFactsDriftTable(attachedDatabase, alias);
  }
}

class TriviaFactsDriftData extends DataClass
    implements Insertable<TriviaFactsDriftData> {
  final String id;
  final String topicId;
  final String content;
  final bool isShown;
  final DateTime createdAt;
  const TriviaFactsDriftData({
    required this.id,
    required this.topicId,
    required this.content,
    required this.isShown,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['content'] = Variable<String>(content);
    map['is_shown'] = Variable<bool>(isShown);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TriviaFactsDriftCompanion toCompanion(bool nullToAbsent) {
    return TriviaFactsDriftCompanion(
      id: Value(id),
      topicId: Value(topicId),
      content: Value(content),
      isShown: Value(isShown),
      createdAt: Value(createdAt),
    );
  }

  factory TriviaFactsDriftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriviaFactsDriftData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      content: serializer.fromJson<String>(json['content']),
      isShown: serializer.fromJson<bool>(json['isShown']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'content': serializer.toJson<String>(content),
      'isShown': serializer.toJson<bool>(isShown),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TriviaFactsDriftData copyWith({
    String? id,
    String? topicId,
    String? content,
    bool? isShown,
    DateTime? createdAt,
  }) => TriviaFactsDriftData(
    id: id ?? this.id,
    topicId: topicId ?? this.topicId,
    content: content ?? this.content,
    isShown: isShown ?? this.isShown,
    createdAt: createdAt ?? this.createdAt,
  );
  TriviaFactsDriftData copyWithCompanion(TriviaFactsDriftCompanion data) {
    return TriviaFactsDriftData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      content: data.content.present ? data.content.value : this.content,
      isShown: data.isShown.present ? data.isShown.value : this.isShown,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriviaFactsDriftData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('content: $content, ')
          ..write('isShown: $isShown, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, topicId, content, isShown, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriviaFactsDriftData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.content == this.content &&
          other.isShown == this.isShown &&
          other.createdAt == this.createdAt);
}

class TriviaFactsDriftCompanion extends UpdateCompanion<TriviaFactsDriftData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<String> content;
  final Value<bool> isShown;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TriviaFactsDriftCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.content = const Value.absent(),
    this.isShown = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TriviaFactsDriftCompanion.insert({
    required String id,
    required String topicId,
    required String content,
    this.isShown = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       topicId = Value(topicId),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<TriviaFactsDriftData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<String>? content,
    Expression<bool>? isShown,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (content != null) 'content': content,
      if (isShown != null) 'is_shown': isShown,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TriviaFactsDriftCompanion copyWith({
    Value<String>? id,
    Value<String>? topicId,
    Value<String>? content,
    Value<bool>? isShown,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TriviaFactsDriftCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      content: content ?? this.content,
      isShown: isShown ?? this.isShown,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isShown.present) {
      map['is_shown'] = Variable<bool>(isShown.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriviaFactsDriftCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('content: $content, ')
          ..write('isShown: $isShown, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TopicsDriftTable topicsDrift = $TopicsDriftTable(this);
  late final $LearnedItemsDriftTable learnedItemsDrift =
      $LearnedItemsDriftTable(this);
  late final $DiscussionMessagesDriftTable discussionMessagesDrift =
      $DiscussionMessagesDriftTable(this);
  late final $TriviaFactsDriftTable triviaFactsDrift = $TriviaFactsDriftTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    topicsDrift,
    learnedItemsDrift,
    discussionMessagesDrift,
    triviaFactsDrift,
  ];
}

typedef $$TopicsDriftTableCreateCompanionBuilder =
    TopicsDriftCompanion Function({
      required String id,
      required String title,
      required String description,
      required String iconKey,
      required String colorHex,
      required String settings,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TopicsDriftTableUpdateCompanionBuilder =
    TopicsDriftCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> iconKey,
      Value<String> colorHex,
      Value<String> settings,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TopicsDriftTableReferences
    extends BaseReferences<_$AppDatabase, $TopicsDriftTable, TopicsDriftData> {
  $$TopicsDriftTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $LearnedItemsDriftTable,
    List<LearnedItemsDriftData>
  >
  _learnedItemsDriftRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.learnedItemsDrift,
        aliasName: $_aliasNameGenerator(
          db.topicsDrift.id,
          db.learnedItemsDrift.topicId,
        ),
      );

  $$LearnedItemsDriftTableProcessedTableManager get learnedItemsDriftRefs {
    final manager = $$LearnedItemsDriftTableTableManager(
      $_db,
      $_db.learnedItemsDrift,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _learnedItemsDriftRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TriviaFactsDriftTable, List<TriviaFactsDriftData>>
  _triviaFactsDriftRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.triviaFactsDrift,
    aliasName: $_aliasNameGenerator(
      db.topicsDrift.id,
      db.triviaFactsDrift.topicId,
    ),
  );

  $$TriviaFactsDriftTableProcessedTableManager get triviaFactsDriftRefs {
    final manager = $$TriviaFactsDriftTableTableManager(
      $_db,
      $_db.triviaFactsDrift,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _triviaFactsDriftRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TopicsDriftTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsDriftTable> {
  $$TopicsDriftTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> learnedItemsDriftRefs(
    Expression<bool> Function($$LearnedItemsDriftTableFilterComposer f) f,
  ) {
    final $$LearnedItemsDriftTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learnedItemsDrift,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearnedItemsDriftTableFilterComposer(
            $db: $db,
            $table: $db.learnedItemsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> triviaFactsDriftRefs(
    Expression<bool> Function($$TriviaFactsDriftTableFilterComposer f) f,
  ) {
    final $$TriviaFactsDriftTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triviaFactsDrift,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriviaFactsDriftTableFilterComposer(
            $db: $db,
            $table: $db.triviaFactsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsDriftTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsDriftTable> {
  $$TopicsDriftTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TopicsDriftTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsDriftTable> {
  $$TopicsDriftTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> learnedItemsDriftRefs<T extends Object>(
    Expression<T> Function($$LearnedItemsDriftTableAnnotationComposer a) f,
  ) {
    final $$LearnedItemsDriftTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.learnedItemsDrift,
          getReferencedColumn: (t) => t.topicId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LearnedItemsDriftTableAnnotationComposer(
                $db: $db,
                $table: $db.learnedItemsDrift,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> triviaFactsDriftRefs<T extends Object>(
    Expression<T> Function($$TriviaFactsDriftTableAnnotationComposer a) f,
  ) {
    final $$TriviaFactsDriftTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.triviaFactsDrift,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TriviaFactsDriftTableAnnotationComposer(
            $db: $db,
            $table: $db.triviaFactsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsDriftTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsDriftTable,
          TopicsDriftData,
          $$TopicsDriftTableFilterComposer,
          $$TopicsDriftTableOrderingComposer,
          $$TopicsDriftTableAnnotationComposer,
          $$TopicsDriftTableCreateCompanionBuilder,
          $$TopicsDriftTableUpdateCompanionBuilder,
          (TopicsDriftData, $$TopicsDriftTableReferences),
          TopicsDriftData,
          PrefetchHooks Function({
            bool learnedItemsDriftRefs,
            bool triviaFactsDriftRefs,
          })
        > {
  $$TopicsDriftTableTableManager(_$AppDatabase db, $TopicsDriftTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsDriftTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsDriftTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsDriftTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsDriftCompanion(
                id: id,
                title: title,
                description: description,
                iconKey: iconKey,
                colorHex: colorHex,
                settings: settings,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String iconKey,
                required String colorHex,
                required String settings,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TopicsDriftCompanion.insert(
                id: id,
                title: title,
                description: description,
                iconKey: iconKey,
                colorHex: colorHex,
                settings: settings,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TopicsDriftTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({learnedItemsDriftRefs = false, triviaFactsDriftRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (learnedItemsDriftRefs) db.learnedItemsDrift,
                    if (triviaFactsDriftRefs) db.triviaFactsDrift,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (learnedItemsDriftRefs)
                        await $_getPrefetchedData<
                          TopicsDriftData,
                          $TopicsDriftTable,
                          LearnedItemsDriftData
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsDriftTableReferences
                              ._learnedItemsDriftRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsDriftTableReferences(
                                db,
                                table,
                                p0,
                              ).learnedItemsDriftRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (triviaFactsDriftRefs)
                        await $_getPrefetchedData<
                          TopicsDriftData,
                          $TopicsDriftTable,
                          TriviaFactsDriftData
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsDriftTableReferences
                              ._triviaFactsDriftRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsDriftTableReferences(
                                db,
                                table,
                                p0,
                              ).triviaFactsDriftRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
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

typedef $$TopicsDriftTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsDriftTable,
      TopicsDriftData,
      $$TopicsDriftTableFilterComposer,
      $$TopicsDriftTableOrderingComposer,
      $$TopicsDriftTableAnnotationComposer,
      $$TopicsDriftTableCreateCompanionBuilder,
      $$TopicsDriftTableUpdateCompanionBuilder,
      (TopicsDriftData, $$TopicsDriftTableReferences),
      TopicsDriftData,
      PrefetchHooks Function({
        bool learnedItemsDriftRefs,
        bool triviaFactsDriftRefs,
      })
    >;
typedef $$LearnedItemsDriftTableCreateCompanionBuilder =
    LearnedItemsDriftCompanion Function({
      required String id,
      required String topicId,
      required String conceptTitle,
      required String contentBody,
      Value<bool> isUnderstood,
      Value<DateTime?> learnedAt,
      Value<int> rowid,
    });
typedef $$LearnedItemsDriftTableUpdateCompanionBuilder =
    LearnedItemsDriftCompanion Function({
      Value<String> id,
      Value<String> topicId,
      Value<String> conceptTitle,
      Value<String> contentBody,
      Value<bool> isUnderstood,
      Value<DateTime?> learnedAt,
      Value<int> rowid,
    });

final class $$LearnedItemsDriftTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LearnedItemsDriftTable,
          LearnedItemsDriftData
        > {
  $$LearnedItemsDriftTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TopicsDriftTable _topicIdTable(_$AppDatabase db) =>
      db.topicsDrift.createAlias(
        $_aliasNameGenerator(db.learnedItemsDrift.topicId, db.topicsDrift.id),
      );

  $$TopicsDriftTableProcessedTableManager get topicId {
    final $_column = $_itemColumn<String>('topic_id')!;

    final manager = $$TopicsDriftTableTableManager(
      $_db,
      $_db.topicsDrift,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DiscussionMessagesDriftTable,
    List<DiscussionMessagesDriftData>
  >
  _discussionMessagesDriftRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.discussionMessagesDrift,
        aliasName: $_aliasNameGenerator(
          db.learnedItemsDrift.id,
          db.discussionMessagesDrift.learnedItemId,
        ),
      );

  $$DiscussionMessagesDriftTableProcessedTableManager
  get discussionMessagesDriftRefs {
    final manager = $$DiscussionMessagesDriftTableTableManager(
      $_db,
      $_db.discussionMessagesDrift,
    ).filter((f) => f.learnedItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _discussionMessagesDriftRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LearnedItemsDriftTableFilterComposer
    extends Composer<_$AppDatabase, $LearnedItemsDriftTable> {
  $$LearnedItemsDriftTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptTitle => $composableBuilder(
    column: $table.conceptTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentBody => $composableBuilder(
    column: $table.contentBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnderstood => $composableBuilder(
    column: $table.isUnderstood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get learnedAt => $composableBuilder(
    column: $table.learnedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsDriftTableFilterComposer get topicId {
    final $$TopicsDriftTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableFilterComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> discussionMessagesDriftRefs(
    Expression<bool> Function($$DiscussionMessagesDriftTableFilterComposer f) f,
  ) {
    final $$DiscussionMessagesDriftTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.discussionMessagesDrift,
          getReferencedColumn: (t) => t.learnedItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiscussionMessagesDriftTableFilterComposer(
                $db: $db,
                $table: $db.discussionMessagesDrift,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LearnedItemsDriftTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnedItemsDriftTable> {
  $$LearnedItemsDriftTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptTitle => $composableBuilder(
    column: $table.conceptTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentBody => $composableBuilder(
    column: $table.contentBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnderstood => $composableBuilder(
    column: $table.isUnderstood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get learnedAt => $composableBuilder(
    column: $table.learnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsDriftTableOrderingComposer get topicId {
    final $$TopicsDriftTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableOrderingComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearnedItemsDriftTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnedItemsDriftTable> {
  $$LearnedItemsDriftTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conceptTitle => $composableBuilder(
    column: $table.conceptTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentBody => $composableBuilder(
    column: $table.contentBody,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUnderstood => $composableBuilder(
    column: $table.isUnderstood,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get learnedAt =>
      $composableBuilder(column: $table.learnedAt, builder: (column) => column);

  $$TopicsDriftTableAnnotationComposer get topicId {
    final $$TopicsDriftTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableAnnotationComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> discussionMessagesDriftRefs<T extends Object>(
    Expression<T> Function($$DiscussionMessagesDriftTableAnnotationComposer a)
    f,
  ) {
    final $$DiscussionMessagesDriftTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.discussionMessagesDrift,
          getReferencedColumn: (t) => t.learnedItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiscussionMessagesDriftTableAnnotationComposer(
                $db: $db,
                $table: $db.discussionMessagesDrift,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LearnedItemsDriftTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnedItemsDriftTable,
          LearnedItemsDriftData,
          $$LearnedItemsDriftTableFilterComposer,
          $$LearnedItemsDriftTableOrderingComposer,
          $$LearnedItemsDriftTableAnnotationComposer,
          $$LearnedItemsDriftTableCreateCompanionBuilder,
          $$LearnedItemsDriftTableUpdateCompanionBuilder,
          (LearnedItemsDriftData, $$LearnedItemsDriftTableReferences),
          LearnedItemsDriftData,
          PrefetchHooks Function({
            bool topicId,
            bool discussionMessagesDriftRefs,
          })
        > {
  $$LearnedItemsDriftTableTableManager(
    _$AppDatabase db,
    $LearnedItemsDriftTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnedItemsDriftTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnedItemsDriftTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnedItemsDriftTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> conceptTitle = const Value.absent(),
                Value<String> contentBody = const Value.absent(),
                Value<bool> isUnderstood = const Value.absent(),
                Value<DateTime?> learnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnedItemsDriftCompanion(
                id: id,
                topicId: topicId,
                conceptTitle: conceptTitle,
                contentBody: contentBody,
                isUnderstood: isUnderstood,
                learnedAt: learnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String topicId,
                required String conceptTitle,
                required String contentBody,
                Value<bool> isUnderstood = const Value.absent(),
                Value<DateTime?> learnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnedItemsDriftCompanion.insert(
                id: id,
                topicId: topicId,
                conceptTitle: conceptTitle,
                contentBody: contentBody,
                isUnderstood: isUnderstood,
                learnedAt: learnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LearnedItemsDriftTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({topicId = false, discussionMessagesDriftRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (discussionMessagesDriftRefs) db.discussionMessagesDrift,
                  ],
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
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable:
                                        $$LearnedItemsDriftTableReferences
                                            ._topicIdTable(db),
                                    referencedColumn:
                                        $$LearnedItemsDriftTableReferences
                                            ._topicIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (discussionMessagesDriftRefs)
                        await $_getPrefetchedData<
                          LearnedItemsDriftData,
                          $LearnedItemsDriftTable,
                          DiscussionMessagesDriftData
                        >(
                          currentTable: table,
                          referencedTable: $$LearnedItemsDriftTableReferences
                              ._discussionMessagesDriftRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LearnedItemsDriftTableReferences(
                                db,
                                table,
                                p0,
                              ).discussionMessagesDriftRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.learnedItemId == item.id,
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

typedef $$LearnedItemsDriftTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnedItemsDriftTable,
      LearnedItemsDriftData,
      $$LearnedItemsDriftTableFilterComposer,
      $$LearnedItemsDriftTableOrderingComposer,
      $$LearnedItemsDriftTableAnnotationComposer,
      $$LearnedItemsDriftTableCreateCompanionBuilder,
      $$LearnedItemsDriftTableUpdateCompanionBuilder,
      (LearnedItemsDriftData, $$LearnedItemsDriftTableReferences),
      LearnedItemsDriftData,
      PrefetchHooks Function({bool topicId, bool discussionMessagesDriftRefs})
    >;
typedef $$DiscussionMessagesDriftTableCreateCompanionBuilder =
    DiscussionMessagesDriftCompanion Function({
      required String id,
      required String learnedItemId,
      required String role,
      required String content,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$DiscussionMessagesDriftTableUpdateCompanionBuilder =
    DiscussionMessagesDriftCompanion Function({
      Value<String> id,
      Value<String> learnedItemId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

final class $$DiscussionMessagesDriftTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DiscussionMessagesDriftTable,
          DiscussionMessagesDriftData
        > {
  $$DiscussionMessagesDriftTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LearnedItemsDriftTable _learnedItemIdTable(_$AppDatabase db) =>
      db.learnedItemsDrift.createAlias(
        $_aliasNameGenerator(
          db.discussionMessagesDrift.learnedItemId,
          db.learnedItemsDrift.id,
        ),
      );

  $$LearnedItemsDriftTableProcessedTableManager get learnedItemId {
    final $_column = $_itemColumn<String>('learned_item_id')!;

    final manager = $$LearnedItemsDriftTableTableManager(
      $_db,
      $_db.learnedItemsDrift,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_learnedItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiscussionMessagesDriftTableFilterComposer
    extends Composer<_$AppDatabase, $DiscussionMessagesDriftTable> {
  $$DiscussionMessagesDriftTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$LearnedItemsDriftTableFilterComposer get learnedItemId {
    final $$LearnedItemsDriftTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.learnedItemId,
      referencedTable: $db.learnedItemsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearnedItemsDriftTableFilterComposer(
            $db: $db,
            $table: $db.learnedItemsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiscussionMessagesDriftTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscussionMessagesDriftTable> {
  $$DiscussionMessagesDriftTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$LearnedItemsDriftTableOrderingComposer get learnedItemId {
    final $$LearnedItemsDriftTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.learnedItemId,
      referencedTable: $db.learnedItemsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearnedItemsDriftTableOrderingComposer(
            $db: $db,
            $table: $db.learnedItemsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiscussionMessagesDriftTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscussionMessagesDriftTable> {
  $$DiscussionMessagesDriftTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$LearnedItemsDriftTableAnnotationComposer get learnedItemId {
    final $$LearnedItemsDriftTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.learnedItemId,
          referencedTable: $db.learnedItemsDrift,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LearnedItemsDriftTableAnnotationComposer(
                $db: $db,
                $table: $db.learnedItemsDrift,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DiscussionMessagesDriftTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiscussionMessagesDriftTable,
          DiscussionMessagesDriftData,
          $$DiscussionMessagesDriftTableFilterComposer,
          $$DiscussionMessagesDriftTableOrderingComposer,
          $$DiscussionMessagesDriftTableAnnotationComposer,
          $$DiscussionMessagesDriftTableCreateCompanionBuilder,
          $$DiscussionMessagesDriftTableUpdateCompanionBuilder,
          (
            DiscussionMessagesDriftData,
            $$DiscussionMessagesDriftTableReferences,
          ),
          DiscussionMessagesDriftData,
          PrefetchHooks Function({bool learnedItemId})
        > {
  $$DiscussionMessagesDriftTableTableManager(
    _$AppDatabase db,
    $DiscussionMessagesDriftTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscussionMessagesDriftTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DiscussionMessagesDriftTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DiscussionMessagesDriftTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> learnedItemId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscussionMessagesDriftCompanion(
                id: id,
                learnedItemId: learnedItemId,
                role: role,
                content: content,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String learnedItemId,
                required String role,
                required String content,
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => DiscussionMessagesDriftCompanion.insert(
                id: id,
                learnedItemId: learnedItemId,
                role: role,
                content: content,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiscussionMessagesDriftTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({learnedItemId = false}) {
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
                    if (learnedItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.learnedItemId,
                                referencedTable:
                                    $$DiscussionMessagesDriftTableReferences
                                        ._learnedItemIdTable(db),
                                referencedColumn:
                                    $$DiscussionMessagesDriftTableReferences
                                        ._learnedItemIdTable(db)
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

typedef $$DiscussionMessagesDriftTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiscussionMessagesDriftTable,
      DiscussionMessagesDriftData,
      $$DiscussionMessagesDriftTableFilterComposer,
      $$DiscussionMessagesDriftTableOrderingComposer,
      $$DiscussionMessagesDriftTableAnnotationComposer,
      $$DiscussionMessagesDriftTableCreateCompanionBuilder,
      $$DiscussionMessagesDriftTableUpdateCompanionBuilder,
      (DiscussionMessagesDriftData, $$DiscussionMessagesDriftTableReferences),
      DiscussionMessagesDriftData,
      PrefetchHooks Function({bool learnedItemId})
    >;
typedef $$TriviaFactsDriftTableCreateCompanionBuilder =
    TriviaFactsDriftCompanion Function({
      required String id,
      required String topicId,
      required String content,
      Value<bool> isShown,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TriviaFactsDriftTableUpdateCompanionBuilder =
    TriviaFactsDriftCompanion Function({
      Value<String> id,
      Value<String> topicId,
      Value<String> content,
      Value<bool> isShown,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TriviaFactsDriftTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TriviaFactsDriftTable,
          TriviaFactsDriftData
        > {
  $$TriviaFactsDriftTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TopicsDriftTable _topicIdTable(_$AppDatabase db) =>
      db.topicsDrift.createAlias(
        $_aliasNameGenerator(db.triviaFactsDrift.topicId, db.topicsDrift.id),
      );

  $$TopicsDriftTableProcessedTableManager get topicId {
    final $_column = $_itemColumn<String>('topic_id')!;

    final manager = $$TopicsDriftTableTableManager(
      $_db,
      $_db.topicsDrift,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TriviaFactsDriftTableFilterComposer
    extends Composer<_$AppDatabase, $TriviaFactsDriftTable> {
  $$TriviaFactsDriftTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isShown => $composableBuilder(
    column: $table.isShown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsDriftTableFilterComposer get topicId {
    final $$TopicsDriftTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableFilterComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriviaFactsDriftTableOrderingComposer
    extends Composer<_$AppDatabase, $TriviaFactsDriftTable> {
  $$TriviaFactsDriftTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isShown => $composableBuilder(
    column: $table.isShown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsDriftTableOrderingComposer get topicId {
    final $$TopicsDriftTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableOrderingComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriviaFactsDriftTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriviaFactsDriftTable> {
  $$TriviaFactsDriftTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isShown =>
      $composableBuilder(column: $table.isShown, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TopicsDriftTableAnnotationComposer get topicId {
    final $$TopicsDriftTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topicsDrift,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsDriftTableAnnotationComposer(
            $db: $db,
            $table: $db.topicsDrift,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TriviaFactsDriftTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriviaFactsDriftTable,
          TriviaFactsDriftData,
          $$TriviaFactsDriftTableFilterComposer,
          $$TriviaFactsDriftTableOrderingComposer,
          $$TriviaFactsDriftTableAnnotationComposer,
          $$TriviaFactsDriftTableCreateCompanionBuilder,
          $$TriviaFactsDriftTableUpdateCompanionBuilder,
          (TriviaFactsDriftData, $$TriviaFactsDriftTableReferences),
          TriviaFactsDriftData,
          PrefetchHooks Function({bool topicId})
        > {
  $$TriviaFactsDriftTableTableManager(
    _$AppDatabase db,
    $TriviaFactsDriftTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriviaFactsDriftTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriviaFactsDriftTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriviaFactsDriftTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isShown = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriviaFactsDriftCompanion(
                id: id,
                topicId: topicId,
                content: content,
                isShown: isShown,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String topicId,
                required String content,
                Value<bool> isShown = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TriviaFactsDriftCompanion.insert(
                id: id,
                topicId: topicId,
                content: content,
                isShown: isShown,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TriviaFactsDriftTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({topicId = false}) {
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
                    if (topicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.topicId,
                                referencedTable:
                                    $$TriviaFactsDriftTableReferences
                                        ._topicIdTable(db),
                                referencedColumn:
                                    $$TriviaFactsDriftTableReferences
                                        ._topicIdTable(db)
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

typedef $$TriviaFactsDriftTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriviaFactsDriftTable,
      TriviaFactsDriftData,
      $$TriviaFactsDriftTableFilterComposer,
      $$TriviaFactsDriftTableOrderingComposer,
      $$TriviaFactsDriftTableAnnotationComposer,
      $$TriviaFactsDriftTableCreateCompanionBuilder,
      $$TriviaFactsDriftTableUpdateCompanionBuilder,
      (TriviaFactsDriftData, $$TriviaFactsDriftTableReferences),
      TriviaFactsDriftData,
      PrefetchHooks Function({bool topicId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TopicsDriftTableTableManager get topicsDrift =>
      $$TopicsDriftTableTableManager(_db, _db.topicsDrift);
  $$LearnedItemsDriftTableTableManager get learnedItemsDrift =>
      $$LearnedItemsDriftTableTableManager(_db, _db.learnedItemsDrift);
  $$DiscussionMessagesDriftTableTableManager get discussionMessagesDrift =>
      $$DiscussionMessagesDriftTableTableManager(
        _db,
        _db.discussionMessagesDrift,
      );
  $$TriviaFactsDriftTableTableManager get triviaFactsDrift =>
      $$TriviaFactsDriftTableTableManager(_db, _db.triviaFactsDrift);
}
