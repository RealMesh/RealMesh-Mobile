import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/bluetooth_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _publicMessages = [];
  final List<ChatMessage> _directMessages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messages),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.public), text: l10n.svet),
            Tab(icon: const Icon(Icons.person), text: l10n.direct),
          ],
        ),
      ),
      body: !bluetoothProvider.isConnected
          ? _buildNotConnectedView(context)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPublicChannelView(context, bluetoothProvider),
                _buildDirectMessagesView(context, bluetoothProvider),
              ],
            ),
    );
  }

  Widget _buildNotConnectedView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.notConnected,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.connectToSendMessages,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPublicChannelView(BuildContext context, BluetoothProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Messages list
        Expanded(
          child: _publicMessages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noMessagesYet,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.broadcastToSvet,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _publicMessages.length,
                  itemBuilder: (context, index) {
                    final message = _publicMessages[_publicMessages.length - 1 - index];
                    return _buildMessageBubble(message, false);
                  },
                ),
        ),
        
        // Message input
        _buildMessageInput(
          context,
          provider,
          hintText: l10n.broadcastToSvetHint,
          onSend: (text) async {
            if (text.trim().isEmpty) return;
            
            final success = await provider.sendMessage('svet', text);
            if (success) {
              setState(() {
                _publicMessages.add(ChatMessage(
                  from: l10n.you,
                  message: text,
                  timestamp: DateTime.now(),
                  isSent: true,
                ));
              });
              _messageController.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _buildDirectMessagesView(BuildContext context, BluetoothProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Messages list
        Expanded(
          child: _directMessages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noDirectMessages,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.sendMessageToNode,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _directMessages.length,
                  itemBuilder: (context, index) {
                    final message = _directMessages[_directMessages.length - 1 - index];
                    return _buildMessageBubble(message, true);
                  },
                ),
        ),
        
        // Message input with recipient selector
        _buildMessageInput(
          context,
          provider,
          hintText: l10n.messageToNode,
          showRecipient: true,
          onSend: (text) async {
            if (text.trim().isEmpty) return;
            
            // TODO: Add recipient selector dialog
            final recipient = await _showRecipientDialog(context, provider);
            if (recipient == null) return;
            
            final success = await provider.sendMessage(recipient, text);
            if (success) {
              setState(() {
                _directMessages.add(ChatMessage(
                  from: l10n.you,
                  to: recipient,
                  message: text,
                  timestamp: DateTime.now(),
                  isSent: true,
                ));
              });
              _messageController.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDirect) {
    final isOwn = message.isSent;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwn) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                message.from[0].toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isOwn ? Colors.blue[500] : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwn)
                    Text(
                      message.from,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isOwn ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  if (isDirect && message.to != null && !isOwn)
                    Text(
                      '→ ${message.to}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isOwn ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isOwn ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isOwn ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isOwn) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[700],
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    BluetoothProvider provider, {
    required String hintText,
    bool showRecipient = false,
    required Function(String) onSend,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (text) => onSend(text),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue[500],
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => onSend(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showRecipientDialog(BuildContext context, BluetoothProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    
    // TODO: Get actual known nodes from provider
    final nodes = <String>['dale@dale', 'dale2@dale']; // Mock data
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectRecipient),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: nodes.map((node) => ListTile(
            leading: const Icon(Icons.person),
            title: Text(node),
            onTap: () => Navigator.pop(context, node),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String from;
  final String? to;
  final String message;
  final DateTime timestamp;
  final bool isSent;

  ChatMessage({
    required this.from,
    this.to,
    required this.message,
    required this.timestamp,
    this.isSent = false,
  });
}
