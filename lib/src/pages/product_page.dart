import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;




class ProductPage extends StatefulWidget {
  
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _picker = ImagePicker();
  
  ProductsBloc productsBloc;
  ProductoModel productM = new ProductoModel();
  bool _saving = false;
  File photo;
  

  @override
  Widget build(BuildContext context) {

    productsBloc = Provider.productsBloc(context);

    final ProductoModel productArguments = ModalRoute.of(context).settings.arguments;
    if ( productArguments !=null ) { productM = productArguments; }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:  Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _selectPhoto
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePic,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton()

              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _createName() {

    return TextFormField(
      initialValue: productM.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre del Producto'
      ),
      onSaved: (value) => productM.title = value,
      validator: (value) {
        if (value.length <3 ) {
          return 'Ingrese un nombre para el producto';
          
        } else {
          return null;
        }
      },
    );

  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: productM.price.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => productM.price = double.parse(value),
      validator: (value) {

        if ( utils.isNumeric(value) ) {
          return null;

        } else {
          return 'solo numeros';
        }
        
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: productM.available,
      title: Text('Disponible'), 
      activeColor: Color.fromRGBO(62, 133, 90, 1.0),
      onChanged: (value) {
        setState(() {
          productM.available = value;
        });
      }
    );
  }

  Widget _createButton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Color.fromRGBO(62, 133, 90, 1.0),
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_saving ) ? null : _submit,
    );
  }

  void _submit() async {

    if ( !formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() { _saving = true; });


    if (photo != null) {
      productM.imgUrl = await productsBloc.uploadImage(photo);
    } 

    if (productM.id == null) {
      productsBloc.createProduct(productM);
       showSnackbar('Registro Creado');
    } else {
      productsBloc.editProduct(productM);

      // setState(() { _saving = false; });
      showSnackbar('Registro Guardado');
    }    
     Navigator.pop(context);

  }
  
  void showSnackbar( String message ) {
    
    final snackbar = SnackBar(
      content: Text( message ),
      duration: Duration( milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

 
 Widget _showPhoto() {
   
  if (productM.imgUrl != null) {
  
        return FadeInImage(
          image: NetworkImage(productM.imgUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.fill,
        );
  
      } else {
  
        if( photo != null ){
          return Image.file(
            photo,
            fit: BoxFit.cover,
            height: 300.0,
          );
        }
        return Image.asset('assets/no-image.png');
      }
 }
 
 Future _selectPhoto() async {
    
    PickedFile image = await _picker.getImage(
      source: ImageSource.gallery
    );
    
    photo = File(image.path);

    if (photo != null) {
        productM.imgUrl = null;
      } 

    setState(() {});

  }

  Future _takePic() async{

    PickedFile image = await _picker.getImage(
      source: ImageSource.camera
    );
    
    photo = File(image.path);

    if (photo != null) {
        productM.imgUrl = null;
      } 

    setState(() {});

    
  }
}