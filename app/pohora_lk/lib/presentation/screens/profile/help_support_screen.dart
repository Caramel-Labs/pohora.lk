import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.support_agent_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Need Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Our support team is ready to assist you with any questions or issues',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact options
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Email support
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.email_outlined, color: Colors.white),
                ),
                title: const Text('Email Support'),
                subtitle: const Text('connectwithcaramel@gmail.com'),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 8),

            // Phone support
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.phone_outlined, color: Colors.white),
                ),
                title: const Text('Phone Support'),
                subtitle: const Text('+94 76 83 77 321'),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 24),

            // FAQ section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // FAQ items using ExpansionPanel
            _buildFaqItem(
              context,
              'How do I add a new cultivation?',
              'To add a new cultivation, go to the Home screen and tap on the "+" button. Follow the steps to select your soil type, location, and crop.',
            ),

            _buildFaqItem(
              context,
              'How does crop recommendation work?',
              'Our AI analyzes your soil data, location, and environmental factors to suggest the most suitable crops for your land. The more accurate data you provide, the better our recommendations will be.',
            ),

            _buildFaqItem(
              context,
              'Can I get fertilizer recommendations?',
              'Yes! Once you have a cultivation set up, you can go to the cultivation details and tap on "Get Fertilizer Recommendation". Our system will suggest the best fertilizer based on your crop and soil conditions.',
            ),

            _buildFaqItem(
              context,
              'How do I update my profile information?',
              'Go to the Profile tab, then tap on "Account Settings". There you can edit your display name and other information.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}
