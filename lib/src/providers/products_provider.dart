import 'dart:convert';
import 'dart:io';

import 'package:form_validation/src/share_pref/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/models/product_model.dart';



class ProductsProviders {

  final String _url = 'https://f-varios-default-rtdb.firebaseio.com';
  final _prefs = new PreferencesUser();


  Future<bool>createProduct( ProductoModel product ) async {

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.post( url, body: productoModelToJson(product));
    
    // se paga el string json a objeto tipo json.
    final decodedData = json.decode(response.body);

    print( decodedData);

    return true;
  }

  Future<List<ProductoModel>> loadProducts() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic>decodedData = json.decode(resp.body);
    final List<ProductoModel> products = new List();

    if ( decodedData == null ) return [];
    if ( decodedData['error'] != null ) return [];
     
    
    decodedData.forEach((id, product) {
      final prodTemp = ProductoModel.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<bool> deleteProduct( String id ) async {

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    await http.delete(url);

    return true;
  }

    Future<bool>updateProduct( ProductoModel product ) async {

    final url = '$_url/productos/${product.id}.json?auth=${_prefs.token}';

    final response = await http.put( url, body: productoModelToJson(product));
    
    // se paga el string json a objeto tipo json.
    final decodedData = json.decode(response.body);

    print( decodedData);

    return true;
  }

  Future<String> uploadImage( File image ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/your-key/image/upload?upload_preset=your-key');
    final mimeType = mime(image.path).split('/'); // image/jpge

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

     if ( resp.statusCode !=200 && resp.statusCode != 201) {
       print('algo salio mal ');
       print(resp.body);
       return null;
       
     } else {

       final responseDate = json.decode(resp.body);
       return responseDate['secure_url'];
     }
    
  }

}