import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_plus/base.dart';

/// iOS 26 Liquid Glass Dynamic Material Demo
/// 
/// Demonstrates the new Liquid Glass Dynamic Material design language introduced in iOS 26
/// with transparency, reflections, refractions, real-time adaptability, and unified design.
class iOS26LiquidGlassDemo extends StatefulWidget {
  @override
  _iOS26LiquidGlassDemoState createState() => _iOS26LiquidGlassDemoState();
}

class _iOS26LiquidGlassDemoState extends State<iOS26LiquidGlassDemo> {
  double _blurIntensity = 60.0;
  double _gradientOpacity = 0.15;
  bool _dynamicBlur = false;
  Color _backgroundColor = Colors.white.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // No need for extendBodyBehindAppBar - automatically handled by BaseScaffold
      appBar: BaseAppBar(
        title: const Text('iOS 26 Liquid Glass'),
        backgroundColor: _backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsSheet(context);
            },
          ),
        ],
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
        // No need for manual SafeArea - automatically handled by BaseScaffold
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(
              'iOS 26 Liquid Glass Dynamic Material',
              "Experience Apple's revolutionary Liquid Glass Dynamic Material with transparency, "
              "reflections, refractions, and real-time adaptability. This unified design language "
              "creates a harmonious experience across all Apple platforms with content-aware "
              "visual transformations and sophisticated optical properties.",
              Icons.layers,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              'Enhanced Backdrop Blur',
              'Variable blur intensity (20-100 sigma) creates depth and glass-like transparency.',
              Icons.blur_on,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              'Gradient Overlays',
              'Multi-stop gradients with controllable opacity for realistic glass reflections.',
              Icons.gradient,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              'Dynamic Effects',
              'Blur and opacity can respond to scroll position and user interaction.',
              Icons.dynamic_feed,
            ),
            const SizedBox(height: 16),
            _buildControlsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
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
                Icon(icon, size: 28, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Blur Intensity: ${_blurIntensity.round()}'),
            Slider(
              value: _blurIntensity,
              min: 20.0,
              max: 100.0,
              divisions: 80,
              onChanged: (value) {
                setState(() {
                  _blurIntensity = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Gradient Opacity: ${(_gradientOpacity * 100).round()}%'),
            Slider(
              value: _gradientOpacity,
              min: 0.0,
              max: 0.5,
              divisions: 50,
              onChanged: (value) {
                setState(() {
                  _gradientOpacity = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Dynamic Blur'),
              subtitle: const Text('Enhanced blur with dynamic effects'),
              value: _dynamicBlur,
              onChanged: (value) {
                setState(() {
                  _dynamicBlur = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Background Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Background Transparency'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _backgroundColor = Colors.white.withOpacity(0.1);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Light Glass'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _backgroundColor = Colors.black.withOpacity(0.1);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Dark Glass'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _backgroundColor = Colors.blue.withOpacity(0.1);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Blue Glass'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _backgroundColor = Colors.transparent;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Full Clear'),
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
}
