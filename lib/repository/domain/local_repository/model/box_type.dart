import 'package:base_repository/repository/domain/model/repository_sub_type.dart';

abstract class BoxType extends RepositorySubType<String> {
  @override
  abstract final String typeName;

  const BoxType(super.typeName);
}
