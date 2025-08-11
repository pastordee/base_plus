import 'package:base/base.dart';
import 'package:flutter/material.dart';

class iOS26LiquidGlassDialogDemo extends StatelessWidget {
  const iOS26LiquidGlassDialogDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: Text('iOS 26 Liquid Glass Dialog'),
      ),
      body: Container(
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(
              'iOS 26 Liquid Glass Dynamic Material - Dialogs',
              'Experience revolutionary dialog interactions with transparency, reflections, '
              'refractions, and real-time adaptability. Enhanced with Material 3 button variants '
              'for comprehensive cross-platform design language.',
              Icons.layers,
            ),
            const SizedBox(height: 24),
            _buildDialogSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.blue.shade700, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildDialogSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dialog Demonstrations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildDemoGrid(context),
      ],
    );
  }

  Widget _buildDemoGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildDemoCard(
          context,
          'Basic Liquid Glass',
          'Simple dialog with optical effects',
          Icons.blur_on,
          () => _showBasicDialog(context),
        ),
        _buildDemoCard(
          context,
          'Action Variants',
          'Material 3 button types',
          Icons.touch_app,
          () => _showActionVariantsDialog(context),
        ),
        _buildDemoCard(
          context,
          'Confirmation',
          'Enhanced confirmation dialog',
          Icons.check_circle,
          () => _showConfirmationDialog(context),
        ),
        _buildDemoCard(
          context,
          'Destructive Action',
          'Delete confirmation with haptics',
          Icons.warning,
          () => _showDestructiveDialog(context),
        ),
      ],
    );
  }

  Widget _buildDemoCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue.shade700, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }

  void _showBasicDialog(BuildContext context) {
    BaseAlertDialog(
      enableLiquidGlass: true,
      glassOpacity: 0.8,
      reflectionIntensity: 0.6,
      refractionStrength: 0.4,
      adaptiveInteraction: true,
      contentHierarchy: true,
      hapticFeedback: true,
      title: const Text('Liquid Glass Dialog'),
      content: const Text(
        'This dialog demonstrates iOS 26 Liquid Glass Dynamic Material with '
        'transparency, reflections, and refractions for an immersive experience.',
      ),
      actions: [
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.text,
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ).show(context);
  }

  void _showActionVariantsDialog(BuildContext context) {
    BaseAlertDialog(
      enableLiquidGlass: true,
      glassOpacity: 0.9,
      reflectionIntensity: 0.7,
      refractionStrength: 0.5,
      adaptiveInteraction: true,
      contentHierarchy: true,
      hapticFeedback: true,
      title: const Text('Material 3 Action Types'),
      content: const Text(
        'This dialog showcases different Material 3 button variants: '
        'TextButton, OutlinedButton, and FilledButton with Liquid Glass effects.',
      ),
      actions: [
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.text,
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.outlined,
          child: const Text('Maybe'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.filled,
          child: const Text('Confirm'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ).show(context);
  }

  void _showConfirmationDialog(BuildContext context) {
    BaseAlertDialog(
      enableLiquidGlass: true,
      glassOpacity: 0.85,
      reflectionIntensity: 0.65,
      refractionStrength: 0.45,
      adaptiveInteraction: true,
      contentHierarchy: true,
      hapticFeedback: true,
      title: const Text('Save Changes?'),
      content: const Text(
        'Do you want to save your changes before closing? '
        'Unsaved changes will be lost.',
      ),
      actions: [
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.text,
          child: const Text('Don\'t Save'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.filled,
          isDefaultAction: true,
          child: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changes saved!')),
            );
          },
        ),
      ],
    ).show(context);
  }

  void _showDestructiveDialog(BuildContext context) {
    BaseAlertDialog(
      enableLiquidGlass: true,
      glassOpacity: 0.9,
      reflectionIntensity: 0.8,
      refractionStrength: 0.6,
      adaptiveInteraction: true,
      contentHierarchy: true,
      hapticFeedback: true,
      title: const Text('Delete Item?'),
      content: const Text(
        'Are you sure you want to delete this item? '
        'This action cannot be undone.',
      ),
      actions: [
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.text,
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        BaseDialogAction(
          enableLiquidGlass: true,
          adaptiveInteraction: true,
          hapticFeedback: true,
          buttonType: BaseDialogActionType.filled,
          isDestructiveAction: true,
          child: const Text('Delete'),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item deleted!'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ],
    ).show(context);
  }
}
