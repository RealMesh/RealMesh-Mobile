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
            
            try {
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
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.failedToSendMessage)),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.error}: $e')),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildDirectMessagesView(BuildContext context, BluetoothProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    // Get known nodes and organize conversations
    // Filter out the current node's address (you can't message yourself)
    final currentNodeAddress = provider.nodeStatus?.address;
    final knownNodes = <String>['dale@dale', 'dale2@dale'] // TODO: Get from provider
        .where((node) => node != currentNodeAddress)
        .toList();
    
    final conversationPartners = _directMessages
        .map((msg) => msg.isSent ? msg.to : msg.from)
        .where((addr) => addr != null && addr != l10n.you)
        .cast<String>()
        .toSet()
        .toList();
    
    final nodesWithoutConversation = knownNodes
        .where((node) => !conversationPartners.contains(node))
        .toList();
    
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[100],
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.searchNodes,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onChanged: (value) {
              // TODO: Implement search filtering
            },
          ),
        ),
        
        // Available nodes list
        Expanded(
          child: ListView(
            children: [
              // Nodes with existing conversations
              if (conversationPartners.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.recentConversations,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...conversationPartners.map((node) => _buildNodeListItem(
                  context,
                  node,
                  hasConversation: true,
                  onTap: () => _openConversation(context, provider, node),
                )),
              ],
              
              // Nodes without conversations
              if (nodesWithoutConversation.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.availableNodes,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...nodesWithoutConversation.map((node) => _buildNodeListItem(
                  context,
                  node,
                  hasConversation: false,
                  onTap: () => _openConversation(context, provider, node),
                )),
              ],
              
              // Empty state
              if (knownNodes.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noNodesAvailable,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.waitForNodeDiscovery,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildNodeListItem(
    BuildContext context,
    String nodeAddress, {
    required bool hasConversation,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    // Get last message with this node
    final lastMessage = hasConversation
        ? _directMessages
            .where((msg) => msg.from == nodeAddress || msg.to == nodeAddress)
            .lastOrNull
        : null;
    
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: hasConversation ? Colors.blue[100] : Colors.grey[200],
            child: Icon(
              Icons.person,
              color: hasConversation ? Colors.blue[700] : Colors.grey[500],
            ),
          ),
          if (!hasConversation)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        nodeAddress,
        style: TextStyle(
          fontWeight: hasConversation ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: lastMessage != null
          ? Text(
              lastMessage.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            )
          : Text(
              l10n.noMessagesYet,
              style: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastMessage != null)
            Text(
              _formatTime(lastMessage.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          if (!hasConversation)
            Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[400]),
        ],
      ),
      onTap: onTap,
    );
  }
  
  void _openConversation(BuildContext context, BluetoothProvider provider, String nodeAddress) {
    final l10n = AppLocalizations.of(context)!;
    
    // Filter messages for this conversation
    final conversationMessages = _directMessages
        .where((msg) => msg.from == nodeAddress || msg.to == nodeAddress)
        .toList();
    
    // Navigate to conversation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ConversationScreen(
          nodeAddress: nodeAddress,
          messages: conversationMessages,
          provider: provider,
          onSendMessage: (text) async {
            if (text.trim().isEmpty) return;
            
            final success = await provider.sendMessage(nodeAddress, text);
            if (success) {
              setState(() {
                _directMessages.add(ChatMessage(
                  from: l10n.you,
                  to: nodeAddress,
                  message: text,
                  timestamp: DateTime.now(),
                  isSent: true,
                ));
              });
            }
          },
        ),
      ),
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

// Conversation screen for direct messaging
class _ConversationScreen extends StatefulWidget {
  final String nodeAddress;
  final List<ChatMessage> messages;
  final BluetoothProvider provider;
  final Function(String) onSendMessage;

  const _ConversationScreen({
    required this.nodeAddress,
    required this.messages,
    required this.provider,
    required this.onSendMessage,
  });

  @override
  State<_ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<_ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.nodeAddress),
            Text(
              l10n.directMessage,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: widget.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          l10n.startConversation,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      final message = widget.messages[widget.messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Input
          Container(
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
                        hintText: l10n.typeMessage,
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
                      onSubmitted: (text) {
                        widget.onSendMessage(text);
                        _messageController.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue[500],
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {
                        widget.onSendMessage(_messageController.text);
                        _messageController.clear();
                        Navigator.pop(context);
                      },
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

  Widget _buildMessageBubble(ChatMessage message) {
    final isOwn = message.isSent;
    final l10n = AppLocalizations.of(context)!;

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

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
