class TransactionsByCategoryModel {
  int typeId;
  String typeName;
  String typeIcon;
  int money;
  String typeColor;

  TransactionsByCategoryModel({
    required this.typeId,
    required this.typeName,
    this.typeIcon = "",
    this.money = 0,
    this.typeColor = ""
  });

  factory TransactionsByCategoryModel.fromJson(Map<String, dynamic> json) => TransactionsByCategoryModel(
        typeId: json['type_id'],
        typeName: json['typeName'],
        typeIcon: json['typeIcon'],
        money: json['money'],
        typeColor: json['typeColor'],
      );

  Map<String, dynamic> toJson() => {
        'typeId': typeId,
        'typeName': typeName,
        'typeIcon': typeIcon,
        'money': money,
        'typeColor': typeColor,
      };
}
