// import 'package:code_canvas/constants/cyberpunk_theme.dart';
// import 'package:code_canvas/providers/spex_chat_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:provider/provider.dart';

// class SpexChatInterface extends StatefulWidget {
//   const SpexChatInterface({super.key});

//   @override
//   State<SpexChatInterface> createState() => _SpexChatInterfaceState();
// }

// class _SpexChatInterfaceState extends State<SpexChatInterface> {
//   final List<Map<String, String>> _messages = [
//     {
//       'role': 'assistant',
//       'content': 'System online. SPEX engine ready. Waiting for input...',
//     },
//   ];
//   bool _isTyping = false;
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//   }

//   void _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     // Get provider properly
//     final chatProvider = context.read<SpexChatProvider>();

//     // Check if chat is active
//     if (!chatProvider.isChatActive) {
//       print('❌ Chat is not active yet!');
//       return;
//     }

//     print('📤 Sending message: $text');

//     try {
//       // Call provider's send function
//       await chatProvider.sendChatMessage(text.trim());
//       print('✅ Message sent to provider');
//     } catch (e) {
//       print('❌ Error sending message: $e');
//       // Show error to user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // // In your chat interface, replace sendMessage function:
//   // void _sendMessage(String text) async {
//   //   if (text.trim().isEmpty) return;

//   //   // Get provider from context
//   //   final chatProvider = context.read<SpexChatProvider>();

//   //   // Send message through provider
//   //   await chatProvider.sendChatMessage(text.trim());

