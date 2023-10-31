import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:unishop/Model/DAO/dao.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function (String image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  String? _selectedImagen;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    final imageUrl = await daoSaveImage(pickedImage);

    setState(() {
      _selectedImagen = imageUrl;
    });

    widget.onPickImage(_selectedImagen!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        icon: const Icon(Icons.add, color: Color.fromARGB(255, 152, 162, 172),),
        label: Text('Add', style: Theme.of(context).textTheme.bodySmall,),
        onPressed:_takePicture,
      );

    if (_selectedImagen != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.network(
          _selectedImagen!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}