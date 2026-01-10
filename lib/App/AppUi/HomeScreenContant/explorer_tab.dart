import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  List<String> images = [
    AppImages.eman,
    AppImages.egirl0,
    AppImages.eman0,
    AppImages.egirl2,
    AppImages.egirl2,
    AppImages.egirl3,
    AppImages.eman1,
    AppImages.egirl4,
    AppImages.egirl5,
    AppImages.egirl6,
    AppImages.eman0,
    AppImages.egirl2,
    AppImages.egirl2,
    AppImages.egirl3,
    AppImages.eman1,
    AppImages.egirl4,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 2,
          childAspectRatio: 0.99,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(images[index]),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColours.greycolour,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Live now"),
                    ),
                  ),
                ),
                Row(children: [

                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
