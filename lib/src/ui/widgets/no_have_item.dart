import 'package:flutter/material.dart';

class NoHaveItem extends StatelessWidget {
  const NoHaveItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/not_data.png",
        width: 300,
        height: 300,
      ),
    );
  }
}
