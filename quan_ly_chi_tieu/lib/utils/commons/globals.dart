import 'package:base_project/models/models.dart';

class Global {
  static AccountModel accountModel = AccountModel(id: 1, money: 0);
  static String ALL = 'all';
  static String INCOMES = 'incomes';
  static String EXPENSES = 'expenses';
  static int TYPE_FIXED = 1;
  static int TYPE_EXTRA = 2;
}
