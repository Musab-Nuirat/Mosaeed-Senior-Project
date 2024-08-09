import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/model/Chat/ChatData.dart';
import 'package:flutter_course_project/view/ChatPage.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double _preferredHeight = 110;
  final bool isTyping;
  const ChatAppBar({
    required this.isTyping,
    super.key,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(ChatAppBar._preferredHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 204, 204, 204),
                width: 0.5,
              ),
            ),
          ),
          height: ChatAppBar._preferredHeight,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'مُســاعد',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Visibility(
                          visible: widget.isTyping,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: CupertinoActivityIndicator(
                              color: Color(0xFF842700),
                              radius: 7,
                            ),
                          ),
                        ),
                        Text(
                          widget.isTyping ? 'Typing' : 'Online',
                          style: const TextStyle(
                            color: Color(0xFF842700),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showCancelDialog(context),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Color(0xFF842700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext pageContext) =>
      showCupertinoModalPopup<CupertinoActionSheet>(
        context: pageContext,
        builder: (context) => CupertinoActionSheet(
          message: const Text(
            'Are you want to clear history?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xFF842700),
              ),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => clearMessagesAndPopDialog(context, pageContext),
              child: const Text(
                'Clear',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: CupertinoColors.systemRed,
                ),
              ),
            )
          ],
        ),
      );

  void clearMessagesAndPopDialog(
    BuildContext context,
    BuildContext pageContext,
  ) {
    ChatData.dummyChat = [];

    Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ChatPage()));
  }
}
