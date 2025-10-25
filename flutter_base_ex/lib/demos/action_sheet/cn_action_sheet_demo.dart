import 'package:base/base.dart';
import 'package:flutter/material.dart';

/// CNActionSheet Demo Page showcasing native iOS action sheets
class CNActionSheetDemo extends StatefulWidget {
  const CNActionSheetDemo({Key? key}) : super(key: key);

  @override
  _CNActionSheetDemoState createState() => _CNActionSheetDemoState();
}

class _CNActionSheetDemoState extends State<CNActionSheetDemo> {
  String _lastResult = 'No action taken yet';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('CNActionSheet Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Native iOS Action Sheets',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These action sheets use the cupertino_native package to show '
                      'true native iOS action sheets on iOS devices, with '
                      'Material Design bottom sheet fallbacks on other platforms. '
                      'Follows Apple HIG guidelines for action sheet design.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Action:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_lastResult),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showBasicActionSheet,
              child: const Text('Basic Action Sheet'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showConfirmationActionSheet,
              child: const Text('Confirmation Action Sheet'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showDestructiveActionSheet,
              child: const Text('Destructive Action Sheet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showMultipleActionsSheet,
              child: const Text('Multiple Actions Sheet'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showPhotoActionsSheet,
              child: const Text('Photo Actions Sheet'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showDocumentActionsSheet,
              child: const Text('Document Actions Sheet'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBasicActionSheet() async {
    final result = await BaseActionSheet.show(
      context: context,
      title: 'Choose an Option',
      message: 'Select one of the available options below.',
      actions: [
        BaseActionSheetAction(
          title: 'Option 1',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Option 1 selected';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Option 2',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Option 2 selected';
            });
          },
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: 'Cancel',
        style: BaseActionSheetActionStyle.cancel,
        onPressed: () {
          setState(() {
            _lastResult = 'Basic action sheet cancelled';
          });
        },
      ),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Basic action sheet dismissed without selection';
      });
    }
  }

  Future<void> _showConfirmationActionSheet() async {
    final confirmed = await BaseActionSheet.showConfirmation(
      context: context,
      title: 'Delete Draft?',
      message: 'This action cannot be undone.',
      confirmTitle: 'Delete Draft',
      cancelTitle: 'Keep Draft',
      onConfirm: () {
        setState(() {
          _lastResult = 'Draft deleted';
        });
      },
    );
    
    if (!confirmed) {
      setState(() {
        _lastResult = 'Draft kept (confirmation cancelled)';
      });
    }
  }

  Future<void> _showDestructiveActionSheet() async {
    final result = await BaseActionSheet.show(
      context: context,
      title: 'Remove Account',
      message: 'This will permanently remove your account and all associated data.',
      actions: [
        BaseActionSheetAction(
          title: 'Remove Account',
          style: BaseActionSheetActionStyle.destructive,
          onPressed: () {
            setState(() {
              _lastResult = 'Account removed';
            });
          },
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: 'Cancel',
        style: BaseActionSheetActionStyle.cancel,
        onPressed: () {
          setState(() {
            _lastResult = 'Account removal cancelled';
          });
        },
      ),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Destructive action sheet dismissed';
      });
    }
  }

  Future<void> _showMultipleActionsSheet() async {
    final result = await BaseActionSheet.show(
      context: context,
      title: 'File Options',
      message: 'What would you like to do with this file?',
      actions: [
        BaseActionSheetAction(
          title: 'Delete File',
          style: BaseActionSheetActionStyle.destructive,
          onPressed: () {
            setState(() {
              _lastResult = 'File deleted';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Share File',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'File shared';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Duplicate File',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'File duplicated';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Rename File',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'File renamed';
            });
          },
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: 'Cancel',
        style: BaseActionSheetActionStyle.cancel,
        onPressed: () {
          setState(() {
            _lastResult = 'File actions cancelled';
          });
        },
      ),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Multiple actions sheet dismissed';
      });
    }
  }

  Future<void> _showPhotoActionsSheet() async {
    final result = await BaseActionSheet.show(
      context: context,
      title: 'Photo Options',
      actions: [
        BaseActionSheetAction(
          title: 'Delete Photo',
          style: BaseActionSheetActionStyle.destructive,
          onPressed: () {
            setState(() {
              _lastResult = 'Photo deleted';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Edit Photo',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Photo editor opened';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Share Photo',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Photo shared';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Add to Album',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Photo added to album';
            });
          },
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: 'Cancel',
        style: BaseActionSheetActionStyle.cancel,
        onPressed: () {
          setState(() {
            _lastResult = 'Photo actions cancelled';
          });
        },
      ),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Photo actions sheet dismissed';
      });
    }
  }

  Future<void> _showDocumentActionsSheet() async {
    final result = await BaseActionSheet.show(
      context: context,
      title: 'Document Actions',
      message: 'Choose an action for "My Document.pdf"',
      actions: [
        BaseActionSheetAction(
          title: 'Open in External App',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Document opened in external app';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Export Copy',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Document copy exported';
            });
          },
        ),
        BaseActionSheetAction(
          title: 'Print Document',
          style: BaseActionSheetActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Document sent to printer';
            });
          },
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: 'Cancel',
        style: BaseActionSheetActionStyle.cancel,
        onPressed: () {
          setState(() {
            _lastResult = 'Document actions cancelled';
          });
        },
      ),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Document actions sheet dismissed';
      });
    }
  }
}