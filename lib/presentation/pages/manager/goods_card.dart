import 'package:flutter/material.dart';
import '../../../core/var_manager.dart';

class GoodsCard extends StatelessWidget {
  final String goods;
  final String prise;
  const GoodsCard({
    Key? key,
    required this.goods,
    required this.prise,
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
            Text(
              goods,
              style: VarManager.cardSize,
            ),
            Text(
              '$prise грн.',
              style: VarManager.cardSize,
            ),
            Text('count'),
          ],
        ),
      ),
    );
  }
}
