import 'package:base_repository/interface/data_address.dart';
import 'package:flutter/foundation.dart';

abstract class Repository<T extends DataSubType> {
  late T _subType;
  T get subType => _subType;

  @mustCallSuper
  Future<void> changeSubType(T newSubType) async => _subType = newSubType;
}
