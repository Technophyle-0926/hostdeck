enum BuildPlatform {
  ios,
  android,
  unknown;

  static BuildPlatform fromString(String platform) {
    final lowerPlatform = platform.toLowerCase();
    if (lowerPlatform == 'ios') return BuildPlatform.ios;
    if (lowerPlatform == 'android') return BuildPlatform.android;
    return BuildPlatform.unknown;
  }

  String get displayName {
    switch (this) {
      case BuildPlatform.ios:
        return 'iOS';
      case BuildPlatform.android:
        return 'Android';
      case BuildPlatform.unknown:
        return 'Unknown';
    }
  }
}

enum ProgressStatus {
  pending,
  success,
  failed;

  static ProgressStatus fromString(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'pending') return ProgressStatus.pending;
    if (lowerStatus == 'success') return ProgressStatus.success;
    if (lowerStatus == 'failed') return ProgressStatus.failed;
    return ProgressStatus.pending;
  }

  String get displayName {
    switch (this) {
      case ProgressStatus.pending:
        return 'Pending';
      case ProgressStatus.success:
        return 'Success';
      case ProgressStatus.failed:
        return 'Failed';
    }
  }
}
