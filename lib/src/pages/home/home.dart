import 'package:flutter/material.dart';
import 'package:history_go/src/pages/pages.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(icon: Icon(Icons.map), text: 'KARTA'),
    Tab(icon: Icon(Icons.local_play), text: 'UPPDRAG'),
    Tab(icon: Icon(Icons.person), text: 'PROFIL'),
    Tab(icon: Icon(Icons.search), text: 'SÖK'),
  ];

  TabController _tabController;
  int selectedIndex = 0;

  @override
  initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: selectedIndex,
    );
    _tabController.addListener(() {
      setState(() {
        if (selectedIndex != _tabController.index) {
          selectedIndex = _tabController.index;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
        labelColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(fontSize: 12, color: Colors.black),
        unselectedLabelColor: Theme.of(context).primaryColorLight,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3.0,
            ),
          ),
        ),
        controller: _tabController,
        tabs: tabs,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          MapPage(),
          MissionsPage(),
          ProfilePage(),
          SearchPage(),
        ],
      ),
    );
  }
}
