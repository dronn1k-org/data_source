import 'dart:async';

import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/extension/iterable_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'exception/local_data_source_exception.dart';
import 'model/local_data.dart';

abstract base class LocalDataSource<Entity extends LocalEntity> {
  @protected
  abstract final String boxName;

  late Box<Json> _box;

  @protected
  late Future<void> ready;

  LocalDataSource() {
    ready = _initAsync();
  }

  String? get lastEntityKey => _box.isNotEmpty ? _box.toMap().keys.last : null;

  @protected
  Entity fromJson(Json json);

  Future<void> _initAsync() async => _box =
      Hive.isBoxOpen(boxName) ? Hive.box(boxName) : await Hive.openBox(boxName);

  @protected
  Future<Entity> createEntity(Entity entity) async {
    await ready;
    final mappedEntity = entity.toJson();
    if (_box.containsKey(entity.localId)) {
      throw EntityAlreadyExists(mappedEntity);
    }
    await _box.put(entity.localId, mappedEntity);
    return entity;
  }

  @protected
  Future<Entity> readEntityById(String id) async {
    await ready;
    final mappedEntity = _box.get(id);
    if (mappedEntity == null) {
      throw EntityDoNotExists(id);
    }
    try {
      return fromJson(mappedEntity);
    } catch (e) {
      throw FromJsonFail(mappedEntity);
    }
  }

  @protected
  Future<void> updateEntity(Entity entity) async {
    await ready;
    if (!_box.containsKey(entity.localId)) {
      throw EntityDoNotExists(entity.localId);
    }
    return _box.put(entity.localId, entity.toJson());
  }

  @protected
  Future<void> deleteEntityById(String id) async {
    await ready;
    _box.delete(id);
  }

  @protected
  Future<List<Entity>> readWhereEntity({
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
}
