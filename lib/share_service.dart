import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'carousel_item.dart';

class ShareService {
  // Share text content (image name and description)
  static Future<void> shareText(CarouselItem item) async {
    try {
      final String textToShare =
          '${item.imageName}\n\n${item.description}\n\n#FlutterCarousel';

      await Share.share(
        textToShare,
        subject: 'Check out this amazing ${item.imageName}!',
      );
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  // Show a share dialog with options
  static void showShareDialog(BuildContext context, CarouselItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share ${item.imageName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  icon: Icons.text_fields,
                  label: 'Share Text',
                  onTap: () {
                    Navigator.pop(context);
                    shareText(item);
                  },
                ),
                _buildShareOption(
                  context,
                  icon: Icons.copy,
                  label: 'Copy Text',
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: '${item.imageName}\n\n${item.description}',
                    ));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a single share option button
  static Widget _buildShareOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}