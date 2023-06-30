import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorChatPage extends StatefulWidget {
  final String buyerId;
  final String sellerId;
  final String productId;
  final dynamic data;

  VendorChatPage({
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.data,
  });

  @override
  _VendorChatPageState createState() => _VendorChatPageState();
}

class _VendorChatPageState extends State<VendorChatPage> {
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
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('vendors').doc(widget.sellerId).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productId': widget.productId,
        'buyerName':widget.data['buyerName'],
        'buyerPhoto': widget.data['buyerPhoto'],
        'sellerPhoto': (userDoc.data() as Map<String, dynamic>)['storeImage'],
        'buyerId': widget.buyerId,
        'sellerId': widget.sellerId,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
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
                    bool isSellerMessage =
                        senderId == FirebaseAuth.instance.currentUser!.uid;

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: isSellerMessage
                            ? NetworkImage(data['sellerPhoto'])
                            : NetworkImage(data['buyerPhoto']),
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
