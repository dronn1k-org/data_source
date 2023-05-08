import 'dart:async';
import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/extension/iterable_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'exception/local_data_source_exception.dart';
import 'model/local_data.dart';

abstract class LocalDataSource<
    Entity extends DTOWithLocalIdentifier<Identifier>, Identifier> {
  @protected
  abstract final String boxName;

  late Box<Json> _box;

  @protected
  late Future<void> ready;

  @mustCallSuper
  LocalDataSource() {
    ready = _initAsync();
  }

  @protected
  Entity fromJson(Json json);

  Future<void> _initAsync() async => _box =
      Hive.isBoxOpen(boxName) ? Hive.box(boxName) : await Hive.openBox(boxName);

  @protected
  Future<Entity> create(Entity entity) async {
    await ready;
    if (_box.containsKey(entity.localId)) {
      throw const EntityAlreadyExists();
    }
    await _box.put(entity.localId, entity.toJson());
    return entity;
  }

  @protected
  Future<Entity> read(Identifier id) async {
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
  Future<void> update(Entity entity) async {
    await ready;
    if (!_box.containsKey(entity.localId)) {
      throw const EntityDoNotExists();
    }
    return _box.put(entity.localId, entity.toJson());
  }

  @protected
  Future<void> delete(Identifier id) async {
    await ready;
    _box.delete(id);
  }

  @protected
  Future<List<Entity>> getList({
    bool Function(Entity entity)? where,
    int pageNumber = 0,
    int limit = 10,
  }) async {
    await ready;
    final List<Entity> resultList = [];
    if (where != null) {
      resultList.addAll(_box.values.whereMap(
        where: where,
        map: fromJson,
      ));
    } else {
      resultList.addAll(_box.values.map(fromJson));
    }
    // TODO handle list length exceptions
    try {
      return resultList.sublist(pageNumber * limit, (pageNumber + 1) * limit);
    } catch (e) {
      return (resultList.length - pageNumber * limit) > 0
          ? resultList.sublist(pageNumber * limit, resultList.length)
          : [];
    }
  }

  @protected
  Future<CallbackResult> request<DataType>(
      Future<DataType> Function() callback);
}
