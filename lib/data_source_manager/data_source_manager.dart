import 'package:base_repository/interface/data_address.dart';
import 'package:base_repository/interface/data_source.dart';

class DataSourceManager {
  DataSourceManager._();
  static final instance = DataSourceManager._();
  factory DataSourceManager() => instance;

  final List<Repository> _activeDataSourceList = [];

  T put<T extends Repository>(T Function() constructor) {
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

  bool dispose<T extends Repository>() {
    final lengthBeforeRemoving = _activeDataSourceList.length;
    _activeDataSourceList.removeWhere((element) => element is T);
    final lengthAfterRemoving = _activeDataSourceList.length;
    return lengthBeforeRemoving - lengthAfterRemoving == 1;
  }

  void changeSubType(DataSubType newSubType) {
    for (var element in _activeDataSourceList) {
      element.changeSubType(newSubType);
    }
  }
}
