import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'carousel_item.dart';

class ShareService {
  // Share text content (image name and description)
  static Future<void> shareText(CarouselItem item) async {
    try {
      // Create a formatted text with emoji for visual appeal
      final String textToShare =
          '📸 ${item.imageName}\n\n'
          '${item.description}\n\n'
          '${_getEmojiForItem(item)}\n\n'
          '#FlutterCarousel #NatureViews';

      await Share.share(
        textToShare,
        subject: 'Check out this amazing ${item.imageName}!',
      );
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  // Helper method to get an appropriate emoji based on the image type
  static String _getEmojiForItem(CarouselItem item) {
    // Match emoji to icon
    switch (item.icon.codePoint) {
      case 0xe332: // Icons.landscape
        return '🏔️ Mountain views are breathtaking!';
      case 0xe0c6: // Icons.beach_access
        return '🏖️ Nothing beats a beautiful sunset at the beach!';
      case 0xe501: // Icons.location_city
        return '🌆 City lights illuminate the night!';
      case 0xe29b: // Icons.forest
        return '🌲 Find peace in the forest!';
      case 0xe6de: // Icons.terrain
        return '🏜️ Desert landscapes are magical!';
      case 0xe798: // Icons.water
        return '💦 The power of water shapes our world!';
      case 0xe594: // Icons.nightlight_round
        return '✨ The night sky holds many wonders!';
      case 0xe406: // Icons.local_florist
        return '🌸 Flowers bring color to our lives!';
      case 0xe02a: // Icons.ac_unit
        return '❄️ Snow creates a winter wonderland!';
      case 0xe25b: // Icons.eco
        return '🍂 Autumn colors remind us of nature\'s cycles!';
      default:
        return '🌍 Nature is amazing!';
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
                _buildShareOption(
                  context,
                  icon: Icons.share,
                  label: 'Share Card',
                  onTap: () {
                    Navigator.pop(context);
                    _shareItemAsText(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Share formatted text with facts
  static Future<void> _shareItemAsText(CarouselItem item) async {
    try {
      // Create a more detailed text with facts if available
      String shareText = '📸 ${item.imageName}\n\n${item.description}';

      // Add facts if available
      if (item.facts.isNotEmpty) {
        shareText += '\n\n📝 Interesting Facts:';
        for (var fact in item.facts) {
          shareText += '\n• $fact';
        }
      }

      // Get relevant emoji
      String emojiText = _getEmojiForItem(item);

      // Add a call to action and hashtags
      shareText += '\n\n$emojiText';
      shareText += '\n\nCheck out more amazing views in the Flutter Carousel app!';
      shareText += '\n\n#FlutterCarousel #NatureViews #${item.imageName.replaceAll(' ', '')}';

      await Share.share(
        shareText,
        subject: 'Discover ${item.imageName}',
      );
    } catch (e) {
      debugPrint('Error sharing detailed text: $e');
    }
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