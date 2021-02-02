import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';



class ProductsBloc {

  final _productsController = new BehaviorSubject<List<ProductoModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProviders();


  Stream<List<ProductoModel>> get productsStream => _productsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;


  void getProducts() async {
    final products = await _productsProvider.loadProducts();

    _productsController.sink.add(products);
  }

  void createProduct( ProductoModel product) async {

    // tell to string there is loading a product to the stream;
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    // tell to string the product was load;
    _loadingController.sink.add(false);

  }

  Future<String> uploadImage( File image) async {
    _loadingController.sink.add(true);
    final imageUrl = await _productsProvider.uploadImage(image);
    _loadingController.sink.add(false);

    return imageUrl;

  }

  void editProduct( ProductoModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);

  }

  void deleteProduct( String id) async {
    await _productsProvider.deleteProduct(id);

  }


  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
  
}