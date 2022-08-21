import 'package:flutter/material.dart';

class ProductDetailTable extends StatelessWidget {
  const ProductDetailTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 450,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15,15,70,15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Details",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  const [
                Text("Faded",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text("Light Fade",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Text("Rise",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text("Mid Rise",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Text("Distressed",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text("Clean Lock",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Text("Color",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text("Red",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Text("Fit",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text("Slim",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text("Details",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Text("Details Details Details Details Details "
                "Details Details Details Details Details Details"
                "Details Details Details Details Details Details"
                "Details Details Details Details Details Details "
                "Details Details Details Details Details Details"
                "Details Details Details Details Details Details"
                " Details Details Details Details Details Details"
                "Details Details Details Details Details",
              maxLines: 4,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
