library base_repository;

import 'package:base_repository/callback_handler/interface/api_endpoint.dart';
import 'package:retrofit/dio.dart';

typedef ClientCallbackResult<T> = HttpResponse<BaseApiEndpoint<T>>;
