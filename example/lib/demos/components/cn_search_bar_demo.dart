import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// Comprehensive demo showcasing CNSearchBar functionality
/// 
/// Demonstrates native iOS UISearchBar features including:
/// - Basic search functionality with real-time filtering
/// - Scope bar for content categorization
/// - Various search bar styles and configurations
/// - Keyboard and input customization options
/// - Apple HIG compliant search patterns
class CNSearchBarDemo extends StatefulWidget {
  const CNSearchBarDemo({Key? key}) : super(key: key);

  @override
  State<CNSearchBarDemo> createState() => _CNSearchBarDemoState();
}

class _CNSearchBarDemoState extends State<CNSearchBarDemo> {
  String _searchText = '';
  int _selectedScope = 0;
  
  // Sample data for filtering
  final List<Map<String, dynamic>> _allItems = [
    {'title': 'The Shawshank Redemption', 'type': 'Movie', 'year': '1994', 'genre': 'Drama'},
    {'title': 'Breaking Bad', 'type': 'TV Show', 'year': '2008', 'genre': 'Crime'},
    {'title': 'The Godfather', 'type': 'Movie', 'year': '1972', 'genre': 'Crime'},
    {'title': 'Game of Thrones', 'type': 'TV Show', 'year': '2011', 'genre': 'Fantasy'},
    {'title': 'Pulp Fiction', 'type': 'Movie', 'year': '1994', 'genre': 'Crime'},
    {'title': 'The Office', 'type': 'TV Show', 'year': '2005', 'genre': 'Comedy'},
    {'title': 'The Dark Knight', 'type': 'Movie', 'year': '2008', 'genre': 'Action'},
    {'title': 'Friends', 'type': 'TV Show', 'year': '1994', 'genre': 'Comedy'},
    {'title': 'Forrest Gump', 'type': 'Movie', 'year': '1994', 'genre': 'Drama'},
    {'title': 'Stranger Things', 'type': 'TV Show', 'year': '2016', 'genre': 'Sci-Fi'},
    {'title': 'The Matrix', 'type': 'Movie', 'year': '1999', 'genre': 'Sci-Fi'},
    {'title': 'The Crown', 'type': 'TV Show', 'year': '2016', 'genre': 'Drama'},
  ];

  final List<String> _scopeTitles = ['All', 'Movies', 'TV Shows'];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _allItems;
    
    // Filter by scope
    if (_selectedScope == 1) {
      items = items.where((item) => item['type'] == 'Movie').toList();
    } else if (_selectedScope == 2) {
      items = items.where((item) => item['type'] == 'TV Show').toList();
    }
    
    // Filter by search text
    if (_searchText.isNotEmpty) {
      items = items.where((item) {
        final title = item['title'].toString().toLowerCase();
        final genre = item['genre'].toString().toLowerCase();
        final year = item['year'].toString();
        final search = _searchText.toLowerCase();
        
        return title.contains(search) || 
               genre.contains(search) || 
               year.contains(search);
      }).toList();
    }
    
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('CNSearchBar Demo'),
      ),
      body: Column(
        children: [
          // Main search bar with scope filtering
          BaseCNSearchBar(
            placeholder: 'Shows, Movies, and More',
            showsCancelButton: true,
            showsScopeBar: true,
            scopeButtonTitles: _scopeTitles,
            selectedScopeIndex: _selectedScope,
            prompt: 'Search your entertainment library',
            onTextChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
            onSearchButtonClicked: (text) {
              // Handle search submission
              debugPrint('Search submitted: $text');
            },
            onCancelButtonClicked: () {
              setState(() {
                _searchText = '';
              });
            },
            onScopeChanged: (index) {
              setState(() {
                _selectedScope = index;
              });
            },
            height: 56,
          ),
          
          // Search results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final items = _filteredItems;
    
    if (items.isEmpty && _searchText.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.search,
              size: 64,
              color: CupertinoColors.systemGrey,
            ),
            SizedBox(height: 16),
            Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemGrey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey2,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildResultItem(item);
      },
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    final title = item['title'] as String;
    final type = item['type'] as String;
    final year = item['year'] as String;
    final genre = item['genre'] as String;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Type icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: type == 'Movie' 
                ? CupertinoColors.systemBlue.withOpacity(0.1)
                : CupertinoColors.systemGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type == 'Movie' ? CupertinoIcons.film : CupertinoIcons.tv,
              color: type == 'Movie' 
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGreen,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type • $year • $genre',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow icon
          const Icon(
            CupertinoIcons.chevron_right,
            color: CupertinoColors.systemGrey3,
            size: 16,
          ),
        ],
      ),
    );
  }
}

