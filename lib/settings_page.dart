import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _openCustomerCare(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Customer Care"),
        content: const Text("Contact us at:\nsupport@edulite.app\n+234 800 000 0000"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _rateApp() {
    print("Open Play Store link...");
  }

  void _shareFeedback(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("We’d love to hear from you!"),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write your thoughts here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Feedback submitted. Thank you!")),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text("Settings", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("App Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.dark_mode, color: textColor),
            title: Text("Theme", style: TextStyle(color: textColor)),
            trailing: DropdownButton<ThemeMode>(
              dropdownColor: backgroundColor,
              value: themeProvider.themeMode,
              underline: const SizedBox(),
              iconEnabledColor: textColor,
              onChanged: (ThemeMode? mode) {
                if (mode == ThemeMode.system) {
                  themeProvider.useSystemTheme();
                } else {
                  themeProvider.toggleTheme(mode == ThemeMode.dark);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("System Default"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light Mode"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Dark Mode"),
                ),
              ],
            ),
          ),
          const Divider(),

          Text("Support & Feedback",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.support_agent, color: textColor),
            title: Text("Customer Care", style: TextStyle(color: textColor)),
            onTap: () => _openCustomerCare(context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.star_rate, color: textColor),
            title: Text("Rate Our App", style: TextStyle(color: textColor)),
            onTap: _rateApp,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.feedback, color: textColor),
            title: Text("Share Your Thoughts", style: TextStyle(color: textColor)),
            onTap: () => _shareFeedback(context),
          ),
          const Divider(),

          Text("Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
