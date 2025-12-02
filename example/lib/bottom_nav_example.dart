// // Bottom Navigation Bar Example with Flutter Base
// // This demonstrates how to use BaseApp with bottomNavigationBar

// import 'package:flutter/material.dart';
// import 'package:base_plus/base.dart';

// class BottomNavExampleApp extends StatefulWidget {
//   const BottomNavExampleApp({Key? key}) : super(key: key);

//   @override
//   State<BottomNavExampleApp> createState() => _BottomNavExampleAppState();
// }

// class _BottomNavExampleAppState extends State<BottomNavExampleApp> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     const HomePage(),
//     const FavoritesPage(),
//     const ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BaseApp(
//       title: 'Flutter Base - Bottom Navigation Example',
      
//       // Direct theme configuration
//       lightTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blue,
//           brightness: Brightness.dark,
//         ),
//       ),
//       themeMode: ThemeMode.system,
      
//       // Custom app content
//       home: _pages[_currentIndex],
      
//       // Bottom Navigation Bar - New Feature!
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Example pages
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: BaseAppBar(
//         title: const Text('Home'),
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.home,
//               size: 80,
//               color: Colors.blue,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Home Page',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Welcome to the Flutter Base Bottom Navigation example!',
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: BaseAppBar(
//         title: const Text('Favorites'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.favorite,
//               size: 80,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Favorites Page',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Card(
//               margin: const EdgeInsets.all(16),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Features:',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('• Easy to integrate'),
//                     const Text('• Works with Material 3'),
//                     const Text('• Supports both light and dark themes'),
//                     const Text('• Compatible with GetX'),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Bottom Navigation works perfectly!'),
//                           ),
//                         );
//                       },
//                       child: const Text('Test SnackBar'),
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

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: BaseAppBar(
//         title: const Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.orange,
//               child: Icon(
//                 Icons.person,
//                 size: 60,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Profile Page',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Card(
//               margin: const EdgeInsets.all(16),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.email),
//                       title: const Text('Email'),
//                       subtitle: const Text('user@example.com'),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.phone),
//                       title: const Text('Phone'),
//                       subtitle: const Text('+1 234 567 8900'),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: const Text('Location'),
//                       subtitle: const Text('Flutter Land'),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: const Text('Profile Info'),
//                             content: const Text(
//                               'This profile page demonstrates how BaseApp\'s '
//                               'bottomNavigationBar integrates seamlessly with '
//                               'the rest of your app.',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.of(context).pop(),
//                                 child: const Text('OK'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.info),
//                       label: const Text('Show Info'),
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

// // Alternative example with GetX integration
// class GetXBottomNavExample extends StatefulWidget {
//   const GetXBottomNavExample({Key? key}) : super(key: key);

//   @override
//   State<GetXBottomNavExample> createState() => _GetXBottomNavExampleState();
// }

// class _GetXBottomNavExampleState extends State<GetXBottomNavExample> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     const HomePage(),
//     const FavoritesPage(),
//     const ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BaseApp(
//       title: 'Flutter Base - GetX + Bottom Navigation',
      
//       // Enable GetX functionality
//       useGetX: true,
      
//       // Theme configuration
//       lightTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.green,
//           brightness: Brightness.dark,
//         ),
//       ),
//       themeMode: ThemeMode.system,
      
//       // App content
//       home: _pages[_currentIndex],
      
//       // Bottom Navigation Bar with GetX
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const BottomNavExampleApp());
// }
