import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add_product_screen';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<String> categories = const [
    'Beverages',
    'Bakery',
    'Canned',
    'Dairy',
    'Dry',
    'Frozen-Food',
    'Meet',
    'Produce',
    'Cleaners',
    'Paper-Goods',
    'Personal-Care',
    'Other'
  ];
  String selectedCategories;
  bool _selectedOffer = false;

  DropdownButton<String> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String cat in categories) {
      var newItem = DropdownMenuItem(
        child: Text(cat),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      icon: Icon(
        Icons.format_align_justify,
        size: 20,
        color: Theme.of(context).accentColor,
      ),
      elevation: 5,
      hint: Text(
        'Urgent select Item Categories',
        softWrap: true,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      value: selectedCategories,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
        });
      },
    );
  }

  bool _isLoading = false;
  final _priceFocusNode = FocusNode();
  final _stockFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageTextController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var addNewProduct = Product(
      title: '',
      price: 0.0,
      stock: 0,
      id: null,
      description: '',
      imageUrl: '',
      categories: '',
      isOffer: false);

  @override
  void initState() {
    // add listener to image focus hence remove from its field we can update uI by using set state
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    // we should dispose focus node when leave the widget to remove data from memory its important.
    _imageFocusNode.removeListener(_updateImage);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _stockFocusNode.dispose();
    _imageTextController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() async {
    final isValid = _form.currentState.validate();
    if (selectedCategories == null) {
      return showDialog<Null>(
        // ignore: deprecated_member_use
        // child:OfflineError() ,
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          backgroundColor: Colors.red,
          content: Text('please select category'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(addNewProduct);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          backgroundColor: Colors.red,
          content: Text(
              'Something went wrong.Check internet Connection and try again'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(children: <Widget>[
                  getCategoriesDropdown(),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return ('this unexpected value');
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Title'),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                      //to transit the focus pointer automatic to next field by helping focus node
                    },
                    onSaved: (value) {
                      addNewProduct = Product(
                          stock: addNewProduct.stock,
                          isOffer: addNewProduct.isOffer,
                          categories: selectedCategories,
                          title: value,
                          imageUrl: addNewProduct.imageUrl,
                          description: addNewProduct.description,
                          id: null,
                          price: addNewProduct.price);
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'please enter valid price';
                      }
                      if (double.parse(value) <= 0) {
                        return 'please enter Price more than Zer0';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_stockFocusNode);
                    },
                    onSaved: (value) {
                      addNewProduct = Product(
                          categories: selectedCategories,
                          title: addNewProduct.title,
                          imageUrl: addNewProduct.imageUrl,
                          description: addNewProduct.description,
                          id: null,
                          stock: addNewProduct.stock,
                          isOffer: addNewProduct.isOffer,
                          price: double.parse(value));
                    },
                  ),
                  TextFormField(
                    //stock data entry
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your Stock Quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'please enter Stock Quantity';
                      }
                      if (int.tryParse(value) <= 0) {
                        return 'please enter Stock more than Zer0';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.phone,
                    focusNode: _stockFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      addNewProduct = Product(
                          stock: int.parse(value),
                          categories: selectedCategories,
                          title: addNewProduct.title,
                          imageUrl: addNewProduct.imageUrl,
                          description: addNewProduct.description,
                          id: null,
                          isOffer: addNewProduct.isOffer,
                          price: addNewProduct.price);
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter valid description';
                      }
                      if (value.length < 5) {
                        return 'enter more than 10 character';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      addNewProduct = Product(
                          stock: addNewProduct.stock,
                          categories: selectedCategories,
                          title: addNewProduct.title,
                          imageUrl: addNewProduct.imageUrl,
                          description: value,
                          id: null,
                          isOffer: addNewProduct.isOffer,
                          price: addNewProduct.price);
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blueGrey),
                        ),
                        child: FittedBox(
                          child: _imageTextController.text.isEmpty
                              ? Text('Image URL View')
                              : Image.network(
                                  _imageTextController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter your URL';
                            }
                            if (!value.startsWith('http') ||
                                !value.startsWith('https')) {
                              return 'enter valid URL';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          controller: _imageTextController,
                          focusNode: _imageFocusNode,
                          onSaved: (value) {
                            addNewProduct = Product(
                                categories: selectedCategories,
                                title: addNewProduct.title,
                                stock: addNewProduct.stock,
                                imageUrl: value,
                                description: addNewProduct.description,
                                id: null,
                                isOffer: addNewProduct.isOffer,
                                price: addNewProduct.price);
                          },
                          onFieldSubmitted: (_) {
                            saveForm();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  SwitchListTile(
                    // selected: true,
                    //secondary: ,
                    activeColor: Theme.of(context).primaryColorDark,
                    value: _selectedOffer,
                    onChanged: (val) {
//                      val = true;

                      setState(() {
                        _selectedOffer = val;
                        print(_selectedOffer);
                        print(selectedCategories);
                      });
                      addNewProduct = Product(
                        isOffer: _selectedOffer,
                        title: addNewProduct.title,
                        imageUrl: addNewProduct.imageUrl,
                        description: addNewProduct.description,
                        id: null,
                        price: addNewProduct.price,
                        stock: addNewProduct.stock,
                        categories: selectedCategories,
                      );
                    },
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.local_offer,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          'is this Offer item?',
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    child: RaisedButton.icon(
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        saveForm();
                      },
                      icon: Icon(Icons.save),
                      label: Text('Submitted'),
                    ),
                  )
                ]),
              ),
            ),
    );
  }
}
