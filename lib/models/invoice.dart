class Invoice {
  final int id;
  final String invoiceNo;
  final int clientId;
  final num total;
  final String status;

  Invoice({
    required this.id,
    required this.invoiceNo,
    required this.clientId,
    required this.total,
    required this.status,
  });

  factory Invoice.fromJson(Map<String, dynamic> j) => Invoice(
    id: j['id'] as int,
    invoiceNo: j['invoiceNo'] ?? '',
    clientId: j['clientId'] as int,
    total: j['total'] as num,
    status: j['status'] ?? '',
  );
}
