import 'package:base_repository/callback_result/misc/typedef_list.dart';

abstract class DTO {
  const DTO();
  DTO.fromJson(Json json);
  Json toJson();
}
