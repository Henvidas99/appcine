import 'package:flutter/material.dart';
import '../Tabs/tab_home_screen.dart';
import '../Tabs/tab_tv_screen.dart';
import '../Tabs/tab_account_screen.dart';


void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const LoadContent(),
    );
  }
}

class LoadContent extends StatefulWidget {
  const LoadContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadContentState createState() => _LoadContentState();
}

class _LoadContentState extends State<LoadContent> {
    int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Henrito Movies'),
        backgroundColor: Color.fromARGB(255, 184, 56, 47),
        toolbarHeight: 35,
        actions: [
          IconButton(
          icon: Icon(Icons.search),
            onPressed: () {
            },
          ),
        ], 
      ),
      
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Tv',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const TabHomeScreen(); // Cargar pantalla de inicio
      case 1:
        return const TabTvScreen(); // Cargar pantalla de búsqueda
      case 2:
        return const TabAccountScreen(); // Cargar pantalla de perfil
      default:
        return Container();
    }
  }
}
