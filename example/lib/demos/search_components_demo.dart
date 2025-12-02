import 'package:base_plus/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// Demo for search functionality across different components
class SearchComponentsDemo extends StatefulWidget {
  const SearchComponentsDemo({Key? key}) : super(key: key);

  @override
  State<SearchComponentsDemo> createState() => _SearchComponentsDemoState();
}

class _SearchComponentsDemoState extends State<SearchComponentsDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: Text('Search Components Demo'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SearchToolbarDemo(),
          SearchNavigationBarDemo(),
          SearchTabBarDemo(),
        ],
      ),
      bottomNavigationBar: BaseTabBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Toolbar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tab),
            label: 'Tab Bar',
          ),
        ],
      ),
    );
  }
}

/// Demo for search toolbar
class SearchToolbarDemo extends StatefulWidget {
  const SearchToolbarDemo({Key? key}) : super(key: key);

  @override
  State<SearchToolbarDemo> createState() => _SearchToolbarDemoState();
}

class _SearchToolbarDemoState extends State<SearchToolbarDemo> {
  String _searchText = '';
  List<String> _allItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
  ];

  List<String> get _filteredItems {
    if (_searchText.isEmpty) return _allItems;
    return _allItems
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Toolbar Example
        BaseToolbar.search(
          leading: [
            BaseToolbarAction(
              icon: CNSymbol('star.fill'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favorites tapped!')),
                );
              },
            ),
          ],
          trailing: [
            BaseToolbarAction(
              label: 'Cancel',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cancel tapped!')),
                );
              },
            ),
            BaseToolbarAction(
              icon: CNSymbol('ellipsis.circle'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('More options tapped!')),
                );
              },
            ),
          ],
          searchConfig: CNSearchConfig(
            placeholder: 'Search fruits...',
            onSearchTextChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
            resultsBuilder: (context, text) => SearchResultsWidget(
              searchText: text,
              results: _filteredItems,
            ),
          ),
          contextIcon: CNSymbol('leaf.fill'),
          tint: Colors.blue,
        ),
        
        // Results Display
        Expanded(
          child: SearchResultsWidget(
            searchText: _searchText,
            results: _filteredItems,
          ),
        ),
      ],
    );
  }
}

/// Demo for search navigation bar
class SearchNavigationBarDemo extends StatefulWidget {
  const SearchNavigationBarDemo({Key? key}) : super(key: key);

  @override
  State<SearchNavigationBarDemo> createState() => _SearchNavigationBarDemoState();
}

class _SearchNavigationBarDemoState extends State<SearchNavigationBarDemo> {
  String _searchText = '';
  List<String> _allContacts = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Brown',
    'Diana Prince',
    'Edward Norton',
    'Fiona Apple',
    'George Martin',
    'Helen Hunt',
    'Ivan Drago',
    'Jane Doe',
  ];

  List<String> get _filteredContacts {
    if (_searchText.isEmpty) return _allContacts;
    return _allContacts
        .where((contact) => contact.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Navigation Bar Example
        BaseNavigationBar.search(
          leading: [
            BaseNavigationBarAction(
              label: 'Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          trailing: [
            BaseNavigationBarAction(
              icon: CNSymbol('plus'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add contact tapped!')),
                );
              },
            ),
            BaseNavigationBarAction.fixedSpace(8),
            BaseNavigationBarAction(
              icon: CNSymbol('ellipsis.circle'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('More options tapped!')),
                );
              },
            ),
          ],
          searchConfig: CNSearchConfig(
            placeholder: 'Search contacts...',
            onSearchTextChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
            resultsBuilder: (context, text) => ContactSearchResultsWidget(
              searchText: text,
              contacts: _filteredContacts,
            ),
          ),
          titleSize: 20,
          onTitlePressed: () {
            print('Title tapped!');
            // Show a simple alert to demonstrate the tap
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Title Tapped'),
                content: const Text('The navigation bar title was tapped!'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          },
          tint: Colors.green,
        ),
        
        // Results Display
        Expanded(
          child: ContactSearchResultsWidget(
            searchText: _searchText,
            contacts: _filteredContacts,
          ),
        ),
      ],
    );
  }
}

/// Demo for search tab bar
class SearchTabBarDemo extends StatefulWidget {
  const SearchTabBarDemo({Key? key}) : super(key: key);

  @override
  State<SearchTabBarDemo> createState() => _SearchTabBarDemoState();
}

