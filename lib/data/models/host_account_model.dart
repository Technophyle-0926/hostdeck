import 'package:isar_community/isar.dart';
import '../../domain/entities/host_account.dart';

part 'host_account_model.g.dart';

@collection
class HostAccountModel {
  Id id = Isar.autoIncrement;

  late String accountName;
  late String email;
  late int maxAppsLimit;
  late int appsCount;

  HostAccountModel();

  factory HostAccountModel.fromEntity(HostAccount entity) {
    return HostAccountModel()
      ..id = entity.id == 0 ? Isar.autoIncrement : entity.id
      ..accountName = entity.accountName
      ..email = entity.email
      ..maxAppsLimit = entity.maxAppsLimit
      ..appsCount = entity.appsCount;
  }

  HostAccount toEntity() {
    return HostAccount(
      id: id,
      accountName: accountName,
      email: email,
      maxAppsLimit: maxAppsLimit,
      appsCount: appsCount,
    );
  }
}
