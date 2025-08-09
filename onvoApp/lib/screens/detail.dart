import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onvo/screens/compare.dart';
import 'package:onvo/utils/services/httpService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPage extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;
  final int? modelId;

  const DetailPage({
    super.key,
    this.categoryName,
    this.categoryId,
    this.modelId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late YoutubePlayerController _controller;
  late int _selectedModelId;

  // ignore: prefer_final_fields
  String _currentVideoId =
      YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=qC0vDKVPCrw&list=PL3bIO3E0Q8OTgdtnCaSSavXosVYz28Ly9",
      ) ??
      "QYnJ3qJ5qJQ";

  final API api = API();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _currentVideoId,
      flags: YoutubePlayerFlags(autoPlay: false, mute: true),
    );
    _selectedModelId = widget.modelId ?? 1;
  }

  void _changeVideo(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _controller.load(videoId);
      setState(() {
        _currentVideoId = videoId;
      });
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Color.fromARGB(255, 64, 85, 130),
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: 5,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 35),

                    Text(
                      "onvo",
                      style: GoogleFonts.getFont(
                        "Roboto",
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      widget.categoryName!,
                      style: GoogleFonts.getFont(
                        "Roboto",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    FutureBuilder(
                      future: api.fetchModels(int.parse(widget.categoryId!)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Hata : ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("Hiç model bulunamadı"));
                        }
                        final models = snapshot.data!;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: models.length,
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  _selectedModelId ==
                                  int.parse(models[index].id);

                              return ListTile(
                                title: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedModelId = int.parse(
                                        models[index].id,
                                      );
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blueAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 43),
                                      child: Text(
                                        models[index].model,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
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
              child: Column(
                children: [
                  Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: api.fetchProductFromModelId(_selectedModelId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Hata : ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("Veri alınamadı"));
                        }
                        final products = snapshot.data!;

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 50,
                                  ), //TODO: Aynı modele sahip içerikler için düzenleme yap.
                                  child: Text(
                                    products[index].name,
                                    style: GoogleFonts.getFont(
                                      "Roboto",
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 40, right: 30, left: 30),
                    height: 50,
                    width: double.infinity,

                    //alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          //barrierColor: Colors.blueGrey,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.blueGrey[800],

                              child: Container(
                                width: 1000,
                                height: 530,
                                padding: EdgeInsets.all(20),

                                child: FutureBuilder(
                                  future: api.fetchProductNameFromCategoryId(
                                    int.parse(widget.categoryId!),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text("Hata : ${snapshot.error}"),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text("Veri alınamadı"),
                                      );
                                    }
                                    final products = snapshot.data!;
                                    return ListView.builder(
                                      clipBehavior: Clip.none,
                                      shrinkWrap: true,
                                      itemCount: products.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Stack(
                                              children: [
                                                // Close button (top-right)
                                                Positioned(
                                                  right: 0,
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: Icon(Icons.close),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                // Centered column
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 16,
                                                    ), // So text doesn't get under the close button
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Hangi Ürünle Karşılaştırmak İstersiniz",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        final product = products[index - 1];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                product.name,
                                                style: GoogleFonts.getFont(
                                                  "Roboto",
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              tileColor: const Color.fromARGB(
                                                223,
                                                255,
                                                255,
                                                255,
                                              ),
                                              shape: RoundedSuperellipseBorder(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      16.0,
                                                    ),
                                              ),
                                              trailing: Icon(
                                                Icons.navigate_next_outlined,
                                              ),
                                              onTap: () async {
                                                int? mainProductId =
                                                    await productIdFromModel();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Compare(
                                                          mainProduct:
                                                              mainProductId!,
                                                          selectedProduct:
                                                              product.id,
                                                        ),
                                                  ),
                                                );
                                                print(
                                                  "\x1B[31mmain product --> $mainProductId\nselected product --> ${product.id}\nselected model id --> $_selectedModelId\x1B[0m",
                                                );
                                              },
                                            ),
                                            Divider(thickness: 0.1),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                        backgroundColor: Color(0xFF4C9AFF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          // Image.asset(
                          //   "assets/icons/ab-testing.png",
                          //   width: 35,
                          //   height: 35,
                          // ),
                          // Icon(Icons.compare, color: Colors.black87, size: 28),
                          Image.asset(
                            "assets/icons/compare.png",
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "KARŞILAŞTIR",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),

                          Image.asset(
                            "assets/icons/compare.png",
                            width: 35,
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int?> productIdFromModel() async {
    final result = await api.fetchProductFromModelId(_selectedModelId!);

    if (result.isNotEmpty) {
      return result[0].id;
    } else {
      return null;
    }
  }
}
