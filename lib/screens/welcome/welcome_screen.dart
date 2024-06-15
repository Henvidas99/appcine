import 'package:flutter/material.dart';
import '../Tabs/tab_home_screen.dart';
import '../Tabs/tab_ticket_screen.dart';
import '../Tabs/tab_account_screen.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';

void main() {
  runApp(const WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadContent(),
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
    if (index == 1) {
      Provider.of<SeatSelectionProvider>(context, listen: false).clearSelectedSeats();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:      
        return const TabHomeScreen(); 
      case 1:
        return const TabTicketScreen(); 
      case 2:
        return const TabAccountScreen(); 
      default:
        return Container();
    }
  }
}
