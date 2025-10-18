import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// Enhanced iOS 26 Liquid Glass Dynamic Material Demo
/// 
/// Demonstrates the improved liquid glass implementation with:
/// - Enhanced BaseAppBar with improved iOS 26 Liquid Glass properties
/// - Enhanced BaseScaffold with automatic glass material detection
/// - Enhanced BaseTabScaffold with advanced glass physics
/// - Professional-grade visual effects and smooth animations
class EnhancedLiquidGlassDemo extends StatefulWidget {
  const EnhancedLiquidGlassDemo({Key? key}) : super(key: key);

  @override
  State<EnhancedLiquidGlassDemo> createState() => _EnhancedLiquidGlassDemoState();
}

class _EnhancedLiquidGlassDemoState extends State<EnhancedLiquidGlassDemo> {
  double _blurIntensity = 60.0;
  double _glassOpacity = 0.15;
  bool _dynamicBlur = true;
  int _selectedDemoIndex = 0;

  // Helper method to create card-like containers
  Widget _buildCard({required Widget child, Color? backgroundColor}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Enhanced Liquid Glass'),
        backgroundColor: Colors.white.withOpacity(0.1),
        liquidGlassBlurIntensity: _blurIntensity,
        liquidGlassGradientOpacity: _glassOpacity,
        liquidGlassDynamicBlur: _dynamicBlur,
        actions: [
          BaseIconButton(
            icon: Icons.settings,
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedDemoIndex,
        children: [
          _buildAppBarDemo(),
          _buildScaffoldDemo(),
          _buildTabScaffoldDemo(),
          _buildInteractiveDemo(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return BaseBottomNavigationBar(
      currentIndex: _selectedDemoIndex,
      onTap: (index) => setState(() => _selectedDemoIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_headline),
          label: 'App Bar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.web_asset),
          label: 'Scaffold',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tab),
          label: 'Tab Scaffold',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.touch_app),
          label: 'Interactive',
        ),
      ],
    );
  }

  Widget _buildAppBarDemo() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildDemoCard(
          'Enhanced iOS 26 Liquid Glass App Bar',
          'Demonstrates advanced liquid glass effects with improved transparency, reflections, and refractions.',
          [
            'Native iOS blur integration',
            'Enhanced gradient system',
            'Multi-layer shadow effects',
            'Rim lighting and edge definition',
            'Dynamic blur adaptation',
          ],
        ),
        const SizedBox(height: 20),
        _buildControlPanel(),
      ],
    );
  }

  Widget _buildScaffoldDemo() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildDemoCard(
          'Automatic Glass Material Detection',
          'BaseScaffold automatically detects liquid glass properties and applies appropriate spacing and effects.',
          [
            'Automatic transparency detection',
            'Smart SafeArea management',
            'Cross-platform compatibility',
            'Zero configuration required',
            'Intelligent spacing adjustment',
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Glass Properties Detected:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildPropertyRow('Blur Intensity', '${_blurIntensity.toStringAsFixed(1)}px'),
                _buildPropertyRow('Glass Opacity', '${(_glassOpacity * 100).toStringAsFixed(1)}%'),
                _buildPropertyRow('Dynamic Blur', _dynamicBlur ? 'Enabled' : 'Disabled'),
                _buildPropertyRow('Auto SafeArea', 'Enabled'),
                _buildPropertyRow('Glass Physics', 'iOS 26 Enhanced'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabScaffoldDemo() {
    return BaseTabScaffold(
      tabBar: const BaseTabBar(
        enableLiquidGlass: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      tabViews: [
        _buildTabContent('Home', 'Enhanced tab with liquid glass effects', Icons.home, Colors.blue),
        _buildTabContent('Search', 'Advanced glass texture integration', Icons.search, Colors.green),
        _buildTabContent('Profile', 'Native iOS cupertino enhancement', Icons.person, Colors.orange),
      ],
    );
  }

  Widget _buildTabContent(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color.withOpacity(0.7)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildCard(
            backgroundColor: color.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Liquid Glass Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Enhanced blur with native integration'),
                  Text('• Multi-layer shadow system'),
                  Text('• Adaptive depth perception'),
                  Text('• Color temperature adjustment'),
                  Text('• Real-time optical effects'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDemoCard(
            'Real-time Liquid Glass Controls',
            'Adjust liquid glass properties and see changes in real-time.',
            [
              'Dynamic blur intensity',
              'Glass opacity control',
              'Interactive physics',
              'Real-time rendering',
              'Native platform effects',
            ],
          ),
          const SizedBox(height: 20),
          _buildInteractiveControls(),
          const SizedBox(height: 20),
          _buildGlassPreview(),
        ],
      ),
    );
  }

  Widget _buildInteractiveControls() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Liquid Glass Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            Text('Blur Intensity: ${_blurIntensity.toStringAsFixed(1)}'),
            Slider(
              value: _blurIntensity,
              min: 0.0,
              max: 120.0,
              divisions: 120,
              onChanged: (value) => setState(() => _blurIntensity = value),
            ),
            
            const SizedBox(height: 16),
            Text('Glass Opacity: ${(_glassOpacity * 100).toStringAsFixed(1)}%'),
            Slider(
              value: _glassOpacity,
              min: 0.0,
              max: 0.5,
              divisions: 50,
              onChanged: (value) => setState(() => _glassOpacity = value),
            ),
            
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dynamic Blur'),
              subtitle: const Text('Adapts to content and interactions'),
              value: _dynamicBlur,
              onChanged: (value) => setState(() => _dynamicBlur = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassPreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background content
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Background Content',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          // Glass overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            height: 80,
            child: BaseAppBar(
              backgroundColor: Colors.white.withOpacity(0.1),
              liquidGlassBlurIntensity: _blurIntensity,
              liquidGlassGradientOpacity: _glassOpacity,
              liquidGlassDynamicBlur: _dynamicBlur,
              leading: const Icon(Icons.arrow_back),
              title: const Text('Glass Preview'),
              actions: const [Icon(Icons.more_vert)],
            ).build(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(String title, String description, List<String> features) {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Glass Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildControlRow('Blur Intensity', '${_blurIntensity.toStringAsFixed(1)}px'),
            _buildControlRow('Glass Opacity', '${(_glassOpacity * 100).toStringAsFixed(1)}%'),
            _buildControlRow('Dynamic Blur', _dynamicBlur ? 'Active' : 'Inactive'),
            _buildControlRow('Glass Physics', 'iOS 26 Enhanced'),
            _buildControlRow('Native Integration', 'cupertino_native'),
            _buildControlRow('Texture Engine', 'liquid_glass_texture'),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => BaseActionSheet(
        title: const Text('Liquid Glass Settings'),
        message: const Text('Configure iOS 26 enhanced effects'),
        actions: [
          BaseActionSheetAction(
            child: const Text('Reset to Defaults'),
            onPressed: () {
              setState(() {
                _blurIntensity = 60.0;
                _glassOpacity = 0.15;
                _dynamicBlur = true;
              });
              Navigator.pop(context);
            },
          ),
          BaseActionSheetAction(
            child: const Text('Maximum Glass Effects'),
            onPressed: () {
              setState(() {
                _blurIntensity = 120.0;
                _glassOpacity = 0.3;
                _dynamicBlur = true;
              });
              Navigator.pop(context);
            },
          ),
          BaseActionSheetAction(
            child: const Text('Minimal Effects'),
            onPressed: () {
              setState(() {
                _blurIntensity = 20.0;
                _glassOpacity = 0.05;
                _dynamicBlur = false;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}