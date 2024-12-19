class ChosenMenu {
  final int id;
  final int user;
  final String itemName;
  final int quantity;
  final double price;
  final int saveSession;
  final double budget;

  ChosenMenu({
    required this.id,
    required this.user,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.saveSession,
    required this.budget,
  });

  factory ChosenMenu.fromJson(Map<String, dynamic> json) {
    return ChosenMenu(
      id: json['pk'],
      user: json['fields']['user'],
      itemName: json['fields']['item_name'],
      quantity: json['fields']['quantity'],
      price: double.parse(json['fields']['price']),
      saveSession: json['fields']['save_session'],
      budget: double.parse(json['fields']['budget']),
    );
  }
}