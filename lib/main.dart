import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screen_brightness/screen_brightness.dart';

void main() => runApp(const MaterialApp(home: KartomatHome()));

class KartomatHome extends StatefulWidget {
  const KartomatHome({super.key});
  @override
  State<KartomatHome> createState() => _KartomatHomeState();
}

class _KartomatHomeState extends State<KartomatHome> {
  List<Map<String, dynamic>> cards = [
    {'name': 'IKEA', 'color': const Color(0xFF0051BA), 'code': '12345678'},
    {'name': 'Walmart', 'color': const Color(0xFF0071CE), 'code': '87654321'},
  ];

  void _showCard(Map<String, dynamic> card) async {
    double br = await ScreenBrightness().current;
    await ScreenBrightness().setScreenBrightness(1.0);
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(card['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            BarcodeWidget(barcode: Barcode.code128(), data: card['code'], width: 300, height: 100),
            const Spacer(),
          ],
        ),
      ),
    );
    await ScreenBrightness().setScreenBrightness(br);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kartomat")),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _showCard(cards[index]),
          child: Align(
            heightFactor: 0.4,
            child: Container(
              height: 150,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cards[index]['color'],
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(blurRadius: 5)],
              ),
              child: Center(child: Text(cards[index]['name'], style: const TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ),
        ),
      ),
    );
  }
}
