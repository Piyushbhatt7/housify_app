import 'package:flutter/material.dart';
import 'package:housify_final/view/widgets/posting_info_trial_ui.dart';

import '../models/posting_model.dart';

class ViewPostingScreen extends StatefulWidget {
  PostingModel? posting;

  ViewPostingScreen({super.key, this.posting});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {
  PostingModel? posting;

  getRequiredInfo() async {
    await posting!.getAllImagesFromStorage();
    await posting!.getHostFromFirestore();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    posting = widget.posting;

    getRequiredInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent,
                  Colors.amberAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        ),
        title: const Text(
          "Posting Information",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // listing images
            AspectRatio(
              aspectRatio: 3 / 2,
              child: PageView.builder(
                  itemCount: posting!.displayImage!.length,
                  itemBuilder: (context, index) {
                    MemoryImage currentImage = posting!.displayImage![index];
                    return Image(
                      image: currentImage,
                      fit: BoxFit.fill,
                    );
                  }),
            ),

            // posting name btn // book now btn // price btn
            // description - profile pic
            // apartment - beds - bathrooms
            // amenities
            // the location

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // posting name btn // book now btn

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.55,
                        child: Text(
                          posting!.name!.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent,
                                    Colors.amberAccent,
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                )),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '\$${posting!.price} / night',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  ),

                  // description - profile pic // name

                  Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            posting!.description!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            maxLines: 5,
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius:
                                MediaQuery.of(context).size.width / 12.5,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundImage: posting!.host!.displayImage,
                                  radius:
                                  MediaQuery.of(context).size.width / 13,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                posting!.host!.getFullNameOfUser(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // 10:39
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  // apartment - beds - bathrooms

                  Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        PostingInfoTrialUi(
                          iconData: Icons.home,
                          category: posting!.type!,
                          categoryInfo: '${posting!.getGuestNumber()} guests',
                        ),
                        PostingInfoTrialUi(
                          iconData: Icons.hotel,
                          category: 'Beds',
                          categoryInfo: posting!.getBedroomsText(),
                        ),
                        PostingInfoTrialUi(
                          iconData: Icons.wc,
                          category: 'Bathrooms',
                          categoryInfo: posting!.getBathroomsText(),
                        ),
                      ],
                    ),
                  ),

                  // amenities

                  const Text(
                    'Amenities: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 25),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 3.6,
                      children:
                      List.generate(posting!.amenities!.length, (index) {
                        String curreAmenity = posting!.amenities![index];
                        return Chip(
                          label: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              curreAmenity,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white10,
                        );
                      }),
                    ),
                  ),

                  // location

                  const Text(
                    'The Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 8),
                      child: Text(
                        posting!.getFullAddress(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
