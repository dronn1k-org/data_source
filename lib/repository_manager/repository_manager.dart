import 'package:base_repository/repository/domain/model/repository_sub_type.dart';
import 'package:base_repository/repository/domain/repository.dart';

class RepositoryManager {
  RepositoryManager._();
  static final instance = RepositoryManager._();
  factory RepositoryManager() => instance;

  final List<Repository> _activeDataSourceList = [];

  T get<T extends Repository>(T Function() constructor) {
    try {
      return _activeDataSourceList.firstWhere(
        (element) => element is T,
      ) as T;
    } catch (e) {
      final dataSource = constructor();
      _activeDataSourceList.add(dataSource);
      return dataSource;
    }
  }

  bool remove<T extends Repository>() {
    final lengthBeforeRemoving = _activeDataSourceList.length;
    _activeDataSourceList.removeWhere((element) => element is T);
    final lengthAfterRemoving = _activeDataSourceList.length;
    return lengthBeforeRemoving - lengthAfterRemoving == 1;
  }

  void changeSubType(RepositorySubType newSubType) {
    for (var element in _activeDataSourceList) {
      element.changeSubType(newSubType);
    }
  }
}
