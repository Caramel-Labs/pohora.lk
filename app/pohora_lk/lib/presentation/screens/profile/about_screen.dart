import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String appVersion = "1.0.0";

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // App logo
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/icons/app-icon-fg.png',
                width: 120,
                height: 120,
                fit: BoxFit.fill,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.agriculture,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),

            const SizedBox(height: 24),

            // App name and version
            const Text(
              'Pohora.lk',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Version $appVersion',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            // App description
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Pohora.lk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pohora.lk is an intelligent agriculture assistant that helps farmers make data-driven decisions for crop selection and fertilizer application. Using machine learning algorithms, we analyze soil conditions, environmental factors, and crop requirements to provide personalized recommendations.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Features
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Key Features',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              context,
              Icons.auto_awesome,
              'Smart Crop Recommendations',
              'Get AI-powered suggestions for the best crops to plant based on your soil and environment.',
            ),

            _buildFeatureItem(
              context,
              Icons.auto_awesome,
              'Smart Fertilizer Recommendations',
              'Receive personalized fertilizer recommendations to maximize crop yield and health.',
            ),

            _buildFeatureItem(
              context,
              Icons.list_alt_outlined,
              'Fertilizer Logs',
              'Monitor your fertilizer applications from planting to harvest with detailed logging.',
            ),

            _buildFeatureItem(
              context,
              Icons.smart_toy_outlined,
              'AI Assistance',
              'Get help from Artifical Intelligence through our integrated chat bot.',
            ),

            const SizedBox(height: 32),

            // Team section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Our Team',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamMember(
                  context,
                  'Ravindu Aratchige',
                  'Founder & ML Engineer',
                ),
                _buildTeamMember(
                  context,
                  'Ramith Gunawardana',
                  'Mobile App Developer',
                ),
                _buildTeamMember(
                  context,
                  'Lasindu Ranasinghe',
                  'Backend Engineer',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamMember(
                  context,
                  'Sohani Weerasinghe',
                  'Business Analyst',
                ),
                _buildTeamMember(
                  context,
                  'Yasitha Dhananya',
                  'Project Manager',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Legal links
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.verified_user),
                    title: const Text('Licenses'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Show open source licenses
                      showLicensePage(
                        context: context,
                        applicationName: 'Pohora.lk',
                        applicationVersion: appVersion,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Copyright notice
            Text(
              '© ${DateTime.now().year} Pohora.lk. All rights reserved.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.2),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(role, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }
}
