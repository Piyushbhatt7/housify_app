import 'package:flutter/material.dart';

class PostingInfoTrialUi extends StatefulWidget {

  IconData? iconData;
  String? category;
  String? categoryInfo;

  PostingInfoTrialUi({super.key, this.iconData, this.category, this.categoryInfo});

  @override
  State<PostingInfoTrialUi> createState() => _PostingInfoTrialUiState();
}

class _PostingInfoTrialUiState extends State<PostingInfoTrialUi> {
  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Icon(
        widget.iconData,
        size: 30,
      ),
      // 11:32
      title: Text(
        widget.category!,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),
      ),

      subtitle: Text(
        widget.categoryInfo!,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}