library base_repository;

import 'package:base_repository/interface/data_address.dart';

abstract class ApiUrl extends DataSubType<String> {
  final String url;

  const ApiUrl(super.typeName) : url = typeName;
}
