// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    int id;
    String user;
    Menu menu;
    List<Category> categories;
    String? assignedCategory; // Properti tambahan untuk menyimpan kategori yang di-assign

    Wishlist({
        required this.id,
        required this.user,
        required this.menu,
        required this.categories,
        this.assignedCategory,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json["id"],
        user: json["user"],
        menu: Menu.fromJson(json["menu"]),
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        assignedCategory: json["assigned_category"], // Menangkap properti assigned_category dari JSON jika ada
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "menu": menu.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "assigned_category": assignedCategory, // Tambahkan assigned_category ke JSON jika diperlukan
    };
}


class Category {
    int id;
    String name;

    Category({
        required this.id,
        required this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Menu {
    int id;
    String name;
    int harga;
    String warung;
    String gambar;

    Menu({
        required this.id,
        required this.name,
        required this.harga,
        required this.warung,
        required this.gambar,
    });

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"],
        harga: json["harga"],
        warung: json["warung"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "harga": harga,
        "warung": warung,
        "gambar": gambar,
    };
}