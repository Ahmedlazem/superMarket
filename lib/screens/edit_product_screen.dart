import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = 'edit_screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  bool isSelectedCat = false;
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
        updatedPRO.categories,
        softWrap: true,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      value: selectedCategories,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
          isSelectedCat = true;
        });
      },
    );
  }

  String id;
  Product updatedPRO;
  final _form1 = GlobalKey<FormState>();

  void saveForm() async {
    final isValid = _form1.currentState.validate();
    if (!isValid) {
      return;
    }

    _form1.currentState.save();
    await Provider.of<Products>(context, listen: false)
        .replaceAndUpdateByID(id, updatedPRO);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments as String;

    updatedPRO = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveForm(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form1,
          child: ListView(
            children: <Widget>[
              Container(
                height: 50,
                width: double.infinity,
                child: getCategoriesDropdown(),
              ),
              TextFormField(
                initialValue: updatedPRO.title,
                validator: (value) {
                  if (value.isEmpty) {
                    return ('this unexpected value');
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  updatedPRO = Product(
                      categories: isSelectedCat
                          ? selectedCategories
                          : updatedPRO.categories,
                      isOffer: updatedPRO.isOffer,
                      title: value,
                      imageUrl: updatedPRO.imageUrl,
                      description: updatedPRO.description,
                      stock: updatedPRO.stock,
                      id: updatedPRO.id,
                      price: updatedPRO.price);
                },
              ),
              TextFormField(
                initialValue: updatedPRO.price.toString(),
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
                onSaved: (value) {
                  updatedPRO = Product(
                      stock: updatedPRO.stock,
                      isOffer: updatedPRO.isOffer,
                      title: updatedPRO.title,
                      imageUrl: updatedPRO.imageUrl,
                      description: updatedPRO.description,
                      id: updatedPRO.id,
                      categories: isSelectedCat
                          ? selectedCategories
                          : updatedPRO.categories,
                      price: double.parse(value));
                },
              ),
              TextFormField(
                //stock data entry
                initialValue: updatedPRO.stock.toString(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'please enter your Stock Quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'please enter Stock Quantity';
                  }
                  if (int.parse(value) <= 0) {
                    return 'please enter Stock more than Zer0';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.phone,

                onSaved: (value) {
                  updatedPRO = Product(
                      stock: int.parse(value),
                      categories: isSelectedCat
                          ? selectedCategories
                          : updatedPRO.categories,
                      title: updatedPRO.title,
                      imageUrl: updatedPRO.imageUrl,
                      description: updatedPRO.description,
                      id: updatedPRO.id,
                      isOffer: updatedPRO.isOffer,
                      price: updatedPRO.price);
                },
              ),
              TextFormField(
                initialValue: updatedPRO.description,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'please enter valid description';
                  }
                  if (value.length < 10) {
                    return 'enter more than 10 character';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  updatedPRO = Product(
                    stock: updatedPRO.stock,
                    isOffer: updatedPRO.isOffer,
                    title: updatedPRO.title,
                    imageUrl: updatedPRO.imageUrl,
                    description: value,
                    id: updatedPRO.id,
                    price: updatedPRO.price,
                    categories: isSelectedCat
                        ? selectedCategories
                        : updatedPRO.categories,
                  );
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
                      child: Image.network(
                        updatedPRO.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: updatedPRO.imageUrl,
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
                      onSaved: (value) {
                        updatedPRO = Product(
                          isOffer: updatedPRO.isOffer,
                          stock: updatedPRO.stock,
                          title: updatedPRO.title,
                          imageUrl: value,
                          description: updatedPRO.description,
                          id: updatedPRO.id,
                          price: updatedPRO.price,
                          categories: isSelectedCat
                              ? selectedCategories
                              : updatedPRO.categories,
                        );
                      },
                      onFieldSubmitted: (_) {
                        // saveForm();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SwitchListTile(
                //selected: true,
                activeColor: Theme.of(context).primaryColor,
                value: updatedPRO.isOffer,
                onChanged: (val) {
                  updatedPRO.isOffer = val;
                  updatedPRO = Product(
                    isOffer: !updatedPRO.isOffer,
                    title: updatedPRO.title,
                    imageUrl: updatedPRO.imageUrl,
                    description: updatedPRO.description,
                    categories: isSelectedCat
                        ? selectedCategories
                        : updatedPRO.categories,
                    id: updatedPRO.id,
                    price: updatedPRO.price,
                    stock: updatedPRO.stock,
                  );
                  setState(() {
                    updatedPRO.isOffer = val;
                  });
                },
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.local_offer,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: updatedPRO.isOffer
                          ? Text('Remove THis Item from Offer')
                          : Text('Add this item to Offer'),
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
