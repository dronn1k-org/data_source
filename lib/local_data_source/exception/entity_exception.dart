import 'package:base_repository/local_data_source/enum/entity_exception_type.dart';

class EntityException implements Exception {
  final EntityExceptionType type;

  const EntityException(this.type);
}
