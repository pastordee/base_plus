import 'package:flutter/material.dart';

/// Simple demo showcasing Material widget concepts
/// This demonstrates the enhanced Material design patterns
class iOS26LiquidGlassMaterialDemo extends StatefulWidget {
  const iOS26LiquidGlassMaterialDemo({Key? key}) : super(key: key);

  @override
  State<iOS26LiquidGlassMaterialDemo> createState() => _iOS26LiquidGlassMaterialDemoState();
}

class _iOS26LiquidGlassMaterialDemoState extends State<iOS26LiquidGlassMaterialDemo> {
  bool _enableEffects = true;
  double _elevation = 8.0;
  double _borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('iOS 26 Liquid Glass Material'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(0.8),
                Colors.purple.withOpacity(0.6),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildControlPanel(),
            const SizedBox(height: 24),
            _buildMaterialExamples(),
            const SizedBox(height: 24),
            _buildFeatureShowcase(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'iOS 26 Liquid Glass Controls',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Enable Liquid Glass Effects'),
              subtitle: const Text('Transparency, reflections, and environmental awareness'),
              value: _enableEffects,
              onChanged: (value) => setState(() => _enableEffects = value),
            ),
            
            const SizedBox(height: 16),
            
            Text('Elevation: ${_elevation.toStringAsFixed(1)}'),
            Slider(
              value: _elevation,
              min: 0.0,
              max: 24.0,
              divisions: 24,
              onChanged: (value) => setState(() => _elevation = value),
            ),
            
            Text('Border Radius: ${_borderRadius.toStringAsFixed(1)}'),
            Slider(
              value: _borderRadius,
              min: 0.0,
              max: 32.0,
              divisions: 32,
              onChanged: (value) => setState(() => _borderRadius = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material Design Examples',
          style: Theme.of(context).textTheme.titleLarge,
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
            _buildExampleCard('Standard Material', MaterialType.card),
            _buildExampleCard('Canvas Material', MaterialType.canvas),
            _buildExampleCard('Transparency', MaterialType.transparency),
            _buildExampleCard('Button Material', MaterialType.button),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleCard(String title, MaterialType materialType) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Material(
            type: materialType,
            elevation: _enableEffects ? _elevation : 2.0,
            borderRadius: BorderRadius.circular(_borderRadius),
            color: _enableEffects 
                ? Colors.white.withOpacity(0.9)
                : Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(_borderRadius),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      materialType.toString().split('.').last,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'iOS 26 Features Showcase',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            color: _enableEffects 
                ? Colors.white.withOpacity(0.85)
                : Colors.white,
            boxShadow: _enableEffects ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: _elevation * 2,
                offset: Offset(0, _elevation * 0.5),
                spreadRadius: 0.5,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 4.0,
                offset: const Offset(0, -1),
                spreadRadius: -0.5,
              ),
            ] : [],
            gradient: _enableEffects ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
                Colors.black.withOpacity(0.05),
              ],
              stops: const [0.0, 0.5, 1.0],
            ) : null,
          ),
          child: Column(
            children: [
              Text(
                'iOS 26 Liquid Glass Dynamic Material',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Experience the next generation of Material Design with '
                'transparency, reflections, environmental awareness, and '
                'enhanced user interactions.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildFeatureChip('Transparency', Icons.opacity),
                  _buildFeatureChip('Reflections', Icons.lightbulb),
                  _buildFeatureChip('Environmental', Icons.eco),
                  _buildFeatureChip('Haptic', Icons.vibration),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStyledButton('Primary', Colors.blue),
                  _buildStyledButton('Secondary', Colors.purple),
                  _buildStyledButton('Accent', Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: _enableEffects 
            ? Colors.blue.withOpacity(0.1)
            : Colors.grey[200],
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(String label, Color color) {
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      elevation: _enableEffects ? 4.0 : 2.0,
      color: _enableEffects 
          ? color.withOpacity(0.9)
          : color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
