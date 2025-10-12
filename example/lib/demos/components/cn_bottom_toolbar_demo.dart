import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// CNBottomToolbar Demo Page showcasing expandable search functionality
class CNBottomToolbarDemo extends StatefulWidget {
  const CNBottomToolbarDemo({Key? key}) : super(key: key);

  @override
  _CNBottomToolbarDemoState createState() => _CNBottomToolbarDemoState();
}

class _CNBottomToolbarDemoState extends State<CNBottomToolbarDemo> 
    with TickerProviderStateMixin {
  String _lastAction = 'No action yet';
  String _searchText = '';
  bool _isSearchFocused = false;
  List<String> _messages = [
    'Hello! How are you doing today?',
    'Meeting at 3 PM - Conference Room A',
    'Don\'t forget to submit the report',
    'Lunch plans for tomorrow?',
    'Project deadline is next Friday',
    'Great job on the presentation!',
    'Team building event next week',
    'Budget review scheduled',
    'Client feedback received',
    'New hire starting Monday',
  ];
  
  List<String> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _filteredMessages = List.from(_messages);
  }

  void _updateAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
      if (text.isEmpty) {
        _filteredMessages = List.from(_messages);
      } else {
        _filteredMessages = _messages
            .where((message) => message.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    });
    _updateAction('Search: "$text" (${_filteredMessages.length} results)');
  }

  void _onSearchFocusChanged(bool focused) {
    setState(() {
      _isSearchFocused = focused;
    });
    _updateAction('Search ${focused ? 'focused' : 'unfocused'}');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Bottom Toolbar Demo'),
      ),
      body: Column(
        children: [
          // Status card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Last Action: $_lastAction'),
                Text('Search Text: "${_searchText}"'),
                Text('Search Focused: $_isSearchFocused'),
                Text('Results: ${_filteredMessages.length} messages'),
              ],
            ),
          ),

          // Message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                final message = _filteredMessages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(message),
                    subtitle: Text('${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _updateAction('Tapped: "$message"');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Bottom toolbar with expandable search
      bottomNavigationBar: BaseCNBottomToolbar(
        leadingAction: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.line_horizontal_3),
          onPressed: () => _updateAction('Menu pressed'),
        ),
        searchPlaceholder: 'Search messages...',
        onSearchChanged: _onSearchChanged,
        onSearchSubmitted: (text) => _updateAction('Search submitted: "$text"'),
        onSearchFocusChanged: _onSearchFocusChanged,
        trailingAction: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.square_pencil),
          onPressed: () => _updateAction('Compose pressed'),
        ),
        currentTabIcon: CupertinoIcons.chat_bubble_2_fill,
        currentTabLabel: 'Messages',
        height: 56,
      ),
    );
  }
}

/// Multiple bottom toolbar examples demo
class CNBottomToolbarVariationsDemo extends StatefulWidget {
  const CNBottomToolbarVariationsDemo({Key? key}) : super(key: key);

  @override
  _CNBottomToolbarVariationsDemoState createState() => _CNBottomToolbarVariationsDemoState();
}

class _CNBottomToolbarVariationsDemoState extends State<CNBottomToolbarVariationsDemo> {
  String _lastAction = 'No action yet';
  int _selectedExample = 0;

  void _updateAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Toolbar Variations'),
      ),
      body: Column(
        children: [
          // Example selector
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: CupertinoSegmentedControl<int>(
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Messages'),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Photos'),
                ),
                2: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Files'),
                ),
              },
              groupValue: _selectedExample,
              onValueChanged: (value) {
                setState(() {
                  _selectedExample = value;
                });
                _updateAction('Switched to example ${value + 1}');
              },
            ),
          ),

          // Status
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text('Last Action: $_lastAction'),
          ),

          // Content area
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getExampleIcon(),
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getExampleTitle(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getExampleDescription(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Dynamic bottom toolbar based on selected example
      bottomNavigationBar: _buildBottomToolbar(),
    );
  }

  IconData _getExampleIcon() {
    switch (_selectedExample) {
      case 0: return CupertinoIcons.chat_bubble_2_fill;
      case 1: return CupertinoIcons.photo_fill;
      case 2: return CupertinoIcons.folder_fill;
      default: return CupertinoIcons.app;
    }
  }

  String _getExampleTitle() {
    switch (_selectedExample) {
      case 0: return 'Messages App';
      case 1: return 'Photos App';
      case 2: return 'Files App';
      default: return 'App';
    }
  }

  String _getExampleDescription() {
    switch (_selectedExample) {
      case 0: return 'Search through your messages with context-aware interface';
      case 1: return 'Find photos quickly with visual search capabilities';
      case 2: return 'Locate files and documents with advanced filtering';
      default: return 'Generic app example';
    }
  }

  Widget _buildBottomToolbar() {
    switch (_selectedExample) {
      case 0: // Messages
        return BaseCNBottomToolbar(
          leadingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.line_horizontal_3),
            onPressed: () => _updateAction('Messages: Menu pressed'),
          ),
          searchPlaceholder: 'Search messages...',
          onSearchChanged: (text) => _updateAction('Messages: Search "$text"'),
          onSearchFocusChanged: (focused) => _updateAction('Messages: Search ${focused ? 'focused' : 'unfocused'}'),
          trailingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.square_pencil),
            onPressed: () => _updateAction('Messages: Compose pressed'),
          ),
          currentTabIcon: CupertinoIcons.chat_bubble_2_fill,
          currentTabLabel: 'Messages',
        );
        
      case 1: // Photos
        return BaseCNBottomToolbar(
          leadingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.square_grid_2x2),
            onPressed: () => _updateAction('Photos: Albums pressed'),
          ),
          searchPlaceholder: 'Search photos...',
          onSearchChanged: (text) => _updateAction('Photos: Search "$text"'),
          onSearchFocusChanged: (focused) => _updateAction('Photos: Search ${focused ? 'focused' : 'unfocused'}'),
          trailingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.camera),
            onPressed: () => _updateAction('Photos: Camera pressed'),
          ),
          currentTabIcon: CupertinoIcons.photo_fill,
          currentTabLabel: 'Photos',
        );
        
      case 2: // Files
        return BaseCNBottomToolbar(
          leadingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.folder),
            onPressed: () => _updateAction('Files: Browse pressed'),
          ),
          searchPlaceholder: 'Search files...',
          onSearchChanged: (text) => _updateAction('Files: Search "$text"'),
          onSearchFocusChanged: (focused) => _updateAction('Files: Search ${focused ? 'focused' : 'unfocused'}'),
          trailingAction: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.plus),
            onPressed: () => _updateAction('Files: Add pressed'),
          ),
          currentTabIcon: CupertinoIcons.folder_fill,
          currentTabLabel: 'Files',
        );
        
      default:
        return BaseCNBottomToolbar(
          searchPlaceholder: 'Search...',
          onSearchChanged: (text) => _updateAction('Search: "$text"'),
        );
    }
  }
}