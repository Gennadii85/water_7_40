import 'package:flutter/material.dart';
import '../../../core/var_manager.dart';

class PriceCard extends StatelessWidget {
  final String goods;
  final String prise;
  final int count;
  final Function addCount;
  final Function delCount;
  // final int id;
  const PriceCard({
    Key? key,
    required this.goods,
    required this.prise,
    required this.count,
    required this.addCount,
    required this.delCount,
    // required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                goods,
                style: VarManager.cardSize,
              ),
            ),
            Text(
              '$prise грн.',
              style: VarManager.cardSize,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => addCount(),
                  icon: const Icon(Icons.add_circle_outline),
                ),
                Text(
                  '$count шт.',
                  style: VarManager.cardSize,
                ),
                IconButton(
                  onPressed: () => delCount(),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
