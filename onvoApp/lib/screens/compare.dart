import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onvo/utils/services/httpService.dart';

class Compare extends StatefulWidget {
  final int mainProduct;
  final int selectedProduct;

  const Compare({
    super.key,
    required this.mainProduct,
    required this.selectedProduct,
  });

  @override
  State<Compare> createState() => _CompareState();
}

class _CompareState extends State<Compare> {
  API api = API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f2f5),
      appBar: AppBar(
        title: Text(
          "Ürün Karşılaştırması",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 49, 83, 177),
      ),
      body: Row(
        children: [
          Expanded(child: getDesign(widget.mainProduct)),
          const VerticalDivider(width: 1, color: Colors.grey),
          Expanded(child: getDesign(widget.selectedProduct)),
        ],
      ),
    );
  }

  Widget getDesign(int id) {
    return FutureBuilder(
      future: api.fetchProduct(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Veri alınamadı"));
        }

        final product = snapshot.data![0];
        final features = parseTechnicalFeatures(product.technicalFeature);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          final entry = features.entries.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF1E3A8A),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.openSans(
                                        fontSize: 13.5,
                                        color: Colors.black87,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${entry.key}: ",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: entry.value),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 104,
              right: 75,
              child: Column(
                children: [
                  Container(width: 2, height: 70, color: Colors.black26),
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${product.price} TL",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, String> parseTechnicalFeatures(String raw) {
    final Map<String, String> features = {};
    final lines = raw.split('\n');
    for (var line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        final key = parts[0].replaceAll('"', '').trim();
        final value = parts
            .sublist(1)
            .join(':')
            .replaceAll('"', '')
            .replaceAll(',', '')
            .trim();
        features[key] = value;
      }
    }
    return features;
  }
}
