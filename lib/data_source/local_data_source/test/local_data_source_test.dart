// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/data_source/data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

base class BaseCbResult<T> extends CallbackResult<T, String> {
  const BaseCbResult({
    required super.callbackStatus,
    super.data,
    super.errors,
  });
}

abstract class BaseDTO implements LocalEntity {
  @override
  String? localId;

  BaseDTO({
    String? localId,
  }) : localId = localId ?? DateTime.now().millisecondsSinceEpoch.toString();
}

abstract base class BaseLocalRepository<Entity extends LocalEntity>
    extends LocalDataSource<Entity> {
  BaseLocalRepository();

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
  final String? id;
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
  final String id;
  const GetUserPayload(this.id);
}

class CreateUserPayload {
  final String name;
  final String surname;
  final String localId;

  const CreateUserPayload({
    required this.name,
    required this.surname,
    required this.localId,
  });
}

class RemoveUserPayload {
  final String id;
  const RemoveUserPayload(this.id);
}

abstract class UserRepository {
  Future<BaseCbResult<User>> getUser(GetUserPayload payload);
  Future<BaseCbResult<User>> createUser(CreateUserPayload payload);
  Future<BaseCbResult<void>> removeUser(RemoveUserPayload payload);
}

final class LocalUserRepository extends BaseLocalRepository<User>
    implements UserRepository {
  @override
  String boxName = 'user';

  @override
  User fromJson(Json json) => User.fromJson(json);

  @override
  Future<BaseCbResult<User>> getUser(GetUserPayload payload) =>
      request(() => readEntityById(payload.id));

  @override
  Future<BaseCbResult<User>> createUser(CreateUserPayload payload) =>
      request(() => addEntity(User(
            name: payload.name,
            surname: payload.surname,
            localId: payload.localId,
          )));

  @override
  Future<BaseCbResult<void>> removeUser(RemoveUserPayload payload) {
    return request(() => deleteEntityById(payload.id));
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
        localId: 'asd',
      );
      final result = await userRepo.createUser(payload);
      expect(result.data?.name, payload.name);
    });
    test('Entity reading test', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 'asd',
      );
      await userRepo.createUser(payload);

      final result = await userRepo.getUser(const GetUserPayload('asd'));
      expect(result.data?.name, payload.name);
    });
    test('Removing entity test', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 'asd',
      );
      await userRepo.createUser(payload);
      await userRepo.getUser(const GetUserPayload('asd'));

      final result = await userRepo.removeUser(const RemoveUserPayload('asd'));
      expect(result.isSuccess, true);
    });

    test('Creating an existed entity', () async {
      final UserRepository userRepo = LocalUserRepository();
      const payload = CreateUserPayload(
        name: 'Name',
        surname: 'Surname',
        localId: 'asd',
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
