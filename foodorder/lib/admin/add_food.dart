import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodorder/service/database.dart';
import 'package:foodorder/widget/widget_support.dart';

class AddFood extends StatefulWidget {
  const AddFood({Key? key}) : super(key: key);

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String _imageFile = '';
  Uint8List? selectedImageInBytes;
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  bool _isBestSelling = false; // Added to track if the item is best-selling

  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://foodorder-423ae.appspot.com',
  );

  final List<String> fooditems = ['MainCourse','Ice-cream', 'Burger', 'Salad', 'Pizza'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food Item"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageFile.isNotEmpty || _imageFile != ''
                  ? Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        selectedImageInBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text('Pick Image',
                      style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Item Name",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Name",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Item Price",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Price",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Item Detail",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Detail",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Select Category",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: fooditems
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        clearFields();
                      },
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await uploadImage(selectedImageInBytes!);
                      },
                      child: const Text('Add Food Item',
                          style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name!;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error: $e",
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
      ));
    }
  }

  Future<void> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      Reference ref = _storage.ref().child('images/$_imageFile');
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

      // Wait for the upload task to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Show a snack bar indicating the image upload success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Image Uploaded",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ));

      // Pass the download URL to the function for adding the item
      uploadItem(downloadURL);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ));
    }
  }

  void uploadItem(String imageUrl) async {
    if (namecontroller.text != "" &&
        pricecontroller.text != "" &&
        detailcontroller.text != "" &&
        value != null) {
      Map<String, dynamic> addItem = {
        "Name": namecontroller.text,
        "Price": pricecontroller.text,
        "Detail": detailcontroller.text,
        "ImageUrl": imageUrl,
      };

      await addFoodItem(
        int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
        value!,
        namecontroller.text,
        detailcontroller.text,
        double.parse(pricecontroller.text),
        imageUrl,
        _isBestSelling,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: const Text(
          "Food Item has been added Successfully",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ));
    }
  }

  Future<void> addFoodItem(int itemId, String categoryName, String itemName,
      String itemDescription, double itemPrice, String imageUrl, bool isBestSelling) async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId.toString())
          .set({
        'itemId': itemId,
        'categoryName': categoryName,
        'itemName': itemName,
        'itemDescription': itemDescription,
        'itemPrice': itemPrice,
        'imageUrl': imageUrl,
        'isBestSelling': isBestSelling,
      });
    } catch (e) {
      throw Exception("Failed to add food item: $e");
    }
  }

  void clearFields() {
    setState(() {
      _imageFile = '';
      selectedImageInBytes = null;
      namecontroller.clear();
      pricecontroller.clear();
      detailcontroller.clear();
      value = null;
    });
  }
}
