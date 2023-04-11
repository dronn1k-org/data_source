import 'package:base_repository/callback_handler/base_callback_result.dart';
import 'package:base_repository/callback_handler/typedef/json_type.dart';
import 'package:base_repository/extension/list_extension.dart';
import 'package:base_repository/local_data_source/enum/entity_exception_type.dart';
import 'package:base_repository/local_data_source/exception/entity_exception.dart';
import 'package:base_repository/local_data_source/interface/box_type.dart';
import 'package:base_repository/local_data_source/model/local_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class BaseLocalDataSource<MODEL_TYPE extends LocalData> {
  @protected
  abstract final String boxName;

  static BoxType? _currentType;

  set currentType(BoxType newType) {}

  String get _boxFullName => '$boxName-${_currentType?.type}';

  late Box<JSON_TYPE> _box;

  @protected
  late Future<void> ready;

  @mustCallSuper
  BaseLocalDataSource() {
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
    if (_box.containsKey(entity.uuid)) {
      throw const EntityException(EntityExceptionType.alreadyExists);
    }
    return _box.put(entity.uuid, entity.toJson());
  }

  @protected
  Future<MODEL_TYPE?> read(String uuid) async {
    await ready;
    final mapEntity = _box.get(uuid);
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
    if (!_box.containsKey(entity.uuid)) {
      throw const EntityException(EntityExceptionType.doNotExists);
    }
    return _box.put(entity.uuid, entity.toJson());
  }

  @protected
  Future<void> delete(String uuid) async {
    await ready;
    _box.delete(uuid);
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

  Future<BaseCallbackResult<RESULT_TYPE, ERRORS_TYPE>>
      request<RESULT_TYPE, ERRORS_TYPE>() {}
}
