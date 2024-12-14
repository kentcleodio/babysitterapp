import 'package:babysitterapp/models/user_model.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/babysitter_service.dart';
import '/controller/userdata.dart';
import 'chatboxpage.dart';

class ChatPage extends StatefulWidget {
  final String currentUserID;
  const ChatPage({super.key, required this.currentUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService chatService = ChatService();
  final BabysitterService babysitterService = BabysitterService();
  late List? chatList;
  final UserData userData = UserData();
  late bool isLongPressed;
  List<String> selectedBabysitterId = [];

  @override
  void initState() {
    super.initState();
    isLongPressed = false;
    chatList = null;
    fetchChatList();
  }

  //fetch chat list of the current user
  Future<void> fetchChatList() async {
    chatList = await chatService.getChatListID(widget.currentUserID);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    chatList!.clear();
  }

  //list item of chat of the current user
  Widget babysitterList(UserModel recipient) => InkWell(
        onTap: () {
          if (isLongPressed) {
            setState(() {
              //Add or remove babysitter id to the selected list
              if (selectedBabysitterId.contains(recipient.email)) {
                selectedBabysitterId.remove(recipient.email);
              } else {
                selectedBabysitterId.add(recipient.email);
              }
            });
          } else {
            // Navigate to the chat box of the clicked babysitter
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatBoxPage(
                recipientID: recipient.email,
                currentUserID: widget.currentUserID,
              ),
            ));
          }
        },
        onLongPress: () {
          setState(() {
            //Add babysitter id to the selected list
            selectedBabysitterId.add(recipient.email);
            isLongPressed = true;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 60,
          child: Row(
            children: [
              //if longpressed is true diplay the checkbox
              if (isLongPressed)
                Checkbox(
                  value: selectedBabysitterId.contains(recipient.email),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        //Add babysitter id to the selected list
                        selectedBabysitterId.add(recipient.email);
                      } else {
                        //Remove babysitter id to the selected list
                        selectedBabysitterId.remove(recipient.email);
                      }
                    });
                  },
                ),
              CircleAvatar(
                radius: 30,
                backgroundImage: (recipient.img != null)
                    ? AssetImage(recipient.img ?? defaultImage)
                    : const AssetImage('assets/images/default_user.png'),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(recipient.email),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Change Appbar content based on isLongPressed value
      appBar: (isLongPressed)
          ? AppBar(
              title: Text('${selectedBabysitterId.length} Selected'),
              //cancel button
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    isLongPressed = false;
                    selectedBabysitterId = [];
                  });
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      //delete function
                      print(selectedBabysitterId);
                      isLongPressed = false;
                      selectedBabysitterId = [];
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            )
          : AppBar(
              title: const Text('Messages'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLongPressed = true;
                    });
                  },
                  child: const Text(
                    'Select',
                    style: TextStyle(color: primaryFgColor),
                  ),
                ),
              ],
            ),
      body: (chatList != null)
          ? ListView(
              children: chatList!.map((l) {
                return FutureBuilder(
                  future: babysitterService.getBabysitterByEmail(l),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading data.'),
                      );
                    } else if (snapshot.hasData) {
                      UserModel recipientData = snapshot.data!;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: const AssetImage(defaultImage),
                            foregroundImage:
                                AssetImage(recipientData.img ?? defaultImage),
                            radius: 30,
                          ),
                          title: Text(
                            recipientData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            recipientData.email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatBoxPage(
                                        recipientID: recipientData.email,
                                        currentUserID: widget.currentUserID)));
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No messages yet'),
                      );
                    }
                  },
                );
              }).toList(),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
