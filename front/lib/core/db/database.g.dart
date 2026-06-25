// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        deleted,
        dirty,
        deletedAt,
        updatedAt,
        createdAt,
        serverUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(Insertable<NotesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final String id;
  final String? title;
  final String? content;
  final bool deleted;
  final bool dirty;
  final DateTime? deletedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? serverUpdatedAt;
  const NotesTableData(
      {required this.id,
      this.title,
      this.content,
      required this.deleted,
      required this.dirty,
      this.deletedAt,
      required this.updatedAt,
      required this.createdAt,
      this.serverUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      deleted: Value(deleted),
      dirty: Value(dirty),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
    );
  }

  factory NotesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String?>(content),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
    };
  }

  NotesTableData copyWith(
          {String? id,
          Value<String?> title = const Value.absent(),
          Value<String?> content = const Value.absent(),
          bool? deleted,
          bool? dirty,
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? updatedAt,
          DateTime? createdAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent()}) =>
      NotesTableData(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        content: content.present ? content.value : this.content,
        deleted: deleted ?? this.deleted,
        dirty: dirty ?? this.dirty,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
      );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, deleted, dirty, deletedAt,
      updatedAt, createdAt, serverUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> content;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime updatedAt,
    required DateTime createdAt,
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        updatedAt = Value(updatedAt),
        createdAt = Value(createdAt);
  static Insertable<NotesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? title,
      Value<String?>? content,
      Value<bool>? deleted,
      Value<bool>? dirty,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? rowid}) {
    return NotesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
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
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remindAtMeta =
      const VerificationMeta('remindAt');
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
      'remind_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _repeatRuleMeta =
      const VerificationMeta('repeatRule');
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
      'repeat_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        noteId,
        remindAt,
        isDone,
        deleted,
        dirty,
        repeatRule,
        updatedAt,
        createdAt,
        serverUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders_table';
  @override
  VerificationContext validateIntegrity(Insertable<RemindersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    }
    if (data.containsKey('remind_at')) {
      context.handle(_remindAtMeta,
          remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta));
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
          _repeatRuleMeta,
          repeatRule.isAcceptableOrUnknown(
              data['repeat_rule']!, _repeatRuleMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id']),
      remindAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}remind_at'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      repeatRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_rule']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final String id;
  final String? noteId;
  final DateTime remindAt;
  final bool isDone;
  final bool deleted;
  final bool dirty;
  final String? repeatRule;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? serverUpdatedAt;
  const RemindersTableData(
      {required this.id,
      this.noteId,
      required this.remindAt,
      required this.isDone,
      required this.deleted,
      required this.dirty,
      this.repeatRule,
      required this.updatedAt,
      required this.createdAt,
      this.serverUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || noteId != null) {
      map['note_id'] = Variable<String>(noteId);
    }
    map['remind_at'] = Variable<DateTime>(remindAt);
    map['is_done'] = Variable<bool>(isDone);
    map['deleted'] = Variable<bool>(deleted);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || repeatRule != null) {
      map['repeat_rule'] = Variable<String>(repeatRule);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      noteId:
          noteId == null && nullToAbsent ? const Value.absent() : Value(noteId),
      remindAt: Value(remindAt),
      isDone: Value(isDone),
      deleted: Value(deleted),
      dirty: Value(dirty),
      repeatRule: repeatRule == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatRule),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
    );
  }

  factory RemindersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<String>(json['id']),
      noteId: serializer.fromJson<String?>(json['noteId']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      repeatRule: serializer.fromJson<String?>(json['repeatRule']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'noteId': serializer.toJson<String?>(noteId),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'isDone': serializer.toJson<bool>(isDone),
      'deleted': serializer.toJson<bool>(deleted),
      'dirty': serializer.toJson<bool>(dirty),
      'repeatRule': serializer.toJson<String?>(repeatRule),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
    };
  }

  RemindersTableData copyWith(
          {String? id,
          Value<String?> noteId = const Value.absent(),
          DateTime? remindAt,
          bool? isDone,
          bool? deleted,
          bool? dirty,
          Value<String?> repeatRule = const Value.absent(),
          DateTime? updatedAt,
          DateTime? createdAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent()}) =>
      RemindersTableData(
        id: id ?? this.id,
        noteId: noteId.present ? noteId.value : this.noteId,
        remindAt: remindAt ?? this.remindAt,
        isDone: isDone ?? this.isDone,
        deleted: deleted ?? this.deleted,
        dirty: dirty ?? this.dirty,
        repeatRule: repeatRule.present ? repeatRule.value : this.repeatRule,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
      );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      repeatRule:
          data.repeatRule.present ? data.repeatRule.value : this.repeatRule,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('remindAt: $remindAt, ')
          ..write('isDone: $isDone, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, remindAt, isDone, deleted, dirty,
      repeatRule, updatedAt, createdAt, serverUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.remindAt == this.remindAt &&
          other.isDone == this.isDone &&
          other.deleted == this.deleted &&
          other.dirty == this.dirty &&
          other.repeatRule == this.repeatRule &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<String> id;
  final Value<String?> noteId;
  final Value<DateTime> remindAt;
  final Value<bool> isDone;
  final Value<bool> deleted;
  final Value<bool> dirty;
  final Value<String?> repeatRule;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> rowid;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.isDone = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    required String id,
    this.noteId = const Value.absent(),
    required DateTime remindAt,
    this.isDone = const Value.absent(),
    this.deleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.repeatRule = const Value.absent(),
    required DateTime updatedAt,
    required DateTime createdAt,
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        remindAt = Value(remindAt),
        updatedAt = Value(updatedAt),
        createdAt = Value(createdAt);
  static Insertable<RemindersTableData> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<DateTime>? remindAt,
    Expression<bool>? isDone,
    Expression<bool>? deleted,
    Expression<bool>? dirty,
    Expression<String>? repeatRule,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (remindAt != null) 'remind_at': remindAt,
      if (isDone != null) 'is_done': isDone,
      if (deleted != null) 'deleted': deleted,
      if (dirty != null) 'dirty': dirty,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? noteId,
      Value<DateTime>? remindAt,
      Value<bool>? isDone,
      Value<bool>? deleted,
      Value<bool>? dirty,
      Value<String?>? repeatRule,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? rowid}) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      remindAt: remindAt ?? this.remindAt,
      isDone: isDone ?? this.isDone,
      deleted: deleted ?? this.deleted,
      dirty: dirty ?? this.dirty,
      repeatRule: repeatRule ?? this.repeatRule,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('remindAt: $remindAt, ')
          ..write('isDone: $isDone, ')
          ..write('deleted: $deleted, ')
          ..write('dirty: $dirty, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteLinksTableTable extends NoteLinksTable
    with TableInfo<$NoteLinksTableTable, NoteLinksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteLinksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
      'from_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
      'to_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
      'dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [fromId, toId, weight, dirty, updatedAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_links_table';
  @override
  VerificationContext validateIntegrity(Insertable<NoteLinksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_id')) {
      context.handle(_fromIdMeta,
          fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta));
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
          _toIdMeta, toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta));
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('dirty')) {
      context.handle(
          _dirtyMeta, dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fromId, toId};
  @override
  NoteLinksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteLinksTableData(
      fromId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_id'])!,
      toId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_id'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      dirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dirty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NoteLinksTableTable createAlias(String alias) {
    return $NoteLinksTableTable(attachedDatabase, alias);
  }
}

