import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  List<bool> categorieSelected = [
    ..._shoppingCategories.map((e) => false).toList()
  ];
  bool uploading = false;
  List<Uint8List> productImages = [];
  String productName = "";
  String productDescription = "";
  final GlobalKey<FormState> _formValidate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //product name
            SizedBox(
              width: 450,
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  label: Text(
                    "Product Name:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.scrim),
                  ),
                ),
                onSaved: (newValue) => productName = newValue!,
                validator: (value) {
                  if (value == "null" ||
                      value == null ||
                      value.length < 6 ||
                      value.isEmpty) {
                    return "enter a valid Product Name atleast 6 characters";
                  }
                  if (value.startsWith("0") ||
                      value.startsWith("1") ||
                      value.startsWith("2") ||
                      value.startsWith("3") ||
                      value.startsWith("4") ||
                      value.startsWith("5") ||
                      value.startsWith("6") ||
                      value.startsWith("6") ||
                      value.startsWith("7") ||
                      value.startsWith("8") ||
                      value.startsWith("9")) {
                    return "the first character should be a letter";
                  }

                  return null;
                },
              ),
            ),
            // list of product type
            const SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "\t\t\t Select Categorie:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  for (int i = 0; i < _shoppingCategories.length; i++)
                    ListTile(
                      title: Text(
                        _shoppingCategories[i],
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Checkbox(
                        activeColor: Theme.of(context).colorScheme.background,
                        checkColor: Theme.of(context).colorScheme.scrim,
                        value: categorieSelected[i],
                        onChanged: (val) {
                          setState(() {
                            categorieSelected[i] = val!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          categorieSelected[i] = !categorieSelected[i];
                        });
                      },
                    ),
                ],
              ),
            ),
            // buttons to add and remove images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //add image
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    iconSize: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return 30;
                      }
                      return 20;
                    }),
                    textStyle: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        );
                      }
                      return const TextStyle();
                    }),
                  ),
                  label: const Text("Select Images"),
                  onPressed: () async {
                    final imageFile =
                        await ImagePickerWeb.getMultiImagesAsBytes();
                    if (imageFile == null) {
                      return;
                    }
                    productImages = [...productImages, ...imageFile];
                    setState(() {});
                  },
                  icon: const Icon(Icons.image),
                ),
                //remove  image
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  label: const Text("Remove all images"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    iconSize: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return 30;
                      }
                      return 20;
                    }),
                    textStyle: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        );
                      }
                      return const TextStyle();
                    }),
                  ),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Confirm Delete All images"),
                            content: const Text(
                                "pressing confirm removes every selected images"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  productImages = [];
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ),
            // list of images selected
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              height: 100,
              width: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 40,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            final imageContext = ctx;
                            return Dialog(
                              child: Stack(
                                children: [
                                  Image.memory(productImages[index]),
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.arrow_back),
                                        ),
                                        //remove perticular image
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Confirm Delete this images"),
                                                    content: const Text(
                                                        "pressing confirm this images"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          productImages
                                                              .removeAt(index);
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              imageContext);
                                                        },
                                                        child: const Text(
                                                            "Confirm"),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.cancel),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text("image${index + 1}")),
                    ),
                  );
                },
                itemCount: productImages.length,
              ),
            ),
            // description box
            SizedBox(
              width: 450,
              child: TextFormField(
                onSaved: (newValue) => productDescription = newValue!,
                validator: (value) {
                  if (value == "null" ||
                      value == null ||
                      value.length < 6 ||
                      value.isEmpty) {
                    return "enter a valid Product Name atleast 6 characters";
                  }
                  return null;
                },
                maxLines: 20,
                minLines: 1,
                maxLength: 250,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  label: Text(
                    "Description:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.scrim),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //button to validate
            uploading == false
                ? ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) =>
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      iconSize: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return 30;
                        }
                        return 20;
                      }),
                      textStyle: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          );
                        }
                        return const TextStyle();
                      }),
                    ),
                    onPressed: () async {
                      if (categorieSelected
                              .every((element) => element == false) ||
                          productImages.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Missing Parameter"),
                              content: const Text(
                                  "you have not selected one of the parameter"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Okay"))
                              ],
                            );
                          },
                        );
                      } else if (_formValidate.currentState!.validate()) {
                        _formValidate.currentState!.save();

                        setState(() {
                          uploading = true;
                        });
                        //images saved in firebase storage
                        final folderId = const Uuid().v4();
                        try {
                          for (final productImage in productImages) {
                            final id = const Uuid().v4();

                            final storageRef =
                                FirebaseStorage.instance.ref("$folderId/$id");
                            storageRef.putData(
                              productImage,
                            );
                          }
                          // details uploaded to firestore database
                          await FirebaseFirestore.instance
                              .collection("products")
                              .doc(folderId)
                              .set({
                            "name": productName,
                            "imagesTotal": productImages.length,
                            "description": productDescription,
                            "type": [
                              for (var i = 0;
                                  i < _shoppingCategories.length;
                                  i++)
                                if (categorieSelected[i]) _shoppingCategories[i]
                            ],
                            "id": folderId,
                          });
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text(
                                    "ERROR",
                                  ),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Okay"),
                                    )
                                  ],
                                );
                              });
                        }
                        // resetting the form
                        _formValidate.currentState!.reset();
                        productImages = [];
                        categorieSelected =
                            categorieSelected.map((e) => e = false).toList();
                        setState(() {
                          uploading = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.upload,
                    ),
                    label: const Text(
                      "Upload",
                      style: TextStyle(),
                    ),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

final List<String> _shoppingCategories = [
  "all",
  "men",
  "women",
  "electronics",
];
