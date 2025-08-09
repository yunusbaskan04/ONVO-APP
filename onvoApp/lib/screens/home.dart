import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onvo/screens/chatbot.dart';
import 'package:onvo/screens/detail.dart';

import 'package:onvo/utils/services/httpService.dart';
import 'package:onvo/utils/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final API api = API();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 14, 44, 95),
            Color.fromARGB(255, 21, 87, 186),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "onvo",
                      style: GoogleFonts.getFont(
                        "Roboto",
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "TEKNOLOJİ DÜNYASINA HOŞGELDİNİZ",
                      style: GoogleFonts.getFont(
                        "Open Sans",
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Text(
                      "Lütfen İlgilendiğiniz Ürün Grubunu Seçiniz",
                      style: GoogleFonts.getFont(
                        "Open Sans",
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: FutureBuilder<List<Category>>(
                        future: api.fetchCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Hata: ${snapshot.error}"),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("Hiç kategori yok"));
                          }
                          final categories = snapshot.data!;

                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,

                                child: ListTile(
                                  leading: Image.network(
                                    categories[index].photo,
                                    fit: BoxFit.cover,
                                  ),

                                  minLeadingWidth: 100,
                                  title: Text(
                                    categories[index].name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          categoryName: categories[index].name,
                                          categoryId:
                                              categories[index].categoryId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Image.asset("assets/photos/onvoLogo.png"),
                    SizedBox(height: 100),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnythingLLMDemo(),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 14, 44, 95),
                              Color.fromARGB(255, 21, 87, 186),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/icons/chatbot.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
