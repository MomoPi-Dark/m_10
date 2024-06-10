import 'package:flutter/material.dart';

import '../configs/text.dart';

profileLayout({
  String? topDescription,
  String? bottomDescription,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 13),
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/pp.jpg"),
              radius: 24,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topDescription ?? "Hi,",
                  style: subTitleTextStyle.copyWith(fontSize: 15),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    truncateName("Iqbal Afnan", 20),
                    style: titleTextStyle.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
