import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'meme_editor_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to Create Meme screen
      context.go('/createMeme');
    } else {
      setState(() {
        _selectedIndex = index;
      });
      // Handle other tabs if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEMIT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {
              // Handle mail icon tap
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.sentiment_satisfied_alt),
                Icon(Icons.sports_basketball),
                Icon(Icons.movie_creation_outlined),
                Icon(Icons.account_balance),
                Icon(Icons.article_outlined),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  1, // Just one item for demonstration based on the image
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 8.0),
                            const Expanded(
                              child: Text(
                                'User Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // Handle more options tap
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300.0, // Placeholder for the content area
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {
                                // Handle like tap
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              onPressed: () {
                                // Handle comment tap
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.send_outlined),
                              onPressed: () {
                                // Handle send tap
                              },
                            ),
                            const Spacer(),
                            // Floating action button positioned here
                            // The image shows it overlaid, we'll handle this below
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add button tap
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MemeEditorPage()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add), // Adjust color as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
        selectedItemColor: activeColor, // Use the activeColor from the theme
        unselectedItemColor: Colors.grey, // Adjust unselected item color
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
