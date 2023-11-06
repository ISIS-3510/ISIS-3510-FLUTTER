import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/Model/degree_relations.dart';
import 'package:unishop/View/user_posts.dart';
import 'package:unishop/widgets/image_input.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:unishop/Controller/new_post_controller.dart';

class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  @override
  State<NewPostView> createState() {
    return _NewPostViewState();
  }
}

class _NewPostViewState extends State<NewPostView> {
  NewPostController controller = NewPostController();
  final _formKey = GlobalKey<FormState>();
  String _selectedImage = '';
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _priceController = TextEditingController();
  var _enteredIsNew = false;
  var _enteredIsRecycled = false;
  String _selectedDegree = DegreeRelations().degreeRelations['ALL']!.first;
  var _subjectController = TextEditingController();
  var _firstime = true;
  bool _isConnected = false;
  StreamSubscription? listener2;
  InternetConnectionChecker? customInstance2;

  @override
  void initState() {
    super.initState();
    _loadCache();
    if (mounted) {
      customInstance2 = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 1), // Custom check timeout
        checkInterval: const Duration(seconds: 1), // Custom check interval
      );
      listener2 = customInstance2!.onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            setState(() {
              _isConnected = true;
            });
            if (_firstime) {
              setState(() {
                _firstime = false;
              });
            } else {
              ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                const SnackBar(
                  content: Text('You are connected to Internet.'),
                  duration: Duration(seconds: 10),
                ),
              );
            }
            break;
          case InternetConnectionStatus.disconnected:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'You are disconnected from Internet. You could try to fill this form and post it to save your information locally, and once you are connected you could save that on Internet by pressing Post again'),
                duration: Duration(seconds: 10),
              ),
            );
            setState(() {
              _isConnected = false;
              _firstime = false;
            });
            print('You are disconnected from internet.');
            break;
        }
      });
    }
  }

  @override
  dispose() {
    listener2!.cancel();
    super.dispose();
  }

  void _loadCache() async {
    String? title = await ReadCache.getString(key: "title");
    String? description = await ReadCache.getString(key: "description");
    String? degree = await ReadCache.getString(key: "degree");
    String? price = await ReadCache.getString(key: "price");
    String? subject = await ReadCache.getString(key: "subject");
    bool? isNew = await ReadCache.getBool(key: "new");
    bool? recycled = await ReadCache.getBool(key: "recycled");
    String? image = await ReadCache.getString(key: "image");
    if (title != null ||
        description != null ||
        degree != null ||
        price != null ||
        subject != null ||
        isNew != null ||
        recycled != null) {
      setState(() {
        _titleController.text = title!;
        _descriptionController.text = description!;
        _selectedDegree = degree!;
        _priceController.text = price!;
        _subjectController.text = subject!;
        _enteredIsNew = isNew!;
        _enteredIsRecycled = recycled!;
      });
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        print(_selectedImage);
      }
    }
  }

  void _selectDegree() async {
    showMaterialRadioPicker<String>(
      headerColor: Color.fromARGB(255, 255, 198, 0),
      context: context,
      title: 'Degrees',
      items: DegreeRelations().degreeRelations['ALL'] ?? [],
      selectedItem: _selectedDegree,
      onChanged: (value) {
        setState(() {
          _selectedDegree = value;
        });
      },
    );
  }

  void _saveItem() async {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredPrice = _priceController.text;
    final enteredDegree = _selectedDegree;
    var enteredSubject = _subjectController.text;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (_formKey.currentState!.validate() && _selectedImage.isNotEmpty) {
      await controller.createPost(
          enteredDegree.trim(),
          enteredDescription.trim(),
          enteredTitle.trim(),
          _enteredIsNew,
          enteredPrice,
          _enteredIsRecycled,
          enteredSubject.trim(),
          _selectedImage,
          userId.toString());
      DeleteCache.deleteKey("title");
      DeleteCache.deleteKey("description");
      DeleteCache.deleteKey("degree");
      DeleteCache.deleteKey("price");
      DeleteCache.deleteKey("subject");
      DeleteCache.deleteKey("new");
      DeleteCache.deleteKey("recycled");
      if (await ReadCache.getString(key: "image") != null) {
        DeleteCache.deleteKey("image");
      }
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const UserPostsView(),
      ));
    } else if (_selectedImage.isEmpty) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Image not found',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Please make sure an image was uploaded',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))
          ],
        ),
      );
      return;
    }
  }

  void _saveCache() async {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredPrice = _priceController.text;
    final enteredDegree = _selectedDegree;
    var enteredSubject = _subjectController.text;

    if (_formKey.currentState!.validate()) {
      WriteCache.setString(key: "title", value: enteredTitle);
      WriteCache.setString(key: "description", value: enteredDescription);
      WriteCache.setString(key: "degree", value: enteredDegree);
      WriteCache.setString(key: "price", value: enteredPrice);
      WriteCache.setString(key: "subject", value: enteredSubject);
      WriteCache.setBool(key: "new", value: _enteredIsNew);
      WriteCache.setBool(key: "recycled", value: _enteredIsRecycled);
      if (_selectedImage.isNotEmpty || _selectedImage != '') {
        WriteCache.setString(key: "image", value: _selectedImage);
      }
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Your data has been saved locally',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Once there is connection to internet you can take the photo of the product, if you have not done it yet, and then post the data',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))
          ],
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const UserPostsView(),
              maintainState: false,
            ));
          },
        ),
        title: Text(
          'New Post',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 22,
              ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15),
                  maxLength: 50,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid title';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Title',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 15),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      counterStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                AbsorbPointer(
                  absorbing: !_isConnected,
                  child: ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                    img: _selectedImage,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  maxLength: 300,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid Description';
                    } else {
                      return null;
                    }
                  },
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 15),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      counterStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.trim().isEmpty ||
                        value.trim().contains(',') ||
                        value.contains(' ')) {
                      return 'Invalid Price';
                    } else if (Decimal.parse(value) < Decimal.parse('1000')) {
                      return 'Price must be 1000 COP or above';
                    } else {
                      return null;
                    }
                  },
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                      prefixText: 'COP ',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Price (1000 COP and above)',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 15),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      counterStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Is new',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15),
                    ),
                    Switch(
                      value: _enteredIsNew,
                      onChanged: (bool value) {
                        setState(() {
                          _enteredIsNew = value;
                        });
                      },
                      activeTrackColor: Color.fromARGB(255, 255, 198, 0),
                      activeColor: Colors.white,
                      inactiveTrackColor: Color.fromARGB(255, 255, 198, 0),
                      inactiveThumbColor: Colors.black,
                    ),
                    Text(
                      'Is recycled',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15),
                    ),
                    Switch(
                      value: _enteredIsRecycled,
                      onChanged: (bool value) {
                        setState(() {
                          _enteredIsRecycled = value;
                        });
                      },
                      activeTrackColor: Color.fromARGB(255, 255, 198, 0),
                      activeColor: Colors.white,
                      inactiveTrackColor: Color.fromARGB(255, 255, 198, 0),
                      inactiveThumbColor: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectDegree,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 198, 0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Select your degree: $_selectedDegree",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subjectController,
                  maxLength: 50,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 15),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid Subject';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Subject',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 15),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      counterStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_isConnected) {
                      _saveItem();
                    } else {
                      _saveCache();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color.fromARGB(255, 255, 198, 0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Post',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
