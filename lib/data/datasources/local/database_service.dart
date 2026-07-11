import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/host_account_model.dart';
import '../../models/aggregated_build_model.dart';
import '../../../domain/entities/host_account.dart';
import '../../../domain/entities/aggregated_build.dart';

class DatabaseService {
  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [HostAccountModelSchema, AggregatedBuildModelSchema],
      directory: dir.path,
    );
  }

  Future<List<HostAccount>> getHostAccounts() async {
    final accounts = await _isar.hostAccountModels.where().findAll();
    return accounts.map((e) => e.toEntity()).toList();
  }

  Future<void> saveHostAccounts(List<HostAccount> accounts) async {
    final models = accounts.map((e) => HostAccountModel.fromEntity(e)).toList();
    await _isar.writeTxn(() async {
      await _isar.hostAccountModels.clear();
      await _isar.hostAccountModels.putAll(models);
    });
  }

  Future<List<AggregatedBuild>> getBuilds() async {
    final builds = await _isar.aggregatedBuildModels.where().findAll();
    return builds.map((e) => e.toEntity()).toList();
  }

  Future<void> saveBuilds(List<AggregatedBuild> builds) async {
    final models = builds.map((e) => AggregatedBuildModel.fromEntity(e)).toList();
    await _isar.writeTxn(() async {
      await _isar.aggregatedBuildModels.clear();
      await _isar.aggregatedBuildModels.putAll(models);
    });
  }
}
