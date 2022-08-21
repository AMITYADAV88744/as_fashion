
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderStepStatus extends StatelessWidget {
  const OrderStepStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TimelineTile(
              alignment: TimelineAlign.start,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 10,
                height: 10,
                color: Colors.green,
                padding: const EdgeInsets.all(8),
                indicator:Container(
                  width: 5,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.green,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.green,
              ),
              endChild: const _Child(
                text: "Order Placed",
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.start,
              indicatorStyle: IndicatorStyle(
                width: 10,
                height: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                drawGap: true,
                indicator:Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.green,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.green,
              ),
              endChild: const _Child(
                text: 'Order Confirmed',
              ),
            ),

            TimelineTile(
              alignment: TimelineAlign.start,
              indicatorStyle: IndicatorStyle(
                width: 10,
                height: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                drawGap: true,
                indicator:Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              endChild: const _Child(
                text: 'Order Confirmed',
              ),
            ),
            TimelineTile(
              alignment: TimelineAlign.start,
              isLast: true,

              indicatorStyle: IndicatorStyle(
                width: 10,
                height: 10,
                padding: const EdgeInsets.all(8),
                indicator:Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              endChild: const _Child(
                text: 'Order Delivered',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _Child extends StatelessWidget {
  const _Child({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 50),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,

        ),
      ),
    );
  }
}