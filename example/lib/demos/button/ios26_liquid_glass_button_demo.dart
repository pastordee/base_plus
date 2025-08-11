import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// iOS 26 Liquid Glass Button Effects Demo
/// 
/// Demonstrates the new Liquid Glass design language for buttons in iOS 26
/// with enhanced backdrop filters, haptic feedback, and adaptive styling.
class iOS26LiquidGlassButtonDemo extends StatefulWidget {
  @override
  _iOS26LiquidGlassButtonDemoState createState() => _iOS26LiquidGlassButtonDemoState();
}

class _iOS26LiquidGlassButtonDemoState extends State<iOS26LiquidGlassButtonDemo> {
  double _blurIntensity = 15.0;
  double _opacity = 0.8;
  bool _hapticFeedback = true;
  bool _liquidGlassEnabled = true;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('iOS 26 Liquid Glass Buttons'),
        backgroundColor: Colors.white.withOpacity(0.1),
        liquidGlassBlurIntensity: 40.0,
        liquidGlassGradientOpacity: 0.12,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildButtonShowcase(),
            const SizedBox(height: 24),
            _buildIconButtonShowcase(),
            const SizedBox(height: 24),
            _buildControlsCard(),
            const SizedBox(height: 24),
            _buildButtonTypesDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 28, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'iOS 26 Liquid Glass Buttons',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Experience the next evolution of iOS button design with enhanced '
              'backdrop filters, adaptive haptic feedback, and glass-like surface effects.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonShowcase() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BaseButton Showcase',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                BaseButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => _showFeedback('Standard Button'),
                  child: const Text('Standard', style: TextStyle(color: Colors.white)),
                ),
                BaseButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  filledButton: true,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => _showFeedback('Filled Button'),
                  child: const Text('Filled'),
                ),
                BaseButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  textButton: true,
                  onPressed: () => _showFeedback('Text Button'),
                  child: const Text('Text'),
                ),
                BaseButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  elevatedButton: true,
                  onPressed: () => _showFeedback('Elevated Button'),
                  child: const Text('Elevated'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButtonShowcase() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BaseIconButton Showcase',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                BaseIconButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity * 0.7, // Slightly less for icons
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  icon: Icons.favorite,
                  color: Colors.red,
                  onPressed: () => _showFeedback('Heart Icon'),
                ),
                BaseIconButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity * 0.7,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  icon: Icons.star,
                  color: Colors.amber,
                  onPressed: () => _showFeedback('Star Icon'),
                ),
                BaseIconButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity * 0.7,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  icon: Icons.share,
                  color: Colors.blue,
                  onPressed: () => _showFeedback('Share Icon'),
                ),
                BaseIconButton(
                  liquidGlassEffect: _liquidGlassEnabled,
                  liquidGlassBlurIntensity: _blurIntensity * 0.7,
                  liquidGlassOpacity: _opacity,
                  adaptiveHaptics: _hapticFeedback,
                  icon: Icons.settings,
                  color: Colors.grey.shade700,
                  onPressed: () => _showFeedback('Settings Icon'),
                ),
              ],
            ),
          ],
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
              'Liquid Glass Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Liquid Glass Effects'),
              subtitle: const Text('Toggle iOS 26 glass surface effects'),
              value: _liquidGlassEnabled,
              onChanged: (value) {
                setState(() {
                  _liquidGlassEnabled = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Blur Intensity: ${_blurIntensity.round()}'),
            Slider(
              value: _blurIntensity,
              min: 5.0,
              max: 30.0,
              divisions: 25,
              onChanged: (value) {
                setState(() {
                  _blurIntensity = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Surface Opacity: ${(_opacity * 100).round()}%'),
            Slider(
              value: _opacity,
              min: 0.3,
              max: 1.0,
              divisions: 70,
              onChanged: (value) {
                setState(() {
                  _opacity = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Adaptive Haptics'),
              subtitle: const Text('Enhanced haptic feedback'),
              value: _hapticFeedback,
              onChanged: (value) {
                setState(() {
                  _hapticFeedback = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonTypesDemo() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material 3 Button Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BaseButton(
                  filledButton: true,
                  adaptiveHaptics: _hapticFeedback,
                  onPressed: () => _showFeedback('Filled Button'),
                  child: const Text('Filled Button'),
                ),
                const SizedBox(height: 8),
                BaseButton(
                  filledTonalButton: true,
                  adaptiveHaptics: _hapticFeedback,
                  onPressed: () => _showFeedback('Filled Tonal Button'),
                  child: const Text('Filled Tonal Button'),
                ),
                const SizedBox(height: 8),
                BaseButton(
                  outlinedButton: true,
                  adaptiveHaptics: _hapticFeedback,
                  onPressed: () => _showFeedback('Outlined Button'),
                  child: const Text('Outlined Button'),
                ),
                const SizedBox(height: 8),
                BaseButton(
                  textButton: true,
                  adaptiveHaptics: _hapticFeedback,
                  onPressed: () => _showFeedback('Text Button'),
                  child: const Text('Text Button'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedback(String buttonType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$buttonType pressed with ${_hapticFeedback ? "haptic" : "no"} feedback'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
