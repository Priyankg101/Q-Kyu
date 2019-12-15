import 'package:flutter/material.dart';

import '../model/codevalue.dart';

class ItemList extends StatelessWidget {
  final List<CodeValue> codevalue;
  final Function deleteItem;
  final Function addqty;
  final Function reduceqty;

  ItemList(this.codevalue, this.deleteItem, this.addqty, this.reduceqty);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: codevalue.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Items added yet!',
                    style: TextStyle(
                        color: Color.fromRGBO(56, 52, 67, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                      height: 200,
                      child: Image.asset(
                        'assets/emptycart.png',
                        color: Color.fromRGBO(56, 52, 67, 1),
                        fit: BoxFit.cover,
                      ))
                ],
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                    height: 150,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color.fromRGBO(150, 153, 168, 1),
                              radius: 30,
                              child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: FittedBox(
                                      child: Text(
                                    '₹${codevalue[index].price}',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ),
                            title: Text('${codevalue[index].prodname}'),
                            subtitle: Text('Quantity: ${codevalue[index].qty}'),
                            trailing: FittedBox(
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () =>
                                    deleteItem(codevalue[index].id),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    iconSize: 35,
                                    color: Color.fromRGBO(251, 92, 8, 1),
                                    onPressed: () =>
                                        addqty(codevalue[index].id),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    iconSize: 35,
                                    color: Color.fromRGBO(251, 92, 8, 1),
                                    onPressed: () =>
                                        reduceqty(codevalue[index].id),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                  '${codevalue[index].price * codevalue[index].qty}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: codevalue.length,
              ));
  }
}
