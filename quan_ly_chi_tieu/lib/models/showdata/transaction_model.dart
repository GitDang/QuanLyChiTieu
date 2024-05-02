class TransactionsModel {
  int id;
  int typeId;
  int money;
  String note;
  String date;
  String images;
  String typeName;
  String typeIcon;
  String typeColor;

  TransactionsModel({
    required this.id,
    required this.typeId,
    required this.money,
    this.note = "",
    this.date = "",
    this.images = "",
    this.typeName = '',
    this.typeIcon = '',
    this.typeColor = '',
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) => TransactionsModel(
        id: json['id'],
        typeId: json['type_id'],
        money: json['money'],
        note: json['note'],
        date: json['date'],
        images: json['images'],
        typeName: json['typeName'],
        typeIcon: json['typeIcon'],
        typeColor: json['typeColor'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type_id': typeId,
        'money': money,
        'note': note,
        'date': date,
        'images': images,
        'typeName': typeName,
        'typeIcon': typeIcon,
        'typeColor': typeColor,
      };
}
