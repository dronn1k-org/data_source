import 'package:base_repository/repository/domain/model/repository_sub_type.dart';
import 'package:flutter/foundation.dart';

abstract class Repository<T extends RepositorySubType> {
  late T _subType;
  T get subType => _subType;

  @mustCallSuper
  Repository(T subType) : _subType = subType;

  @mustCallSuper
  Future<void> changeSubType(T newSubType) async => _subType = newSubType;
}
