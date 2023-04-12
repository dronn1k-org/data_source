library base_repository;

import 'package:base_repository/interface/dto.dart';
import 'package:retrofit/dio.dart';

typedef ClientCallbackResult<T extends DTO> = HttpResponse<T>;
