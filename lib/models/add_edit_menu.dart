// To parse this JSON data, do
//
//     final addEditMenu = addEditMenuFromJson(jsonString);

import 'dart:convert';

AddEditMenu addEditMenuFromJson(String str) => AddEditMenu.fromJson(json.decode(str));

String addEditMenuToJson(AddEditMenu data) => json.encode(data.toJson());

class AddEditMenu {
    List<DropdownWarung> dropdownWarungs;

    AddEditMenu({
        required this.dropdownWarungs,
    });

    factory AddEditMenu.fromJson(Map<String, dynamic> json) => AddEditMenu(
        dropdownWarungs: List<DropdownWarung>.from(json["dropdown_warungs"].map((x) => DropdownWarung.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "dropdown_warungs": List<dynamic>.from(dropdownWarungs.map((x) => x.toJson())),
    };
}

class DropdownWarung {
    int id;
    String nama;

    DropdownWarung({
        required this.id,
        required this.nama,
    });

    factory DropdownWarung.fromJson(Map<String, dynamic> json) => DropdownWarung(
        id: json["id"],
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
    };
}
