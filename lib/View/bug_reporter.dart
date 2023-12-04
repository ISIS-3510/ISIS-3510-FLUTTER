import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unishop/Controller/bug_controller.dart';

class BugReporterView extends StatefulWidget {
  const BugReporterView({super.key});

  @override
  State<BugReporterView> createState() => _BugReporterViewState();
}

class _BugReporterViewState extends State<BugReporterView> {
  BugController controller = BugController();
  var _bugController = TextEditingController();
  bool _isConnected = false;
  var _firstime = true;
  final _formKey = GlobalKey<FormState>();
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
                    'You are disconnected from Internet. You could try to fill this form and post it to save your information locally, and once you are connected you could save that on Internet by pressing Report again'),
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
    String? bug = await ReadCache.getString(key: "bugReport");
    if (bug != null) {
      setState(() {
        _bugController.text = bug;
      });
    }
  }

  void _saveItem() async {
    final enteredbug = _bugController.text;

    if (_formKey.currentState!.validate()) {
      await controller.addBugReport(enteredbug);
      DeleteCache.deleteKey("bugReport");
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  void _saveCache() async {
    final enteredBug = _bugController.text;

    if (_formKey.currentState!.validate()) {
      WriteCache.setString(key: "bugReport", value: enteredBug);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Your data has been saved locally'),
          content: const Text(
              'Once there is connection to internet you can report your bug, if you have not done it yet'),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Bug Reporter',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        height: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _bugController,
                maxLines: null,
                maxLength: 300,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Invalid Bug Description';
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
                    'Bug Description',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15),
                  ),
                ),
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
                child: const Text('Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
