// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {

    String id;
    String title;
    double price;
    bool available;
    String imgUrl;

    ProductoModel({
        this.id,
        this.title = '',
        this.price  = 0.0,
        this.available = true,
        this.imgUrl,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => new ProductoModel(
        id         : json["id"],
        title      : json["title"],
        price      : json["price"],
        available  : json["available"],
        imgUrl     : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        // "id"         : id,
        "title"      : title,
        "price"      : price,
        "available"  : available,
        "fotoUrl"    : imgUrl,
    };
}