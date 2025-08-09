import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onvo/utils/services/chatbot/chat_service.dart';
import 'package:flutter_typing_indicator/flutter_typing_indicator.dart';
import 'package:onvo/screens/compare.dart';
import 'package:onvo/screens/detail.dart';
import 'package:onvo/utils/models/messages.dart';
import 'package:onvo/utils/services/httpService.dart';

class AnythingLLMDemo extends StatefulWidget {
  const AnythingLLMDemo({super.key});

  @override
  State<AnythingLLMDemo> createState() => _AnythingLLMDemoState();
}

class _AnythingLLMDemoState extends State<AnythingLLMDemo> {
  final TextEditingController _controller = TextEditingController();
  final List<Messages> _messages = [];
  API api = API();
  List<String> result_keywords = ["Ürün Kodu", "Ürün Adı", "Fiyat"];
  bool _aiTyping = false;
  bool _loading = false;

  final ChatService chatService = ChatService(
    apiKey: '27NAD4G-3HQMTCT-GGGAFFS-9XJXYR5', // kendi anahtarını buraya koy
  );

  Future<void> _sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(Messages(text: messageText, isMe: true));
      _loading = true;
      _aiTyping = true;
    });

    _controller.clear();

    try {
      final result = await chatService.sendMessage(
        message: messageText,
        mode: 'chat', // veya 'query'
        sessionId: 'flutter-session-001',
      );

      setState(() {
        _messages.add(
          Messages(
            text: result['textResponse'] ?? 'Yanıt bulunamadı.',
            isMe: false,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(Messages(text: 'Hata: $e', isMe: false));
      });
    } finally {
      setState(() {
        _loading = false;
        _aiTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(thickness: 2, color: Color(0xFFCCCCCC)),
            Expanded(child: _buildMessageList()),
            const Divider(thickness: 2, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 20),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_left_outlined),
            iconSize: 40,
          ),
          Image.asset("assets/icons/messages_icon.png", width: 40, height: 40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ONVO Asistan",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              Text(
                "Akıllı asistanınızla sohbet edin",
                style: GoogleFonts.openSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty && !_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/messages_icon.png",
              width: 90,
              height: 90,
            ),
            const SizedBox(height: 12),
            Text(
              "ONVO Asistan'a Hoş Geldiniz!",
              style: GoogleFonts.openSans(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Sorularınızı sorun, dosya yükleyin ve akıllı asistanınızla sohbet edin.",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length + (_aiTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_aiTyping && index == _messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [SizedBox(width: 8), TypingIndicator()],
              ),
            ),
          );
        }

        final msg = _messages[index];
        bool buttonResult = result_keywords.every(
          (element) => msg.text.contains(element),
        );
        bool evenProduct = false;
        List<int> productIDs = [];
        late int firstId;
        late int secondId;

        if (buttonResult) {
          final regex = RegExp(r'Ürün Kodu:\s*(\d+)');
          final matches = regex.allMatches(msg.text);
          for (var match in matches) {
            String productId = match.group(1)!;

            productIDs.add(int.parse(productId));
          }
          evenProduct = productIDs.length == 2 ? true : false;
          firstId = productIDs[0];
          if (evenProduct) secondId = productIDs[1];
        }

        return Align(
          alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: msg.isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              msg.isMe
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/icons/profile1.png"),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        "assets/icons/onvoProfile1.png",
                      ),
                    ),
              SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(vertical: 4),
                constraints: msg.isMe
                    ? BoxConstraints(maxWidth: 200)
                    : BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: buttonResult
                    ? evenProduct
                          ? Column(
                              children: [
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      productIdFromModel(firstId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    child: Text(
                                      "Birinci Ürüne Gitmek İçin Tıklayın",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      productIdFromModel(secondId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    child: Text(
                                      "İkinci Ürüne Gitmek İçin Tıklayın",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Compare(
                                            mainProduct: firstId,
                                            selectedProduct: secondId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    child: Text(
                                      "Ürünleri Karşılaştırmak İçin Tıklayın",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 19,
                                  ),
                                ),

                                SizedBox(height: 10),
                                SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      productIdFromModel(firstId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    child: Text(
                                      "Ürüne Gitmek İçin Tıklayın",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                    : Text(
                        msg.text,
                        style: TextStyle(color: Colors.black87, fontSize: 19),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/attachment.png",
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Mesajınızı yazın...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 13),
        InkWell(
          child: ElevatedButton(
            onPressed: _loading ? null : _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(120, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/send.png",
                  width: 20,
                  height: 40,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  "Gönder",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> productIdFromModel(int id) async {
    final result = await api.fetchProduct(id);
    final categories = await api.fetchCategories();

    if (result.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            categoryId: result[0].categoryId,
            modelId: int.parse(result[0].modelId),
            categoryName: categories[int.parse(result[0].categoryId) - 1].name,
          ),
        ),
      );
    } else {
      print("HATA");
    }
  }
}
