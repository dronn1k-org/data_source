library base_repository;

import 'package:base_repository/repository/domain/model/repository_sub_type.dart';

abstract class ApiUrl extends RepositorySubType<String> {
  final String url;

  const ApiUrl(super.typeName) : url = typeName;
}