/// Demo showcasing different CNSearchBar styles and configurations
class CNSearchBarVariationsDemo extends StatefulWidget {
  const CNSearchBarVariationsDemo({Key? key}) : super(key: key);

  @override
  State<CNSearchBarVariationsDemo> createState() => _CNSearchBarVariationsDemoState();
}

class _CNSearchBarVariationsDemoState extends State<CNSearchBarVariationsDemo> {
  String _basicSearch = '';
  String _prominentSearch = '';
  String _minimalSearch = '';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Search Bar Styles'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Basic Search Bar
          _buildSection(
            'Default Style',
            'Standard iOS search bar with basic functionality',
            BaseCNSearchBar(
              placeholder: 'Search messages',
              showsCancelButton: true,
              searchBarStyle: CNSearchBarStyle.defaultStyle,
              onTextChanged: (text) => setState(() => _basicSearch = text),
              onCancelButtonClicked: () => setState(() => _basicSearch = ''),
              height: 44,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Prominent Search Bar
          _buildSection(
            'Prominent Style',
            'Enhanced search bar with prominent visual treatment',
            BaseCNSearchBar(
              placeholder: 'Search photos',
              showsCancelButton: true,
              showsBookmarkButton: true,
              searchBarStyle: CNSearchBarStyle.prominent,
              barTintColor: CupertinoColors.systemBlue.withOpacity(0.1),
              tintColor: CupertinoColors.systemBlue,
              onTextChanged: (text) => setState(() => _prominentSearch = text),
              onCancelButtonClicked: () => setState(() => _prominentSearch = ''),
              onBookmarkButtonClicked: () {
                debugPrint('Bookmark button pressed');
              },
              height: 56,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Minimal Search Bar
          _buildSection(
            'Minimal Style',
            'Streamlined search bar with minimal visual elements',
            BaseCNSearchBar(
              placeholder: 'Quick search',
              searchBarStyle: CNSearchBarStyle.minimal,
              keyboardType: CNKeyboardType.webSearch,
              returnKeyType: CNReturnKeyType.search,
              onTextChanged: (text) => setState(() => _minimalSearch = text),
              height: 36,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Advanced Configuration
          _buildSection(
            'Advanced Features',
            'Search bar with scope filtering and custom keyboard',
            BaseCNSearchBar(
              placeholder: 'Search contacts',
              prompt: 'Find people in your network',
              showsCancelButton: true,
              showsScopeBar: true,
              scopeButtonTitles: const ['All', 'Friends', 'Family', 'Work'],
              selectedScopeIndex: 0,
              keyboardType: CNKeyboardType.namePhonePad,
              autocapitalizationType: CNAutocapitalizationType.words,
              autocorrectionType: CNAutocorrectionType.yes,
              onTextChanged: (text) {
                debugPrint('Advanced search: $text');
              },
              onScopeChanged: (index) {
                debugPrint('Scope changed to: $index');
              },
              height: 50,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Current Search States
          _buildSearchStates(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, Widget searchBar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: searchBar,
        ),
      ],
    );
  }

  Widget _buildSearchStates() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Search States',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchState('Default', _basicSearch),
          _buildSearchState('Prominent', _prominentSearch),
          _buildSearchState('Minimal', _minimalSearch),
        ],
      ),
    );
  }

  Widget _buildSearchState(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '(no search)' : '"$value"',
              style: TextStyle(
                fontSize: 14,
                color: value.isEmpty 
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.label,
                fontStyle: value.isEmpty ? FontStyle.italic : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}