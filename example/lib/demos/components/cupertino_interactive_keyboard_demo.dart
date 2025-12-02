import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:base_plus/base.dart';

/// Comprehensive demo showcasing CupertinoInteractiveKeyboard functionality
/// 
/// Demonstrates iOS-style interactive keyboard features including:
/// - Interactive keyboard dismissal with drag gestures
/// - Keyboard height tracking and callbacks
/// - Custom keyboard toolbar integration
/// - Tap-to-dismiss functionality
/// - Animation customization
/// - Apple HIG compliant keyboard behavior
class CupertinoInteractiveKeyboardDemo extends StatefulWidget {
  const CupertinoInteractiveKeyboardDemo({Key? key}) : super(key: key);

  @override
  State<CupertinoInteractiveKeyboardDemo> createState() => _CupertinoInteractiveKeyboardDemoState();
}

class _CupertinoInteractiveKeyboardDemoState extends State<CupertinoInteractiveKeyboardDemo> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();
  
  double _keyboardHeight = 0;
  bool _enableInteractiveDismissal = true;
  bool _enableTapToDismiss = true;
  bool _showKeyboardToolbar = true;
  String _lastAction = 'No keyboard activity yet';

  @override
  void dispose() {
    _textController.dispose();
    _messageController.dispose();
    _textFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _updateAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Interactive Keyboard Demo'),
      ),
      body: Column(
        children: [
          // Platform information banner
          _buildPlatformBanner(),
          
          Expanded(
            child: BaseCupertinoInteractiveKeyboard(
             
              enableInteractiveDismissal: _enableInteractiveDismissal,
              dismissOnTap: _enableTapToDismiss,
              keyboardToolbar: _showKeyboardToolbar ? _buildKeyboardToolbar() : null,
             onKeyboardVisibilityChanged: (isVisible) {
                print('Keyboard is ${isVisible ? 'visible' : 'hidden'}');
              },
              onKeyboardHeightChanged: (height) {
                print('Keyboard height: $height');
              },
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.easeInOutCubic,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Card
                    _buildStatusCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Settings Section
                    _buildSettingsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Text Input Section
                    _buildTextInputSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Message Composer Section
                    _buildMessageComposerSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Feature Demo Section
                    _buildFeatureDemoSection(),
                    
                    // Add extra space for scrolling when keyboard is visible
                    SizedBox(height: _keyboardHeight > 0 ? 200 : 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformBanner() {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return Container(
        width: double.infinity,
        color: CupertinoColors.systemRed.withOpacity(0.1),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.info_circle,
              color: CupertinoColors.systemRed,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Interactive keyboard dismissal only works on iOS devices',
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: CupertinoColors.systemBlue.withOpacity(0.1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.hand_draw,
            color: CupertinoColors.systemBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tap a text field, then drag DOWN on the field to dismiss the keyboard',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
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
            'Keyboard Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusRow('Last Action', _lastAction),
          _buildStatusRow('Keyboard Height', '${_keyboardHeight.toStringAsFixed(1)}px'),
          _buildStatusRow('Keyboard Visible', _keyboardHeight > 0 ? 'Yes' : 'No'),
          _buildStatusRow('Interactive Dismissal', _enableInteractiveDismissal ? 'Enabled' : 'Disabled'),
          _buildStatusRow('Tap to Dismiss', _enableTapToDismiss ? 'Enabled' : 'Disabled'),
          _buildStatusRow('Keyboard Toolbar', _showKeyboardToolbar ? 'Shown' : 'Hidden'),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
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
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Interactive Dismissal Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interactive Dismissal',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Drag down on text field to dismiss',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: _enableInteractiveDismissal,
                onChanged: (value) {
                  setState(() {
                    _enableInteractiveDismissal = value;
                  });
                  _updateAction('Interactive dismissal ${value ? 'enabled' : 'disabled'}');
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Tap to Dismiss Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to Dismiss',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Tap outside text fields to dismiss',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: _enableTapToDismiss,
                onChanged: (value) {
                  setState(() {
                    _enableTapToDismiss = value;
                  });
                  _updateAction('Tap to dismiss ${value ? 'enabled' : 'disabled'}');
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Keyboard Toolbar Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input Accessory',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Show toolbar above keyboard',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: _showKeyboardToolbar,
                onChanged: (value) {
                  setState(() {
                    _showKeyboardToolbar = value;
                  });
                  _updateAction('Input accessory ${value ? 'shown' : 'hidden'}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputSection() {
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
            'Text Input (Try dragging down)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          CupertinoTextField(
            controller: _textController,
            focusNode: _textFocusNode,
            placeholder: 'Tap here, then drag DOWN to dismiss keyboard...',
            decoration: BoxDecoration(
              color: CupertinoColors.systemFill,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            maxLines: 3,
            onTap: () => _updateAction('Text field tapped'),
            onChanged: (text) => _updateAction('Text changed: "$text"'),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onPressed: () {
                    _textFocusNode.requestFocus();
                    _updateAction('Text field focused programmatically');
                  },
                  child: const Text('Focus'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onPressed: () {
                    _textController.clear();
                    _updateAction('Text field cleared');
                  },
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposerSection() {
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
            'Message Composer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  placeholder: 'Type a message...',
                  maxLines: 3,
                  minLines: 1,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () => _updateAction('Message field tapped'),
                  onChanged: (text) => _updateAction('Message: "${text.split('\n').last}"'),
                ),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    _updateAction('Message sent: "${_messageController.text}"');
                    _messageController.clear();
                  }
                },
                child: const Icon(
                  CupertinoIcons.paperplane_fill,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDemoSection() {
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
            'Feature Demo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Try these interactive keyboard features:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          
          _buildFeatureItem(
            CupertinoIcons.hand_draw,
            'Drag to Dismiss',
            'Tap a text field, then drag DOWN on the text field itself to dismiss the keyboard interactively (iOS only)',
          ),
          _buildFeatureItem(
            CupertinoIcons.hand_raised,
            'Tap to Dismiss',
            'Tap anywhere outside the text fields to dismiss the keyboard',
          ),
          _buildFeatureItem(
            CupertinoIcons.rectangle_dock,
            'Input Accessory',
            'Notice the toolbar that appears above the keyboard with action buttons',
          ),
          _buildFeatureItem(
            CupertinoIcons.arrow_up_arrow_down,
            'Height Tracking',
            'Watch the keyboard height value update in the status card',
          ),
          _buildFeatureItem(
            CupertinoIcons.gear,
            'Settings Control',
            'Use the settings above to toggle different keyboard behaviors',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: CupertinoColors.systemBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardToolbar() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              _updateAction('Format: Bold');
            },
            child: const Text('Bold'),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              _updateAction('Format: Italic');
            },
            child: const Text('Italic'),
          ),
          const Spacer(),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _updateAction('Keyboard dismissed via toolbar');
            },
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Demo showcasing different keyboard toolbar configurations
class CupertinoInteractiveKeyboardVariationsDemo extends StatefulWidget {
  const CupertinoInteractiveKeyboardVariationsDemo({Key? key}) : super(key: key);

  @override
  State<CupertinoInteractiveKeyboardVariationsDemo> createState() => 
      _CupertinoInteractiveKeyboardVariationsDemoState();
}

class _CupertinoInteractiveKeyboardVariationsDemoState extends State<CupertinoInteractiveKeyboardVariationsDemo> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _selectedToolbarStyle = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Keyboard Variations'),
      ),
      body: Column(
        children: [
          // Platform information banner
          _buildVariationsPlatformBanner(),
          
          Expanded(
            child: BaseCupertinoInteractiveKeyboard(
              key: ValueKey(_selectedToolbarStyle), // Force rebuild when toolbar style changes
              enableInteractiveDismissal: true,
              onKeyboardVisibilityChanged: (isVisible) {
                print('Keyboard is ${isVisible ? 'visible' : 'hidden'}');
              },
              onKeyboardHeightChanged: (height) {
                print('Keyboard height: $height');
              },
                          dismissOnTap: true,
              keyboardToolbar: _buildSelectedToolbar(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Toolbar Style Selector
                  _buildToolbarSelector(),
                  
                  const SizedBox(height: 24),
                  
                  // Email Input
                  _buildInputSection(
                    'Email',
                    'Enter your email address',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password Input
                  _buildInputSection(
                    'Password',
                    'Enter your password',
                    _passwordController,
                    obscureText: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Search Input
                  _buildInputSection(
                    'Search',
                    'Search for something...',
                    _searchController,
                    keyboardType: TextInputType.text,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Notes Input
                  _buildInputSection(
                    'Notes',
                    'Write your notes here...',
                    _notesController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  
                  const SizedBox(height: 200), // Extra space for keyboard
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationsPlatformBanner() {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return Container(
        width: double.infinity,
        color: Colors.orange.withOpacity(0.1),
        padding: const EdgeInsets.all(12),
        child: Text(
          'Interactive keyboard dismissal only works on iOS devices. On other platforms, keyboard behaves normally.',
          style: TextStyle(
            color: Colors.orange[800],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: CupertinoColors.systemGreen.withOpacity(0.1),
      padding: const EdgeInsets.all(12),
      child: Text(
        'Try different toolbar styles and drag down on text fields to dismiss the keyboard',
        style: TextStyle(
          color: CupertinoColors.systemGreen,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildToolbarSelector() {
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
            'Input Accessory Style',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          CupertinoSegmentedControl<int>(
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Simple'),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Actions'),
              ),
              2: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Format'),
              ),
              3: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('None'),
              ),
            },
            groupValue: _selectedToolbarStyle,
            onValueChanged: (value) {
              // Dismiss keyboard first to allow the new toolbar to be attached
              FocusScope.of(context).unfocus();
              setState(() {
                _selectedToolbarStyle = value;
              });
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: Keyboard will dismiss when changing toolbar style. Tap a text field to see the new toolbar.',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(
    String title,
    String placeholder,
    TextEditingController controller, {
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            obscureText: obscureText,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: BoxDecoration(
              color: CupertinoColors.systemFill,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget? _buildSelectedToolbar() {
    switch (_selectedToolbarStyle) {
      case 0:
        return _buildSimpleToolbar();
      case 1:
        return _buildActionsToolbar();
      case 2:
        return _buildFormatToolbar();
      default:
        return null;
    }
  }

  Widget _buildSimpleToolbar() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => FocusScope.of(context).previousFocus(),
            child: const Text('Previous'),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => FocusScope.of(context).nextFocus(),
            child: const Text('Next'),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => FocusScope.of(context).unfocus(),
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsToolbar() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.photo, size: 20),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.camera, size: 20),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.location, size: 20),
          ),
          const Spacer(),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => FocusScope.of(context).unfocus(),
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatToolbar() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Text('B', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Text('I', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Text('U', style: TextStyle(decoration: TextDecoration.underline)),
          ),
          const VerticalDivider(),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.textformat, size: 18),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {},
            child: const Icon(CupertinoIcons.list_bullet, size: 18),
          ),
          const Spacer(),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => FocusScope.of(context).unfocus(),
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}