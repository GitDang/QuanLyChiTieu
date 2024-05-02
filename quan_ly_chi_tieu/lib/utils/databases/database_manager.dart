import 'dart:io';

import 'package:base_project/models/models.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._internal();

  static final DatabaseManager instance = DatabaseManager._internal();
  late Database db;

  Future setupDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.sqlite');
    bool isExisted = await databaseExists(path);
    if (!isExisted) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load('assets/databases/database.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }
    db = await openDatabase(path);
    getGlobalAccount();
  }

  void getGlobalAccount() async {
    Global.accountModel = await getAccount();
  }

  void addAccount(int money) async {
    await db.rawInsert('INSERT INTO account(money) VALUES(?)', [money]);
    getGlobalAccount();
  }

  Future<AccountModel> getAccount() async {
    List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM account ORDER BY id DESC');
    if (list.isNotEmpty) {
      return AccountModel.fromJson(list[0]);
    }
    return AccountModel(id: 1, money: 0);
  }

  void updateAccount(int money) async {
    await db.rawUpdate('UPDATE account SET money = ? WHERE id = ?', [money, Global.accountModel.id]);
    getGlobalAccount();
  }

  getIncomes(startDate, endDate) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT incomes.*, type_incomes.name as typeName, type_incomes.icon as typeIcon, type_incomes.color as typeColor FROM incomes LEFT JOIN type_incomes ON incomes.type_id = type_incomes.id WHERE date >= ? AND date <= ? ORDER BY date DESC',
      [startDate, endDate]
    );
    List<TransactionsModel> listIncomes = [];
    if (list.isNotEmpty) {
      for (var income in list) {
        listIncomes.add(TransactionsModel.fromJson(income));
      }
    }
    return listIncomes;
  }

  getExpenses(startDate, endDate) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT expenses.*, type_expenses.name as typeName, type_expenses.icon as typeIcon, type_expenses.color as typeColor FROM expenses LEFT JOIN type_expenses ON expenses.type_id = type_expenses.id WHERE date >= ? AND date <= ? ORDER BY date DESC',
      [startDate, endDate]
    );
    List<TransactionsModel> listIncomes = [];
    if (list.isNotEmpty) {
      for (var income in list) {
        listIncomes.add(TransactionsModel.fromJson(income));
      }
    }
    return listIncomes;
  }

  getIncomesByCategories(categoryId) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT incomes.*, type_incomes.name as typeName, type_incomes.icon as typeIcon, type_incomes.color as typeColor FROM incomes LEFT JOIN type_incomes ON incomes.type_id = type_incomes.id WHERE type_id = ? ORDER BY date ASC',
      [categoryId]
    );
    List<TransactionsModel> listIncomes = [];
    if (list.isNotEmpty) {
      for (var income in list) {
        listIncomes.add(TransactionsModel.fromJson(income));
      }
    }
    return listIncomes;
  }

  getExpensesByCategories(categoryId) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT expenses.*, type_expenses.name as typeName, type_expenses.icon as typeIcon, type_expenses.color as typeColor FROM expenses LEFT JOIN type_expenses ON expenses.type_id = type_expenses.id WHERE type_id = ? ORDER BY date ASC',
      [categoryId]
    );
    List<TransactionsModel> listExpenses = [];
    if (list.isNotEmpty) {
      for (var expense in list) {
        listExpenses.add(TransactionsModel.fromJson(expense));
      }
    }
    return listExpenses;
  }

  Future<List<CategoryModel>> getTypeIncomes() async {
    List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM type_incomes ORDER BY type');
    List<CategoryModel> listTypes = [];
    if (list.isNotEmpty) {
      for (var type in list) {
        listTypes.add(CategoryModel.fromJson(type));
      }
    }
    return listTypes;
  }

  Future<List<CategoryModel>> getTypeExpenses() async {
    List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM type_expenses ORDER BY type');
    List<CategoryModel> listTypes = [];
    if (list.isNotEmpty) {
      for (var type in list) {
        listTypes.add(CategoryModel.fromJson(type));
      }
    }
    return listTypes;
  }

  void addIncome({required int money, required int type_id, String note = '', required String date, String images = ''}) async {
    await db.rawInsert('INSERT INTO incomes(money, type_id, note, date, images) VALUES( ? , ? , ? , ? , ? )', [money, type_id, note, date, images]);
  }

  void addExpense({required int money, required int type_id, String note = '', required String date, String images = ''}) async {
    await db.rawInsert('INSERT INTO expenses(money, type_id, note, date, images) VALUES( ? , ? , ? , ? , ? )', [money, type_id, note, date, images]);
  }

  getIncomeById(id) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT incomes.*, type_incomes.name as typeName, type_incomes.icon as typeIcon, type_incomes.color as typeColor, type_incomes.type as type FROM incomes LEFT JOIN type_incomes ON incomes.type_id = type_incomes.id WHERE incomes.id = ? ',
      [id]
    );
    var incomeModel = TransactionsModel(id: 0, typeId: 0, money: 0);
    if (list.isNotEmpty) {
      incomeModel = TransactionsModel.fromJson(list[0]);
    }
    return incomeModel;
  }

  getExpenseById(id) async {
    List<Map<String, dynamic>> list = await db.rawQuery(
      'SELECT expenses.*, type_expenses.name as typeName, type_expenses.icon as typeIcon, type_expenses.color as typeColor, type_expenses.type as type FROM expenses LEFT JOIN type_expenses ON expenses.type_id = type_expenses.id WHERE expenses.id = ? ',
      [id]
    );
    var expenseModel = TransactionsModel(id: 0, typeId: 0, money: 0);

    if (list.isNotEmpty) {
      expenseModel = TransactionsModel.fromJson(list[0]);
    }
    return expenseModel;
  }

  deleteIncomeById(id) async {
    await db.rawQuery('DELETE FROM incomes WHERE id = ? ', [id]);
  }

  deleteExpenseById(id) async {
    await db.rawQuery('DELETE FROM expenses WHERE id = ? ', [id]);
  }

  void addTypeIncome({required String name, String icon = '', String color = '', int type = 1}) async {
    await db.rawInsert('INSERT INTO type_incomes(name, icon, color, type) VALUES( ? , ? , ? , ? )', [name, icon, color, type]);
  }

  void addTypeExpense({required String name, String icon = '', String color = '', int type = 1}) async {
    await db.rawInsert('INSERT INTO type_expenses(name, icon, color, type) VALUES( ? , ? , ? , ? )', [name, icon, color, type]);
  }

  deleteTypeIncomeById(id) async {
    await db.rawQuery('DELETE FROM type_incomes WHERE id = ? ', [id]);
  }

  deleteTypeExpenseById(id) async {
    await db.rawQuery('DELETE FROM type_expenses WHERE id = ? ', [id]);
  }

  resetApp() async {
    await db.rawQuery('DELETE FROM account');
    await db.rawQuery('DELETE FROM incomes');
    await db.rawQuery('DELETE FROM expenses');
  }
}
