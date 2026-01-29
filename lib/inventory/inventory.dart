import 'package:mining_shooter/inventory/item.dart';

class Inventory {
  final Map<String, Item> _itemMap;
  Map<String, Item> get itemMap => _itemMap;

  Inventory._({required Map<String, Item> itemMap}) : _itemMap = itemMap;

  factory Inventory.fromJson(Map<String, dynamic> json) {
    final itemMap = (json['items'] as Map<String, dynamic>?) ?? {};
    return Inventory._(
      itemMap: itemMap.map(
        (id, item) => MapEntry(id, Item.fromJson(item as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': _itemMap.map((id, item) => MapEntry(id, item.toJson()))};
  }

  void addItem(String id, String name, int count) {
    if (_itemMap[id] != null) {
      itemMap[id]!.count += count;
    } else {
      itemMap[id] = Item(id: id, count: count, name: name);
    }
  }

  void removeItem(String id, int count) {


    itemMap[id]!.count -= count;

    if(itemMap[id]!.count == 0) {
      itemMap.remove(id);
    }

  }
}
