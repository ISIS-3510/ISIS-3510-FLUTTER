import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/Model/degree_relations.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/widgets/image_input.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  @override
  State<NewPostView> createState() {
    return _NewPostViewState();
  }
}

class _NewPostViewState extends State<NewPostView> {
  final _formKey = GlobalKey<FormState>();
  String _selectedImage = '';
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _priceController = TextEditingController();
  var _enteredIsNew = false;
  var _enteredIsRecycled = false;
  String _selectedDegree = DegreeRelations().degreeRelations['ALL']!.first;
  var _subjectController = TextEditingController();

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
    final userId =prefs.getString('user_id');

    if (_formKey.currentState!.validate() && _selectedImage.isNotEmpty) {
      ProductDTO post = PostsRepository.createPost(enteredDegree.trim(), enteredDescription.trim(), enteredTitle.trim(), _enteredIsNew, enteredPrice, _enteredIsRecycled, enteredSubject.trim(), _selectedImage, userId.toString());
      
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        post
      );
    } else if (_selectedImage.isEmpty) {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Image not found'),
          content: const Text(
              'Please make sure an image was uploaded'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Ok'))
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
        title: Text(
          'New Post',
          style: Theme.of(context).textTheme.titleLarge,
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
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 15
                      ),
                  maxLength: 50,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid title';
                    } else{
                      return null;
                    } 
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      'Title',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  maxLength: 300,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid Description';
                    } else{
                      return null;
                    } 
                  },
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 15
                      ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      'Description',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.trim().isEmpty || value.trim().contains(',') || value.contains(' ')) {
                      return 'Invalid Price';
                    } else if (Decimal.parse(value) < Decimal.parse('1000')) {
                      return 'Price must be 1000 COP or above';
                    } 
                    else{
                      return null;
                    } 
                  },
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontSize: 15
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                    prefixText: 'COP ',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      'Price (1000 COP and above)',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
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
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
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
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
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
                ElevatedButton(
                  onPressed: _selectDegree,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 198, 0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Select your degree: $_selectedDegree"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subjectController,
                  maxLength: 50,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 15
                      ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Invalid Subject';
                    } else {
                      return null;
                    } 
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217).withOpacity(0.11),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(
                      'Subject',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15
                      ),
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
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
