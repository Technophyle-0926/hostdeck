class AggregatedBuild {
  final int id;
  final int hostAccountId;
  final String projectName;
  final String version;
  final String environment;
  final DateTime uploadDate;
  final double sizeMb;
  final String platform;
  final String downloadUrl;

  AggregatedBuild({
    required this.id,
    required this.hostAccountId,
    required this.projectName,
    required this.version,
    required this.environment,
    required this.uploadDate,
    required this.sizeMb,
    required this.platform,
    required this.downloadUrl,
  });
}
