import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedTab = 2; // "New" default selected

  final List<String> tabs = ["Following", "Explore", "New", "Nearby"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 TOP EXPLORER BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  /// Tabs
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        tabs.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = index;
                            });
                          },
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: selectedTab == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selectedTab == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Icons
                  Row(
                    children: const [
                      Icon(Icons.search, size: 26),
                      SizedBox(width: 12),
                      Icon(Icons.emoji_events, color: Colors.amber),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// 🔹 CONTENT AREA
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  /// 🔹 TAB CONTENT SWITCH
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return const Center(child: Text("Following Content"));
      case 1:
        return const Center(child: Text("Explore Content"));
      case 2:
        return const Center(child: Text("New Content"));
      case 3:
        return const Center(child: Text("Nearby Content"));
      default:
        return const SizedBox();
    }
  }
}
