import 'package:flutterlone/data/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  Database? _database;

//   Khoi tao CSDL va tao bang
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'product_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, description TEXT, price REAL, image TEXT)'
        );
      },
      version: 1
    );
  }

//   Them san pham moi vao CSDL
  Future<void> insertProduct(Product product) async {
    final db = await database;

    await db!.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

//   Lay ds san pham tu CSDL
  Future<List<Product>> getProducts() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

//   Cap nhat san pham
  Future<void> updateProduct(Product product) async {
    final db = await database;

    await db!.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id]
    );
  }

//   Xoa san pham
  Future<void> deleteProduct(int id) async {
    final db = await database;

    await db!.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}