//   //   // UI will update automatically through provider
//   // }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: 300.ms,
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<SpexChatProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         children: [
//           // Messages Area
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length + (_isTyping ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index < _messages.length) {
//                   final message = _messages[index];
//                   return _MessageBubble(
//                         role: message['role']!,
//                         content: message['content']!,
//                       )
//                       .animate(delay: (index * 100).ms)
//                       .fadeIn()
//                       .slideY(begin: 0.1, duration: 300.ms);
//                 } else {
//                   return _TypingIndicator();
//                 }
//               },
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Quick Actions
//           Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _ActionChip(
//                   label: 'Analyze Domain',
//                   icon: Icons.search,
//                   onTap: () => _sendMessage('Analyze Domain'),
//                 ),
//                 const SizedBox(width: 12),
//                 _ActionChip(
//                   label: 'Extract Schema',
//                   icon: Icons.schema,
//                   onTap: () => _sendMessage('Extract Schema'),
//                 ),
//                 const SizedBox(width: 12),
//                 _ActionChip(
//                   label: 'View Logs',
//                   icon: Icons.list_alt,
//                   onTap: () => _sendMessage('View Logs'),
//                 ),
//                 const SizedBox(width: 12),
//                 _ActionChip(
//                   label: 'Clear Cache',
//                   icon: Icons.delete_outline,
//                   onTap: () => _sendMessage('Clear Cache'),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Input Area
//           Container(
//             decoration: SpexTheme.glassBox,
//             child: Container(
//               padding: const EdgeInsets.all(2),
//               decoration: SpexTheme.cyanGlowBorder,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: SpexColors.spexSurface,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _textController,
//                         style: Theme.of(context).textTheme.bodyLarge,
//                         decoration: InputDecoration(
//                           hintText: 'Enter instructions to generate agent...',
//                           hintStyle:
//                               Theme.of(context).inputDecorationTheme.hintStyle,
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 20,
//                           ),
//                         ),
//                         onSubmitted: (value) {
//                           _sendMessage(value);
//                           _textController.clear();
//                         },
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           _sendMessage(_textController.text);
//                           _textController.clear();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               _textController.text.trim().isNotEmpty
//                                   ? SpexColors.spexYellow
//                                   : SpexColors.spexWhite.withOpacity(0.05),
//                           foregroundColor:
//                               _textController.text.trim().isNotEmpty
//                                   ? Colors.black
//                                   : SpexColors.spexWhite.withOpacity(0.2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                           elevation: 0,
//                         ),
//                         child:
//                             _isTyping
//                                 ? SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.black,
//                                   ),
//                                 )
//                                 : Icon(
//                                   Icons.arrow_forward,
//                                   size: 24,
//                                   color:
//                                       _textController.text.trim().isNotEmpty
//                                           ? Colors.black
//                                           : SpexColors.spexWhite.withOpacity(
//                                             0.2,
//                                           ),
//                                 ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // --------------------------------------------------------------------------------------------------------------------------
//           // Add this as a floating button or in your quick actions
//           FloatingActionButton(
//             onPressed: () async {
//               print('🔍 DEBUG: Manual test started');

//               final provider = context.read<SpexChatProvider>();
//               print('   isChatActive: ${provider.isChatActive}');
//               print('   collectionName: ${provider.collectionName}');
//               print('   websiteUrl: ${provider.websiteUrl}');
//               print('   messages count: ${provider.messages.length}');

//               // Try sending a test message
//               await provider.sendChatMessage('What is Flutter?');
//             },
//             child: Icon(Icons.bug_report),
//           ),

//           const SizedBox(height: 16),

//           // Footer
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 6,
//                 height: 6,
//                 margin: const EdgeInsets.only(right: 8),
//                 decoration: BoxDecoration(
//                   color: SpexColors.spexYellow,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: SpexColors.spexYellow.withOpacity(0.8),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 'Encrypted Connection v2.4.0',
//                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   color: SpexColors.spexTextSecondary,
//                   letterSpacing: 2.0,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MessageBubble extends StatefulWidget {
//   final String role;
//   final String content;

//   const _MessageBubble({required this.role, required this.content});

//   @override
//   State<_MessageBubble> createState() => _MessageBubbleState();
// }

// class _MessageBubbleState extends State<_MessageBubble> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final isBot = widget.role == 'assistant';

//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Avatar
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color:
//                     isBot
//                         ? SpexColors.spexYellow.withOpacity(0.1)
//                         : SpexColors.spexCyan.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color:
//                       isBot
//                           ? SpexColors.spexYellow.withOpacity(0.3)
//                           : SpexColors.spexCyan.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Icon(
//                 isBot ? Icons.memory : Icons.person,
//                 size: 20,
//                 color: isBot ? SpexColors.spexYellow : SpexColors.spexCyan,
//               ),
//             ),

//             const SizedBox(width: 16),

//             // Content Box
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color:
//                       isBot
//                           ? SpexColors.botMessageBg
//                           : SpexColors.userMessageBg,
//                   borderRadius: BorderRadius.only(
//                     topLeft: isBot ? Radius.zero : const Radius.circular(20),
//                     topRight: isBot ? const Radius.circular(20) : Radius.zero,
//                     bottomLeft: const Radius.circular(20),
//                     bottomRight: const Radius.circular(20),
//                   ),
//                   border: Border.all(
//                     color:
//                         _isHovered
//                             ? (isBot
//                                 ? SpexColors.spexYellow.withOpacity(0.3)
//                                 : SpexColors.spexCyan.withOpacity(0.3))
//                             : SpexColors.spexBorder,
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.content,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),

//                     // Hover Footer
//                     AnimatedOpacity(
//                       opacity: _isHovered ? 1 : 0,
//                       duration: 300.ms,
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 12),
//                         child: Row(
//                           children: [
//                             Text(
//                               isBot ? 'SPEX_CORE' : 'USER_ID_01',
//                               style: Theme.of(
//                                 context,
//                               ).textTheme.labelSmall?.copyWith(
//                                 color:
//                                     isBot
//                                         ? SpexColors.spexYellow
//                                         : SpexColors.spexCyan,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Container(
//                               width: 1,
//                               height: 12,
//                               color: SpexColors.spexTextSecondary,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               DateTime.now().toString().substring(11, 16),
//                               style: Theme.of(
//                                 context,
//                               ).textTheme.bodySmall?.copyWith(
//                                 color: SpexColors.spexTextSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TypingIndicator extends StatefulWidget {
//   @override
//   State<_TypingIndicator> createState() => _TypingIndicatorState();
// }

// class _TypingIndicatorState extends State<_TypingIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: SpexColors.spexYellow.withOpacity(0.1),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: SpexColors.spexYellow.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Icon(Icons.memory, size: 20, color: SpexColors.spexYellow),
//           ),

//           const SizedBox(width: 16),

//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: SpexColors.botMessageBg,
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               border: Border.all(color: SpexColors.spexBorder, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.circle, size: 14, color: SpexColors.spexYellow),
//                 const SizedBox(width: 8),
//                 Text(
//                   'PROCESSING DATA STREAM...',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: SpexColors.spexYellow,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionChip extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;

