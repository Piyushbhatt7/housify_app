
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/app_constants.dart';
import '../widgets/posting_listing_tile_ui.dart';
import '../widgets/posting_tile_button.dart';
import 'create_posting_screen.dart';

class MyPostingScreen extends StatefulWidget {
  const MyPostingScreen({super.key});

  @override
  State<MyPostingScreen> createState() => _MyPostingScreenState();
}

class _MyPostingScreenState extends State<MyPostingScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: ListView.builder(
          itemCount: AppConstants.currentUser.myPostings!.length + 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(26, 0, 26, 26),
              child: InkResponse(
                onTap: () {
                  Get.to(CreatePostingScreen(
                    posting:
                    (index == AppConstants.currentUser.myPostings!.length)
                        ? null
                        : AppConstants.currentUser.myPostings![index],
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.2,
                    ),
                  ),
                  child: (index == AppConstants.currentUser.myPostings!.length)
                      ? PostingTileButton()
                      : PostingListingTileUi(
                      posting: AppConstants.currentUser.myPostings![index]),
                ),
              ),
            );
          }),
    );
  }
}
