import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../global.dart';
import '../../models/app_constants.dart';
import '../../models/posting_model.dart';
import '../host_home_screen.dart';
import '../widgets/amenities_ui.dart';

class CreatePostingScreen extends StatefulWidget {
  PostingModel? posting;
  CreatePostingScreen({super.key, this.posting});

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController =
  TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _amenitiesTextEditingController =
  TextEditingController();

  final List<String> residenceTypes = [
    'Detatched House',
    'Villa',
    'Apartment',
    'Condo',
    'Flat',
    'Town House',
    'Studio',
  ];

  String residenceTypesSelected = "";

  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;

  List<MemoryImage>? _imagesList;

  _selectImageFromGallery(int index) async {
    var imageFilePickedFromGaleery =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFilePickedFromGaleery != null) {
      MemoryImage imageFileInBytesForm = MemoryImage(
          (File(imageFilePickedFromGaleery.path)).readAsBytesSync());

      if (index < 0) {
        _imagesList!.add(imageFileInBytesForm);
      } else {
        _imagesList![index] = imageFileInBytesForm;
      }

      setState(() {});
    }
  }

  initializedValues() {
    if (widget.posting == null) {
      _nameTextEditingController = TextEditingController(text: "");
      _priceTextEditingController = TextEditingController(text: "");
      _descriptionTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      _cityTextEditingController = TextEditingController(text: "");
      _countryTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      residenceTypesSelected = residenceTypes.first;

      _beds = {
        'small': 0,
        'medium': 0,
        'large': 0,
      };

      _bathrooms = {
        'full': 0,
        'half': 0,
      };

      _imagesList = [];
    } else {
      _nameTextEditingController =
          TextEditingController(text: widget.posting!.name);
      _priceTextEditingController =
          TextEditingController(text: widget.posting!.price.toString());
      _descriptionTextEditingController =
          TextEditingController(text: widget.posting!.description);
      _addressTextEditingController =
          TextEditingController(text: widget.posting!.address);
      _cityTextEditingController =
          TextEditingController(text: widget.posting!.city);
      _countryTextEditingController =
          TextEditingController(text: widget.posting!.country);
      _amenitiesTextEditingController =
          TextEditingController(text: widget.posting!.getAmenitiesString());
      _beds = widget.posting!.beds;
      _bathrooms = widget.posting!.bathrooms;
      _imagesList = widget.posting!.displayImage;
      residenceTypesSelected = widget.posting!.type!;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializedValues();
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
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Create / Update a Posting",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                if (residenceTypesSelected == "") {
                  return;
                }

                if (_imagesList!.isEmpty) {
                  return;
                }

                postingModel.name = _nameTextEditingController.text;
                postingModel.price =
                    double.parse(_priceTextEditingController.text);
                postingModel.description =
                    _descriptionTextEditingController.text;
                postingModel.address = _addressTextEditingController.text;
                postingModel.city = _cityTextEditingController.text;
                postingModel.country = _countryTextEditingController.text;
                postingModel.amenities =
                    _amenitiesTextEditingController.text.split(",");
                postingModel.type = residenceTypesSelected;
                postingModel.beds = _beds;
                postingModel.bathrooms = _bathrooms;
                postingModel.displayImage = _imagesList;

                postingModel.host =
                    AppConstants.currentUser.createUserFromContact();

                postingModel.setImagesNames();

                // if this is new or old post
                if (widget.posting == null) {
                  postingModel.rating = 3.5;
                  postingModel.bookings = [];
                  postingModel.reviews = [];

                  await postingViewModel.addListingInfoToFirestore();

                  await postingViewModel.addImagesToFirebaseStorage();
                  // postingViewModel.updateListingInfoToFirestore();

                  Get.snackbar("New Listing",
                      "your new listing is uploaded successfully");
                } else {
                  postingModel.rating = widget.posting!.rating;
                  postingModel.bookings = widget.posting!.bookings;
                  postingModel.reviews = widget.posting!.reviews;
                  postingModel.id = widget.posting!.id;

                  for (int i = 0;
                  i < AppConstants.currentUser.myPostings!.length;
                  i++) {
                    if (AppConstants.currentUser.myPostings![i].id ==
                        postingModel.id) {
                      AppConstants.currentUser.myPostings![i] = postingModel;
                      break;
                    }
                  }

                  await postingViewModel.updateListingInfoToFirestore();

                  Get.snackbar(
                      "Update Listing", "your listing is updated successfully");
                }

                postingModel = PostingModel();
                // PostingModel newPosting = PostingModel();

                Get.to(HostHomeScreen());
              },
              icon: const Icon(Icons.upload))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(26, 26, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Listing name
                        Padding(
                          padding: EdgeInsets.only(top: 1.0),
                          child: TextFormField(
                            decoration:
                            InputDecoration(labelText: "Listing name"),
                            style: TextStyle(fontSize: 25.0),
                            controller: _nameTextEditingController,
                            validator: (textInput) {
                              if (textInput!.isEmpty) {
                                return "please enter valid name";
                              }

                              return null;
                            },
                          ),
                        ),

                        // Select property type

                        Padding(
                          padding: EdgeInsets.only(top: 28.0),
                          child: DropdownButton(
                            items: residenceTypes.map((item) {
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ));
                            }).toList(),
                            onChanged: (valueItem) {
                              setState(() {
                                residenceTypesSelected = valueItem.toString();
                              });
                            },
                            isExpanded: true,
                            value: residenceTypesSelected,
                            hint: Text(
                              "Selected property type",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        // Price

                        Padding(
                          padding: EdgeInsets.only(top: 21.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Price",
                                  ),
                                  style: TextStyle(
                                    fontSize: 25.0,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _priceTextEditingController,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "please enter a valid price";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Text(
                                  "\$ / night",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Description

                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Description",
                            ),
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                            controller: _descriptionTextEditingController,
                            maxLines: 1,
                            minLines: 1,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "please enter a valid description";
                              }

                              return null;
                            },
                          ),
                        ),

                        // Address

                        Padding(
                          padding: const EdgeInsets.all(21),
                          child: TextFormField(
                            //enabled: false,
                            decoration: InputDecoration(labelText: "Address"),
                            style: TextStyle(
                              fontSize: 25.0,
                            ),

                            controller: _addressTextEditingController,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "please enter a valid address";
                              }

                              return null;
                            },
                          ),
                        ),

                        // 9:37 video
                        // beds
                        const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Text(
                            'Beds',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 21.0, left: 15.0, right: 15.0),
                          child: Column(
                            children: [
                              // Twin // Single bed
                              AmenitiesUi(
                                type: 'Twin/Single',
                                startValue: _beds!['small']!,
                                decreaseValue: () {
                                  _beds!['small'] = _beds!['small']! - 1;

                                  if (_beds!['small']! < 0) {
                                    _beds!['small'] = 0;
                                  }
                                },
                                increaseValue: () {
                                  _beds!['small'] = _beds!['small']! + 1;
                                },
                              ),

                              // Double Bed

                              AmenitiesUi(
                                  type: 'Double',
                                  startValue: _beds!['medium']!,
                                  decreaseValue: () {
                                    _beds!['medium'] = _beds!['medium']! - 1;

                                    if (_beds!['medium']! < 0) {
                                      _beds!['medium'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _beds!['medium'] = _beds!['medium']! + 1;
                                  }),

                              //Queen King Bed

                              AmenitiesUi(
                                type: 'Queen/King',
                                startValue: _beds!['large']!,
                                decreaseValue: () {
                                  _beds!['large'] = _beds!['large']! - 1;

                                  if (_beds!['large']! < 0) {
                                    _beds!['large'] = 0;
                                  }
                                },
                                increaseValue: () {
                                  _beds!['large'] = _beds!['large']! + 1;
                                },
                              ),

                              // Bathrooms
                              // Full Bathrooms // 16:43

                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
                                child: Column(
                                  children: [
                                    AmenitiesUi(
                                        type: 'Full',
                                        startValue: _bathrooms!['full']!,
                                        decreaseValue: () {
                                          _bathrooms!['full'] =
                                              _bathrooms!['full']! - 1;

                                          if (_bathrooms!['full']! < 0) {
                                            _bathrooms!['full'] = 0;
                                          }
                                        },
                                        increaseValue: () {
                                          _bathrooms!['full'] =
                                              _bathrooms!['full']! + 1;
                                        }),

                                    // Half bathroom

                                    AmenitiesUi(
                                        type: 'Half',
                                        startValue: _bathrooms!['half']!,
                                        decreaseValue: () {
                                          _bathrooms!['half'] =
                                              _bathrooms!['half']! - 1;

                                          if (_bathrooms!['half']! < 0) {
                                            _bathrooms!['half'] = 0;
                                          }
                                        },
                                        increaseValue: () {
                                          _bathrooms!['half'] =
                                              _bathrooms!['half']! + 1;
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        // extra amenities

                        Padding(
                          padding: EdgeInsets.only(top: 21.0),
                          child: TextFormField(
                            decoration:
                            InputDecoration(labelText: "Amenities, "),
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                            controller: _amenitiesTextEditingController,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "please enter valid amenities";
                              }
                              return null;
                            },
                            maxLines: 3,
                            minLines: 1,
                          ),
                        ),

                        // Photos of residence

                        const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Photos",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 25.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: _imagesList!.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _imagesList!.length) {
                                return IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    _selectImageFromGallery(-1);
                                  },
                                );
                              }

                              return MaterialButton(
                                onPressed: () {},
                                child: Image(
                                  image: _imagesList![index],
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
