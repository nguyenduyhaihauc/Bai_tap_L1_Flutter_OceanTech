import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterlone/data/model/product.dart';

class ProductDetailPage extends StatefulWidget {

  final Product product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
      ),
      body: Column(
        children: [
          Image.file(
            File(widget.product.image),
            height: 250,
            width: 350,
          ),
          Text(
            widget.product.name,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600
            ),
          ),
          Text(
            '\$${widget.product.price}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}

