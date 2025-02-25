import 'package:flutter/material.dart';

class EventItems extends StatelessWidget {
  const EventItems({
    super.key,
    this.ontap,
  });
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          child: Row(
            children: [
              Text('higher secondary boys 100 mts running'),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.orange,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
