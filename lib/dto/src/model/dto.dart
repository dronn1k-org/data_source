import 'package:data_source/callback_result/callback_result.dart';

abstract class DTO {
  const DTO();
  DTO.fromJson(Json json);
  Json toJson();
}
