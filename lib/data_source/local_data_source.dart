import 'package:hive/hive.dart';

abstract class BaseLocalDataSource<MODEL_TYPE> {
  final String _dataId;
  
  late Box<MODEL_TYPE> box;

  const BaseLocalDataSource({
    required String dataId,
  }) : _dataId = dataId;
  
  Future<void> _init() {
    
  };
}
