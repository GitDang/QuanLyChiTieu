class AccountModel {
  int id;
  int money;

  AccountModel({
    required this.id,
    required this.money,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'],
        money: json['money'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'money': money,
      };
}
