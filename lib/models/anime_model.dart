class Anime {
  final int id;
  final String name;
  final String imageUrl;
  final String familyCreator;

  Anime({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.familyCreator,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] ?? 0,
      name: json['name'] ?? "noName",
      imageUrl: (json['images'] != null &&
              json['images'] is List &&
              json['images'].isNotEmpty)
          ? json['images'][0]
          : 'https://via.placeholder.com/600x400',
      familyCreator: _extractFamilyCreator(json['family']),
    );
  }

  static String _extractFamilyCreator(dynamic family) {
    if (family == null || family is! Map) return "Gaada Keluarga";

    // Jika ada key 'creator', pakai itu
    if (family.containsKey('creator')) {
      return family['creator'] ?? "family is null";
    }

    // Ambil salah satu nilai pertama yang tersedia (misal father, mother, dsb)
    if (family.isNotEmpty) {
      return family.values.first.toString();
    }

    return "family is null";
  }
}
