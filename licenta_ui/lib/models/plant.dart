import 'dart:convert';

class Plant {
  final int id;
  final String species;

  Plant({this.id = 0, this.species = ''});

  @override
  String toString() {
    return 'id: $id   species: $species';
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(id: json["id"], species: json["species"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "species": species,
      };
}

List<Plant> plantsFromJson(String str) =>
    List<Plant>.from(json.decode(str).map((x) => Plant.fromJson(x)));

List<String> getSpecies(List<Plant> plants) =>
    List<String>.from(plants.map((plant) => plant.species));

String plantToJson(List<Plant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
