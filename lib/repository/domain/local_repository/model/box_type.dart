import 'package:base_repository/repository/domain/model/repository_sub_type.dart';

abstract class BoxSubType extends RepositorySubType<String> {
  @override
  abstract final String typeName;

  const BoxSubType(super.typeName);
}
