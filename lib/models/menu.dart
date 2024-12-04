// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

List<Menu> menuFromJson(String str) =>
    List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

String menuToJson(List<Menu> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menu {
  Model model;
  int pk;
  Fields fields;

  Menu({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String warung;
  String menu;
  int harga;
  String gambar;

  Fields({
    required this.warung,
    required this.menu,
    required this.harga,
    required this.gambar,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        warung: json["warung"],
        menu: json["menu"],
        harga: json["harga"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "warung": warung,
        "menu": menu,
        "harga": harga,
        "gambar": gambar,
      };
}

enum Model { MENU_MENU }

final modelValues = EnumValues({"menu.menu": Model.MENU_MENU});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
