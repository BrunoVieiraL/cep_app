import 'dart:io';
import 'package:cep_app/models/address_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddressDataBase {
  AddressDataBase._();
  static final AddressDataBase instance = AddressDataBase._();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'address.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE address(
  cep TEXT PRIMARY KEY,
  logradouro TEXT,
  complemento TEXT,
  bairro TEXT,
  localidade TEXT,
  uf TEXT,
  ibge TEXT,
  gia TEXT,
  ddd TEXT,
  siafi TEXT)
''');
  }

  Future<List<AddressModel>> getAddress(String logradouro) async {
    Database db = await instance.database;
    var queryAddress = await db.query('address',
        orderBy: 'cep', where: 'logradouro = ?', whereArgs: [logradouro]);

    List<AddressModel> addressList = queryAddress.isNotEmpty
        ? queryAddress.map((element) => AddressModel.fromJson(element)).toList()
        : [];

    return addressList;
  }

  Future<List<AddressModel>> getCEP(String cep) async {
    Database db = await instance.database;
    var queryAddress = await db
        .query('address', orderBy: 'cep', where: 'cep = ?', whereArgs: [cep]);

    List<AddressModel> addressList = queryAddress.isNotEmpty
        ? queryAddress.map((element) => AddressModel.fromJson(element)).toList()
        : [];

    return addressList;
  }

  Future<List<AddressModel>> getAllCEP() async {
    Database db = await instance.database;
    var queryAddress = await db.query('address', orderBy: 'cep', where: 'cep');

    List<AddressModel> addressList = queryAddress.isNotEmpty
        ? queryAddress.map((element) => AddressModel.fromJson(element)).toList()
        : [];

    return addressList;
  }

  Future<int> addAddress(AddressModel address) async {
    Database db = await instance.database;
    return await db.insert('address', address.toJson());
  }

  Future<int> deleteAddress(String cep) async {
    Database db = await instance.database;
    return await db.delete('address', where: 'cep = ?', whereArgs: [cep]);
  }
}
