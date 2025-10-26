import 'package:base/base.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Pull-down button classes are re-exported from base_widgets via base_cn_pull_down_button

/// Comprehensive demo of all cupertino_native components
/// Shows CNButton, CNIcon, CNSlider, CNSwitch, CNSegmentedControl, and CNPopupMenuButton
class CupertinoNativeDemo extends StatefulWidget {
  const CupertinoNativeDemo({Key? key}) : super(key: key);

  @override
  State<CupertinoNativeDemo> createState() => _CupertinoNativeDemoState();
}

class _CupertinoNativeDemoState extends State<CupertinoNativeDemo> {
  String _lastAction = 'No action yet';
  String _lastInlineAction = 'None';
  double _sliderValue = 50.0;
  bool _switchValue = true;
  bool _coloredSwitchValue = false;
  int _segmentedControlIndex = 0;
  
  // For format sheet demo
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;

  // For CNPopupButton demo - separate state for each button to show independent behavior
  int _filterIndex1 = 0; // Plain style button
  int _filterIndex2 = 0; // Tinted style button
  int _filterIndex3 = 0; // Gray style button with prefix
  final List<String> _filterOptions = ['All', 'Images', 'Videos', 'Documents'];

  void _set(String action) {
    setState(() => _lastAction = action);
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Native Components'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Status',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Last Action: $_lastAction',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          
          _buildSection(
            title: 'CNButton Styles',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.plain,
                  onPressed: () => _set('Plain Button'),
                  shrinkWrap: true,
                  child: const Text('Plain'),
                ),
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.gray,
                  onPressed: () => _set('Gray Button'),
                  shrinkWrap: true,
                  child: const Text('Gray'),
                ),
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.filled,
                  onPressed: () => _set('Filled Button'),
                  shrinkWrap: true,
                  child: const Text('Filled'),
                ),
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.tinted,
                  onPressed: () => _set('Tinted Button'),
                  shrinkWrap: true,
                  child: const Text('Tinted'),
                ),
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.bordered,
                  onPressed: () => _set('Bordered Button'),
                  shrinkWrap: true,
                  child: const Text('Bordered'),
                ),
                BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.prominentGlass,
                  onPressed: () => _set('ProminentGlass'),
                  shrinkWrap: true,
                  child: const Text('ProminentGlass'),
                ),
                const BaseButton(
                  useCNButton: true,
                  cnButtonStyle: CNButtonStyle.bordered,
                  onPressed: null,
                  shrinkWrap: true,
                  child: Text('Disabled'),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'CNButton with Icons',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CNButton.icon(
                  icon: const CNSymbol('heart.fill', size: 18),
                  style: CNButtonStyle.plain,
                  onPressed: () => _set('Icon Plain'),
                ),
                CNButton.icon(
                  icon: const CNSymbol('heart.fill', size: 18),
                  style: CNButtonStyle.gray,
                  onPressed: () => _set('Icon Gray'),
                ),
                CNButton.icon(
                  icon: const CNSymbol('star.fill', size: 18),
                  style: CNButtonStyle.filled,
                  onPressed: () => _set('Icon Filled'),
                ),
                CNButton.icon(
                  icon: const CNSymbol('gearshape', size: 18),
                  style: CNButtonStyle.tinted,
                  onPressed: () => _set('Icon Tinted'),
                ),
                CNButton.icon(
                  icon: const CNSymbol('trash', size: 18),
                  style: CNButtonStyle.bordered,
                  onPressed: () => _set('Icon Bordered'),
                ),
                CNButton.icon(
                  icon: const CNSymbol('paperplane.fill', size: 18),
                  style: CNButtonStyle.prominentGlass,
                  onPressed: () => _set('Icon ProminentGlass'),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'CNIcon (SF Symbols)',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BaseCNIcon(symbol: 'heart', size: 32),
                BaseCNIcon(symbol: 'heart.fill', size: 32),
                BaseCNIcon(symbol: 'star', size: 32),
                BaseCNIcon(symbol: 'star.fill', size: 32),
                BaseCNIcon(symbol: 'bolt.fill', size: 32),
                BaseCNIcon(symbol: 'flame.fill', size: 32),
              ],
            ),
          ),

          _buildSection(
            title: 'CNIcon with Colors',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BaseCNIcon(
                  symbol: 'heart.fill',
                  size: 32,
                  color: Colors.red,
                  fallbackIcon: Icons.favorite,
                ),
                BaseCNIcon(
                  symbol: 'star.fill',
                  size: 32,
                  color: Colors.orange,
                  fallbackIcon: Icons.star,
                ),
                BaseCNIcon(
                  symbol: 'bolt.fill',
                  size: 32,
                  color: Colors.yellow,
                  fallbackIcon: Icons.flash_on,
                ),
                BaseCNIcon(
                  symbol: 'drop.fill',
                  size: 32,
                  color: Colors.blue,
                  fallbackIcon: Icons.water_drop,
                ),
                BaseCNIcon(
                  symbol: 'leaf.fill',
                  size: 32,
                  color: Colors.green,
                  fallbackIcon: Icons.eco,
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'CNSegmentedControl',
            child: Column(
              children: [
                BaseSegmentedControl(
                  labels: const ['One', 'Two', 'Three'],
                  selectedIndex: _segmentedControlIndex,
                  onValueChanged: (i) {
                    setState(() => _segmentedControlIndex = i);
                    _set('Segment ${i + 1}');
                  },
                ),
                const SizedBox(height: 8),
                Text('Selected: ${_segmentedControlIndex + 1}'),
              ],
            ),
          ),

          _buildSection(
            title: 'CNSlider',
            child: Column(
              children: [
                BaseSlider(
                  value: _sliderValue,
                  min: 0,
                  max: 100,
                  onChanged: (v) {
                    setState(() => _sliderValue = v);
                    _set('Slider: ${v.toStringAsFixed(1)}');
                  },
                ),
                Text('Value: ${_sliderValue.toStringAsFixed(1)}'),
              ],
            ),
          ),

          _buildSection(
            title: 'CNSwitch',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Basic Switch'),
                    BaseSwitch(
                      value: _switchValue,
                      onChanged: (v) {
                        setState(() => _switchValue = v);
                        _set('Switch: $v');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Colored Switch'),
                    BaseSwitch(
                      value: _coloredSwitchValue,
                      // color: CupertinoColors.systemPink,
                      onChanged: (v) {
                        setState(() => _coloredSwitchValue = v);
                        _set('Colored Switch: $v');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BasePopupMenuButton',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BasePopupMenuButton.icon(
                  items: const [
                    BasePopupMenuItem(
                      label: 'Edit',
                      iosIcon: 'pencil',
                      iconData: Icons.edit,
                    ),
                    BasePopupMenuItem(
                      label: 'Share',
                      iosIcon: 'square.and.arrow.up',
                      iconData: Icons.share,
                    ),
                    BasePopupMenuItem.divider(),
                    BasePopupMenuItem(
                      label: 'Delete',
                      iosIcon: 'trash',
                      iconData: Icons.delete,
                    ),
                  ],
                  onSelected: (index) {
                    final actions = ['Edit', 'Share', 'Delete'];
                    if (index < actions.length) {
                      _set('Popup: ${actions[index]}');
                    }
                  },
                ),
                BasePopupMenuButton(
                  buttonLabel: 'Actions',
                  items: const [
                    BasePopupMenuItem(
                      label: 'New File',
                      iosIcon: 'doc',
                      iconData: Icons.insert_drive_file,
                    ),
                    BasePopupMenuItem(
                      label: 'New Folder',
                      iosIcon: 'folder',
                      iconData: Icons.folder,
                    ),
                    BasePopupMenuItem.divider(),
                    BasePopupMenuItem(
                      label: 'Settings',
                      iosIcon: 'gearshape',
                      iconData: Icons.settings,
                    ),
                  ],
                  onSelected: (index) {
                    final actions = ['New File', 'New Folder', 'Settings'];
                    if (index < actions.length) {
                      _set('Action: ${actions[index]}');
                    }
                  },
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNPullDownButton (NEW!)',
            child: Column(
              children: [
                const Text(
                  'Native iOS pull-down button with inline actions',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    // Icon-style pull-down button with inline actions
                    BaseCNPullDownButton.icon(
                      buttonIcon: const CNSymbol('ellipsis.circle', size: 24),
                      size: 44,
                      items: const [
                        CNPullDownMenuInlineActions(
                          actions: [
                            CNPullDownInlineAction(
                              label: 'Crop',
                              icon: CNSymbol('crop', size: 24),
                            ),
                            CNPullDownInlineAction(
                              label: 'Filter',
                              icon: CNSymbol('camera.filters', size: 24),
                            ),
                            CNPullDownInlineAction(
                              label: 'Adjust',
                              icon: CNSymbol('slider.horizontal.3', size: 24),
                            ),
                          ],
                        ),
                        CNPullDownMenuDivider(),
                        CNPullDownMenuItem(
                          label: 'Save to Photos',
                          icon: CNSymbol('square.and.arrow.down'),
                        ),
                        const CNPullDownMenuDivider(),
                        CNPullDownMenuSubmenu(
                          title: 'Attachment View',
                          icon: CNSymbol('paperclip'),
                          items: [
                            CNPullDownMenuItem(
                              label: 'Gallery View',
                              icon: CNSymbol('square.grid.2x2'),
                            ),
                            CNPullDownMenuItem(
                              label: 'List View',
                              icon: CNSymbol('list.bullet'),
                            ),
                          ],
                        ),
                        CNPullDownMenuItem(
                          label: 'Duplicate',
                          icon: CNSymbol('doc.on.doc'),
                        ),
                        CNPullDownMenuDivider(),
                        CNPullDownMenuItem(
                          label: 'Delete',
                          icon: CNSymbol('trash'),
                          isDestructive: true,
                        ),
                      ],
                      onSelected: (index) {
                        final actions = ['Save to Photos', 'Duplicate', 'Delete'];
                        setState(() => _lastAction = 'Menu: ${actions[index]}');
                      },
                      onInlineActionSelected: (index) {
                        final actions = ['Crop', 'Filter', 'Adjust'];
                        setState(() {
                          _lastAction = 'Inline: ${actions[index]}';
                          _lastInlineAction = actions[index];
                        });
                      },
                    ),
                    
                    // Label-style pull-down button
                    BaseCNPullDownButton(
                      buttonLabel: 'Edit Photo',
                      items: const [
                        CNPullDownMenuItem(
                          label: 'Rotate Left',
                          icon: CNSymbol('rotate.left'),
                        ),
                        CNPullDownMenuItem(
                          label: 'Rotate Right',
                          icon: CNSymbol('rotate.right'),
                        ),
                        CNPullDownMenuDivider(),
                        CNPullDownMenuItem(
                          label: 'Flip Horizontal',
                          icon: CNSymbol('arrow.left.and.right'),
                        ),
                      ],
                      onSelected: (index) {
                        final actions = ['Rotate Left', 'Rotate Right', 'Flip Horizontal'];
                        setState(() => _lastAction = 'Edit: ${actions[index]}');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Inline Action: $_lastInlineAction',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Native iOS pull-down button (UIButton)\n'
                  '• Inline action buttons at top of menu\n'
                  '• Regular menu items with icons\n'
                  '• Dividers for organization\n'
                  '• Destructive action styling\n'
                  '• Separate callbacks for inline vs menu items',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNPullDownButtonAnchor (NEW!)',
            child: Column(
              children: [
                const Text(
                  'Pull-down button anchored to CNButton with custom styling',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Icon-style pull-down button anchor with gray style
                    BasePullDownButtonAnchor.icon(
                      buttonIcon: const CNSymbol('ellipsis.circle'),
                      buttonStyle: CNButtonStyle.gray,
                      size: 44,
                      items: const [
                        CNPullDownMenuItem(
                          label: 'Settings',
                          icon: CNSymbol('gear'),
                        ),
                        CNPullDownMenuItem(
                          label: 'Help',
                          icon: CNSymbol('questionmark.circle'),
                        ),
                        CNPullDownMenuItem(
                          label: 'About',
                          icon: CNSymbol('info.circle'),
                        ),
                        CNPullDownMenuDivider(),
                        CNPullDownMenuItem(
                          label: 'Delete',
                          icon: CNSymbol('trash'),
                          isDestructive: true,
                        ),
                      ],
                      onSelected: (index) {
                        setState(() {
                          switch (index) {
                            case 0:
                              _lastAction = 'Settings selected';
                              break;
                            case 1:
                              _lastAction = 'Help selected';
                              break;
                            case 2:
                              _lastAction = 'About selected';
                              break;
                            case 3:
                              _lastAction = 'Delete selected';
                              break;
                          }
                        });
                      },
                    ),
                    
                    // Icon-style with tinted button style
                    BasePullDownButtonAnchor.icon(
                      buttonIcon: const CNSymbol('star.fill'),
                      buttonStyle: CNButtonStyle.tinted,
                      tint: CupertinoColors.systemYellow,
                      size: 44,
                      menuTitle: 'Favorites',
                      items: const [
                        CNPullDownMenuItem(
                          label: 'Add to Favorites',
                          icon: CNSymbol('star'),
                        ),
                        CNPullDownMenuItem(
                          label: 'View Favorites',
                          icon: CNSymbol('list.star'),
                        ),
                        CNPullDownMenuDivider(),
                        CNPullDownMenuItem(
                          label: 'Clear Favorites',
                          icon: CNSymbol('trash'),
                          isDestructive: true,
                        ),
                      ],
                      onSelected: (index) {
                        final actions = ['Add to Favorites', 'View Favorites', 'Clear Favorites'];
                        setState(() => _lastAction = 'Favorite: ${actions[index]}');
                      },
                    ),
                    
                    // Icon-style with filled button style
                    BasePullDownButtonAnchor.icon(
                      buttonIcon: const CNSymbol('square.and.arrow.up'),
                      buttonStyle: CNButtonStyle.filled,
                      size: 44,
                      items: const [
                        CNPullDownMenuItem(
                          label: 'Share Link',
                          icon: CNSymbol('link'),
                        ),
                        CNPullDownMenuItem(
                          label: 'Copy',
                          icon: CNSymbol('doc.on.doc'),
                        ),
                        CNPullDownMenuItem(
                          label: 'Save',
                          icon: CNSymbol('square.and.arrow.down'),
                        ),
                      ],
                      onSelected: (index) {
                        final actions = ['Share Link', 'Copy', 'Save'];
                        setState(() => _lastAction = 'Share: ${actions[index]}');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Anchors pull-down menu to CNButton styles\n'
                  '• Supports all CNButtonStyle options (plain, gray, tinted, filled, bordered, glass)\n'
                  '• Custom tint colors for themed buttons\n'
                  '• Optional menu title displayed at top of menu\n'
                  '• Icon-only buttons with customizable size\n'
                  '• Alignment control for menu positioning',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BasePopupButton (NEW!)',
            child: Column(
              children: [
                const Text(
                  'Native iOS popup button for selecting from a list of options',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Popup button with plain style
                    Expanded(
                      child: BasePopupButton(
                        width: 200,
                        height: 24,
                        options: _filterOptions,
                        selectedIndex: _filterIndex1,
                        onSelected: (index) {
                          print('Plain button tapped: $index'); // Debug
                          setState(() => _filterIndex1 = index);
                          _set('Plain: ${_filterOptions[index]}');
                        },
                        buttonStyle: CNButtonStyle.plain,
                      ),
                    ),
                    const SizedBox(width: 2),
                    
                    // Popup button with tinted style
                    Expanded(
                      child: BasePopupButton(
                        width: 200,
                        options: _filterOptions,
                        selectedIndex: _filterIndex2,
                        onSelected: (index) {
                          print('Tinted button tapped: $index'); // Debug
                          setState(() => _filterIndex2 = index);
                          _set('Tinted: ${_filterOptions[index]}');
                        },
                        buttonStyle: CNButtonStyle.tinted,
                        tint: CupertinoColors.systemBlue,
                      ),
                    ),
                    const SizedBox(width: 2),
                    
                    // Popup button with gray style and prefix
                    Expanded(
                      child: BasePopupButton(
                        width:200,
                        options: _filterOptions,
                        selectedIndex: _filterIndex3,
                        onSelected: (index) {
                          print('Gray button tapped: $index'); // Debug
                          setState(() => _filterIndex3 = index);
                          _set('Gray: ${_filterOptions[index]}');
                        },
                        buttonStyle: CNButtonStyle.gray,
                        prefix: 'Show:',
                        height: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 66),
                // Popup button with bordered style and custom width
                Center(
                  child: BasePopupButton(
                    options: const ['Small', 'Medium', 'Large', 'Extra Large'],
                    selectedIndex: 1,
                    onSelected: (index) {
                      final sizes = ['Small', 'Medium', 'Large', 'Extra Large'];
                      _set('Size: ${sizes[index]}');
                    },
                    buttonStyle: CNButtonStyle.bordered,
                    prefix: 'Size:',
                    width: 200,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selected: Plain=${_filterOptions[_filterIndex1]}, Tinted=${_filterOptions[_filterIndex2]}, Gray=${_filterOptions[_filterIndex3]}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Native iOS popup button (UIButton with popup menu)\n'
                  '• Displays selected option on button label\n'
                  '• Supports all CNButtonStyle options\n'
                  '• Optional prefix text (e.g., "Show:", "Filter:")\n'
                  '• Custom dimensions (width and height)\n'
                  '• Custom tint colors for themed buttons\n'
                  '• Divider support between options',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNNavigationBar (Tap to Open Demo)',
            child: Column(
              children: [
                const Text(
                  'Native iOS navigation bar with leading, title, and trailing actions',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const _CNNavigationBarDemoPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Navigation Bar Demo'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Leading actions (typically back button)\n'
                  '• Title with large title support\n'
                  '• Trailing actions (settings, add, etc.)\n'
                  '• Transparent mode with blur effects',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseToolbar (Tap to Open Demo)',
            child: Column(
              children: [
                const Text(
                  'Native iOS toolbar with flexible leading, middle, and trailing actions',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const _CNToolbarDemoPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Toolbar Demo'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Leading, middle, and trailing action groups\n'
                  '• Transparent with blur effects\n'
                  '• Customizable heights and alignments\n'
                  '• Icon and label support with text actions\n'
                  '• Mixed icon and text in same toolbar',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNBottomToolbar (Expandable Search)',
            child: Column(
              children: [
                const Text(
                  'Native iOS bottom toolbar with expandable search functionality',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BaseCNBottomToolbar(
                    leadingAction: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.line_horizontal_3),
                      onPressed: () => _set('Menu pressed'),
                    ),
                    searchPlaceholder: 'Search messages...',
                    onSearchChanged: (text) => _set('Search: $text'),
                    onSearchFocusChanged: (focused) => _set('Search focused: $focused'),
                    trailingAction: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.square_pencil),
                      onPressed: () => _set('Compose pressed'),
                    ),
                    currentTabIcon: CupertinoIcons.house_fill,
                    currentTabLabel: 'Home',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Expandable search with context display\n'
                  '• Leading and trailing action buttons\n'
                  '• Smooth animations and transitions\n'
                  '• Apple HIG compliant design\n'
                  '• Cross-platform Material fallback',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNSearchBar (Native UISearchBar)',
            child: Column(
              children: [
                const Text(
                  'Native iOS UISearchBar with scope filtering and advanced features',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BaseSearchBar(
                    placeholder: 'Shows, Movies, and More',
                    showsCancelButton: true,
                    showsScopeBar: true,
                    scopeButtonTitles: const ['All', 'Movies', 'TV Shows'],
                    selectedScopeIndex: 0,
                    onTextChanged: (text) => _set('Search: $text'),
                    onSearchButtonClicked: (text) => _set('Search submitted: $text'),
                    onCancelButtonClicked: () => _set('Search cancelled'),
                    onScopeChanged: (index) => _set('Scope changed to: $index'),
                    height: 56,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Native iOS UISearchBar rendering\n'
                  '• Scope bar for content filtering\n'
                  '• Multiple search bar styles (default, prominent, minimal)\n'
                  '• Advanced keyboard and input configuration\n'
                  '• Apple HIG compliant search behavior\n'
                  '• Material Design fallback for other platforms',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildSection(
            title: 'BaseCNNativeSheet (Native UISheetPresentationController)',
            child: Column(
              children: [
                const Text(
                  'Native iOS sheet presentation with resizable detents, inline actions, and item rows',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showNativeSheet(),
                      child: const Text('Modal Sheet'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showNonmodalSheet(),
                      child: const Text('Nonmodal Sheet'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showCustomHeaderSheet(),
                      child: const Text('Custom Header'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showFormatSheet(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Format Sheet (NEW!)'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Features:\n'
                  '• Native UISheetPresentationController rendering\n'
                  '• Resizable sheets with detents (medium, large, custom)\n'
                  '• Nonmodal sheets for background interaction\n'
                  '• Custom header with title and close button\n'
                  '• Inline action buttons (NEW!)\n'
                  '• Item rows - side-by-side buttons (NEW!)\n'
                  '• Custom styling for all elements\n'
                  '• Apple HIG compliant sheet behavior\n'
                  '• Material Design bottom sheet fallback',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Native Sheet Methods
  Future<void> _showNativeSheet() async {
    final selectedIndex = await BaseNativeSheet.show(
      context: context,
      title: 'Settings',
      message: 'Configure your app preferences',
      items: [
        const CNSheetItem(title: 'Brightness', icon: 'sun.max'),
        const CNSheetItem(title: 'Appearance', icon: 'moon'),
        const CNSheetItem(title: 'Notifications', icon: 'bell'),
      ],
      detents: [CNSheetDetent.medium],
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final options = ['Brightness', 'Appearance', 'Notifications'];
      _set('Sheet selected: ${options[selectedIndex]}');
    } else {
      _set('Sheet dismissed');
    }
  }

  Future<void> _showNonmodalSheet() async {
    final selectedIndex = await BaseNativeSheet.show(
      context: context,
      title: 'Format',
      items: [
        const CNSheetItem(title: 'Bold', icon: 'bold', dismissOnTap: false),
        const CNSheetItem(title: 'Italic', icon: 'italic', dismissOnTap: false),
        const CNSheetItem(title: 'Underline', icon: 'underline'),
      ],
      detents: [CNSheetDetent.custom(280)],
      isModal: false, // Nonmodal - allows background interaction
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final formats = ['Bold', 'Italic', 'Underline'];
      _set('Nonmodal sheet: ${formats[selectedIndex]}');
    } else {
      _set('Nonmodal sheet dismissed');
    }
  }

  Future<void> _showCustomHeaderSheet() async {
    final selectedIndex = await BaseNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Custom Header',
      headerTitleSize: 18,
      headerTitleWeight: FontWeight.w600,
      headerHeight: 56,
      items: [
        const CNSheetItem(title: 'Option 1', icon: 'star'),
        const CNSheetItem(title: 'Option 2', icon: 'heart'),
        const CNSheetItem(title: 'Option 3', icon: 'bookmark'),
      ],
      detents: [CNSheetDetent.custom(320)],
      isModal: false,
    );
    
    if (selectedIndex != null) {
      _set('Custom header option ${selectedIndex + 1} selected');
    } else {
      _set('Custom header sheet dismissed');
    }
  }

  void _showFormatSheet() {
    BaseNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Format',
      subtitle: 'Text Formatting Options',
      isModal: true,
      headerTitleAlignment: 'center',
      headerHeight: 70,
      detents: const [
        CNSheetDetent.medium,
        CNSheetDetent.large,
      ],
      // Inline action buttons - like iOS Notes formatting toolbar
      inlineActions: [
        CNSheetInlineActions(
          actions: [
            CNSheetInlineAction(
              label: 'B',
              icon: 'bold',
              isToggled: _isBold,
            ),
            CNSheetInlineAction(
              label: 'I',
              icon: 'italic',
              isToggled: _isItalic,
            ),
            CNSheetInlineAction(
              label: 'U',
              icon: 'underline',
              isToggled: _isUnderline,
            ),
            CNSheetInlineAction(
              label: 'S',
              icon: 'strikethrough',
              isToggled: _isStrikethrough,
            ),
          ],
        ),
      ],
      onInlineActionSelected: (actionIndex, inlineActionIndex) {
        setState(() {
          _lastInlineAction = 'Row $actionIndex, Button $inlineActionIndex pressed';
          // Toggle the formatting state based on which button was pressed
          switch (inlineActionIndex) {
            case 0:
              _isBold = !_isBold;
              _showMessage('Bold ${_isBold ? 'enabled' : 'disabled'}');
              break;
            case 1:
              _isItalic = !_isItalic;
              _showMessage('Italic ${_isItalic ? 'enabled' : 'disabled'}');
              break;
            case 2:
              _isUnderline = !_isUnderline;
              _showMessage('Underline ${_isUnderline ? 'enabled' : 'disabled'}');
              break;
            case 3:
              _isStrikethrough = !_isStrikethrough;
              _showMessage('Strikethrough ${_isStrikethrough ? 'enabled' : 'disabled'}');
              break;
          }
        });
      },
      // Item rows - side-by-side buttons with equal widths
      itemRows: const [
        CNSheetItemRow(
          items: [
            CNSheetItem(
              title: 'Reset All',
              icon: 'arrow.counterclockwise',
            ),
            CNSheetItem(
              title: 'Copy Format',
              icon: 'doc.on.clipboard',
            ),
          ],
        ),
      ],
      onItemSelected: (itemIndex) {
        if (itemIndex == 0) {
          // Reset All
          setState(() {
            _isBold = false;
            _isItalic = false;
            _isUnderline = false;
            _isStrikethrough = false;
            _lastInlineAction = '';
          });
          _showMessage('All formatting reset');
        } else {
          // Copy Format
          Navigator.pop(context);
          _showMessage('Format copied to clipboard');
        }
      },
      // Regular list items
      items: const [
        CNSheetItem(
          title: 'Font Size',
          icon: 'textformat.size',
        ),
        CNSheetItem(
          title: 'Text Color',
          icon: 'paintpalette',
        ),
        CNSheetItem(
          title: 'Background Color',
          icon: 'paintbrush.fill',
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Full-page CNToolbar Demo
class _CNToolbarDemoPage extends StatefulWidget {
  const _CNToolbarDemoPage();

  @override
  State<_CNToolbarDemoPage> createState() => _CNToolbarDemoPageState();
}

class _CNToolbarDemoPageState extends State<_CNToolbarDemoPage> {
  bool _isTransparent = true;
  BaseToolbarAlignment _middleAlignment = BaseToolbarAlignment.center;
  // CNToolbarMiddleAlignment _middleAlignment = CNToolbarMiddleAlignment.center;
  bool _isSearchExpanded = false;

  // Remember the toolbar state before search expansion
  bool _lastTransparentState = true;
  BaseToolbarAlignment _lastMiddleAlignment = BaseToolbarAlignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade100,
                  Colors.purple.shade100,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'CNToolbar Demo',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Transparent Background'),
                              value: _isTransparent,
                              onChanged: (v) => setState(() => _isTransparent = v),
                            ),
                            const Divider(),
                            const Text('Middle Alignment:'),
                            SegmentedButton<BaseToolbarAlignment>(
                              segments: const [
                                ButtonSegment(
                                  value: BaseToolbarAlignment.leading,
                                  label: Text('Leading'),
                                ),
                                ButtonSegment(
                                  value: BaseToolbarAlignment.center,
                                  label: Text('Center'),
                                ),
                                ButtonSegment(
                                  value: BaseToolbarAlignment.trailing,
                                  label: Text('Trailing'),
                                ),
                              ],
                              selected: {_middleAlignment},
                              onSelectionChanged: (Set<BaseToolbarAlignment> selection) {
                                setState(() => _middleAlignment = selection.first);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Top toolbar
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: BaseToolbar(
                middleAlignment: _middleAlignment,
                leading: [
                  BaseToolbarAction(
                    // iconSize: 15,
                    icon: const CNSymbol('chevron.left'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  BaseToolbarAction.fixedSpace(1),
                  BaseToolbarAction(
                    label: 'Share',
                    padding: 5,
                    onPressed: () => print('Share tapped'),
                  ),
                ],
                middle: [
                  BaseToolbarAction(
                    iconSize: 15,
                    icon: const CNSymbol('pencil',),
                    onPressed: () => print('Edit tapped'),
                  ),
                  BaseToolbarAction(
                    iconSize: 15,
                    icon: const CNSymbol('trash',),
                    onPressed: () => print('Delete tapped'),
                  ),
                ],
                trailing: [
                   BaseToolbarAction.fixedSpace(2),
                  BaseToolbarAction(
                    padding: 12,
                    label: 'Settings',
                    labelSize: 15,
                    onPressed: () => print('Settings tapped'),
                  ),
                  BaseToolbarAction.fixedSpace(2),
                  BaseToolbarAction(
                    // iconSize: 10,
                    icon: const CNSymbol('plus',),
                    onPressed: () => print('Add tapped'),
                  ),
                ],
                tint: CupertinoColors.label,
                transparent: _isTransparent,
              ),
            ),
          ),
          
          // Bottom toolbar
          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child: SafeArea(
              bottom: false,
              child: _isSearchExpanded
                  ? _buildExpandedSearchToolbar()
                  : _buildNormalToolbar(),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildExpandedSearchToolbar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Row(
          children: [
            // Show a mini toolbar with the back icon on the left
            // Using 'trailing' for single-item toolbar positions it naturally
            SizedBox(
              width: 80,
              height: 44,
              child: BaseToolbar(
                trailing: [
                  BaseToolbarAction(
                    icon: CNSymbol('plus', size: 22),
                    onPressed: () {
                      // Return to normal toolbar state
                      setState(() {
                        _isSearchExpanded = false;
                        _isTransparent = _lastTransparentState;
                        _middleAlignment = _lastMiddleAlignment;
                      });
                    },
                  ),
                ],
                transparent: _lastTransparentState,
                tint: CupertinoColors.label,
              ),
            ),
            const SizedBox(width: 0),
            // Expanded search bar
            Expanded(
              child: BaseSearchBar(
                placeholder: 'Search',
                showsCancelButton: true,
                onTextChanged: (text) {
                  print('Searching: $text');
                },
                onSearchButtonClicked: (text) {
                  print('Search submitted: $text');
                },
                onCancelButtonClicked: () {
                  setState(() {
                    _isSearchExpanded = false;
                    _isTransparent = _lastTransparentState;
                    _middleAlignment = _lastMiddleAlignment;
                  });
                },
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNormalToolbar() {
    return SafeArea(
      top: false,
      child: BaseToolbar(
        middleAlignment: _middleAlignment,
        leading: [
          BaseToolbarAction(
            label: 'Cancel',
            padding: 12,
            onPressed: () => print('Cancel tapped'),
          ),
        ],
        middle: [
          BaseToolbarAction(
            iconSize: 10,
            icon: CNSymbol('pencil', size: 10),
            onPressed: () => print('Edit tapped', ),
          ),
          BaseToolbarAction(
            icon: CNSymbol('trash', size: 4),
            onPressed: () => print('Delete tapped'),
          ),
        ],
        trailing: [
          BaseToolbarAction(
            icon: CNSymbol('magnifyingglass'),
            onPressed: () {
              setState(() {
                // Save current state before expanding search
                _lastTransparentState = _isTransparent;
                _lastMiddleAlignment = _middleAlignment;
                _isSearchExpanded = true;
              });
            },
          ),
          BaseToolbarAction(
            label: 'Done',
            padding: 12,
            onPressed: () => print('Done tapped'),
          ),
        ],
        tint: CupertinoColors.label,
        transparent: _isTransparent,
      ),
    );
  }
}

/// Full-page CNNavigationBar Demo
class _CNNavigationBarDemoPage extends StatefulWidget {
  const _CNNavigationBarDemoPage();

  @override
  State<_CNNavigationBarDemoPage> createState() => _CNNavigationBarDemoPageState();
}

class _CNNavigationBarDemoPageState extends State<_CNNavigationBarDemoPage> {
  bool _isTransparent = true;
  bool _showLargeTitle = false;
  double _titleSize = 18.0;
  bool _enableTitleTap = true;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold( 
      backgroundColor:  CupertinoColors.systemPink, 
      // baseParam: BaseParam(nativeIOS: true),
      appBar: BaseAppBar(
        baseParam: BaseParam(nativeIOS: true),
        transparent: _isTransparent,
        tint: CupertinoColors.label,
        leadingActions: [
          BaseNavigationBarAction(
            icon: const CNSymbol('chevron.left'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BaseNavigationBarAction.fixedSpace(8),
          BaseNavigationBarAction(
            label: 'Back',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        trailingActions: [
          BaseNavigationBarAction(
            icon: const CNSymbol('gear'),
            // iconSize: 12,
            onPressed: () {
              print('Settings tapped');
            },
          ),
          BaseNavigationBarAction(
            icon: const CNSymbol('ellipsis.circle'),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Menu'),
                  content: const Text('Copy, Paste, or Delete'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Copy'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('Copy selected');
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Paste'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('Paste selected');
                      },
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text('Delete'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('Delete selected');
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          BaseNavigationBarAction(
            icon: const CNSymbol('plus'),
            onPressed: () {
              print('Add tapped');
            },
          ),
        ],
        title: Text('Native Nav Bar'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade100,
                    Colors.purple.shade100,
                    Colors.pink.shade100,
                  ],
                ),
              ),
            ),
            // Positioned(
            //   child: SizedBox(height: 80)), // Spacer for nav bar
            // Content with Navigation Bar at top
            Column(
              children: [
                // SizedBox(height: 100),
                // Top Navigation Bar
                
                
                // Content area
                Expanded(
                  child: ListView(
                    
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CNNavigationBar Demo',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'This demonstrates the native iOS navigation bar with:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              const Text('• Leading actions (back button and label)'),
                              const Text('• Title text with custom size and tap interaction'),
                              const Text('• Trailing actions (settings and add buttons)'),
                              const Text('• Optional transparency'),
                              const Text('• Optional large title mode'),
                              const SizedBox(height: 16),
                              SwitchListTile(
                                title: const Text('Transparent'),
                                subtitle: const Text('Enable blur effect'),
                                value: _isTransparent,
                                onChanged: (value) {
                                  setState(() {
                                    _isTransparent = value;
                                  });
                                },
                              ),
                              SwitchListTile(
                                title: const Text('Large Title'),
                                subtitle: const Text('iOS 11+ style large title'),
                                value: _showLargeTitle,
                                onChanged: (value) {
                                  setState(() {
                                    _showLargeTitle = value;
                                  });
                                },
                              ),
                              const Divider(),
                              Text('Title Size: ${_titleSize.toStringAsFixed(1)}'),
                              Slider(
                                value: _titleSize,
                                min: 12.0,
                                max: 24.0,
                                divisions: 12,
                                onChanged: (value) {
                                  setState(() {
                                    _titleSize = value;
                                  });
                                },
                              ),
                              SwitchListTile(
                                title: const Text('Enable Title Tap'),
                                subtitle: const Text('Allow tapping the navigation bar title'),
                                value: _enableTitleTap,
                                onChanged: (value) {
                                  setState(() {
                                    _enableTitleTap = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Interactive hint card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.touch_app, color: Colors.blue.shade700, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _enableTitleTap 
                                  ? '👆 Try tapping the "Native Nav Bar" title above to see the onTitlePressed in action!' 
                                  : 'Enable "Title Tap" setting above to make the navigation title interactive',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Navigation Bar Features',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureItem(
                                'Leading Actions',
                                'Typically used for back navigation with icon and label',
                              ),
                              _buildFeatureItem(
                                'Title',
                                'Main navigation bar title, supports large title mode and custom sizing',
                              ),
                              _buildFeatureItem(
                                'Title Interaction',
                                'Tap the title to trigger custom actions and interactions',
                              ),
                              _buildFeatureItem(
                                'Trailing Actions',
                                'Action buttons like settings, add, search, etc.',
                              ),
                              _buildFeatureItem(
                                'Transparency',
                                'Blur effect with transparent background',
                              ),
                              _buildFeatureItem(
                                'Large Title',
                                'iOS 11+ style large title that collapses on scroll',
                              ),
                              _buildFeatureItem(
                                'SF Symbols',
                                'Native iOS SF Symbols with Material Design fallback',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Common SF Symbols Used',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSymbolItem('chevron.left', 'Back navigation'),
                              _buildSymbolItem('gear', 'Settings'),
                              _buildSymbolItem('plus', 'Add new item'),
                              _buildSymbolItem('magnifyingglass', 'Search'),
                              _buildSymbolItem('ellipsis.circle', 'More options'),
                              _buildSymbolItem('square.and.arrow.up', 'Share'),
                              _buildSymbolItem('trash', 'Delete'),
                              _buildSymbolItem('pencil', 'Edit'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 5,
          //   child: SafeArea(
          //     bottom: false,
          //     child:BaseNavigationBar(
          //         leading: [
          //           BaseNavigationBarAction(
          //             icon: const CNSymbol('chevron.left'),
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //           BaseNavigationBarAction.fixedSpace(8),
          //           BaseNavigationBarAction(
          //             label: 'Back',
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //         ],
          //         title: 'Native Nav Bar',
          //         titleSize: _titleSize,
          //         onTitlePressed: _enableTitleTap ? () {
          //           showCupertinoDialog(
          //             context: context,
          //             builder: (context) => CupertinoAlertDialog(
          //               title: const Text('Title Tapped!'),
          //               content: const Text('The navigation bar title was tapped. This demonstrates the onTitlePressed functionality.'),
          //               actions: [
          //                 CupertinoDialogAction(
          //                   child: const Text('Cool!'),
          //                   onPressed: () => Navigator.of(context).pop(),
          //                 ),
          //               ],
          //             ),
          //           );
          //         } : null,
          //         trailing: [
          //           BaseNavigationBarAction(
          //             icon: const CNSymbol('gear'),
          //             // iconSize: 12,
          //             onPressed: () {
          //               print('Settings tapped');
          //             },
          //           ),
          //           BaseNavigationBarAction(
          //             icon: const CNSymbol('ellipsis.circle'),
          //             onPressed: () {
          //               showCupertinoDialog(
          //                 context: context,
          //                 builder: (context) => CupertinoAlertDialog(
          //                   title: const Text('Menu'),
          //                   content: const Text('Copy, Paste, or Delete'),
          //                   actions: [
          //                     CupertinoDialogAction(
          //                       child: const Text('Copy'),
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                         print('Copy selected');
          //                       },
          //                     ),
          //                     CupertinoDialogAction(
          //                       child: const Text('Paste'),
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                         print('Paste selected');
          //                       },
          //                     ),
          //                     CupertinoDialogAction(
          //                       isDestructiveAction: true,
          //                       child: const Text('Delete'),
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                         print('Delete selected');
          //                       },
          //                     ),
          //                     CupertinoDialogAction(
          //                       child: const Text('Cancel'),
          //                       onPressed: () => Navigator.of(context).pop(),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             },
          //           ),
          //           BaseNavigationBarAction(
          //             icon: const CNSymbol('plus'),
          //             onPressed: () {
          //               print('Add tapped');
          //             },
          //           ),
          //         ],
          //         tint: CupertinoColors.label,
          //         transparent: _isTransparent,
          //         largeTitle: _showLargeTitle,
          //       )
          //     )
          //   ),
          
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolItem(String symbol, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              symbol,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
