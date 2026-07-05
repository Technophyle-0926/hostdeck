import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/aggregated_build.dart';

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
      ..downloadUrl = entity.downloadUrl;
  }

  factory AggregatedBuildModel.fromFirestoreJson(Map<String, dynamic> json, int hostAccountId, String appName, [String appDownloadUrl = '']) {
    final fields = json['fields'] ?? {};
    
    // Helper to safely extract values
    String extractString(String key) {
      return fields[key]?['stringValue'] ?? '';
    }
    
    double extractDouble(String key) {
      final field = fields[key];
      if (field == null) return 0.0;
      if (field.containsKey('doubleValue')) return (field['doubleValue'] as num).toDouble();
      if (field.containsKey('integerValue')) {
        return double.tryParse(field['integerValue'].toString()) ?? 0.0;
      }
      if (field.containsKey('stringValue')) {
        return double.tryParse(field['stringValue'].toString()) ?? 0.0;
      }
      return 0.0;
    }

    // Convert size to MB (it comes in bytes as a string like "24836897")
    double sizeInBytes = extractDouble('size');
    double sizeInMb = sizeInBytes > 0 ? sizeInBytes / (1024 * 1024) : 0.0;

    return AggregatedBuildModel()
      ..hostAccountId = hostAccountId
      ..projectName = appName
      ..version = extractString('version')
      ..environment = extractString('ios_distribution_type').isEmpty 
          ? 'Prod' 
          : extractString('ios_distribution_type')
      ..uploadDate = DateTime.tryParse(json['updateTime'] ?? json['createTime'] ?? '') ?? DateTime.now()
      ..sizeMb = sizeInMb
      ..platform = extractString('platform')
      ..downloadUrl = extractString('cached_share_key').isNotEmpty 
          ? 'https://appho.st/d/${extractString('cached_share_key')}'
          : appDownloadUrl;
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
    );
  }
}
