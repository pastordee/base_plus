import 'package:base_plus/base.dart';
import 'package:flutter/material.dart';

/// Enhanced bottom navigation demo showcasing iOS 26 Liquid Glass Dynamic Material
/// and Material 3 NavigationBar integration
class iOS26LiquidGlassBottomNavDemo extends StatefulWidget {
  const iOS26LiquidGlassBottomNavDemo({Key? key}) : super(key: key);

  @override
  State<iOS26LiquidGlassBottomNavDemo> createState() => _iOS26LiquidGlassBottomNavDemoState();
}

class _iOS26LiquidGlassBottomNavDemoState extends State<iOS26LiquidGlassBottomNavDemo> 
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _enableLiquidGlass = true;
  bool _useMaterial3 = true;

  final List<Widget> _pages = [
    const _DemoHomePage(),
    const _DemoGalleryPage(),
    const _DemoInteractionsPage(),
    const _DemoSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('iOS 26 Liquid Glass Navigation'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_enableLiquidGlass ? Icons.blur_on : Icons.blur_off),
            onPressed: () => setState(() => _enableLiquidGlass = !_enableLiquidGlass),
            tooltip: 'Toggle Liquid Glass',
          ),
          IconButton(
            icon: Icon(_useMaterial3 ? Icons.new_releases : Icons.navigation),
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
              Colors.purple.shade100,
              Colors.blue.shade100,
              Colors.teal.shade100,
            ],
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BaseBottomNavigationBar(
        enableLiquidGlass: _enableLiquidGlass,
        glassOpacity: 0.85,
        reflectionIntensity: 0.6,
        adaptiveInteraction: true,
        hapticFeedback: true,
        useMaterial3Navigation: _useMaterial3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home with Liquid Glass',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Gallery',
            tooltip: 'Gallery showcase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app_outlined),
            activeIcon: Icon(Icons.touch_app),
            label: 'Interactive',
            tooltip: 'Interactive features',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
            tooltip: 'Configuration settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: _enableLiquidGlass ? 0 : 8,
        backgroundColor: _enableLiquidGlass ? Colors.transparent : null,
      ),
    );
  }
}

class _DemoHomePage extends StatelessWidget {
  const _DemoHomePage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInfoCard(
          'iOS 26 Liquid Glass Dynamic Material',
          'Experience revolutionary bottom navigation with transparency, reflections, '
          'and real-time adaptability. Toggle features using the top-right controls.',
          Icons.layers,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          'Optical Transparency',
          'Environmental awareness through graduated opacity and clarity zones',
          Icons.blur_on,
          Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          'Adaptive Interactions',
          'Real-time responsiveness with enhanced haptic feedback',
          Icons.touch_app,
          Colors.teal,
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          'Material 3 Integration',
          'Modern NavigationBar with semantic ColorScheme usage',
          Icons.new_releases,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon, Color color) {
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
              color.withOpacity(0.1),
              color.withOpacity(0.05),
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
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
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

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class _DemoGalleryPage extends StatelessWidget {
  const _DemoGalleryPage();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final colors = [
          Colors.blue, Colors.purple, Colors.teal, Colors.orange,
          Colors.red, Colors.green, Colors.indigo, Colors.pink,
        ];
        final icons = [
          Icons.photo, Icons.video_library, Icons.music_note, Icons.palette,
          Icons.camera, Icons.mic, Icons.brush, Icons.design_services,
        ];
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors[index].withOpacity(0.2),
                  colors[index].withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icons[index], size: 48, color: colors[index]),
                const SizedBox(height: 8),
                Text(
                  'Gallery ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors[index],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DemoInteractionsPage extends StatefulWidget {
  const _DemoInteractionsPage();

  @override
  State<_DemoInteractionsPage> createState() => _DemoInteractionsPageState();
}

class _DemoInteractionsPageState extends State<_DemoInteractionsPage> {
  double _sliderValue = 0.5;
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Interactive Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Opacity: ${(_sliderValue * 100).round()}%'),
                Slider(
                  value: _sliderValue,
                  onChanged: (value) => setState(() => _sliderValue = value),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enhanced Effects'),
                  value: _switchValue,
                  onChanged: (value) => setState(() => _switchValue = value),
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
              children: [
                const Text(
                  'Interaction Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Light haptic feedback!')),
                        );
                      },
                      child: const Text('Light'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medium haptic feedback!')),
                        );
                      },
                      child: const Text('Medium'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Heavy haptic feedback!')),
                        );
                      },
                      child: const Text('Heavy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoSettingsPage extends StatelessWidget {
  const _DemoSettingsPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
          subtitle: Text('iOS 26 Liquid Glass Dynamic Material Demo'),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.palette),
          title: Text('Theme'),
          subtitle: Text('Material 3 with Liquid Glass effects'),
        ),
        const ListTile(
          leading: Icon(Icons.touch_app),
          title: Text('Haptic Feedback'),
          subtitle: Text('Enhanced tactile responses'),
        ),
        const ListTile(
          leading: Icon(Icons.blur_on),
          title: Text('Optical Effects'),
          subtitle: Text('Transparency and reflections'),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.star),
          title: Text('Version'),
          subtitle: Text('Flutter Base v3.0.0+1'),
        ),
      ],
    );
  }
}
