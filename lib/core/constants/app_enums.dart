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
