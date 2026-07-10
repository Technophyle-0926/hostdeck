import 'package:isar/isar.dart';
import '../../domain/entities/aggregated_build.dart';
import '../../core/constants/app_keys.dart';

part 'aggregated_build_model.g.dart';

@collection
class AggregatedBuildModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int hostAccountId;
  
  late String projectName;
  late String version;
  late String environment;
  late DateTime uploadDate;
  late double sizeMb;
  late String platform;
  late String downloadUrl;
  late String appIconUrl;

  AggregatedBuildModel();

  factory AggregatedBuildModel.fromEntity(AggregatedBuild entity) {
    return AggregatedBuildModel()
      ..id = entity.id == 0 ? Isar.autoIncrement : entity.id
      ..hostAccountId = entity.hostAccountId
      ..projectName = entity.projectName
      ..version = entity.version
      ..environment = entity.environment
      ..uploadDate = entity.uploadDate
      ..sizeMb = entity.sizeMb
      ..platform = entity.platform
      ..downloadUrl = entity.downloadUrl
      ..appIconUrl = entity.appIconUrl;
  }

  factory AggregatedBuildModel.fromFirestoreJson(Map<String, dynamic> json, int hostAccountId, String appName, [String appDownloadUrl = '', String appIconUrl = '']) {
    final fields = json[AppKeys.fields] ?? {};
    
    // Helper to safely extract values
    String extractString(String key) {
      return fields[key]?[AppKeys.stringValue] ?? '';
    }
    
    double extractDouble(String key) {
      final field = fields[key];
      if (field == null) return 0.0;
      if (field.containsKey(AppKeys.doubleValue)) return (field[AppKeys.doubleValue] as num).toDouble();
      if (field.containsKey(AppKeys.integerValue)) {
        return double.tryParse(field[AppKeys.integerValue].toString()) ?? 0.0;
      }
      if (field.containsKey(AppKeys.stringValue)) {
        return double.tryParse(field[AppKeys.stringValue].toString()) ?? 0.0;
      }
      return 0.0;
    }

    // Convert size to MB (it comes in bytes as a string like "24836897")
    double sizeInBytes = extractDouble(AppKeys.size);
    double sizeInMb = sizeInBytes > 0 ? sizeInBytes / (1024 * 1024) : 0.0;

    return AggregatedBuildModel()
      ..hostAccountId = hostAccountId
      ..projectName = appName
      ..version = extractString(AppKeys.version)
      ..environment = extractString(AppKeys.iosDistributionType).isEmpty 
          ? 'Prod' 
          : extractString(AppKeys.iosDistributionType)
      ..uploadDate = DateTime.tryParse(json[AppKeys.createTime] ?? json[AppKeys.updateTime] ?? '') ?? DateTime.now()
      ..sizeMb = sizeInMb
      ..platform = extractString(AppKeys.platform)
      ..downloadUrl = extractString(AppKeys.cachedShareKey).isNotEmpty 
          ? 'https://appho.st/d/${extractString(AppKeys.cachedShareKey)}'
          : appDownloadUrl
      ..appIconUrl = extractString(AppKeys.logoUrl).isNotEmpty 
    ? extractString(AppKeys.logoUrl) 
    : appIconUrl;
  }

  AggregatedBuild toEntity() {
    return AggregatedBuild(
      id: id,
      hostAccountId: hostAccountId,
      projectName: projectName,
      version: version,
      environment: environment,
      uploadDate: uploadDate,
      sizeMb: sizeMb,
      platform: platform,
      downloadUrl: downloadUrl,
      appIconUrl: appIconUrl,
    );
  }
}
