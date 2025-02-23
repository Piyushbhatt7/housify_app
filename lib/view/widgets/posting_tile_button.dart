import 'package:flutter/material.dart';

class PostingTileButton extends StatelessWidget {
  const PostingTileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/11.0,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          Text(
            "Create a listing",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),
          )
        ],
      ),
    );
  }
}