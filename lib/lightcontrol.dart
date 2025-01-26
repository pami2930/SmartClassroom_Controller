import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LightControlScreen extends StatefulWidget {
  @override
  _LightControlScreenState createState() => _LightControlScreenState();
}

class _LightControlScreenState extends State<LightControlScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? serverUrl;

  Future<void> toggleLight(String state) async {
    if (serverUrl == null || serverUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid server IP.')),
      );
      return;
    }

    final fullUrl = '$serverUrl/toggle?state=$state';

    try {
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$state request sent successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send $state request.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E), // Background color updated
      appBar: AppBar(
        title: Text('Light Control'),
        backgroundColor: Colors.white, // White background for the AppBar
        foregroundColor: Colors.black, // Black text color for contrast
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Server URL',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  serverUrl = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => toggleLight('on'),
              child: Text('Turn ON'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => toggleLight('off'),
              child: Text('Turn OFF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white, // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
