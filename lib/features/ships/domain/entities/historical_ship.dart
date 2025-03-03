class HistoricalShip {
  final String name;
  final String country;
  final int yearCommissioned;
  final double displacement;
  final double length;
  final double beam;
  final double draft;
  final double maxSpeed;
  final String imageUrl;
  final String description;
  final List<String> armament;

  HistoricalShip({
    required this.name,
    required this.country,
    required this.yearCommissioned,
    required this.displacement,
    required this.length,
    required this.beam,
    required this.draft,
    required this.maxSpeed,
    required this.imageUrl,
    required this.description,
    required this.armament,
  });
} 