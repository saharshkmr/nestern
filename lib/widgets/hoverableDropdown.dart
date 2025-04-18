import 'dart:async';
import 'package:flutter/material.dart';

class HoverableDropdown extends StatelessWidget {
  final String title;
  final List<PopupMenuItem<String>> items;
  final Widget? badge;
  final Function(String)? onSelected; // Added onSelected parameter

  HoverableDropdown({
    required this.title,
    required this.items,
    this.badge,
    this.onSelected, // Initialize onSelected
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<PopupMenuButtonState<String>> _popupKey = GlobalKey();
    Timer? _closeTimer;

    return MouseRegion(
      onEnter: (_) {
        // Cancel any existing close timer
        _closeTimer?.cancel();

        // Open the dropdown when hovered
        final dynamic popupMenuState = _popupKey.currentState;
        popupMenuState?.showButtonMenu();
      },
      onExit: (_) {
        // Start a timer to close the dropdown after a short delay
        _closeTimer = Timer(Duration(milliseconds: 2), () {
          final dynamic popupMenuState = _popupKey.currentState;
          popupMenuState?.hideButtonMenu();
        });
      },
      child: PopupMenuButton<String>(
        key: _popupKey,
        onSelected: (value) {
          if (onSelected != null) {
            onSelected!(value); // Call the onSelected callback
          }
        },
        itemBuilder: (BuildContext context) => items,
        child: Row(
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
            if (badge != null) ...[
              SizedBox(width: 4),
              badge!,
            ],
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }
}