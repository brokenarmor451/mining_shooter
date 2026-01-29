class AreaPurchaseData {
  Map<String, bool> purchaseMap;

  AreaPurchaseData._({
    required this.purchaseMap
  });

  factory  AreaPurchaseData.fromJson(Map<String, dynamic> json) {

    final Map<String, bool> purchasesMap = json.cast<String, bool>();

    return AreaPurchaseData._(purchaseMap: purchasesMap);
  }

  Map<String, dynamic> toJson() {
    return {
      ...purchaseMap
    };
  }
}