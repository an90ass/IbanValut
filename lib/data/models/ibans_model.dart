class Iban {
  String? id;
  final String bankName;
  final String ibanNumber;
  final String createdAt;

  Iban({
    required this.bankName,
    required this.ibanNumber,
    required this.createdAt,
  });

  Iban.withId({
    required this.id,
    required this.bankName,
    required this.ibanNumber,
    required this.createdAt,
  });

  factory Iban.fromMap(Map<String, dynamic> map) {
    return Iban.withId(
      id: map['id'].toString(), 
      bankName: map['bankName'] ?? '',
      ibanNumber: map['ibanNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'bankName': bankName,
      'ibanNumber': ibanNumber,
      'createdAt': createdAt,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }
}
