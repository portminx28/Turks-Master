import 'package:flutter/material.dart';
import 'package:turks/widgets/appbar_widget.dart';
import 'package:turks/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/cloud_function/add_sales.dart';
import '../../widgets/button_widget.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final box = GetStorage();

  late String item;

  int qty = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(box.read('productName')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              box.read('productURL'),
              height: 250,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: ListTile(
              leading:
                  TextBold(text: 'Price', fontSize: 18, color: Colors.black),
              trailing: TextBold(
                  text: box.read('productPrice').toString(),
                  fontSize: 18,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: ListTile(
              leading:
                  TextBold(text: 'Quantity', fontSize: 18, color: Colors.black),
              trailing: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (qty == 0) {
                            } else {
                              qty--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove)),
                    TextBold(
                        text: qty.toString(), fontSize: 18, color: Colors.grey),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            qty++;
                          });
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            child: ListTile(
              leading: TextBold(
                  text: 'Expiration Date', fontSize: 18, color: Colors.black),
              trailing: TextBold(
                  text: box.read('productExDate'),
                  fontSize: 18,
                  color: Colors.grey),
            ),
          ),
          const Expanded(child: SizedBox()),
          ButtonWidget(
              onPressed: () {
                if (qty != 0) {
                  addSales(box.read('productName'), box.read('productPrice'),
                      qty.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to Sales'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cannot Procceed! Quantity must not be 0'),
                    ),
                  );
                }
              },
              text: 'Add Sales'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
