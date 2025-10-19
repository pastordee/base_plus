import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:cupertino_native/cupertino_native.dart';


/// Comprehensive demo showcasing CNNativeSheet functionality
/// 
/// Demonstrates native iOS UISheetPresentationController features including:
/// - Modal and nonmodal sheet presentations
/// - Resizable sheets with detents (medium, large, custom heights)
/// - Custom header sheets with styling options
/// - Various sheet configurations and item types
/// - Apple HIG compliant sheet behavior patterns
class CNNativeSheetDemo extends StatefulWidget {
  const CNNativeSheetDemo({Key? key}) : super(key: key);

  @override
  State<CNNativeSheetDemo> createState() => _CNNativeSheetDemoState();
}

class _CNNativeSheetDemoState extends State<CNNativeSheetDemo> {
  String _lastAction = 'No action yet';
  int? _lastSelectedIndex;

  void _updateAction(String action, [int? selectedIndex]) {
    setState(() {
      _lastAction = action;
      _lastSelectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('CNNativeSheet Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          _buildStatusCard(),
          
          const SizedBox(height: 24),
          
          // Basic Sheets Section
          _buildSection(
            'Basic Sheets',
            'Standard modal sheet presentations',
            [
              _buildDemoButton(
                'Settings Sheet',
                'Medium height settings sheet',
                () => _showSettingsSheet(),
              ),
              _buildDemoButton(
                'Actions Sheet',
                'Photo actions with destructive option',
                () => _showActionsSheet(),
              ),
              _buildDemoButton(
                'Large Sheet',
                'Full height sheet with many options',
                () => _showLargeSheet(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Nonmodal Sheets Section
          _buildSection(
            'Nonmodal Sheets',
            'Sheets that allow background interaction',
            [
              _buildDemoButton(
                'Format Sheet',
                'Like Apple Notes formatting (nonmodal)',
                () => _showFormatSheet(),
              ),
              _buildDemoButton(
                'Tools Palette',
                'Drawing tools palette (nonmodal)',
                () => _showToolsPalette(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Custom Header Sheets Section
          _buildSection(
            'Custom Header Sheets',
            'Sheets with custom header styling',
            [
              _buildDemoButton(
                'Custom Header',
                'Sheet with styled header and close button',
                () => _showCustomHeaderSheet(),
              ),
              _buildDemoButton(
                'Preferences',
                'App preferences with leading close button',
                () => _showPreferencesSheet(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Advanced Features Section
          _buildSection(
            'Advanced Features',
            'Custom detents and styling options',
            [
              _buildDemoButton(
                'Custom Height',
                'Sheet with custom 280pt height',
                () => _showCustomHeightSheet(),
              ),
              _buildDemoButton(
                'Multiple Detents',
                'Sheet with medium and large detents',
                () => _showMultipleDetentsSheet(),
              ),
              _buildDemoButton(
                'Styled Sheet',
                'Sheet with custom colors and styling',
                () => _showStyledSheet(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last Action',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _lastAction,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          if (_lastSelectedIndex != null) ...[
            const SizedBox(height: 4),
            Text(
              'Selected Index: $_lastSelectedIndex',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, List<Widget> buttons) {
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
        ...buttons,
      ],
    );
  }

  Widget _buildDemoButton(String title, String subtitle, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: CupertinoColors.systemGrey3,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Basic Sheets
  Future<void> _showSettingsSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Settings',
      message: 'Configure your app preferences',
      items: [
        const CNSheetItem(title: 'Brightness', icon: 'sun.max'),
        const CNSheetItem(title: 'Appearance', icon: 'moon'),
        const CNSheetItem(title: 'Notifications', icon: 'bell'),
        const CNSheetItem(title: 'Privacy', icon: 'hand.raised'),
      ],
      detents: [CNSheetDetent.medium],
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final options = ['Brightness', 'Appearance', 'Notifications', 'Privacy'];
      _updateAction('Selected: ${options[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Settings sheet dismissed');
    }
  }

  Future<void> _showActionsSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Photo Actions',
      items: [
        const CNSheetItem(title: 'Share Photo', icon: 'square.and.arrow.up'),
        const CNSheetItem(title: 'Add to Album', icon: 'plus.rectangle.on.rectangle'),
        const CNSheetItem(title: 'Edit Photo', icon: 'paintbrush'),
        const CNSheetItem(title: 'Copy Photo', icon: 'doc.on.clipboard'),
        const CNSheetItem(title: 'Delete Photo', icon: 'trash'),
      ],
      detents: [CNSheetDetent.large],
    );
    
    if (selectedIndex != null) {
      final actions = ['Share', 'Add to Album', 'Edit', 'Copy', 'Delete'];
      _updateAction('Selected: ${actions[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Photo actions sheet dismissed');
    }
  }

  Future<void> _showLargeSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'More Options',
      message: 'Choose from all available options',
      items: [
        const CNSheetItem(title: 'Create New', icon: 'plus'),
        const CNSheetItem(title: 'Import File', icon: 'square.and.arrow.down'),
        const CNSheetItem(title: 'Export Data', icon: 'square.and.arrow.up'),
        const CNSheetItem(title: 'Sync Settings', icon: 'arrow.triangle.2.circlepath'),
        const CNSheetItem(title: 'Backup Data', icon: 'icloud.and.arrow.up'),
        const CNSheetItem(title: 'Reset App', icon: 'arrow.counterclockwise'),
        const CNSheetItem(title: 'Help & Support', icon: 'questionmark.circle'),
        const CNSheetItem(title: 'About', icon: 'info.circle'),
      ],
      detents: [CNSheetDetent.large],
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final options = ['Create New', 'Import File', 'Export Data', 'Sync Settings', 
                     'Backup Data', 'Reset App', 'Help & Support', 'About'];
      _updateAction('Selected: ${options[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Large sheet dismissed');
    }
  }

  // Nonmodal Sheets
  Future<void> _showFormatSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Format',
      items: [
        const CNSheetItem(title: 'Bold', icon: 'bold', dismissOnTap: false),
        const CNSheetItem(title: 'Italic', icon: 'italic', dismissOnTap: false),
        const CNSheetItem(title: 'Underline', icon: 'underline', dismissOnTap: false),
        const CNSheetItem(title: 'Strikethrough', icon: 'strikethrough'),
      ],
      detents: [CNSheetDetent.custom(280)],
      isModal: false, // Nonmodal - allows background interaction
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final formats = ['Bold', 'Italic', 'Underline', 'Strikethrough'];
      _updateAction('Applied: ${formats[selectedIndex]} formatting', selectedIndex);
    } else {
      _updateAction('Format sheet dismissed');
    }
  }

  Future<void> _showToolsPalette() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Drawing Tools',
      items: [
        const CNSheetItem(title: 'Pencil', icon: 'pencil', dismissOnTap: false),
        const CNSheetItem(title: 'Brush', icon: 'paintbrush', dismissOnTap: false),
        const CNSheetItem(title: 'Eraser', icon: 'eraser', dismissOnTap: false),
        const CNSheetItem(title: 'Text', icon: 'textformat'),
      ],
      detents: [CNSheetDetent.custom(240)],
      isModal: false, // Nonmodal
      prefersGrabberVisible: false,
    );
    
    if (selectedIndex != null) {
      final tools = ['Pencil', 'Brush', 'Eraser', 'Text'];
      _updateAction('Selected tool: ${tools[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Tools palette dismissed');
    }
  }

  // Custom Header Sheets
  Future<void> _showCustomHeaderSheet() async {
    final selectedIndex = await BaseCNNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Custom Header',
      headerTitleSize: 18,
      headerTitleWeight: FontWeight.w600,
      headerHeight: 56,
      showHeaderDivider: true,
      items: [
        const CNSheetItem(title: 'Option 1', icon: 'star'),
        const CNSheetItem(title: 'Option 2', icon: 'heart'),
        const CNSheetItem(title: 'Option 3', icon: 'bookmark'),
      ],
      detents: [CNSheetDetent.custom(320)],
    );
    
    if (selectedIndex != null) {
      _updateAction('Custom header option ${selectedIndex + 1} selected', selectedIndex);
    } else {
      _updateAction('Custom header sheet dismissed');
    }
  }

  Future<void> _showPreferencesSheet() async {
    final selectedIndex = await BaseCNNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Preferences',
      headerTitleSize: 20,
      headerTitleWeight: FontWeight.w700,
      headerHeight: 60,
      closeButtonPosition: 'leading',
      closeButtonIcon: 'xmark.circle.fill',
      closeButtonSize: 20,
      items: [
        const CNSheetItem(title: 'General', icon: 'gear'),
        const CNSheetItem(title: 'Account', icon: 'person.circle'),
        const CNSheetItem(title: 'Security', icon: 'lock'),
        const CNSheetItem(title: 'Advanced', icon: 'slider.horizontal.3'),
      ],
      detents: [CNSheetDetent.medium],
    );
    
    if (selectedIndex != null) {
      final prefs = ['General', 'Account', 'Security', 'Advanced'];
      _updateAction('Preferences: ${prefs[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Preferences sheet dismissed');
    }
  }

  // Advanced Features
  Future<void> _showCustomHeightSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Custom Height',
      message: 'This sheet is exactly 280 points tall',
      items: [
        const CNSheetItem(title: 'Action 1', icon: 'circle'),
        const CNSheetItem(title: 'Action 2', icon: 'square'),
        const CNSheetItem(title: 'Action 3', icon: 'triangle'),
      ],
      detents: [CNSheetDetent.custom(280)],
      prefersGrabberVisible: true,
      preferredCornerRadius: 24,
    );
    
    if (selectedIndex != null) {
      _updateAction('Custom height action ${selectedIndex + 1}', selectedIndex);
    } else {
      _updateAction('Custom height sheet dismissed');
    }
  }

  Future<void> _showMultipleDetentsSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Resizable Sheet',
      message: 'Drag to resize between medium and large',
      items: [
        const CNSheetItem(title: 'Small Task', icon: 'checkmark'),
        const CNSheetItem(title: 'Medium Task', icon: 'checkmark.circle'),
        const CNSheetItem(title: 'Large Task', icon: 'checkmark.circle.fill'),
        const CNSheetItem(title: 'Extra Task', icon: 'plus.circle'),
        const CNSheetItem(title: 'Bonus Task', icon: 'star.circle'),
      ],
      detents: [CNSheetDetent.medium, CNSheetDetent.large],
      prefersGrabberVisible: true,
    );
    
    if (selectedIndex != null) {
      final tasks = ['Small', 'Medium', 'Large', 'Extra', 'Bonus'];
      _updateAction('Selected: ${tasks[selectedIndex]} Task', selectedIndex);
    } else {
      _updateAction('Resizable sheet dismissed');
    }
  }

  Future<void> _showStyledSheet() async {
    final selectedIndex = await BaseCNNativeSheet.show(
      context: context,
      title: 'Styled Sheet',
      message: 'Custom colors and styling',
      items: [
        const CNSheetItem(title: 'Primary Action', icon: 'star'),
        const CNSheetItem(title: 'Secondary Action', icon: 'heart'),
        const CNSheetItem(title: 'Warning Action', icon: 'exclamationmark.triangle'),
      ],
      detents: [CNSheetDetent.custom(300)],
      itemBackgroundColor: CupertinoColors.systemBlue.withOpacity(0.1),
      itemTextColor: CupertinoColors.systemBlue,
      itemTintColor: CupertinoColors.systemBlue,
      preferredCornerRadius: 20,
    );
    
    if (selectedIndex != null) {
      final actions = ['Primary', 'Secondary', 'Warning'];
      _updateAction('Styled action: ${actions[selectedIndex]}', selectedIndex);
    } else {
      _updateAction('Styled sheet dismissed');
    }
  }
}

/// Demo showcasing different sheet styles and use cases
class CNNativeSheetVariationsDemo extends StatefulWidget {
  const CNNativeSheetVariationsDemo({Key? key}) : super(key: key);

  @override
  State<CNNativeSheetVariationsDemo> createState() => _CNNativeSheetVariationsDemoState();
}

class _CNNativeSheetVariationsDemoState extends State<CNNativeSheetVariationsDemo> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Sheet Variations'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUseCase(
            'Apple Photos Style',
            'Share and action sheet like Photos app',
            () => _showPhotosStyleSheet(),
          ),
          
          _buildUseCase(
            'Apple Notes Style',
            'Formatting sheet like Notes app (nonmodal)',
            () => _showNotesStyleSheet(),
          ),
          
          _buildUseCase(
            'Apple Maps Style',
            'Location actions like Maps app',
            () => _showMapsStyleSheet(),
          ),
          
          _buildUseCase(
            'Apple Files Style',
            'File management like Files app',
            () => _showFilesStyleSheet(),
          ),
          
          _buildUseCase(
            'Settings Style',
            'Settings panel with custom header',
            () => _showSettingsStyleSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCase(String title, String description, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.systemBlue.withOpacity(0.1),
                CupertinoColors.systemBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CupertinoColors.systemBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.rectangle_stack,
                  color: CupertinoColors.systemBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
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
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: CupertinoColors.systemBlue,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPhotosStyleSheet() async {
    await BaseCNNativeSheet.show(
      context: context,
      title: 'Share Photo',
      items: [
        const CNSheetItem(title: 'AirDrop', icon: 'airplayaudio'),
        const CNSheetItem(title: 'Messages', icon: 'message'),
        const CNSheetItem(title: 'Mail', icon: 'envelope'),
        const CNSheetItem(title: 'Copy Link', icon: 'link'),
        const CNSheetItem(title: 'Add to Album', icon: 'plus.rectangle.on.rectangle'),
        const CNSheetItem(title: 'Duplicate', icon: 'doc.on.doc'),
        const CNSheetItem(title: 'Hide', icon: 'eye.slash'),
        const CNSheetItem(title: 'Delete', icon: 'trash'),
      ],
      detents: [CNSheetDetent.medium, CNSheetDetent.large],
      prefersGrabberVisible: true,
    );
  }

  Future<void> _showNotesStyleSheet() async {
    await BaseCNNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Format',
      headerTitleSize: 20,
      headerTitleWeight: FontWeight.w600,
      items: [
        const CNSheetItem(title: 'Bold', icon: 'bold', dismissOnTap: false),
        const CNSheetItem(title: 'Italic', icon: 'italic', dismissOnTap: false),
        const CNSheetItem(title: 'Underline', icon: 'underline', dismissOnTap: false),
        const CNSheetItem(title: 'Strikethrough', icon: 'strikethrough', dismissOnTap: false),
        const CNSheetItem(title: 'Title', icon: 'textformat'),
        const CNSheetItem(title: 'Heading', icon: 'textformat'),
        const CNSheetItem(title: 'Subheading', icon: 'textformat'),
      ],
      detents: [CNSheetDetent.custom(400)],
      isModal: false, // Nonmodal like Notes
      prefersGrabberVisible: true,
    );
  }

  Future<void> _showMapsStyleSheet() async {
    await BaseCNNativeSheet.show(
      context: context,
      title: 'Apple Park',
      message: 'Cupertino, CA',
      items: [
        const CNSheetItem(title: 'Directions', icon: 'arrow.triangle.turn.up.right.diamond'),
        const CNSheetItem(title: 'Call', icon: 'phone'),
        const CNSheetItem(title: 'Website', icon: 'safari'),
        const CNSheetItem(title: 'Share Location', icon: 'square.and.arrow.up'),
        const CNSheetItem(title: 'Add to Favorites', icon: 'heart'),
        const CNSheetItem(title: 'Report an Issue', icon: 'exclamationmark.triangle'),
      ],
      detents: [CNSheetDetent.medium],
      prefersGrabberVisible: true,
    );
  }

  Future<void> _showFilesStyleSheet() async {
    await BaseCNNativeSheet.show(
      context: context,
      title: 'Document.pdf',
      items: [
        const CNSheetItem(title: 'Quick Look', icon: 'eye'),
        const CNSheetItem(title: 'Share', icon: 'square.and.arrow.up'),
        const CNSheetItem(title: 'Copy', icon: 'doc.on.clipboard'),
        const CNSheetItem(title: 'Duplicate', icon: 'doc.on.doc'),
        const CNSheetItem(title: 'Move', icon: 'folder'),
        const CNSheetItem(title: 'Rename', icon: 'pencil'),
        const CNSheetItem(title: 'Compress', icon: 'archivebox'),
        const CNSheetItem(title: 'Delete', icon: 'trash'),
      ],
      detents: [CNSheetDetent.large],
      prefersGrabberVisible: true,
    );
  }

  Future<void> _showSettingsStyleSheet() async {
    await BaseCNNativeSheet.showWithCustomHeader(
      context: context,
      title: 'Display & Brightness',
      headerTitleSize: 18,
      headerTitleWeight: FontWeight.w600,
      headerHeight: 56,
      headerBackgroundColor: CupertinoColors.systemGroupedBackground,
      items: [
        const CNSheetItem(title: 'Appearance', icon: 'sun.max'),
        const CNSheetItem(title: 'Brightness', icon: 'sun.max'),
        const CNSheetItem(title: 'Auto-Lock', icon: 'lock'),
        const CNSheetItem(title: 'Text Size', icon: 'textformat.size'),
        const CNSheetItem(title: 'Display Zoom', icon: 'plus.magnifyingglass'),
      ],
      detents: [CNSheetDetent.medium],
      prefersGrabberVisible: false,
    );
  }
}