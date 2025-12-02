import 'package:base_plus/base.dart';
import 'package:flutter/material.dart';

/// Enhanced expansion panel demo showcasing iOS 26 Liquid Glass Dynamic Material
/// and Material 3 BaseExpansion integration
class iOS26LiquidGlassExpansionDemo extends StatefulWidget {
  const iOS26LiquidGlassExpansionDemo({Key? key}) : super(key: key);

  @override
  State<iOS26LiquidGlassExpansionDemo> createState() => _iOS26LiquidGlassExpansionDemoState();
}

class _iOS26LiquidGlassExpansionDemoState extends State<iOS26LiquidGlassExpansionDemo> {
  bool _enableLiquidGlass = true;
  bool _useMaterial3 = true;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('iOS 26 Liquid Glass Expansion'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_enableLiquidGlass ? Icons.blur_on : Icons.blur_off),
            onPressed: () => setState(() => _enableLiquidGlass = !_enableLiquidGlass),
            tooltip: 'Toggle Liquid Glass',
          ),
          IconButton(
            icon: Icon(_useMaterial3 ? Icons.new_releases : Icons.extension),
            onPressed: () => setState(() => _useMaterial3 = !_useMaterial3),
            tooltip: 'Toggle Material 3',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade100,
              Colors.purple.shade100,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildControlsCard(),
            const SizedBox(height: 24),
            _buildDemoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.expand_more, color: Colors.indigo.shade700, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'iOS 26 Liquid Glass Expansion Panels',
                      style: TextStyle(
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
                'Experience revolutionary expansion panels with transparency, reflections, '
                'and real-time adaptability. Enhanced with Material 3 design tokens and '
                'sophisticated optical properties for immersive user interactions.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Liquid Glass Effects'),
              subtitle: const Text('Toggle iOS 26 glass surface effects'),
              value: _enableLiquidGlass,
              onChanged: (value) => setState(() => _enableLiquidGlass = value),
            ),
            SwitchListTile(
              title: const Text('Material 3 Styling'),
              subtitle: const Text('Enhanced elevation and modern tokens'),
              value: _useMaterial3,
              onChanged: (value) => setState(() => _useMaterial3 = value),
            ),
            SwitchListTile(
              title: const Text('Haptic Feedback'),
              subtitle: const Text('Enhanced tactile experience'),
              value: _hapticFeedback,
              onChanged: (value) => setState(() => _hapticFeedback = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expansion Panel Demonstrations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildDemoCard(
              'Basic Panel',
              'Standard expansion with glass effects',
              Icons.web_asset,
              () => _showBasicExpansion(),
            ),
            _buildDemoCard(
              'Bottom Sheet',
              'Material 3 bottom sheet style',
              Icons.vertical_align_bottom,
              () => _showBottomSheetExpansion(),
            ),
            _buildDemoCard(
              'Dialog Style',
              'Centered dialog expansion',
              Icons.dialpad,
              () => _showDialogExpansion(),
            ),
            _buildDemoCard(
              'Custom Content',
              'Rich content with interactions',
              Icons.dashboard,
              () => _showRichContentExpansion(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDemoCard(
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
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.indigo.shade700, size: 24),
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
      ),
    );
  }

  void _showBasicExpansion() {
    openBaseExpansion(
      context,
      BaseExpansion(
        left: 20.0,
        top: 150.0,
        right: 20.0,
        height: 200.0,
        enableLiquidGlass: _enableLiquidGlass,
        useMaterial3Elevation: _useMaterial3,
        hapticFeedback: _hapticFeedback,
        glassOpacity: 0.85,
        reflectionIntensity: 0.6,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.indigo.shade700),
                  const SizedBox(width: 12),
                  const Text(
                    'Basic Expansion Panel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'This is a basic expansion panel with iOS 26 Liquid Glass effects. '
                'Notice the transparency, reflections, and smooth animations.',
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheetExpansion() {
    openBaseExpansion(
      context,
      BaseExpansionM3.bottomSheet(
        height: 300.0,
        enableLiquidGlass: _enableLiquidGlass,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.vertical_align_bottom, color: Colors.indigo.shade700),
                  const SizedBox(width: 12),
                  const Text(
                    'Bottom Sheet Style',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Material 3 bottom sheet with enhanced Liquid Glass effects. '
                'Slide up from bottom with sophisticated optical properties.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialogExpansion() {
    openBaseExpansion(
      context,
      BaseExpansionM3.dialog(
        width: 320.0,
        height: 280.0,
        enableLiquidGlass: _enableLiquidGlass,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.dialpad, size: 48, color: Colors.indigo.shade700),
              const SizedBox(height: 16),
              const Text(
                'Dialog Style Expansion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Centered dialog with enhanced Material 3 styling and '
                'iOS 26 Liquid Glass Dynamic Material effects.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRichContentExpansion() {
    openBaseExpansion(
      context,
      BaseExpansion(
        left: 16.0,
        top: 100.0,
        right: 16.0,
        height: 400.0,
        enableLiquidGlass: _enableLiquidGlass,
        useMaterial3Elevation: _useMaterial3,
        hapticFeedback: _hapticFeedback,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.dashboard, color: Colors.indigo.shade700),
                  const SizedBox(width: 12),
                  const Text(
                    'Rich Content Panel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Features Showcase',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem('Liquid Glass transparency and reflections'),
              _buildFeatureItem('Material 3 elevation with surface tinting'),
              _buildFeatureItem('Enhanced haptic feedback'),
              _buildFeatureItem('Environmental awareness'),
              _buildFeatureItem('Adaptive interaction states'),
              const SizedBox(height: 20),
              const Text(
                'Interactive Elements',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: 0.5,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
