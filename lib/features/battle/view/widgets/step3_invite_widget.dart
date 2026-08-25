import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'custom_button.dart';

class Step3InviteWidget extends StatefulWidget {
  const Step3InviteWidget({
    super.key,
    required this.onNext,
    required this.battleCode,
    required this.invitedFriends,
  });

  final VoidCallback onNext;
  final String battleCode;
  final List<String> invitedFriends;

  @override
  State<Step3InviteWidget> createState() => _Step3InviteWidgetState();
}

class _Step3InviteWidgetState extends State<Step3InviteWidget> {
  Future<void> _copyCode() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.battleCode));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Battle code copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clipboard is unavailable on this device'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _addFriend() {
    setState(() {
      widget.invitedFriends.add("NEW");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invite Friends",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Share the battle code to challenge your friends.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "BATTLE CODE",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12)
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF6B11A1).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Text(
                widget.battleCode,
                style:  Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24,letterSpacing: 2,),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyCode,
                  icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                  label: const Text("Copy Code",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B11A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Share.share(
                      'Join my battle! Use code: ${widget.battleCode}',
                    );
                  },
                  icon:  Icon(Icons.share, color: Theme.of(context).textTheme.headlineSmall?.color, size: 18),
                  label: const Text("Share invite"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: "Start Battle",
              onPressed: widget.onNext,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
            ),
          ],
        ),
      ),
    );
  }
}