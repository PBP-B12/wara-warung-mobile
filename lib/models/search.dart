// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'dart:convert';

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

String searchToJson(Search data) => json.encode(data.toJson());

class Search {
    List<Result> results;

    Search({
        required this.results,
    });

    factory Search.fromJson(Map<String, dynamic> json) => Search(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    String menu;
    int harga;
    String warung;
    String gambar;
    int id;
    int avgRating;

    Result({
        required this.menu,
        required this.harga,
        required this.warung,
        required this.gambar,
        required this.id,
        required this.avgRating,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        menu: json["menu"],
        harga: json["harga"],
        warung: json["warung"],
        gambar: json["gambar"],
        id: json["id"],
        avgRating: json["avg_rating"],
    );

    Map<String, dynamic> toJson() => {
        "menu": menu,
        "harga": harga,
        "warung": warung,
        "gambar": gambar,
        "id": id,
        "avg_rating": avgRating,
    };
}