import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/product_model.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

     final productsBloc = Provider.productsBloc(context);
     productsBloc.getProducts();
    
    return Scaffold(
      appBar: AppBar (
        title: Text('Home Page'),
      ),
      body: _createList(productsBloc),
      floatingActionButton: _createBotton(context),
    );
  }

  Widget _createBotton(BuildContext context) {
    return FloatingActionButton(
      child:Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: ()=>Navigator.pushNamed(context, 'product'),
    );
  }

  Widget _createList(ProductsBloc productsBloc) {

    // stream builder es el que se encargara de buscar en el stream del bloc 
    //la información del producto para cargar el listado

    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>>snapshot){

        if (snapshot.hasData) {
          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _createItems(context, productsBloc, products[index]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItems(BuildContext context, ProductsBloc productsBloc, ProductoModel product) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( direction ){
        productsBloc.deleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            ( product.imgUrl == null ) 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage(product.imgUrl),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
             ListTile(
              title: Text('${product.title} - ${product.price} '),
              subtitle: Text('${product.id}'),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
            ),
          ],
        ),
      )
    );



  }
}