library base_repository;

import 'package:base_repository/repository/domain/model/dto.dart';
import 'package:retrofit/dio.dart';

typedef Json = Map<String, dynamic>;

typedef RemoteCallbackResult<T extends DTO> = HttpResponse<T>;

typedef ClientCallback<T extends DTO> = Future<RemoteCallbackResult<T>>
    Function();
