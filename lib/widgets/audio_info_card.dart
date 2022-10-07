import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

class AudioInfoCard extends StatefulWidget {
  final String title;
  final double angle;
  final String tag;
  final double distance;

  const AudioInfoCard({
    Key? key,
    required this.title,
    required this.angle,
    required this.tag,
    required this.distance,
  }) : super(key: key);

  @override
  State<AudioInfoCard> createState() => _AudioInfoCardState();
}

class _AudioInfoCardState extends State<AudioInfoCard> {
  @override
  Widget build(BuildContext context) {
    final Widget icon = Provider.of<AudioClassification>(context, listen: false)
        .audioIcon(widget.tag);

    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        padding: const EdgeInsets.all(10),
        width: constraints.maxWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: const Color.fromRGBO(47, 60, 80, 1),
        ),
        child: Row(
          children: [
            SizedBox(width: constraints.maxWidth * 0.03),
            icon,
            SizedBox(width: constraints.maxWidth * 0.05),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                '${widget.distance.toString()} m  -  ${widget.angle}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.03),
          ],
        ),
      );
    });
  }
}
