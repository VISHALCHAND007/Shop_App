import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/temp_product.dart';
import 'package:shop_app/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = "/edit-product";

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _editedProduct = TempProduct(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
  );
  var _init = false;
  var isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(loadImg);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_init) {
      _init = true;
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null && productId.isNotEmpty) {
        var product = Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).findByInd(productId);
        _editedProduct.id = product.id;
        _editedProduct.title = product.title;
        _editedProduct.description = product.description;
        _editedProduct.price = product.price;
        _editedProduct.imageUrl = product.imageUrl;
        _imageURLController.text = product.imageUrl;
        _editedProduct.isFavourite = product.isFavourite;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageURLController.dispose();
    _imageFocusNode.removeListener(loadImg);
    _imageFocusNode.dispose();
    super.dispose();
  }

  void loadImg() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    var isValid = _form.currentState?.validate();
    if (isValid != null && isValid) {
      _form.currentState?.save();
      setState(() {
        isLoading = true;
      });
      if (_editedProduct.id.isEmpty) {
        //adding product
        Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).addProduct(_editedProduct).then((_) {
          setState(() {
            // isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } else {
        //editing product
        Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).updateProduct(_editedProduct, _editedProduct.id);
        //     .then((_) {
        //   setState(() {
        //     isLoading = true;
        //   });
        // });
        Navigator.of(context).pop();
      }
    }
  }

  String? _simpleValidator(String? enteredValue, String errorMsg) {
    if (enteredValue != null && enteredValue.isEmpty) {
      return errorMsg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.check))],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (value) =>
                          _simpleValidator(value, "Enter a title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        if (value != null) _editedProduct.title = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Enter a price";
                        }
                        if (double.tryParse(value!) == null) {
                          return "Enter a valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Price should be greate than zero.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      onSaved: (value) {
                        if (value != null)
                          _editedProduct.price = double.parse(value);
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: InputDecoration(labelText: "Description"),
                      validator: (value) =>
                          _simpleValidator(value, "Enter description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        if (value != null) _editedProduct.description = value;
                      },
                    ),
                    Row(
                      crossAxisAlignment: .end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _imageURLController.text.isNotEmpty
                              ? FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(Icons.image_not_supported_outlined),
                                    Text("Enter URL"),
                                  ],
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _editedProduct.imageUrl,
                            decoration: InputDecoration(labelText: "Image URL"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter valid image url";
                              }
                              var uri = Uri.tryParse(value);
                              if (uri == null ||
                                  !uri.hasScheme ||
                                  !(uri.scheme == "http" ||
                                      uri.scheme == "https")) {
                                return "Please enter a valid URL (http or https)";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLController,
                            focusNode: _imageFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              if (value != null)
                                _editedProduct.imageUrl = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
