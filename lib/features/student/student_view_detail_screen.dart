import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class StudentViewDetailScreen extends StatelessWidget {
  const StudentViewDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Student Details'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'https://static.vecteezy.com/system/resources/previews/001/131/187/large_2x/serious-man-portrait-real-people-high-definition-grey-background-photo.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Soman',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('Reg No: 12345678'),
                    const SizedBox(height: 5),
                    const Text('College User ID: COLLAGE12345'),
                  ],
                ),
              ),
            ),
            const Wrap(
              children: [
                ResultShowcard(
                  imgUrl:
                      'https://5.imimg.com/data5/PB/EA/XR/SELLER-14961972/screenshot-2-500x500.jpg',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Custom Alert Dialog for Add Result as image
class AddResult extends StatelessWidget {
  const AddResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomAlertDialog(title: 'Add Result');
  }
}

//Card to show result in the page

class ResultShowcard extends StatelessWidget {
  const ResultShowcard({
    super.key,
    required this.imgUrl,
  });
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: NetworkImage(imgUrl))),
      ),
    );
  }
}
