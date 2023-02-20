library base_repository;

import 'package:base_repository/callback_handler/typedef/json_type.dart';

abstract class DTO {
  DTO();
  DTO.fromJson(JSON_TYPE json);
}
