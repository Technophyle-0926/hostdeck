class AggregatedBuild {
  final int id;
  final int hostAccountId;
  final String projectId;
  final String projectName;
  final String version;
  final String environment;
  final DateTime uploadDate;
  final double sizeMb;
  final String platform;
  final String downloadUrl;
  final String appIconUrl;

  AggregatedBuild({
    required this.id,
    required this.hostAccountId,
    required this.projectId,
    required this.projectName,
    required this.version,
    required this.environment,
    required this.uploadDate,
    required this.sizeMb,
    required this.platform,
    required this.downloadUrl,
    this.appIconUrl = '',
  });

  AggregatedBuild copyWith({
    int? id,
    int? hostAccountId,
    String? projectId,
    String? projectName,
    String? version,
    String? environment,
    DateTime? uploadDate,
    double? sizeMb,
    String? platform,
    String? downloadUrl,
    String? appIconUrl,
  }) {
    return AggregatedBuild(
      id: id ?? this.id,
      hostAccountId: hostAccountId ?? this.hostAccountId,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      version: version ?? this.version,
      environment: environment ?? this.environment,
      uploadDate: uploadDate ?? this.uploadDate,
      sizeMb: sizeMb ?? this.sizeMb,
      platform: platform ?? this.platform,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      appIconUrl: appIconUrl ?? this.appIconUrl,
    );
  }
}
