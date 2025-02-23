import 'package:flutter/material.dart';
import '../../models/posting_model.dart';

class PostingListingTileUi extends StatefulWidget {

  PostingModel? posting;

  PostingListingTileUi({super.key, this.posting});

  @override
  State<PostingListingTileUi> createState() => _PostingListingTileUiState();
}

class _PostingListingTileUiState extends State<PostingListingTileUi> {

  PostingModel? posting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    posting = widget.posting;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            posting!.name!,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
        trailing: AspectRatio(
          aspectRatio: 3/2,
          child: Image(
            image: posting!.displayImage!.first,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}