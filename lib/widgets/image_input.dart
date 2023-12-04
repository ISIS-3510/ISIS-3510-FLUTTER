import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:unishop/Model/DAO/dao.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage, required this.img});

  final void Function (String image) onPickImage;

  final String img;

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

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final result = await ImageGallerySaver.saveFile(pickedImage.path);
    print(result);

    final imageUrl = await daoSaveImage(pickedImage);

    setState(() {
      _selectedImagen = imageUrl;
    });

    widget.onPickImage(_selectedImagen!);
  }

  void _selectPicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

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
        onPressed:_showDialogPictureorGallery,
      );

    if (_selectedImagen != null) {
      content = GestureDetector(
        onTap: _showDialogPictureorGallery,
        child: Image.network(
          _selectedImagen!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    if (widget.img != '') {
        content = GestureDetector(
          onTap: _showDialogPictureorGallery,
          child: Image.network(
            widget.img,
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
  void _showDialogPictureorGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select the origin of the picture'),
          content: Text('Choose one of the following options'),
          actions: [
            TextButton(
              onPressed: () {
                _selectPicture();
                Navigator.of(context).pop();
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                _takePicture();
                Navigator.of(context).pop();
              },
              child: Text('Camera'),
            ),
          ],
        );
      },
    );
  }
}