//   const _ActionChip({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   State<_ActionChip> createState() => _ActionChipState();
// }

// class _ActionChipState extends State<_ActionChip> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: 300.ms,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration:
//               _isHovered ? SpexTheme.activeActionChip : SpexTheme.actionChip,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 6,
//                 height: 6,
//                 margin: const EdgeInsets.only(right: 12),
//                 decoration: BoxDecoration(
//                   color:
//                       _isHovered
//                           ? SpexColors.spexCyan
//                           : SpexColors.spexWhite.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               Icon(
//                 widget.icon,
//                 size: 14,
//                 color: _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 widget.label.toUpperCase(),
//                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   color:
//                       _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//----------------------------------------------------------------------------------------------------------------------------------------
// import 'package:code_canvas/constants/cyberpunk_theme.dart';
// import 'package:code_canvas/providers/spex_chat_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:provider/provider.dart';

// class SpexChatInterface extends StatefulWidget {
//   const SpexChatInterface({super.key});

//   @override
//   State<SpexChatInterface> createState() => _SpexChatInterfaceState();
// }

// class _SpexChatInterfaceState extends State<SpexChatInterface> {
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );

//     // Add debug print
//     print('💬 SpexChatInterface initialized');
//   }

//   void _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     print('📤 _sendMessage called with: "$text"');

//     // Get provider properly using context
//     final chatProvider = context.read<SpexChatProvider>();

//     // Debug info
//     print('   isChatActive: ${chatProvider.isChatActive}');
//     print('   collectionName: ${chatProvider.collectionName}');
//     print('   websiteUrl: ${chatProvider.websiteUrl}');

//     // Check if chat is active
//     if (!chatProvider.isChatActive) {
//       print('❌ Chat is not active yet!');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Chat is not ready yet. Please wait for indexing to complete.',
//           ),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     try {
//       // Clear input first
//       final message = text.trim();
//       _textController.clear();

//       // Call provider's send function
//       print('📤 Calling provider.sendChatMessage...');
//       await chatProvider.sendChatMessage(message);
//       print('✅ Message sent to provider');
//     } catch (e) {
//       print('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: 300.ms,
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('💬 SpexChatInterface building...');

//     return Consumer<SpexChatProvider>(
//       builder: (context, chatProvider, child) {
//         print('   Consumer: messages count = ${chatProvider.messages.length}');
//         print('   Consumer: isChatActive = ${chatProvider.isChatActive}');

//         return Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             children: [
//               // Status indicator
//               if (!chatProvider.isChatActive)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.1),
//                     border: Border.all(color: Colors.orange),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.info, color: Colors.orange, size: 16),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           chatProvider.isCrawling
//                               ? '🕸️ Crawling website...'
//                               : chatProvider.isIndexing
//                               ? '📚 Indexing content...'
//                               : '⏳ Waiting for website initialization...',
//                           style: const TextStyle(color: Colors.orange),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Messages Area - NOW USING PROVIDER'S MESSAGES
//               Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   itemCount: chatProvider.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = chatProvider.messages[index];
//                     print('   Rendering message $index: ${message['role']}');

//                     // Scroll to bottom when new messages added
//                     if (index == chatProvider.messages.length - 1) {
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         _scrollToBottom();
//                       });
//                     }

