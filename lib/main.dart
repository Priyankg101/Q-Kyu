import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner/widgets/item_list.dart';
import 'package:simple_permissions/simple_permissions.dart';
import './model/codevalue.dart';

import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _reader = '';
  final List<CodeValue> _database = [
    CodeValue(id: '8902519003300', prodname: 'Notebook', price: 45.0, qty: 1),
    CodeValue(id: '8901063092334', prodname: 'Good Day', price: 5.0, qty: 1),
    CodeValue(id: '8901491983143', prodname: 'Orange Lays', price: 10.0, qty: 1),
    CodeValue(id: '8901491983150', prodname: 'Blue Lays', price: 10, qty: 1)
  ];
  List<CodeValue> _usercart = [];

  CodeValue get _currentitem {
    return _database.lastWhere((tx) {
      return _reader == tx.id;
    });
  }

  void _addNewItem(currentitem) {
    _usercart.add(currentitem);
  }

  void _deleteitem(String id) {
    setState(() {
      _usercart.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _addqty(String id) {
    setState(() {
      _usercart.firstWhere((tx) {
        return tx.id == id;
      }).qty++;
    });
  }

  void _reduceqty(String id) {
    if (_usercart.firstWhere((tx) {
          return tx.id == id;
        }).qty >
        1)
      setState(() {
        _usercart.firstWhere((tx) {
          return tx.id == id;
        }).qty--;
      });
  }

  double _total(_usercart) {
    double tot = 0;
    for (int i = 0; i < _usercart.length; i++) {
      tot = tot + _usercart[i].price * _usercart[i].qty;
    }
    return tot;
  }

  Permission permission = Permission.Camera;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.pinkAccent,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(150, 153, 168, 1),
        drawer: Builder(
          builder: (context) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 150,
                  child: DrawerHeader(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: 50,
                            child: Image.asset(
                              'assets/265972.png',
                              color: Color.fromRGBO(251, 92, 8, 1),
                              //fit: BoxFit.cover,
                            )),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Container(
                            child: Text("Welcome",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ))),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(57, 53, 70, 1),
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.history),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('History'),
                    ],
                  ),
                  onTap: () {
                    // ...
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.bookmark),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('Reminder'),
                    ],
                  ),
                  onTap: () {
                    // ...
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Q KYU"),
          backgroundColor: Color.fromRGBO(93, 79, 94, 1),
          iconTheme: new IconThemeData(color: Color.fromRGBO(239, 89, 8, 1)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: SizedBox(
                    height: 200,
                    child:
                        ItemList(_usercart, _deleteitem, _addqty, _reduceqty))),
            Container(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                        splashColor: Colors.greenAccent,
                        color: Color.fromRGBO(239, 89, 8, 1),
                        child: Text(
                          "Scan",
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                        onPressed: scan),
                    Text(
                      "Total: ${_total(_usercart)}",
                      style: TextStyle(
                          color: Color.fromRGBO(93, 79, 94, 1),
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text("Check Out",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
   void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child:QrImage(
              data: _total(_usercart).toString(),
              backgroundColor: Colors.white,
            ),);}
    );
   }

          
  requestPermission() async {
    PermissionStatus result =
        await SimplePermissions.requestPermission(permission);
    setState(
      () => new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(" $result"),
      ),
    );
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }
      // _startAddNewTransaction(context);
      setState(() => this._reader = reader);

      _addNewItem(_currentitem);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      } else {
        setState(() => _reader = "unknown exception $e");
      }
    } on FormatException {
      setState(() => _reader = '');
    } catch (e) {
      setState(() => _reader = 'Unknown error: $e');
    }
  }
}
