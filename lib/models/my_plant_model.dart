class MyPlantModel {
  final String? id;
  final String studentId;
  final int plantId;
  final String plantName;
  final String waterSchedule;
  final String lastWateredDate;
  final String notes;
  final String healthStatus;
  final String imageUrl;

  MyPlantModel({
    this.id,
    required this.studentId,
    required this.plantId,
    required this.plantName,
    required this.waterSchedule,
    required this.lastWateredDate,
    required this.notes,
    required this.healthStatus,
    required this.imageUrl,
  });

  factory MyPlantModel.fromJson(Map<String, dynamic> json) {
    return MyPlantModel(
      id: json['id']?.toString(),
      studentId: json['student_id'] ?? '',
      plantId: json['plant_id'] ?? 0,
      plantName: json['plant_name'] ?? '',
      waterSchedule: json['water_schedule'] ?? '2 Hari sekali',
      lastWateredDate: json['last_watered_date'] ?? '',
      notes: json['notes'] ?? '',
      healthStatus: json['health_status'] ?? 'Healthy',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'plant_id': plantId,
      'plant_name': plantName,
      'water_schedule': waterSchedule,
      'last_watered_date': lastWateredDate,
      'notes': notes,
      'health_status': healthStatus,
      'image_url': imageUrl,
    };
  }
}