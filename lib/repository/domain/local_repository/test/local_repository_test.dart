// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

import 'package:base_repository/callback_handler/misc/enum_list.dart';
import 'package:base_repository/callback_handler/misc/typedef_list.dart';
import 'package:base_repository/callback_handler/model/base_callback_result.dart';
import 'package:base_repository/repository/domain/local_repository/exception/local_repository_exception.dart';
import 'package:base_repository/repository/domain/local_repository/local_repository.dart';
import 'package:base_repository/repository/domain/local_repository/model/box_type.dart';
import 'package:base_repository/repository/domain/local_repository/model/local_data.dart';

class BaseCbResult<T> extends CallbackResult<T, String> {
  const BaseCbResult({
    required super.callbackStatus,
    super.data,
    super.errors,
  });
}

enum BoxType implements BoxSubType {
  prod('prod'),
  dev('dev');

  const BoxType(this.typeName);

  @override
  final String typeName;

  @override
  String toString() => typeName;
}

abstract class BaseDTO extends DTOWithLocalIdentifier<int> {
  @override
  final int localId;

  BaseDTO({
    int? localId,
  }) : localId = localId ?? DateTime.now().millisecondsSinceEpoch;
}

abstract class BaseLocalRepository<Entity extends DTOWithLocalIdentifier<int>>
    extends LocalRepository<Entity, int, BoxType> {
  BaseLocalRepository([super.subType = BoxType.dev]);

  @override
  Future<BaseCbResult<DataType>> request<DataType>(
      Future<DataType> Function() callback) async {
    try {
      final result = await callback();
      return BaseCbResult(callbackStatus: CallbackStatus.success, data: result);
    } on EntityAlreadyExists {
      return const BaseCbResult(
        callbackStatus: CallbackStatus.fail,
        errors: 'Entity is already exists',
      );
    } on EntityDoNotExists {
      return const BaseCbResult(
        callbackStatus: CallbackStatus.fail,
        errors: 'Entity do not exists',
      );
    } on FromJsonFail {
      rethrow;
    } catch (e) {
      return const BaseCbResult(callbackStatus: CallbackStatus.fail);
    }
  }
}

class User extends BaseDTO {
  final int? id;
  final String name;
  final String surname;

  User({
    this.id,
    super.localId,
    required this.name,
    required this.surname,
  });

  factory User.fromJson(Json json) => User(
        id: json['id'],
        localId: json['localId'],
        name: json['name'],
        surname: json['surname'],
      );

  @override
  Json toJson() => {
        'id': id,
        'localId': localId,
        'name': name,
        'surname': surname,
      };
}

class GetUserPayload {
  final int id;
  const GetUserPayload(this.id);
}

class CreateUserPayload {
  final String name;
  final String surname;
  final int localId;

  const CreateUserPayload({
    required this.name,
    required this.surname,
    required this.localId,
  });
}

class RemoveUserPayload {
  final int id;
  const RemoveUserPayload(this.id);
}

abstract class UserRepository {
  Future<BaseCbResult<User>> getUser(GetUserPayload payload);
  Future<BaseCbResult<User>> createUser(CreateUserPayload payload);
  Future<BaseCbResult<void>> removeUser(RemoveUserPayload payload);
}

class LocalUserRepository extends BaseLocalRepository<User>
    implements UserRepository {
  @override
  String boxName = 'user';

  @override
  User fromJson(Json json) => User.fromJson(json);

  @override
  Future<BaseCbResult<User>> getUser(GetUserPayload payload) =>
      request(() => read(payload.id));

  @override
  Future<BaseCbResult<User>> createUser(CreateUserPayload payload) =>
      request(() => create(User(
            name: payload.name,
            surname: payload.surname,
            localId: payload.localId,
          )));

  @override
  Future<BaseCbResult<void>> removeUser(RemoveUserPayload payload) {
    return request(() => delete(payload.id));
  }
}

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  group('Local Repository testing', () {
    test('Entity creation test', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 0,
      );
      final result = await userRepo.createUser(payload);
      expect(result.data?.name, payload.name);
    });
    test('Entity reading test', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 0,
      );
      await userRepo.createUser(payload);

      final result = await userRepo.getUser(const GetUserPayload(0));
      expect(result.data?.name, payload.name);
    });
    test('Removing entity test', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 0,
      );
      await userRepo.createUser(payload);
      await userRepo.getUser(const GetUserPayload(0));

      final result = await userRepo.removeUser(const RemoveUserPayload(0));
      expect(result.isSuccess, true);
    });

    test('Creating an existed entity', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 0,
      );
      await userRepo.createUser(payload);

      final result = await userRepo.createUser(payload);

      expect(result.isFail, true);
    });
  });
  tearDown(() async {
    await tearDownTestHive();
  });
}
