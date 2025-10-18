import 'package:base/base.dart';
import 'package:flutter/material.dart';

/// CNAlert Demo Page showcasing native iOS alerts
class CNAlertDemo extends StatefulWidget {
  const CNAlertDemo({Key? key}) : super(key: key);

  @override
  _CNAlertDemoState createState() => _CNAlertDemoState();
}

class _CNAlertDemoState extends State<CNAlertDemo> {
  String _lastResult = 'No action taken yet';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('CNAlert Demo'),
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
                      'Native iOS Alerts',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These alerts use the cupertino_native package to show '
                      'true native iOS alert dialogs on iOS devices, with '
                      'Material Design fallbacks on other platforms.',
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
              onPressed: _showBasicAlert,
              child: const Text('Basic Alert'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showInfoAlert,
              child: const Text('Info Alert'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showConfirmationAlert,
              child: const Text('Confirmation Alert'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showDestructiveAlert,
              child: const Text('Destructive Alert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showMultipleActionsAlert,
              child: const Text('Multiple Actions Alert'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showCustomAlert,
              child: const Text('Custom Styled Alert'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBasicAlert() async {
    final result = await BaseCNAlert.show(
      context: context,
      title: 'Hello',
      message: 'This is a basic alert message.',
      actions: [
        CNAlertAction(
          title: 'OK',
          style: CNAlertActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'OK pressed in basic alert';
            });
          },
        ),
      ],
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Basic alert dismissed without action';
      });
    }
  }

  Future<void> _showInfoAlert() async {
    await BaseCNAlert.showInfo(
      context: context,
      title: 'Information',
      message: 'This is an informational alert using the convenience method.',
    );
    
    setState(() {
      _lastResult = 'Info alert shown';
    });
  }

  Future<void> _showConfirmationAlert() async {
    final confirmed = await BaseCNAlert.showConfirmation(
      context: context,
      title: 'Save Document',
      message: 'Do you want to save your changes?',
      confirmTitle: 'Save',
      onConfirm: () {
        setState(() {
          _lastResult = 'Document saved';
        });
      },
    );
    
    if (!confirmed) {
      setState(() {
        _lastResult = 'Save cancelled by user';
      });
    }
  }

  Future<void> _showDestructiveAlert() async {
    final confirmed = await BaseCNAlert.showDestructiveConfirmation(
      context: context,
      title: 'Delete Account',
      message: 'This action cannot be undone. All your data will be permanently deleted.',
      destructiveTitle: 'Delete Account',
      onDestroy: () {
        setState(() {
          _lastResult = 'Account deleted';
        });
      },
    );
    
    if (!confirmed) {
      setState(() {
        _lastResult = 'Account deletion cancelled';
      });
    }
  }

  Future<void> _showMultipleActionsAlert() async {
    final result = await BaseCNAlert.show(
      context: context,
      title: 'Choose Action',
      message: 'What would you like to do with this file?',
      actions: [
        CNAlertAction(
          title: 'Cancel',
          style: CNAlertActionStyle.cancel,
          onPressed: () {
            setState(() {
              _lastResult = 'Action cancelled';
            });
          },
        ),
        CNAlertAction(
          title: 'Copy',
          style: CNAlertActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'File copied';
            });
          },
        ),
        CNAlertAction(
          title: 'Move',
          style: CNAlertActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'File moved';
            });
          },
        ),
        CNAlertAction(
          title: 'Delete',
          style: CNAlertActionStyle.destructive,
          onPressed: () {
            setState(() {
              _lastResult = 'File deleted';
            });
          },
        ),
      ],
      preferredActionIndex: 1, // Highlight "Copy" as default
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Multiple actions alert dismissed';
      });
    }
  }

  Future<void> _showCustomAlert() async {
    final result = await BaseCNAlert.show(
      context: context,
      title: 'Update Available',
      message: 'A new version of the app is available. Would you like to update now?',
      actions: [
        CNAlertAction(
          title: 'Later',
          style: CNAlertActionStyle.cancel,
          onPressed: () {
            setState(() {
              _lastResult = 'Update postponed';
            });
          },
        ),
        CNAlertAction(
          title: 'Update Now',
          style: CNAlertActionStyle.defaultStyle,
          onPressed: () {
            setState(() {
              _lastResult = 'Update started';
            });
          },
        ),
      ],
      preferredActionIndex: 1,
      // Force Material on Cupertino for demonstration
      cupertino: BaseParam(forceUseMaterial: false),
      // Force Cupertino on Material for demonstration  
      material: BaseParam(forceUseCupertino: false),
    );
    
    if (result == null) {
      setState(() {
        _lastResult = 'Update alert dismissed';
      });
    }
  }
}