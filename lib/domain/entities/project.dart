class Project {
  final String id; // This will likely be the Firestore document ID
  final String name;
  final String appName; // The App Name exactly as it appears in AppHost
  final String description;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    required this.appName,
    this.description = '',
    required this.createdAt,
  });
}
