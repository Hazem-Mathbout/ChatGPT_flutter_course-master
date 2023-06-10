import 'package:flutter/material.dart';

class AwesomeDialog extends StatefulWidget {
  final Duration remainingAdPointsTime;
  final Function onWatchAdsClicked;

  const AwesomeDialog({
    Key? key,
    required this.remainingAdPointsTime,
    required this.onWatchAdsClicked,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AwesomeDialogState createState() => _AwesomeDialogState();
}

class _AwesomeDialogState extends State<AwesomeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _animation,
              child: const Icon(
                Icons.warning,
                size: 80,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '!انتهت نقاطك',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'من فضلك انتظر ${formatDuration(widget.remainingAdPointsTime)} للحصول على 20 نقطة إضافية',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.onWatchAdsClicked();
              },
              child: const Text('مشاهدة إعلان (+20 نقطة)'),
            ),
          ],
        ),
      ),
    );
  }
}
