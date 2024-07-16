import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../../../../core/services/auth_service.dart';
import '../../../../../../../core/controllers/user_controller.dart';
import '../../../../../../../utils/contants/colors.2.0.dart';

const defaultAvatar = "assets/images/add_photo.png";

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    Key? key,
    this.profileImage = defaultAvatar,
  }) : super(key: key);

  final String profileImage;

  @override
  State<StatefulWidget> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? selectedImage;
  Uint8List? _image;
  String _profileImageUrl = '';
  bool _isLoading = false;

  final AuthService _auth = AuthService();
  final UserController _user = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (_user.currentUser!.photoURL.isNotEmpty) {
        setState(() {
          _profileImageUrl = _user.currentUser!.photoURL;
        });
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/profile_image.png';
        final file = File(path);

        if (await file.exists()) {
          setState(() {
            _profileImageUrl = file.path;
          });
        } else {
          setState(() {
            _profileImageUrl = widget.profileImage;
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  Future<void> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/profile_image.png';
        final file = File(path);

        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _profileImageUrl = file.path;
        });
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> _saveProfileImageLocally(Uint8List imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/profile_image.png';
      final file = File(path);

      await file.writeAsBytes(imageBytes);

      setState(() {
        _profileImageUrl = file.path;
      });
    } catch (e) {
      print('Error saving profile image locally: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        selectedImage = File(pickedFile.path);
        _image = File(pickedFile.path).readAsBytesSync();
      });

      Get.back(); // Close the bottom sheet after picking an image
      await _uploadToFirebase();
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadToFirebase() async {
    if (selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final fileName =
          'profile_images/${_auth.currentUser?.uid ?? DateTime.now().millisecondsSinceEpoch}.png';

      final ref = FirebaseStorage.instance.ref().child(fileName);

      await ref.putFile(selectedImage!);

      final downloadURL = await ref.getDownloadURL();

      _user.currentUser?.changePhotoURL(downloadURL);
      await _user.updateUser(_user.currentUser!);

      await _saveProfileImageLocally(_image!);

      setState(() {
        _profileImageUrl = downloadURL;
      });
    } catch (e) {
      print('Error uploading to Firebase: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          color: defaultContainerSecondaryLayoutColor,
          child: Wrap(
            children: <Widget>[
              ListTile(
                onTap: () => _pickImage(ImageSource.gallery),
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
              ),
              ListTile(
                onTap: () => _pickImage(ImageSource.camera),
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 80,
      // backgroundImage: NetworkImage(_profileImageUrl),
      backgroundImage: _profileImageUrl.isNotEmpty
          ? NetworkImage(_profileImageUrl)
          : FileImage(File(_profileImageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                _buildProfileAvatar(),
                if (_isLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => showMoreOptions(context),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.amber,
                    ),
                    padding: WidgetStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Choose your photo",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
