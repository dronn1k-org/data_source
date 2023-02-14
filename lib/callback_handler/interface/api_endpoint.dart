// ignore_for_file: public_member_api_docs, sort_constructors_first
library base_repository;

import 'package:base_repository/callback_handler/interface/dto.dart';

abstract class BaseApiEndpoint<T> implements DTO {}
