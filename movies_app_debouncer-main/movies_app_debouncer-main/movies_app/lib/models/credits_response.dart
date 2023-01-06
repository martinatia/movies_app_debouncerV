// To parse this JSON data, do
//
//     final credits = creditsFromMap(jsonString);

import 'dart:convert';

class CreditsResponse {
  CreditsResponse({
    required this.id,
    required this.cast,
  });

  int id;
  List<Cast> cast;

  factory CreditsResponse.fromJson(String str) =>
      CreditsResponse.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory CreditsResponse.fromMap(Map<String, dynamic> json) => CreditsResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromMap(x))),
      );

  // Map<String, dynamic> toMap() => {
  //       "id": id,
  //       "cast": List<dynamic>.from(cast.map((x) => x.toMap())),
  //     };
}

class Cast {
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });
  get fullProfilePath {
    if (profilePath != null)
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    return ('https://i.stack.imgur.com/GNhxO.png');
  }

  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  int castId;
  String character;
  String creditId;
  int order;

  factory Cast.fromJson(String str) => Cast.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
      );

  // Map<String, dynamic> toMap() => {
  //       "adult": adult,
  //       "gender": gender,
  //       "id": id,
  //       "known_for_department":
  //           knownForDepartmentValues.reverse[knownForDepartment],
  //       "name": name,
  //       "original_name": originalName,
  //       "popularity": popularity,
  //       "profile_path": profilePath == null ? null : profilePath,
  //       "cast_id": castId,
  //       "character": character,
  //       "credit_id": creditId,
  //       "order": order,
  //     };
}

// enum KnownForDepartment { ACTING }

// final knownForDepartmentValues = EnumValues({
//     "Acting": KnownForDepartment.ACTING
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }
