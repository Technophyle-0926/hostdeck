class HostAccount {
  final int id;
  final String accountName;
  final String email;
  final int maxAppsLimit;
  final int appsCount;

  HostAccount({
    required this.id,
    required this.accountName,
    required this.email,
    required this.maxAppsLimit,
    required this.appsCount,
  });

  int get availableSlots => maxAppsLimit - appsCount;

  double get usagePercentage {
    if (maxAppsLimit == 0) return 0;
    return (appsCount / maxAppsLimit);
  }

  bool isCapacityCritical() {
    // Critical if 1 or 0 slots remaining, or if usage is > 90%
    if (maxAppsLimit == 0) return false;
    return availableSlots <= 1 || usagePercentage > 0.90;
  }
}
