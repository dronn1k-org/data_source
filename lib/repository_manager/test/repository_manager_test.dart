import 'package:base_repository/repository/domain/local_repository/test/local_repository_test.dart';
import 'package:base_repository/repository_manager/repository_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  group('Repository manager testing', () {
    test('Manager singleton', () async {
      final firstField = RepositoryManager.instance;
      final secondField = RepositoryManager();

      expect(firstField == secondField, true);
    });
    test('Repository singleton', () {
      final repManager = RepositoryManager();
      final firstRepField = repManager.get(() => LocalUserRepository());
      final secondRepField = repManager.get(() => LocalUserRepository());

      expect(
        firstRepField == secondRepField && repManager.repositoryQuantity == 1,
        true,
      );
    });

    test('Repository removing', () {
      final repManager = RepositoryManager();
      repManager.get(() => LocalUserRepository());
      repManager.remove<LocalUserRepository>();

      expect(repManager.repositoryQuantity, 0);
    });

    test('Changing repository sub type', () async {
      final repManager = RepositoryManager();
      final userRepo = repManager.get(() => LocalUserRepository());
      final subTypeBefore = userRepo.subType;

      await repManager.changeSubType(BoxType.prod);
      final subTypeAfter = userRepo.subType;

      expect(subTypeAfter != subTypeBefore, true);
    });
  });
  tearDown(() async {
    await tearDownTestHive();
  });
}
