import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screen_brightness/screen_brightness.dart';

void main() => runApp(const KartomatApp());

class KartomatApp extends StatelessWidget {
  const KartomatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartomat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light, colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.blue),
      themeMode: ThemeMode.system,
      home: const CardListScreen(),
    );
  }
}

class CardListScreen extends StatefulWidget {
  const CardListScreen({super.key});
  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  // Przykładowe dane zgodne z Twoimi screenami
  List<Map<String, dynamic>> cards = [
    {'id': '1', 'name': 'IKEA', 'brand': 'IKEA Family', 'color': const Color(0xFF0051BA), 'code': '123456789', 'type': Barcode.code128()},
    {'id': '2', 'name': 'Walmart', 'brand': 'Membership', 'color': const Color(0xFF0071CE), 'code': '126401648164015', 'type': Barcode.code128()},
    {'id': '3', 'name': 'CVS ExtraCare', 'brand': 'CVS Pharmacy', 'color': const Color(0xFFCC0000), 'code': '9988776655', 'type': Barcode.qrCode()},
  ];

  void _viewCard(Map<String, dynamic> card) async {
    double originalBrightness = await ScreenBrightness().current;
    await ScreenBrightness().setScreenBrightness(1.0); // Rozjaśnianie 100%

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 30),
              Text(card['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              BarcodeWidget(barcode: card['type'], data: card['code'], width: 280, height: 150),
              const SizedBox(height: 15),
              Text(card['code'], style: const TextStyle(letterSpacing: 2)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
    await ScreenBrightness().setScreenBrightness(originalBrightness); // Przywracanie jasności
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kartomat", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Dismissible(
            key: Key(card['id']),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => setState(() => cards.removeAt(index)),
            child: Align(
              heightFactor: 0.35, // Kluczowy parametr dla efektu "Wallet" (nakładanie kart)
              child: GestureDetector(
                onTap: () => _viewCard(card),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: card['color'],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, -4))],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.credit_card, size: 20)),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(card['brand'], style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
