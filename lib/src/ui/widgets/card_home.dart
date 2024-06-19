import 'package:flutter/material.dart';

class CardHome extends StatelessWidget {
  const CardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Sun'),
            subtitle: Text('Sun'),
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
