import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/widgets/image_input.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  @override
  State<NewPostView> createState() {
    return _NewPostViewState();
  }
}



class _NewPostViewState extends State<NewPostView> {
  File? _selectedImage;
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _priceController = TextEditingController();
  var _enteredIsNew = false;
  var _enteredIsRecycled = false;
  var _degreeController = TextEditingController();
  var _subjectController = TextEditingController();

  void _saveItem() async {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredPrice = _priceController.text;
    final enteredDegree = _degreeController.text;
    var enteredSubject = _subjectController.text;


    final imageBytes = _selectedImage!.readAsBytesSync();
    String imageTextBytes = String.fromCharCodes(imageBytes);
    final url = Uri.https('creative-mole-46.hasura.app',
        'api/rest/post/create');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': 'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
      },
      body: json.encode(
        {
          "object":{
            "date": DateTime.now().toIso8601String(),
            "degree": enteredDegree,
            "description": enteredDescription,
            "name": enteredTitle,
            "new": _enteredIsNew,
            "price": double.tryParse(enteredPrice),
            "recycled": _enteredIsRecycled,
            "subject": enteredSubject,
            "urlsImages": imageTextBytes,
            "userId": "b7e0f74e-debe-4dcc-8283-9d6a97e76166"
          }
        },
      ),
    );

    final Map<String, dynamic> resData = json.decode(response.body);

    print(resData);

    if (!context.mounted) {
      return;
    }

    print(resData);
    Navigator.of(context).pop(
      Product(
        title: enteredTitle,
        description: enteredDescription,
        price: double.tryParse(enteredPrice)!,
        isNew: _enteredIsNew,
        isRecycled: _enteredIsRecycled,
        degree: enteredDegree,
        subject: enteredSubject,
        image: imageTextBytes,
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Title',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            ImageInput(onPickImage: (image) {
              _selectedImage = image;
            },),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: null,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              maxLines: null,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Price',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Is new',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Switch(
                  value: _enteredIsNew,
                  onChanged: (bool value) {
                    setState(() {
                      _enteredIsNew = value;
                    });
                  },
                  activeTrackColor: Color.fromARGB(255, 255, 198, 0),
                  inactiveTrackColor: Color.fromARGB(255, 255, 198, 0),
                  inactiveThumbColor: Colors.black,
                ),
                Text(
                  'Is recycled',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Switch(
                  value: _enteredIsRecycled,
                  onChanged: (bool value) {
                    setState(() {
                      _enteredIsRecycled = value;
                    });
                  },
                  activeTrackColor: Color.fromARGB(255, 255, 198, 0),
                  inactiveTrackColor: Color.fromARGB(255, 255, 198, 0),
                  inactiveThumbColor: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _degreeController,
              maxLines: null,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Degree',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subjectController,
              maxLines: null,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Subject',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 255, 198, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