class _SearchTabBarDemoState extends State<SearchTabBarDemo> {
  String _searchText = '';
  int _currentTabIndex = 0;
  
  List<String> _allCategories = [
    'Technology',
    'Sports',
    'Music',
    'Movies',
    'Food',
    'Travel',
    'Art',
    'Science',
    'History',
    'Nature',
  ];

  List<String> get _filteredCategories {
    if (_searchText.isEmpty) return _allCategories;
    return _allCategories
        .where((category) => category.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Content area
        Expanded(
          child: CategorySearchResultsWidget(
            searchText: _searchText,
            categories: _filteredCategories,
            currentTab: _currentTabIndex,
          ),
        ),
        
        // Search Tab Bar Example
        BaseTabBar.search(
          currentIndex: _currentTabIndex,
          onTap: (index) => setState(() => _currentTabIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          searchConfig: CNSearchConfig(
            placeholder: 'Search categories...',
            onSearchTextChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
            resultsBuilder: (context, text) => CategorySearchResultsWidget(
              searchText: text,
              categories: _filteredCategories,
              currentTab: _currentTabIndex,
            ),
          ),
          cnTint: Colors.purple,
          useNativeCupertinoTabBar: true,
        ),
      ],
    );
  }
}

/// Generic search results widget
class SearchResultsWidget extends StatelessWidget {
  final String searchText;
  final List<String> results;

  const SearchResultsWidget({
    Key? key,
    required this.searchText,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchText.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Start typing to search',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No results for "$searchText"',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: const Icon(Icons.local_grocery_store),
          title: _buildHighlightedText(item, searchText),
          subtitle: Text('Fruit #${index + 1}'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: $item')),
            );
          },
        );
      },
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text);
    
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];
    
    int start = 0;
    int index = textLower.indexOf(queryLower);
    
    while (index >= 0) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ));
      
      start = index + query.length;
      index = textLower.indexOf(queryLower, start);
    }
    
    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return RichText(text: TextSpan(children: spans, style: const TextStyle(color: Colors.black)));
  }
}

/// Contact search results widget
class ContactSearchResultsWidget extends StatelessWidget {
  final String searchText;
  final List<String> contacts;

  const ContactSearchResultsWidget({
    Key? key,
    required this.searchText,
    required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchText.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search your contacts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No contacts found for "$searchText"',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(contact[0]),
          ),
          title: _buildHighlightedText(contact, searchText),
          subtitle: Text('Contact #${index + 1}'),
          trailing: const Icon(Icons.phone),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Calling $contact')),
            );
          },
        );
      },
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text);
    
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];
    
    int start = 0;
    int index = textLower.indexOf(queryLower);
    
    while (index >= 0) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          backgroundColor: Colors.green,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ));
      
      start = index + query.length;
      index = textLower.indexOf(queryLower, start);
    }
    
    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return RichText(text: TextSpan(children: spans, style: const TextStyle(color: Colors.black)));
  }
}

/// Category search results widget
class CategorySearchResultsWidget extends StatelessWidget {
  final String searchText;
  final List<String> categories;
  final int currentTab;

  const CategorySearchResultsWidget({
    Key? key,
    required this.searchText,
    required this.categories,
    required this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tabName = ['Home', 'Favorites', 'Profile'][currentTab];
    
    if (searchText.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getTabIcon(currentTab), size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Welcome to $tabName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for categories above',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No categories found for "$searchText"',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(_getCategoryIcon(category), color: Colors.purple),
            title: _buildHighlightedText(category, searchText),
            subtitle: Text('Shown in $tabName tab'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exploring $category in $tabName')),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0: return Icons.home;
      case 1: return Icons.star;
      case 2: return Icons.person;
      default: return Icons.tab;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technology': return Icons.computer;
      case 'sports': return Icons.sports_soccer;
      case 'music': return Icons.music_note;
      case 'movies': return Icons.movie;
      case 'food': return Icons.restaurant;
      case 'travel': return Icons.flight;
      case 'art': return Icons.palette;
      case 'science': return Icons.science;
      case 'history': return Icons.history_edu;
      case 'nature': return Icons.nature;
      default: return Icons.category;
    }
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text);
    
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];
    
    int start = 0;
    int index = textLower.indexOf(queryLower);
    
    while (index >= 0) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          backgroundColor: Colors.purple,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ));
      
      start = index + query.length;
      index = textLower.indexOf(queryLower, start);
    }
    
    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return RichText(text: TextSpan(children: spans, style: const TextStyle(color: Colors.black)));
  }
}