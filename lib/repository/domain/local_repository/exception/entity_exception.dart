import 'package:base_repository/repository/domain/local_repository/misc/enum_list.dart';

class EntityException implements Exception {
  final EntityExceptionType type;

  const EntityException(this.type);
}
