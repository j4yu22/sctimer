import 'package:flutter/material.dart';

class HeaderUI extends StatelessWidget {
  const HeaderUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 28,
            onPressed: () {
              // Handle settings press
            },
          ),

          // Dropdowns
          Row(
            children: [
              _buildDropdown(),
              const SizedBox(width: 8),
              _buildDropdown(),
              const SizedBox(width: 8),
              _buildDropdown(),
            ],
          ),

          // Wrench Icon
          IconButton(
            icon: const Icon(Icons.build),
            iconSize: 24,
            onPressed: () {
              // Handle tool press
            },
          ),
        ],
      ),
    );
  }

  // Private dropdown builder
  Widget _buildDropdown() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<String>(
        value: null,
        hint: const Text(''),
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(), // Remove default underline
        items: const [
          DropdownMenuItem(value: '1', child: Text('1')),
          DropdownMenuItem(value: '2', child: Text('2')),
          DropdownMenuItem(value: '3', child: Text('3')),
        ],
        onChanged: (value) {
          // Handle dropdown change
        },
      ),
    );
  }
}
