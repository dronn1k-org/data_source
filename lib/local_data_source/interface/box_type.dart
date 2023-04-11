import 'package:base_repository/interface/data_address.dart';

abstract class BoxType extends DataAddress<String> {
  abstract final String type;

  const BoxType(super.address);
}
