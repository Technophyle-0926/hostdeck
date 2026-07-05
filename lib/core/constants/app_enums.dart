enum BuildEnvironment {
  prod,
  stage,
  unknown;

  static BuildEnvironment fromString(String env) {
    final lowerEnv = env.toLowerCase();
    if (lowerEnv == 'prod' || lowerEnv == 'production') return BuildEnvironment.prod;
    if (lowerEnv == 'stage' || lowerEnv == 'staging') return BuildEnvironment.stage;
    return BuildEnvironment.unknown;
  }

  String get displayName {
    switch (this) {
      case BuildEnvironment.prod:
        return 'Prod';
      case BuildEnvironment.stage:
        return 'Stage';
      case BuildEnvironment.unknown:
        return 'Unknown';
    }
  }
}

enum BuildPlatform {
  ios,
  android,
  web,
  unknown;

  static BuildPlatform fromString(String platform) {
    final lowerPlatform = platform.toLowerCase();
    if (lowerPlatform == 'ios') return BuildPlatform.ios;
    if (lowerPlatform == 'android') return BuildPlatform.android;
    if (lowerPlatform == 'web') return BuildPlatform.web;
    return BuildPlatform.unknown;
  }
}
