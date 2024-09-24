import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterlone/data/model/product.dart';
import 'package:flutterlone/data/repository/product_repository.dart';
import 'package:flutterlone/screen/product/product_detail_screen.dart';
import 'package:flutterlone/screen/widget/snack_bar_widget.dart';
import 'package:flutterlone/screen/widget/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeProductScreen extends StatelessWidget {
  const HomeProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeGridProduct();
  }
}

class HomeGridProduct extends StatefulWidget {
  const HomeGridProduct({super.key});

  @override
  State<HomeGridProduct> createState() => _HomeGridProductState();
}

class _HomeGridProductState extends State<HomeGridProduct> {

  List<Product> productList = [];
  final ProductRepository repository = ProductRepository();

  // Ham khoi tao ban dau
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Load lai danh sach sp khi co su thay doi
  Future<void> _loadProducts() async {
    final products = await repository.getProducts();
    setState(() {
      productList = products;
    });
  }

  // Luu lai san pham moi them va load lai danh sach san pham
  Future<void> _addProduct(Product product) async {
    await repository.insertProduct(product);
    _loadProducts();
  }

  // Dialog add new product
  Future<void> _showAddProductDialog() async {
    String name = '';
    String description = '';
    double price = 0.0;
    File? imageFile;
    final picker = ImagePicker();

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add New Product'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: 'Name Product',
                        hintText: 'Enter name Product',
                        onChanged: (value) => name = value,
                      ),
                      CustomTextField(
                        labelText: 'Description Product',
                        hintText: 'Enter description Product',
                        onChanged: (value) => description = value,
                      ),
                      CustomTextField(
                        labelText: 'Price Product',
                        hintText: 'Enter price Product',
                        onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 15,),
                      imageFile != null
                          ? Image.file(
                        imageFile!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : Text('No image selected'),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery
                            );
                            if (pickedFile != null) {
                              setState(() {
                                imageFile = File(pickedFile.path);
                              });
                            }
                          },
                          child: const Text('Choose Image')
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (name.isNotEmpty && imageFile != null) {
                          final newProduct = Product(
                              id: DateTime.now().millisecondsSinceEpoch,
                              name: name,
                              description: description,
                              price: price,
                              image: imageFile!.path
                          );
                          _addProduct(newProduct);
                          showCustomSnackBar(
                              context, 'Add new product successfully !!!',
                              Colors.green);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add')
                  )
                ],
              );
            }
            
          );
        }
    );
  }

  // Dialog sưa
  Future<void> _showEditProductDialog(Product product) async {
    final TextEditingController nameController = TextEditingController(text: product.name);
    final TextEditingController descriptionController = TextEditingController(text: product.description);
    final TextEditingController priceController = TextEditingController(text: product.price.toStringAsFixed(2));
    File? imageFile = product.image.isNotEmpty ? File(product.image) : null;
    final picker = ImagePicker();

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Update Product'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: 'Name Product',
                          hintText: 'Enter name Product',
                          controller: nameController,
                        ),
                        CustomTextField(
                          labelText: 'Description Product',
                          hintText: 'Enter description Product',
                          controller: descriptionController,
                        ),
                        CustomTextField(
                          labelText: 'Price Product',
                          hintText: 'Enter price Product',
                          controller: priceController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 15,),
                        imageFile != null
                            ? Image.file(
                          imageFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                            : Text('No image selected'),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  imageFile = File(pickedFile.path);
                                });
                              }
                            },
                            child: Text('Choose Image')
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isNotEmpty) {
                            final updatedProduct = Product(
                                id: product.id,
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.tryParse(priceController.text) ?? 0.0,
                                image: imageFile?.path ?? product.image
                            );
                            await repository.updateProduct(updatedProduct);
                            _loadProducts();
                            showCustomSnackBar(
                                context, 'Update product successfully !!!',
                                Colors.green);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Update')
                    )
                  ],
                );
              }

          );
        }
    );
  }

  // Xac nhan xoa
  Future<void> _showDeleteProductDialog(int id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete product'),
            content: Text('Are you sure you want to delete this product?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')
              ),
              ElevatedButton(
                  onPressed: () async {
                    await repository.deleteProduct(id);
                    _loadProducts();
                    showCustomSnackBar(
                        context, 'Delete product Successfully !!!',
                        Colors.green);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete')
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Product'),
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 2, // Số cột tổng, tương đương với 'crossAxisCount' trong GridView
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product)
                  )
              );
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(product.image),
                        height: 150, // Chỉnh chiều cao của hình ảnh
                        width: double.infinity, // Đảm bảo hình ảnh chiếm hết chiều rộng
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(product.name),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>_showEditProductDialog(product),
                        icon: Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () => _showDeleteProductDialog(product.id),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1), // Điều chỉnh số ô mà mỗi item chiếm, ở đây là 2 cột
        mainAxisSpacing: 4.0, // Khoảng cách giữa các item theo chiều dọc
        crossAxisSpacing: 4.0, // Khoảng cách giữa các item theo chiều ngang
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddProductDialog,
          child: const Icon(Icons.add),
      ),
    );
  }
}


