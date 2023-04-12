import 'package:base_repository/interface/data_address.dart';

abstract class BoxType extends DataSubType<String> {
  @override
  abstract final String typeName;

  const BoxType(super.typeName);
}
