import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Covid War Room';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final entries = <String>['A', 'B', 'Jaruko'];
  final List<int> colorCodes = <int>[600, 500, 100];
  final entries2 = <String>['dlsfjasdf', 'adfasfasfda', 'asdlfhas;dfasf'];
  final List<int> colorCodes2 = <int>[600, 500, 100];

  Widget _buildList() {
    if (_selectedIndex == 0) {
      return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.amber[colorCodes[index]],
              child: Center(child: Text('Entry ${entries[index]}')),
            );
          });
    } else {
      return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: entries2.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.amber[colorCodes2[index]],
              child: Center(child: Text('Entry ${entries2[index]}')),
            );
          });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getANewItem(_selectedIndex) {
    setState(() {
      if(_selectedIndex==0){
        entries.add('Water');
        colorCodes.add(400);
      }
      else{
        entries2.add('Fire');
        colorCodes2.add(400);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid War Room'),
      ),
      body: Center(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Fluttertoast.showToast(
              msg: 'Test toast for fab',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0);
          _getANewItem(_selectedIndex);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.king_bed_rounded),
            label: 'Bed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Leads',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
