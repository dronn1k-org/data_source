import 'dart:async';

import 'package:base_repository/callback_handler/typedef/json_type.dart';
import 'package:base_repository/extension/list_extension.dart';
import 'package:base_repository/interface/data_source.dart';
import 'package:base_repository/local_data_source/enum/entity_exception_type.dart';
import 'package:base_repository/local_data_source/exception/entity_exception.dart';
import 'package:base_repository/local_data_source/interface/box_type.dart';
import 'package:base_repository/local_data_source/model/local_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class LocalRepository<
    MODEL_TYPE extends DTOWithLocalIdentifier<IdentifierType>,
    IdentifierType> extends Repository<BoxType> {
  @protected
  abstract final String boxName;

  @override
  abstract final BoxType subType;

  String get _boxFullName => '$boxName-${subType.typeName}';

  late Box<JSON_TYPE> _box;

  @protected
  late Future<void> ready;

  final _subTypeChangerCompleter = Completer<void>();

  @mustCallSuper
  LocalRepository() {
    ready = _initAsync();
  }

  @protected
  MODEL_TYPE fromJson(JSON_TYPE json);

  Future<void> _initAsync() async => _box = Hive.isBoxOpen(_boxFullName)
      ? Hive.box(_boxFullName)
      : await Hive.openBox(_boxFullName);

  @protected
  Future<void> create(MODEL_TYPE entity) async {
    await ready;
    if (_box.containsKey(entity.localId)) {
      throw const EntityException(EntityExceptionType.alreadyExists);
    }
    return _box.put(entity.localId, entity.toJson());
  }

  @protected
  Future<MODEL_TYPE> read(IdentifierType id) async {
    await ready;
    final mapEntity = _box.get(id);
    if (mapEntity == null) {
      throw const EntityException(EntityExceptionType.doNotExists);
    }
    try {
      return fromJson(mapEntity);
    } catch (e) {
      throw const EntityException(EntityExceptionType.fromJsonFail);
    }
  }

  @protected
  Future<void> update(MODEL_TYPE entity) async {
    await ready;
    if (!_box.containsKey(entity.localId)) {
      throw const EntityException(EntityExceptionType.doNotExists);
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

  @override
  Future<void> changeSubType(BoxType newSubType) async {
    ready = _subTypeChangerCompleter.future;
    _box.flush();
    _box.close();
    super.changeSubType(newSubType);
    _box = await Hive.openBox(_boxFullName);
    _subTypeChangerCompleter.complete();
  }
}
