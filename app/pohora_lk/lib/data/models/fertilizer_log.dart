class FertilizerLog {
  final int id;
  final DateTime timestamp;
  final int cultivationId;
  final int fertilizerId;
  final String fertilizerName;

  FertilizerLog({
    required this.id,
    required this.timestamp,
    required this.cultivationId,
    required this.fertilizerId,
    required this.fertilizerName,
  });

  factory FertilizerLog.fromJson(Map<String, dynamic> json) {
    return FertilizerLog(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      cultivationId: json['cultivationId'],
      fertilizerId: json['fertilizerId'],
      fertilizerName: json['fertilizerName'],
    );
  }
}
