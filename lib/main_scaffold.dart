import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ransomapp/contracts_page.dart';
import 'package:ransomapp/create_contract_page_route.dart';
import 'package:ransomapp/feed_page.dart';
import 'package:ransomapp/firebase_auth_model.dart';
import 'package:ransomapp/listings_page.dart';
import 'package:ransomapp/notifications_page.dart';

class MainScaffold extends StatefulWidget {
  MainScaffold({Key key}) : super(key: key);

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetTabView = <Widget>[
    FeedPage(),
    ContractsPage(),
    ListingsPage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ransom', style: TextStyle(fontFamily: 'Righteous')),
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset('assets/ransom_logo.png'),
            onPressed: () {
              try {
                Provider.of<AuthModel>(context, listen: false).signOut();
              } catch (e) {
                print(e);
              }
            }),
      ),
      body: _widgetTabView.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateContractPageRoute()),
                );
              },
              child: Icon(Icons.add))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text('Contracts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Listings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifcations'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
