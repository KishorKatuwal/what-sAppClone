import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_clone/common/widgets/loader_screen.dart';
import 'package:wa_clone/features/call/controller/call_controller.dart';
import 'package:wa_clone/models/user_model.dart';

import '../../../colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);


  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
        context, name, uid, profilePic, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                children: [
                  Text(name),
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: ()=> makeCall(ref, context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            receiverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}


//9/10/09