import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ja': ja,
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
