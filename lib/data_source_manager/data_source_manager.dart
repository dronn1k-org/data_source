import 'package:base_repository/interface/data_source.dart';

class DataSourceManager {
  DataSourceManager._();
  static final instance = DataSourceManager._();
  factory DataSourceManager() => instance;

  final List<DataSource> _activeDataSourceList = [];

  T put<T extends DataSource>(T Function() constructor) =>
      _activeDataSourceList.firstWhere(
        (element) => element is T,
        orElse: constructor,
      ) as T;

  void dispose<T extends DataSource>() {}
}
