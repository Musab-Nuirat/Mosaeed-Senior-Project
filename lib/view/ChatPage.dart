import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_course_project/model/Chat/ChatData.dart';
import 'package:flutter_course_project/model/api/Api.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'widgets/ChatAppBar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isDialogShowing = false;

  User user = const User(id: '1', firstName: 'User', lastName: 'User', role: Role.user);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: ChatAppBar(
      isTyping: false,
    ),
    extendBodyBehindAppBar: true,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: ui.Chat(
          messages: ChatData.dummyChat,
          inputOptions: const ui.InputOptions(
            sendButtonVisibilityMode: ui.SendButtonVisibilityMode.editing,
          ),
          onSendPressed: (partialText) async {
            final userMessage = TextMessage(
              author: user,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: partialText.text,
            );

            setState(() {
              ChatData.dummyChat.insert(0, userMessage);
            });

            try {
              final reply = await _sendPostRequest(partialText.text);

              final botMessage = TextMessage(
                author: const User(
                  id: '2',
                  firstName: 'Chat',
                  lastName: 'Bot',
                  role: Role.user,
                ),
                createdAt: DateTime.now().millisecondsSinceEpoch + 1,
                id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
                text: reply,
              );

              setState(() {
                ChatData.dummyChat.insert(0, botMessage);
              });
            } catch (e) {
              _showErrorDialog(context, e.toString());

              setState(() {
                final errorMessage = TextMessage(
                  author: const User(
                    id: '2',
                    firstName: 'Chat',
                    lastName: 'Bot',
                    role: Role.user,
                  ),
                  createdAt: DateTime.now().millisecondsSinceEpoch + 1,
                  id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
                  text: 'فشل الاتصال بالخادم. الرجاء المحاولة مرة أخرى.',
                );

                ChatData.dummyChat.insert(0, errorMessage);
              });
            }
          },

          emptyState: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: const AssetImage('assets/robot.png'),
                width: 150,
                height: 150,
              ),
              const Text(
                'إسأل المساعد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 3),
              InkWell(
                onTap: () => launchUrl(
                  Uri.parse('https://www.aaup.edu/'),
                ),
                child: const Text(
                  'المزيد من المعلومات',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:Color(0xFF842700),
                  ),
                ),
              ),
            ],
          ),
          user: user,
          scrollPhysics: const BouncingScrollPhysics(),
          dateHeaderBuilder: (header) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                DateFormat('MMMM d, y').format(header.dateTime),
                style: const TextStyle(
                  color: Color.fromARGB(255, 138, 138, 138),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          theme: ui.DefaultChatTheme(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            /// MESSAGES
            messageInsetsHorizontal: 10,
            messageInsetsVertical: 8,
            messageBorderRadius: 14,
            primaryColor: const Color(0xFF842700),
            secondaryColor: Colors.grey.shade200,
            receivedMessageBodyTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            sentMessageBodyTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),

            /// INPUT
            inputBorderRadius: BorderRadius.zero,
            inputBackgroundColor: Colors.white,
            inputTextColor: Colors.black,
            inputTextCursorColor: const Color(0xFF842700),
            inputPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 7,
            ),
            inputTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            inputContainerDecoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF92705B),
                  width: 0.5,
                ),
              ),
            ),
            inputTextDecoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(
                  color: Color(0xFF92705B),
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(
                  color: Color(0xFF92705B),
                  width: 0.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              isCollapsed: true,
            ),

            /// SEND BUTTON
            sendButtonMargin: EdgeInsets.zero,
            sendButtonIcon: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Color(0xFF842700) ,
              ),
              padding: const EdgeInsets.all(2),
              child: Transform.rotate(
                angle: 1.5708,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'ChatBot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => pages[index]),
        );
      },
    ),
  );
  final List<Widget> pages = [
    HomePage(
      studentId: "",
    ),
    ChatPage(),
    ProfilePage()
  ];
  Future<String> _sendPostRequest(String text) async {
    // Await the result of the API call
    // final reply = await Api.getChatReply(text);
    final reply = "This is a static response for the demo version";
    return reply;
  }

  Future<void> _showErrorDialog(BuildContext context, String error) async {
    _isDialogShowing = true;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('حدث خطأ'),
        content: Text(error),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسنا',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xFF842700),
              ),
            ),
          ),
        ],
      ),
    );
    _isDialogShowing = false;
  }
}
