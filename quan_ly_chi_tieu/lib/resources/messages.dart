import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ja': ja,
        'en': en,
      };

  Map<String, String> en = {
    // Splash
    'splash.title': 'Kanrimo',

    // Input money first
    'input_money.input_amount': 'Please input first money',
    'input_money.to_next': 'Next',
    'input_money.must_be_positive_number': 'Initially the amount must be a positive number',
    'input_money.not_null': 'Please enter numbers only',
    'input_money.max_value': 'Please enter within 8 characters',

    // Introduction
    'introduction.welcome': 'Welcome to Kanrimo！',
    'introduction.expense_management': 'Kanrimo - An app that allows you to easily record your income and expenses',
    'introduction.start': 'Start',

    // Home
    'home.title': 'Total',
    'home.segmented.expense': 'Expense',
    'home.segmented.income': 'Income',
    'home.chart.no_expenses': 'No expenses has been generated',
    'home.chart.no_incomes': 'No income has been generated',

    // Add transaction
    'add.transaction.title': 'Add transaction',
    'add.transaction.category': 'Category',
    'add.transaction.comment': 'Comment',
    'add.transaction.photo': 'Photo',
    'add.transaction.add': 'Add',
    'add.transaction.category_required': 'Please select a category',
    'add.transaction.date_required': 'Please choose a date',

    // Currency
    'yen': ' ',

    // Datetime
    'day': 'Day',
    'week': 'Week',
    'month': 'Month',
    'year': 'Year',

    // Category
    'category.title': 'Category',
    'category.create': 'Create',
    'category.add': 'Create Category',
    'category.name': 'Category Name',
    'category.plan': 'Planned expenses',
    'category.icon': 'Icon',
    'category.color': 'Color',
    'category.plus': 'Add',
    'category.add.name_required': 'Enter category name',
    'category.monthly.must_be_positive_number': 'Planned expenditure must be a positive number',
    'category.cost.fixed': ' Fixed costs',
    'category.cost.extra': ' Variable costs',
    'category.delete_confirm': 'Are you sure you want to delete the category?',
    'category.not_remove': 'A list with existing transactions cannot be deleted.',
    'category.no_transaction': 'No data',

    // Transaction
    'transaction.detail': 'Transaction details',
    'transaction.money': 'amount',
    'transaction.category': 'Category',
    'transaction.date': 'Day',
    'transaction.comment': 'Comment',
    'transaction.delete': 'Delete',
    'transaction.delete_confirm': 'Are you sure you want to delete the transaction?',
    'transaction.yes': 'Yes',
    'transaction.no': 'No',

    // Graph
    'graph.title': 'Graph',
    'graph.all': 'All',
    'graph.expense': 'Expense',
    'graph.income': 'Income',
    'graph.detail.all': 'General schedule',
    'graph.detail.expense': 'Plan Expense',
    'graph.detail.income': 'Plan Income',
    'graph.detail.no_data.all': 'No all occurred',
    'graph.detail.no_data.expense': 'No expense occurred',
    'graph.detail.no_data.income': 'No income occurred',

    // Menu
    'menu.home': 'Total',
    'menu.category': 'Category',
    'menu.graph': 'Graph',
    'menu.reset': 'Reset',
    'menu.reset_confirm': 'Do you want to reset the app?',
  };

  Map<String, String> ja = {
    // Splash
    'splash.title': 'マネーライフ',

    // Input money first
    'input_money.input_amount': '最初に金額を入力してください',
    'input_money.to_next': '次へ',
    'input_money.must_be_positive_number': '最初に金額は正の数でなければなりません',
    'input_money.not_null': '数字のみを入力してください',
    'input_money.max_value': '8文字以内で入力してください',

    // Introduction
    'introduction.welcome': 'マネーライフへようこそ！',
    'introduction.expense_management': 'マネーライフ - 収入と支出を簡単に記録できるアプリ',
    'introduction.start': '始める',

    // Home
    'home.title': '合計',
    'home.segmented.expense': '支出',
    'home.segmented.income': '収入',
    'home.chart.no_expenses': '支出は発生していません',
    'home.chart.no_incomes': '収入は発生していません',

    // Add transaction
    'add.transaction.title': '取引を追加',
    'add.transaction.category': 'カテゴリー',
    'add.transaction.comment': 'コメント',
    'add.transaction.photo': '写真',
    'add.transaction.add': '追加',
    'add.transaction.category_required': 'カテゴリーを選択してください',
    'add.transaction.date_required': '日付を選択してください',

    // Currency
    'yen': '¥',

    // Datetime
    'day': '日',
    'week': '週',
    'month': '月',
    'year': '年',

    // Category
    'category.title': 'カテゴリー',
    'category.create': '作成',
    'category.add': 'カテゴリーの作成',
    'category.name': 'カテゴリーの名前',
    'category.plan': '予定支出',
    'category.icon': 'アイコン',
    'category.color': '色',
    'category.plus': '追加',
    'category.add.name_required': 'カテゴリーの名前を入力',
    'category.monthly.must_be_positive_number': '予定支出は正の数でなければなりません',
    'category.cost.fixed': ' 固定費',
    'category.cost.extra': ' 変動費',
    'category.delete_confirm': '本当にカテゴリーを削除しますか?',
    'category.not_remove': '既取引のあるリストが削除できません。',
    'category.no_transaction': 'データなし',

    // Transaction
    'transaction.detail': '取引詳細',
    'transaction.money': '金額',
    'transaction.category': 'カテゴリー',
    'transaction.date': '日',
    'transaction.comment': 'コメント',
    'transaction.delete': '削除',
    'transaction.delete_confirm': '本当に取引を削除しますか?',
    'transaction.yes': 'はい',
    'transaction.no': 'いいえ',

    // Graph
    'graph.title': 'グラフ',
    'graph.all': '一般',
    'graph.expense': '支出',
    'graph.income': '収入',
    'graph.detail.all': '予定一般',
    'graph.detail.expense': '予定支出',
    'graph.detail.income': '予定収入',
    'graph.detail.no_data.all': '一般は発生していません',
    'graph.detail.no_data.expense': '支出は発生していません',
    'graph.detail.no_data.income': '収入は発生していません',

    // Menu
    'menu.home': '合計',
    'menu.category': 'カテゴリー',
    'menu.graph': 'グラフ',
    'menu.reset': 'リセット',
    'menu.reset_confirm': 'アプリをリセットしますか?',
  };
}
