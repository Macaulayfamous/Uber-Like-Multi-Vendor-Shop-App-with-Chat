import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InnerChatScreen extends StatefulWidget {
  final String productName;
  final String buyerId;
  final String sellerId;
  final String productId;

  InnerChatScreen(
      {required this.buyerId,
      required this.sellerId,
      required this.productId,
      required this.productName});

  @override
  _InnerChatScreenState createState() => _InnerChatScreenState();
}

class _InnerChatScreenState extends State<InnerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firestore
        .collection('chats')
        .where('buyerId', isEqualTo: widget.buyerId)
        .where('sellerId', isEqualTo: widget.sellerId)
        .where(
          'productId',
          isEqualTo: widget.productId,
        )
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('vendors').doc(widget.sellerId).get();
    DocumentSnapshot buyerDoc =
        await _firestore.collection('buyers').doc(widget.buyerId).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productId': widget.productId,
        'buyerName': (buyerDoc.data() as Map<String, dynamic>)['firstName'],
        'buyerPhoto': (buyerDoc.data() as Map<String, dynamic>)['userImage'],
        'sellerPhoto': (userDoc.data() as Map<String, dynamic>)['storeImage'],
        'buyerId': widget.buyerId,
        'sellerId': widget.sellerId,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
      });
    }

    setState(() {
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Chat' + "> " + "" + widget.productName,
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages.'),
                  );
                }

                return ListView(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String message = data['message'].toString();
                    String senderId = data['senderId']
                        .toString(); // Assuming 'senderId' field exists

                    // Determine if the sender is the buyer or the seller
                    bool isBuyer = senderId == widget.buyerId;
                    String senderType = isBuyer ? 'Buyer' : 'Seller';

                    bool isBuyerMessage =
                        senderId == FirebaseAuth.instance.currentUser!.uid;

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: isBuyerMessage
                            ? NetworkImage(data['buyerPhoto'])
                            : NetworkImage(data['sellerPhoto']),
                      ),
                      title: Text(message),
                      subtitle: Text('Sent by $senderType'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
