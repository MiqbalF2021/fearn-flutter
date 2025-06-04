class Location {
  final String id;
  final String name;
  final String area;
  final Polygon polygon;
  final String? type;
  final Region region;

  Location({
    required this.id,
    required this.name,
    required this.area,
    required this.polygon,
    this.type,
    required this.region,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      polygon: Polygon.fromJson(json['polygon']),
      type: json['type'],
      region: Region.fromJson(json['region']),
    );
  }
}

class Polygon {
  final String type;
  final List<List<List<dynamic>>> coordinates;

  Polygon({
    required this.type,
    required this.coordinates,
  });

  factory Polygon.fromJson(Map<String, dynamic> json) {
    return Polygon(
      type: json['type'],
      coordinates: (json['coordinates'] as List).map((outerList) {
        return (outerList as List).map((innerList) {
          return (innerList as List).cast<dynamic>().toList();
        }).toList();
      }).toList(),
    );
  }
}

class Region {
  final String id;
  final String name;
  final PlantationGroup plantationGroup;

  Region({
    required this.id,
    required this.name,
    required this.plantationGroup,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      plantationGroup: PlantationGroup.fromJson(json['plantationGroup']),
    );
  }
}

class PlantationGroup {
  final String id;
  final String name;

  PlantationGroup({
    required this.id,
    required this.name,
  });

  factory PlantationGroup.fromJson(Map<String, dynamic> json) {
    return PlantationGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}