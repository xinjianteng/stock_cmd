import 'package:html/dom.dart';

List<NodeList> flatten(NodeList list) {
  List<NodeList> allNodes = [];
  for (var item in list) {
    final items = item.nodes;
    if (items.isNotEmpty && items.length > 1) {
      flatten(items);
    } else {
      allNodes.add(item.nodes);
    }
  }
  return allNodes;
}
