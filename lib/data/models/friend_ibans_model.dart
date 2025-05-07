class FriendIban {
  String? id;
  final String name;
  final String bankName;
  final String ibanNumber;
  final String createdAt;

  FriendIban({
    required this.name,
    required this.bankName,
    required this.ibanNumber,
    required this.createdAt,
  });

  FriendIban.withId({
    required this.id,
    required this.name,
    required this.bankName,
    required this.ibanNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'bankName': bankName,
      'iban': ibanNumber, 
      'createdAt': createdAt,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory FriendIban.fromMap(Map<String, dynamic> map) {
    return FriendIban.withId(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      bankName: map['bankName'] ?? '',
      ibanNumber: map['iban'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
