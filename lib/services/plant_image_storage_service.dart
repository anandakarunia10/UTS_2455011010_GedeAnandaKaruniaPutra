import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantImageStorageService {
  PlantImageStorageService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _bucketName = 'plant-images';

  final http.Client _httpClient;
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Returns an existing permanent Supabase URL unchanged, or downloads
  /// [sourceUrl] and uploads its bytes to the public `plant-images` bucket.
  Future<String> uploadFromUrl(
    String sourceUrl, {
    required int plantId,
  }) async {
    final uri = Uri.tryParse(sourceUrl);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw Exception('URL gambar tidak valid. Periksa URL gambar tanaman.');
    }

    final isAlreadyStored =
        uri.host == Uri.parse(_supabase.storage.from(_bucketName).getPublicUrl('check')).host &&
        uri.path.contains('/storage/v1/object/public/$_bucketName/');

    if (isAlreadyStored) {
      return sourceUrl;
    }

    final response = await _httpClient
        .get(uri)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Gambar sumber tidak dapat diunduh (HTTP ${response.statusCode}). '
        'URL mungkin sudah kedaluwarsa. Masukkan URL gambar yang masih aktif.',
      );
    }

    if (response.bodyBytes.isEmpty) {
      throw Exception('File gambar kosong.');
    }

    final contentType = _getImageContentType(response.headers['content-type']);
    final extension = _extensionFor(contentType);
    final filePath =
        'plants/${plantId}_${DateTime.now().microsecondsSinceEpoch}.$extension';

    await _supabase.storage.from(_bucketName).uploadBinary(
          filePath,
          response.bodyBytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: false,
          ),
        );

    return _supabase.storage.from(_bucketName).getPublicUrl(filePath);
  }

  String _getImageContentType(String? header) {
    final normalized = header?.split(';').first.trim().toLowerCase();

    const supported = {
      'image/jpeg',
      'image/png',
      'image/webp',
      'image/gif',
      'image/avif',
    };

    if (normalized != null && supported.contains(normalized)) {
      return normalized;
    }

    // Perenual plant photos are normally JPEG. If the server omits the
    // content type, use JPEG as the safe default for this image source.
    if (normalized == null || normalized.isEmpty || normalized == 'application/octet-stream') {
      return 'image/jpeg';
    }

    throw Exception('Format gambar tidak didukung: $normalized');
  }

  String _extensionFor(String contentType) {
    switch (contentType) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/gif':
        return 'gif';
      case 'image/avif':
        return 'avif';
      case 'image/jpeg':
      default:
        return 'jpg';
    }
  }
}
