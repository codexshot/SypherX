import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../app_constants/app_colors.dart';

class CustomDropDownButton extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;

  const CustomDropDownButton(
      {super.key, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_vert_rounded,
          color: greyColor,
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem,onDelete, onEdit);
        },
        dropdownStyleData: DropdownStyleData(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 15),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item, Function() onDelete, Function() onEdit) {
    switch (item) {
      case MenuItems.edit:
        onEdit();
        break;
      case MenuItems.delete:
        onDelete();
        break;
    }
  }
}