//                     return _MessageBubble(
//                           role: message['role'] as String,
//                           content: message['content'] as String,
//                           isError: message['isError'] == true,
//                         )
//                         .animate(delay: (index * 100).ms)
//                         .fadeIn()
//                         .slideY(begin: 0.1, duration: 300.ms);
//                   },
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Quick Actions - Only show when chat is active
//               if (chatProvider.isChatActive)
//                 Container(
//                   height: 60,
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       _ActionChip(
//                         label: 'What is Flutter?',
//                         icon: Icons.question_mark,
//                         onTap: () => _sendMessage('What is Flutter?'),
//                       ),
//                       const SizedBox(width: 12),
//                       _ActionChip(
//                         label: 'How to install?',
//                         icon: Icons.download,
//                         onTap: () => _sendMessage('How do I install Flutter?'),
//                       ),
//                       const SizedBox(width: 12),
//                       _ActionChip(
//                         label: 'Mobile support',
//                         icon: Icons.phone_android,
//                         onTap:
//                             () => _sendMessage(
//                               'What platforms does Flutter support?',
//                             ),
//                       ),
//                       const SizedBox(width: 12),
//                       _ActionChip(
//                         label: 'Widgets',
//                         icon: Icons.widgets,
//                         onTap: () => _sendMessage('What are Flutter widgets?'),
//                       ),
//                     ],
//                   ),
//                 ),

//               const SizedBox(height: 16),

//               // Input Area - Only show when chat is active
//               if (chatProvider.isChatActive)
//                 Container(
//                   decoration: SpexTheme.glassBox,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: SpexTheme.cyanGlowBorder,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: SpexColors.spexSurface,
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _textController,
//                               style: Theme.of(context).textTheme.bodyLarge,
//                               decoration: InputDecoration(
//                                 hintText: 'Ask about the website...',
//                                 hintStyle:
//                                     Theme.of(
//                                       context,
//                                     ).inputDecorationTheme.hintStyle,
//                                 border: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                   vertical: 20,
//                                 ),
//                               ),
//                               onSubmitted: (value) {
//                                 _sendMessage(value);
//                               },
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(right: 8),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (_textController.text.trim().isNotEmpty) {
//                                   _sendMessage(_textController.text);
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     _textController.text.trim().isNotEmpty
//                                         ? SpexColors.spexYellow
//                                         : SpexColors.spexWhite.withOpacity(
//                                           0.05,
//                                         ),
//                                 foregroundColor:
//                                     _textController.text.trim().isNotEmpty
//                                         ? Colors.black
//                                         : SpexColors.spexWhite.withOpacity(0.2),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 16,
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child:
//                                   _textController.text.trim().isNotEmpty
//                                       ? Icon(
//                                         Icons.arrow_forward,
//                                         size: 24,
//                                         color: Colors.black,
//                                       )
//                                       : Icon(
//                                         Icons.arrow_forward,
//                                         size: 24,
//                                         color: SpexColors.spexWhite.withOpacity(
//                                           0.2,
//                                         ),
//                                       ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//               // Debug Button - Keep for testing
//               FloatingActionButton(
//                 mini: true,
//                 onPressed: () async {
//                   print('🔍 DEBUG: Manual test started');
//                   final provider = context.read<SpexChatProvider>();
//                   print('   isChatActive: ${provider.isChatActive}');
//                   print('   collectionName: ${provider.collectionName}');
//                   print('   websiteUrl: ${provider.websiteUrl}');
//                   print('   messages count: ${provider.messages.length}');
//                   print('   crawledPages: ${provider.crawledPages.length}');

//                   if (provider.isChatActive &&
//                       provider.collectionName != null) {
//                     print('   ✅ Sending test message...');
//                     await provider.sendChatMessage('What is Flutter?');
//                   } else {
//                     print('   ❌ Cannot send - chat not ready');
//                   }
//                 },
//                 child: Icon(Icons.bug_report, size: 20),
//               ).animate().scale(delay: 1.seconds),

//               const SizedBox(height: 16),

//               // Footer
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 6,
//                     height: 6,
//                     margin: const EdgeInsets.only(right: 8),
//                     decoration: BoxDecoration(
//                       color:
//                           chatProvider.isChatActive
//                               ? Colors.green
//                               : SpexColors.spexYellow,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: (chatProvider.isChatActive
//                                   ? Colors.green
//                                   : SpexColors.spexYellow)
//                               .withOpacity(0.8),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     chatProvider.isChatActive
//                         ? '✅ Chat Active | ${chatProvider.crawledPages.length} pages indexed'
//                         : '🔴 Initializing...',
//                     style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                       color:
//                           chatProvider.isChatActive
//                               ? Colors.green
//                               : SpexColors.spexTextSecondary,
//                       letterSpacing: 1.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _MessageBubble extends StatefulWidget {
//   final String role;
//   final String content;
//   final bool isError;

//   const _MessageBubble({
//     required this.role,
//     required this.content,
//     this.isError = false,
//   });

//   @override
//   State<_MessageBubble> createState() => _MessageBubbleState();
// }

// class _MessageBubbleState extends State<_MessageBubble> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final isBot = widget.role == 'assistant';
//     final isSystem =
//         widget.content.contains('✅ Website indexed') ||
//         widget.content.contains('pages crawled');

//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Avatar
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color:
//                     isSystem
//                         ? Colors.green.withOpacity(0.1)
//                         : isBot
//                         ? SpexColors.spexYellow.withOpacity(0.1)
//                         : SpexColors.spexCyan.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color:
//                       isSystem
//                           ? Colors.green.withOpacity(0.3)
//                           : isBot
//                           ? SpexColors.spexYellow.withOpacity(0.3)
//                           : SpexColors.spexCyan.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Icon(
//                 isSystem
//                     ? Icons.check_circle
//                     : isBot
//                     ? Icons.memory
//                     : Icons.person,
//                 size: 20,
//                 color:
//                     isSystem
//                         ? Colors.green
//                         : isBot
//                         ? SpexColors.spexYellow
//                         : SpexColors.spexCyan,
//               ),
//             ),

//             const SizedBox(width: 16),

//             // Content Box
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color:
//                       widget.isError
//                           ? Colors.red.withOpacity(0.05)
//                           : isSystem
//                           ? Colors.green.withOpacity(0.05)
//                           : isBot
//                           ? SpexColors.botMessageBg
//                           : SpexColors.userMessageBg,
//                   borderRadius: BorderRadius.only(
//                     topLeft: isBot ? Radius.zero : const Radius.circular(20),
//                     topRight: isBot ? const Radius.circular(20) : Radius.zero,
//                     bottomLeft: const Radius.circular(20),
//                     bottomRight: const Radius.circular(20),
//                   ),
//                   border: Border.all(
//                     color:
//                         widget.isError
//                             ? Colors.red
//                             : isSystem
//                             ? Colors.green
//                             : _isHovered
//                             ? (isBot
//                                 ? SpexColors.spexYellow.withOpacity(0.3)
//                                 : SpexColors.spexCyan.withOpacity(0.3))
//                             : SpexColors.spexBorder,
//                     width: widget.isError || isSystem ? 2 : 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.content,
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         color:
//                             widget.isError
//                                 ? Colors.red
//                                 : isSystem
//                                 ? Colors.green
//                                 : SpexColors.spexWhite,
//                       ),
//                     ),

//                     // Hover Footer - Only show for non-system messages
//                     if (!isSystem && !widget.isError)
//                       AnimatedOpacity(
//                         opacity: _isHovered ? 1 : 0,
//                         duration: 300.ms,
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 12),
//                           child: Row(
//                             children: [
//                               Text(
//                                 isBot ? 'SPEX.AI' : 'You',
//                                 style: Theme.of(
//                                   context,
//                                 ).textTheme.labelSmall?.copyWith(
//                                   color:
//                                       isBot
//                                           ? SpexColors.spexYellow
//                                           : SpexColors.spexCyan,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 width: 1,
//                                 height: 12,
//                                 color: SpexColors.spexTextSecondary,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 DateTime.now().toString().substring(11, 16),
//                                 style: Theme.of(
//                                   context,
//                                 ).textTheme.bodySmall?.copyWith(
//                                   color: SpexColors.spexTextSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TypingIndicator extends StatefulWidget {
//   @override
//   State<_TypingIndicator> createState() => _TypingIndicatorState();
// }

// class _TypingIndicatorState extends State<_TypingIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: SpexColors.spexYellow.withOpacity(0.1),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: SpexColors.spexYellow.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Icon(Icons.memory, size: 20, color: SpexColors.spexYellow),
//           ),

//           const SizedBox(width: 16),

//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: SpexColors.botMessageBg,
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               border: Border.all(color: SpexColors.spexBorder, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.circle, size: 14, color: SpexColors.spexYellow),
//                 const SizedBox(width: 8),
//                 Text(
//                   'PROCESSING DATA STREAM...',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: SpexColors.spexYellow,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionChip extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;

//   const _ActionChip({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   State<_ActionChip> createState() => _ActionChipState();
// }

// class _ActionChipState extends State<_ActionChip> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: 300.ms,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration:
//               _isHovered
//                   ? BoxDecoration(
//                     color: SpexColors.spexCyan.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: SpexColors.spexCyan, width: 1),
//                   )
//                   : BoxDecoration(
//                     color: SpexColors.spexSurface,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: SpexColors.spexBorder, width: 1),
//                   ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 widget.icon,
//                 size: 14,
//                 color: _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 widget.label,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color:
//                       _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:code_canvas/providers/spex_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class SpexChatInterface extends StatefulWidget {
  const SpexChatInterface({super.key});

  @override
  State<SpexChatInterface> createState() => _SpexChatInterfaceState();
}

