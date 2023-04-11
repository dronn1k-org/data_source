library base_repository;

import 'package:base_repository/interface/data_address.dart';

abstract class ApiUrl extends DataAddress<String> {
  abstract final String url;

  const ApiUrl(super.address);
}
