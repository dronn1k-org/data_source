abstract class LocalRepositoryException implements Exception {}

class EntityDoNotExists implements LocalRepositoryException {
  const EntityDoNotExists();
}

class EntityAlreadyExists implements LocalRepositoryException {
  const EntityAlreadyExists();
}

class FromJsonFail implements LocalRepositoryException {
  const FromJsonFail();
}
