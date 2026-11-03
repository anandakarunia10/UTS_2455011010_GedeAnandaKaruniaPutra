
class WateringHistoryModel {
  final String? id;
  final String plantId;
  final DateTime wateredAt;
  final String? notes;

  const WateringHistoryModel({
    this.id,
    required this.plantId,
    required this.wateredAt,
    this.notes,
  });

  factory WateringHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WateringHistoryModel(
      id: json['id']?.toString(),
      plantId: json['plant_id'].toString(),
      wateredAt: DateTime.parse(
        json['watered_at'].toString(),
      ),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_id': plantId,
      'watered_at': wateredAt.toIso8601String(),
      'notes': notes,
    };
  }
}
