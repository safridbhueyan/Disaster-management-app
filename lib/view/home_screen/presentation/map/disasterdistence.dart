import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/googlemap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Disasterdistence extends StatelessWidget {
  const Disasterdistence({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      // padding: EdgeInsets.all(12.r),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20.r),
      //   color: Colors.white,
      // ),
      padding: EdgeInsets.all(12),

      color: Colors.white.withValues(alpha: 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text("Disaster Zone", style: textTheme.titleMedium),
                Consumer(
                  builder: (_, ref, _) {
                    final distance = ref
                        .watch(googleMapProvider)
                        .distanceToNearestZoo;
                    return Text(
                      "$distance KM Away",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Color(0xff7C8690),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                spacing: 4,
                children: [
                  Icon(Icons.directions, color: Colors.white, size: 20),
                  Text("Get Direction"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
