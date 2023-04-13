import 'package:base_repository/repository/domain/model/repository_sub_type.dart';
import 'package:base_repository/repository/domain/repository.dart';
import 'package:flutter/foundation.dart';

class RepositoryManager {
  RepositoryManager._();
  static final instance = RepositoryManager._();
  factory RepositoryManager() => instance;

  final List<Repository> _activeRepList = [];

  @visibleForTesting
  int get repositoryQuantity => _activeRepList.length;

  T get<T extends Repository>(T Function() constructor) {
    try {
      return _activeRepList.firstWhere(
        (element) => element is T,
      ) as T;
    } catch (e) {
      final dataSource = constructor();
      _activeRepList.add(dataSource);
      return dataSource;
    }
  }

  bool remove<T extends Repository>() {
    final lengthBeforeRemoving = _activeRepList.length;
    _activeRepList.removeWhere((element) => element is T);
    final lengthAfterRemoving = _activeRepList.length;
    return lengthBeforeRemoving - lengthAfterRemoving == 1;
  }

  bool isExists<T extends Repository>() {
    try {
      _activeRepList.firstWhere((element) => element is T);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> changeSubType<T extends RepositorySubType>(T newSubType) async {
    for (var element in _activeRepList) {
      if (element.subType is T) {
        await element.changeSubType(newSubType);
      }
    }
  }
}
