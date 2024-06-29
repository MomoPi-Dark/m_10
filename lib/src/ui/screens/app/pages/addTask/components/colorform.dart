import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';

class ColorForm extends StatefulWidget {
  final int selectedColor;
  final void Function(int) onColorSelected;
  final Widget? title;

  const ColorForm({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.title,
  });

  @override
  State<ColorForm> createState() => _ColorFormState();
}

class _ColorFormState extends State<ColorForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) widget.title!,
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              colorList.length,
              (index) => GestureDetector(
                onTap: () {
                  widget.onColorSelected(index);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorList[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.selectedColor == index
                          ? Colors.grey[800]!
                          : Colors.transparent,
                    ),
                  ),
                  child: widget.selectedColor == index
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
