class PlantApiModel {
  final int id;
  final String commonName;
  final List<String> scientificName;
  final String watering;
  final String sunlight;
  final String imageUrl;

  PlantApiModel({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.watering,
    required this.sunlight,
    required this.imageUrl,
  });

  factory PlantApiModel.fromJson(Map<String, dynamic> json) {
    // Default fallback image jika API tidak menyediakan foto
    final defaultImg =
        'https://images.unsplash.com/photo-1545241047-6083a3684587?q=80&w=600';

    String img = defaultImg;
    if (json['default_image'] != null &&
        json['default_image']['regular_url'] != null) {
      img = json['default_image']['regular_url'];
    }

    return PlantApiModel(
      id: json['id'] ?? 0,
      commonName: json['common_name'] ?? 'Tanaman Tanpa Nama',
      scientificName: json['scientific_name'] != null
          ? List<String>.from(json['scientific_name'])
          : ['Unknown'],
      watering: json['watering'] ?? 'Regular',
      sunlight: json['sunlight'] != null
          ? (json['sunlight'] is List
              ? (json['sunlight'] as List).join(', ')
              : json['sunlight'].toString())
          : 'Full Sun',
      imageUrl: img,
    );
  }
}