class NoteLinksTableData extends DataClass
    implements Insertable<NoteLinksTableData> {
  final String fromId;
  final String toId;
  final int weight;
  final bool dirty;
  final DateTime? updatedAt;
  final DateTime createdAt;
  const NoteLinksTableData(
      {required this.fromId,
      required this.toId,
      required this.weight,
      required this.dirty,
      this.updatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_id'] = Variable<String>(fromId);
    map['to_id'] = Variable<String>(toId);
    map['weight'] = Variable<int>(weight);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NoteLinksTableCompanion toCompanion(bool nullToAbsent) {
    return NoteLinksTableCompanion(
      fromId: Value(fromId),
      toId: Value(toId),
      weight: Value(weight),
      dirty: Value(dirty),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory NoteLinksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteLinksTableData(
      fromId: serializer.fromJson<String>(json['fromId']),
      toId: serializer.fromJson<String>(json['toId']),
      weight: serializer.fromJson<int>(json['weight']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromId': serializer.toJson<String>(fromId),
      'toId': serializer.toJson<String>(toId),
      'weight': serializer.toJson<int>(weight),
      'dirty': serializer.toJson<bool>(dirty),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NoteLinksTableData copyWith(
          {String? fromId,
          String? toId,
          int? weight,
          bool? dirty,
          Value<DateTime?> updatedAt = const Value.absent(),
          DateTime? createdAt}) =>
      NoteLinksTableData(
        fromId: fromId ?? this.fromId,
        toId: toId ?? this.toId,
        weight: weight ?? this.weight,
        dirty: dirty ?? this.dirty,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  NoteLinksTableData copyWithCompanion(NoteLinksTableCompanion data) {
    return NoteLinksTableData(
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      toId: data.toId.present ? data.toId.value : this.toId,
      weight: data.weight.present ? data.weight.value : this.weight,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteLinksTableData(')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('weight: $weight, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(fromId, toId, weight, dirty, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteLinksTableData &&
          other.fromId == this.fromId &&
          other.toId == this.toId &&
          other.weight == this.weight &&
          other.dirty == this.dirty &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class NoteLinksTableCompanion extends UpdateCompanion<NoteLinksTableData> {
  final Value<String> fromId;
  final Value<String> toId;
  final Value<int> weight;
  final Value<bool> dirty;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NoteLinksTableCompanion({
    this.fromId = const Value.absent(),
    this.toId = const Value.absent(),
    this.weight = const Value.absent(),
    this.dirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteLinksTableCompanion.insert({
    required String fromId,
    required String toId,
    this.weight = const Value.absent(),
    this.dirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : fromId = Value(fromId),
        toId = Value(toId),
        createdAt = Value(createdAt);
  static Insertable<NoteLinksTableData> custom({
    Expression<String>? fromId,
    Expression<String>? toId,
    Expression<int>? weight,
    Expression<bool>? dirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromId != null) 'from_id': fromId,
      if (toId != null) 'to_id': toId,
      if (weight != null) 'weight': weight,
      if (dirty != null) 'dirty': dirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteLinksTableCompanion copyWith(
      {Value<String>? fromId,
      Value<String>? toId,
      Value<int>? weight,
      Value<bool>? dirty,
      Value<DateTime?>? updatedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return NoteLinksTableCompanion(
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      weight: weight ?? this.weight,
      dirty: dirty ?? this.dirty,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('NoteLinksTableCompanion(')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('weight: $weight, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $NoteLinksTableTable noteLinksTable = $NoteLinksTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notesTable, remindersTable, noteLinksTable];
}

typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  Value<String?> title,
  Value<String?> content,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  required DateTime updatedAt,
  required DateTime createdAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String?> title,
  Value<String?> content,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<DateTime?> deletedAt,
  Value<DateTime> updatedAt,
  Value<DateTime> createdAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});

class $$NotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);
}

class $$NotesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (
      NotesTableData,
      BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData>
    ),
    NotesTableData,
    PrefetchHooks Function()> {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion(
            id: id,
            title: title,
            content: content,
            deleted: deleted,
            dirty: dirty,
            deletedAt: deletedAt,
            updatedAt: updatedAt,
            createdAt: createdAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> title = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime updatedAt,
            required DateTime createdAt,
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion.insert(
            id: id,
            title: title,
            content: content,
            deleted: deleted,
            dirty: dirty,
            deletedAt: deletedAt,
            updatedAt: updatedAt,
            createdAt: createdAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (
      NotesTableData,
      BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData>
    ),
    NotesTableData,
    PrefetchHooks Function()>;
typedef $$RemindersTableTableCreateCompanionBuilder = RemindersTableCompanion
    Function({
  required String id,
  Value<String?> noteId,
  required DateTime remindAt,
  Value<bool> isDone,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String?> repeatRule,
  required DateTime updatedAt,
  required DateTime createdAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableTableUpdateCompanionBuilder = RemindersTableCompanion
    Function({
  Value<String> id,
  Value<String?> noteId,
  Value<DateTime> remindAt,
  Value<bool> isDone,
  Value<bool> deleted,
  Value<bool> dirty,
  Value<String?> repeatRule,
  Value<DateTime> updatedAt,
  Value<DateTime> createdAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
      column: $table.remindAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatRule => $composableBuilder(
      column: $table.repeatRule, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
      column: $table.remindAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatRule => $composableBuilder(
      column: $table.repeatRule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get repeatRule => $composableBuilder(
      column: $table.repeatRule, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);
}

class $$RemindersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (
      RemindersTableData,
      BaseReferences<_$AppDatabase, $RemindersTableTable, RemindersTableData>
    ),
    RemindersTableData,
    PrefetchHooks Function()> {
  $$RemindersTableTableTableManager(
      _$AppDatabase db, $RemindersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> noteId = const Value.absent(),
            Value<DateTime> remindAt = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> repeatRule = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion(
            id: id,
            noteId: noteId,
            remindAt: remindAt,
            isDone: isDone,
            deleted: deleted,
            dirty: dirty,
            repeatRule: repeatRule,
            updatedAt: updatedAt,
            createdAt: createdAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> noteId = const Value.absent(),
            required DateTime remindAt,
            Value<bool> isDone = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<String?> repeatRule = const Value.absent(),
            required DateTime updatedAt,
            required DateTime createdAt,
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion.insert(
            id: id,
            noteId: noteId,
            remindAt: remindAt,
            isDone: isDone,
            deleted: deleted,
            dirty: dirty,
            repeatRule: repeatRule,
            updatedAt: updatedAt,
            createdAt: createdAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (
      RemindersTableData,
      BaseReferences<_$AppDatabase, $RemindersTableTable, RemindersTableData>
    ),
    RemindersTableData,
    PrefetchHooks Function()>;
typedef $$NoteLinksTableTableCreateCompanionBuilder = NoteLinksTableCompanion
    Function({
  required String fromId,
  required String toId,
  Value<int> weight,
  Value<bool> dirty,
  Value<DateTime?> updatedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$NoteLinksTableTableUpdateCompanionBuilder = NoteLinksTableCompanion
    Function({
  Value<String> fromId,
  Value<String> toId,
  Value<int> weight,
  Value<bool> dirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$NoteLinksTableTableFilterComposer
    extends Composer<_$AppDatabase, $NoteLinksTableTable> {
  $$NoteLinksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$NoteLinksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteLinksTableTable> {
  $$NoteLinksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dirty => $composableBuilder(
      column: $table.dirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$NoteLinksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteLinksTableTable> {
  $$NoteLinksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NoteLinksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteLinksTableTable,
    NoteLinksTableData,
    $$NoteLinksTableTableFilterComposer,
    $$NoteLinksTableTableOrderingComposer,
    $$NoteLinksTableTableAnnotationComposer,
    $$NoteLinksTableTableCreateCompanionBuilder,
    $$NoteLinksTableTableUpdateCompanionBuilder,
    (
      NoteLinksTableData,
      BaseReferences<_$AppDatabase, $NoteLinksTableTable, NoteLinksTableData>
    ),
    NoteLinksTableData,
    PrefetchHooks Function()> {
  $$NoteLinksTableTableTableManager(
      _$AppDatabase db, $NoteLinksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteLinksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteLinksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteLinksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> fromId = const Value.absent(),
            Value<String> toId = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteLinksTableCompanion(
            fromId: fromId,
            toId: toId,
            weight: weight,
            dirty: dirty,
            updatedAt: updatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String fromId,
            required String toId,
            Value<int> weight = const Value.absent(),
            Value<bool> dirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteLinksTableCompanion.insert(
            fromId: fromId,
            toId: toId,
            weight: weight,
            dirty: dirty,
            updatedAt: updatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoteLinksTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteLinksTableTable,
    NoteLinksTableData,
    $$NoteLinksTableTableFilterComposer,
    $$NoteLinksTableTableOrderingComposer,
    $$NoteLinksTableTableAnnotationComposer,
    $$NoteLinksTableTableCreateCompanionBuilder,
    $$NoteLinksTableTableUpdateCompanionBuilder,
    (
      NoteLinksTableData,
      BaseReferences<_$AppDatabase, $NoteLinksTableTable, NoteLinksTableData>
    ),
    NoteLinksTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
  $$NoteLinksTableTableTableManager get noteLinksTable =>
      $$NoteLinksTableTableTableManager(_db, _db.noteLinksTable);
}
