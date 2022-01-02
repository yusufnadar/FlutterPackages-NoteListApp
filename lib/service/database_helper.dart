import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_packages/model/category_model.dart';
import 'package:flutter_packages/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    var exists = await databaseExists(path);
    if (!exists) {
      var data = await rootBundle.load(join('assets', filePath));
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path);
  }

  Future<List<CategoryModel>?> getCategories() async {
    try {
      var db = await instance.database;
      var tempList = <CategoryModel>[];
      var categories = await db.query('categories');
      for (var item in categories) {
        tempList.add(CategoryModel.fromjson(item));
      }
      return tempList;
    } catch (e) {
      print('get categories $e');
      return null;
    }
  }

  Future<bool?> addCategories(CategoryModel category) async {
    try {
      var db = await instance.database;
      await db.insert('categories', category.toJson());
      return true;
    } catch (e) {
      print('add categories hatalı $e');
      return null;
    }
  }

  Future<bool?> editCategory(CategoryModel category) async{
    try{
      var db = await instance.database;
      await db.update('categories', category.toJson(),where: 'id = ?',whereArgs: [category.id]);
      return true;
    }catch(e){
      print('edit categories hatalı $e');
      return null;
    }
  }

  Future<bool?> deleteCategory(id)async{
    try{
      var db = await instance.database;
      await db.delete('categories',where: 'id = ?',whereArgs: [id]);
      return true;
    }catch(e){
      print('delete category hata $e');
      return null;
    }
  }

  Future<List<NoteModel>?> getNotes(id)async{
    try{
      var db = await instance.database;
      var tempList = <NoteModel>[];
      var notes = await db.query('note',where: 'categoryId = ?',whereArgs: [id]);
      for(var item in notes){
        tempList.add(NoteModel.fromjson(item));
      }
      return tempList;
    }catch(e){
      print('get notes hatalı $e');
      return null;
    }
  }

  Future<bool?> addNote(NoteModel noteModel)async{
    try{
      var db = await instance.database;
      await db.insert('note', noteModel.toJson());
      return true;
    }catch(e){
      print('add note hatalı $e');
      return null;
    }
  }

  Future<bool?> editNote(NoteModel noteModel)async{
    try{
      var db = await instance.database;
      await db.update('note', noteModel.toJsonCompletedNot(),where: 'id = ?',whereArgs: [noteModel.id]);
      return true;
    }catch(e){
      print('update note hata $e');
      return null;
    }
  }

  Future changeCompleted(id,deger)async{
    if(deger == 0){
      deger = 1;
    }else {
      deger = 0;
    }
    try{
      var db = await instance.database;
      await db.update('note', {'completed':deger},where: 'id = ?',whereArgs: [id]);
      return true;
    }catch(e){
      print('update note hata $e');
      return null;
    }
  }

  Future deletNote(id)async{
    try{
      var db = await instance.database;
      await db.delete('note',where: 'id= ?',whereArgs: [id]);
      return true;
    }catch(e){
      print('delete note hata $e');
      return null;
    }
  }

}
