import 'dart:async';

import 'package:base_repository/callback_handler/model/base_callback_result.dart';
import 'package:base_repository/callback_handler/misc/typedef_list.dart';
import 'package:base_repository/extension/iterable_extension.dart';
import 'package:base_repository/repository/domain/local_repository/exception/local_repository_exception.dart';
import 'package:base_repository/repository/domain/repository.dart';
import 'package:base_repository/repository/domain/local_repository/model/local_data.dart';
import 'package:base_repository/repository/domain/local_repository/model/box_type.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class LocalRepository<
    MODEL_TYPE extends DTOWithLocalIdentifier<IdentifierType>,
    IdentifierType,
    RepoSubType extends BoxSubType> extends Repository<RepoSubType> {
  @protected
  abstract final String boxName;

  String get _boxFullName => '$boxName-${subType.typeName}';

  late Box<Json> _box;

  @protected
  late Future<void> ready;

  final _subTypeChangerCompleter = Completer<void>();

  @mustCallSuper
  LocalRepository(super.subType) {
    ready = _initAsync();
  }

  @protected
  MODEL_TYPE fromJson(Json json);

  Future<void> _initAsync() async => _box = Hive.isBoxOpen(_boxFullName)
      ? Hive.box(_boxFullName)
      : await Hive.openBox(_boxFullName);

  @protected
  Future<void> create(MODEL_TYPE entity) async {
    await ready;
    if (_box.containsKey(entity.localId)) {
      throw const EntityAlreadyExists();
    }
    return _box.put(entity.localId, entity.toJson());
  }

  @protected
  Future<MODEL_TYPE> read(IdentifierType id) async {
    await ready;
    final mapEntity = _box.get(id);
    if (mapEntity == null) {
      throw const EntityDoNotExists();
    }
    try {
      return fromJson(mapEntity);
    } catch (e) {
      throw const FromJsonFail();
    }
  }

  @protected
  Future<void> update(MODEL_TYPE entity) async {
    await ready;
    if (!_box.containsKey(entity.localId)) {
      throw const EntityDoNotExists();
    }
    return _box.put(entity.localId, entity.toJson());
  }

  @protected
  Future<void> delete(IdentifierType id) async {
    await ready;
    _box.delete(id);
  }

  @protected
  Future<List<MODEL_TYPE>> getList({
    bool Function(MODEL_TYPE entity)? where,
    int pageNumber = 0,
    int limit = 10,
  }) async {
    await ready;
    List<MODEL_TYPE> resultList = [];
    if (where != null) {
      resultList.addAll(_box.values.whereMap(
        where: where,
        map: fromJson,
      ));
    } else {
      resultList.addAll(_box.values.map(fromJson));
    }
    // TODO handle list length exceptions
    return resultList.sublist(pageNumber * limit, (pageNumber + 1) * limit);
  }

  Future<CallbackResult> request<DataType>(
      Future<DataType> Function() callback);

  @override
  Future<void> changeSubType(RepoSubType newSubType) async {
    ready = _subTypeChangerCompleter.future;
    _box.flush();
    _box.close();
    super.changeSubType(newSubType);
    _box = await Hive.openBox(_boxFullName);
    _subTypeChangerCompleter.complete();
  }
}
