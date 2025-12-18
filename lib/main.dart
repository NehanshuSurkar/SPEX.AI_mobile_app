import 'package:code_canvas/constants/cyberpunk_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/spex_home.dart';
import 'screens/url_input_screen.dart';

import 'providers/spex_chat_provider.dart';

void main() {
  runApp(const SpexApp());
}

class SpexApp extends StatelessWidget {
  const SpexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpexChatProvider(),
      child: MaterialApp(
        title: 'SPEX.AI',
        theme: SpexTheme.theme,
        debugShowCheckedModeBanner: false,
        home: Consumer<SpexChatProvider>(
          builder: (context, chatProvider, child) {
            // Show URL input screen if not initialized
            if (!chatProvider.isInitialized) {
              return const UrlInputScreen();
            }
            // Show main chat screen once initialized
            return const SpexHome();
          },
        ),
      ),
    );
  }
}

// import 'package:code_canvas/Screens/drawer/welcome_screen.dart';
// import 'package:code_canvas/Screens/url_input_screen.dart';
// import 'package:code_canvas/constants/cyberpunk_theme.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:code_canvas/providers/spex_chat_provider.dart';

// void main() {
//   runApp(const SpexApp());
// }

// class SpexApp extends StatelessWidget {
//   const SpexApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => SpexChatProvider(),
//       child: MaterialApp(
//         title: 'SPEX.AI',
//         theme: SpexTheme.theme,
//         debugShowCheckedModeBanner: false,
//         home: const SpexWelcomeWrapper(), // Start with welcome wrapper
//       ),
//     );
//   }
// }

// class SpexWelcomeWrapper extends StatefulWidget {
//   const SpexWelcomeWrapper({super.key});

//   @override
//   State<SpexWelcomeWrapper> createState() => _SpexWelcomeWrapperState();
// }

// class _SpexWelcomeWrapperState extends State<SpexWelcomeWrapper> {
//   late SpexChatProvider _provider;

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return SpexWelcomeScreen(
//       onNewSession: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const UrlInputScreen()),
//         );
//       },
//     );
//   }
// }