class _SpexChatInterfaceState extends State<SpexChatInterface> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Get provider properly using context
    final chatProvider = context.read<SpexChatProvider>();

    // Check if chat is active
    if (!chatProvider.isChatActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Chat is not ready yet. Please wait for indexing to complete.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Clear input first
      final message = text.trim();
      _textController.clear();

      // Call provider's send function
      await chatProvider.sendChatMessage(message);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpexChatProvider>(
      builder: (context, chatProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Status indicator
              if (!chatProvider.isChatActive)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.isCrawling
                              ? '🕸️ Crawling website...'
                              : chatProvider.isIndexing
                              ? '📚 Indexing content...'
                              : '⏳ Waiting for website initialization...',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),

              // Messages Area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];

                    // Scroll to bottom when new messages added
                    if (index == chatProvider.messages.length - 1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }

                    return _MessageBubble(
                          role: message['role'] as String,
                          content: message['content'] as String,
                          isError: message['isError'] == true,
                        )
                        .animate(delay: (index * 100).ms)
                        .fadeIn()
                        .slideY(begin: 0.1, duration: 300.ms);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Website-specific Quick Actions
              if (chatProvider.isChatActive && chatProvider.websiteUrl != null)
                _WebsiteSpecificActions(
                  websiteUrl: chatProvider.websiteUrl!,
                  onSendMessage: _sendMessage,
                ),

              const SizedBox(height: 16),

              // Input Area - Only show when chat is active
              if (chatProvider.isChatActive)
                Container(
                  decoration: SpexTheme.glassBox,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: SpexTheme.cyanGlowBorder,
                    child: Container(
                      decoration: BoxDecoration(
                        color: SpexColors.spexSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText:
                                    'Ask about ${chatProvider.websiteUrl ?? "the website"}...',
                                hintStyle:
                                    Theme.of(
                                      context,
                                    ).inputDecorationTheme.hintStyle,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                              ),
                              onSubmitted: (value) {
                                _sendMessage(value);
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_textController.text.trim().isNotEmpty) {
                                  _sendMessage(_textController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _textController.text.trim().isNotEmpty
                                        ? SpexColors.spexYellow
                                        : SpexColors.spexWhite.withOpacity(
                                          0.05,
                                        ),
                                foregroundColor:
                                    _textController.text.trim().isNotEmpty
                                        ? Colors.black
                                        : SpexColors.spexWhite.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                elevation: 0,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 24,
                                color:
                                    _textController.text.trim().isNotEmpty
                                        ? Colors.black
                                        : SpexColors.spexWhite.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color:
                          chatProvider.isChatActive
                              ? Colors.green
                              : SpexColors.spexYellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (chatProvider.isChatActive
                                  ? Colors.green
                                  : SpexColors.spexYellow)
                              .withOpacity(0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    chatProvider.isChatActive
                        ? '✅ Chat Active | ${chatProvider.crawledPages.length} pages indexed'
                        : '🔴 Initializing...',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color:
                          chatProvider.isChatActive
                              ? Colors.green
                              : SpexColors.spexTextSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Website-specific action chips widget
class _WebsiteSpecificActions extends StatelessWidget {
  final String websiteUrl;
  final Function(String) onSendMessage;

  const _WebsiteSpecificActions({
    required this.websiteUrl,
    required this.onSendMessage,
  });

  List<_ActionChipData> _getSuggestedQuestions() {
    // Extract domain from URL
    final uri = Uri.tryParse(websiteUrl);
    final domain = uri?.host ?? websiteUrl;

    return [
      _ActionChipData(
        label: 'What is this website about?',
        icon: Icons.info_outline,
        question: 'What is the main purpose of this website?',
      ),
      _ActionChipData(
        label: 'Key Features',
        icon: Icons.star_border,
        question: 'What are the main features or services offered?',
      ),
      _ActionChipData(
        label: 'Getting Started',
        icon: Icons.play_arrow,
        question: 'How do I get started with this website/service?',
      ),
      _ActionChipData(
        label: 'Latest Updates',
        icon: Icons.update,
        question: 'What are the recent updates or changes?',
      ),
      _ActionChipData(
        label: 'Documentation',
        icon: Icons.article,
        question: 'Is there documentation available and where can I find it?',
      ),
      _ActionChipData(
        label: 'Contact/Support',
        icon: Icons.support_agent,
        question: 'How can I get support or contact the team?',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getSuggestedQuestions();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Show first 4 suggestions (you can adjust this number)
          for (int i = 0; i < questions.length && i < 4; i++)
            Padding(
              padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
              child: _ActionChip(
                label: questions[i].label,
                icon: questions[i].icon,
                onTap: () => onSendMessage(questions[i].question),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionChipData {
  final String label;
  final IconData icon;
  final String question;

  _ActionChipData({
    required this.label,
    required this.icon,
    required this.question,
  });
}

class _ActionChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ActionChip> createState() => _ActionChipState();
}

class _ActionChipState extends State<_ActionChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration:
              _isHovered
                  ? BoxDecoration(
                    color: SpexColors.spexCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SpexColors.spexCyan, width: 1),
                  )
                  : BoxDecoration(
                    color: SpexColors.spexSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SpexColors.spexBorder, width: 1),
                  ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      _isHovered ? SpexColors.spexCyan : SpexColors.spexWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final String role;
  final String content;
  final bool isError;

  const _MessageBubble({
    required this.role,
    required this.content,
    this.isError = false,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isBot = widget.role == 'assistant';
    final isSystem =
        widget.content.contains('✅ Website indexed') ||
        widget.content.contains('pages crawled');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isSystem
                        ? Colors.green.withOpacity(0.1)
                        : isBot
                        ? SpexColors.spexYellow.withOpacity(0.1)
                        : SpexColors.spexCyan.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSystem
                          ? Colors.green.withOpacity(0.3)
                          : isBot
                          ? SpexColors.spexYellow.withOpacity(0.3)
                          : SpexColors.spexCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                isSystem
                    ? Icons.check_circle
                    : isBot
                    ? Icons.memory
                    : Icons.person,
                size: 20,
                color:
                    isSystem
                        ? Colors.green
                        : isBot
                        ? SpexColors.spexYellow
                        : SpexColors.spexCyan,
              ),
            ),

            const SizedBox(width: 16),

            // Content Box
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      widget.isError
                          ? Colors.red.withOpacity(0.05)
                          : isSystem
                          ? Colors.green.withOpacity(0.05)
                          : isBot
                          ? SpexColors.botMessageBg
                          : SpexColors.userMessageBg,
                  borderRadius: BorderRadius.only(
                    topLeft: isBot ? Radius.zero : const Radius.circular(20),
                    topRight: isBot ? const Radius.circular(20) : Radius.zero,
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  border: Border.all(
                    color:
                        widget.isError
                            ? Colors.red
                            : isSystem
                            ? Colors.green
                            : _isHovered
                            ? (isBot
                                ? SpexColors.spexYellow.withOpacity(0.3)
                                : SpexColors.spexCyan.withOpacity(0.3))
                            : SpexColors.spexBorder,
                    width: widget.isError || isSystem ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            widget.isError
                                ? Colors.red
                                : isSystem
                                ? Colors.green
                                : SpexColors.spexWhite,
                      ),
                    ),

                    // Hover Footer - Only show for non-system messages
                    if (!isSystem && !widget.isError)
                      AnimatedOpacity(
                        opacity: _isHovered ? 1 : 0,
                        duration: 300.ms,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Text(
                                isBot ? 'SPEX.AI' : 'You',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  color:
                                      isBot
                                          ? SpexColors.spexYellow
                                          : SpexColors.spexCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 12,
                                color: SpexColors.spexTextSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateTime.now().toString().substring(11, 16),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: SpexColors.spexTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SpexColors.spexYellow.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: SpexColors.spexYellow.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(Icons.memory, size: 20, color: SpexColors.spexYellow),
          ),

          const SizedBox(width: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SpexColors.botMessageBg,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: SpexColors.spexBorder, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 14, color: SpexColors.spexYellow),
                const SizedBox(width: 8),
                Text(
                  'PROCESSING DATA STREAM...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SpexColors.spexYellow,
                    fontFamily: 'monospace',
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
