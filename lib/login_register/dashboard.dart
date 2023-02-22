import 'package:flutter/material.dart';
import 'package:sampleproject/login_register/update_credentials_page.dart';
import 'package:sampleproject/services/chat_gpt.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

class Dashboard extends StatefulWidget {
  int? userId;
  String? username;
  String? password;
  String? name;
  Dashboard({Key? key, this.username, this.password, this.name, this.userId}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class _DashboardState extends State<Dashboard> {
  TextEditingController controller = TextEditingController();
  final _scrollController = ScrollController();
  final openai = OpenAI();
  final List<ChatMessage> _messages = [];
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateCredentialsPage(
                      name: widget.name,
                      password: widget.password,
                      username: widget.username,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: backgroundColor),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Text('Welcome', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        Text(widget.name!, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    )),
                Expanded(
                    child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    var message = _messages[index];
                    return ChatMessageWidget(
                      text: message.text,
                      chatMessageType: message.chatMessageType,
                    );
                  },
                )),
                Visibility(
                  visible: isLoading,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.black38,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.black))),
                  child: TextFormField(
                    onEditingComplete: () {
                      setState(() {
                        _messages.add(ChatMessage(text: controller.text, chatMessageType: ChatMessageType.user));
                        isLoading = true;
                      });
                      var input = controller.text;
                      controller.clear();
                      Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
                      openai.chatGPT(input).then((value) {
                        setState(() {
                          isLoading = false;
                          _messages.add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));
                        });
                      });
                      controller.clear();
                      Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
                    },
                    controller: controller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _messages.add(ChatMessage(text: controller.text, chatMessageType: ChatMessageType.user));
                          isLoading = true;
                        });
                        var input = controller.text;
                        controller.clear();
                        Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
                        openai.chatGPT(input).then((value) {
                          setState(() {
                            isLoading = false;
                            _messages.add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));
                          });
                        });
                        controller.clear();
                        Future.delayed(Duration(milliseconds: 50)).then((value) => _scrollDown());
                      },
                      icon: Icon(Icons.send),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot ? botBackgroundColor : backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                    child: Image.asset(
                      'assets/bot.png',
                      scale: 1.5,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
