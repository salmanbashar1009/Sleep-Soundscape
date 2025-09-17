import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/api_services/hive_service.dart';
import 'package:sleep_soundscape/model_view/add_sound_provider.dart';
import 'package:sleep_soundscape/view/Banner/widget/glassBox.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';
import 'package:sleep_soundscape/view/upload_screen/widgets/info_section.dart';

class MusicUploadScreen extends StatefulWidget {
  const MusicUploadScreen({super.key});

  @override
  _MusicUploadScreenState createState() => _MusicUploadScreenState();
}

class _MusicUploadScreenState extends State<MusicUploadScreen> {
  // String? selectedFile;
  // String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String? selectedImage;

  bool get isFormValid {
    final addSoundProvider = Provider.of<AddSoundProvider>(context);

    return addSoundProvider.selectedAudio != null &&
        addSoundProvider.selectedImage != null &&
        addSoundProvider.category != null &&
        _titleController.text.isNotEmpty &&
        _subtitleController.text.isNotEmpty;
  }

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       selectedFile = result.files.single.name;
  //     });
  //   }
  // }

  // Future<void> _pickImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       selectedImage = result.files.single.name;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/bgdark.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        HiveServices.clearData(boxName: "userData", modelName: "user");
                        Navigator.pushNamedAndRemoveUntil(context, RouteName.signInScreen, (route) => false);
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red, // Red color for the logout text
                          fontSize: 18.sp, // Adjust font size
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    "Upload Your Music",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(

                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Title",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(

                    controller: _subtitleController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subtitle';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Subtitle",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                    ),

                  ),
                  SizedBox(height: 16.h),
                  Consumer<AddSoundProvider>(
                      builder: (context,addSoundProvider,child) {
                        return GestureDetector(
                          onTap: () async{
                            final pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              addSoundProvider.setImage(File(pickedFile.path));
                            }
                          },
                          child: Glassbox(
                            title: addSoundProvider.selectedImage?.path ??  "Upload Thumbnail",
                            discription: "Tap to select an image",
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 16.h),
                  // Remove custom styling for the category dropdown
                  Consumer<AddSoundProvider>(
                    builder: (context,addSoundProvider,child) {
                      return DropdownButtonFormField<String>(
                        value: addSoundProvider.category,
                        hint: Text(
                          "Select Category",
                          style: TextStyle(
                              color: Colors.white), // Set hint text color to white
                        ),
                        items: [
                          "Ambient",
                          "Nature Sounds",
                          "Instrumental",
                          "Meditation"
                        ]
                            .map((category) =>
                            DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: TextStyle(color: Colors
                                    .white), // Set item text color to white
                              ),
                            ))
                            .toList(),
                        onChanged: (value) {
                          addSoundProvider.setCategory(value!);
                        },
                        style: TextStyle(color: Colors.white),
                        // Set selected text color to white
                        dropdownColor: Colors
                            .black, // Set dropdown background color to black
                      );
                    }
                  ),

                  SizedBox(height: 16.h),
                  Consumer<AddSoundProvider>(
                    builder: (context,addSoundProvider,child) {
                      return GestureDetector(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

                          if (result != null) {
                            addSoundProvider.setAudio(File(result.files.single.path!));
                          }
                        },
                        child: Glassbox(
                          title: addSoundProvider.selectedAudio?.path ?? "Select Music File",
                          discription: "Tap to upload your audio file",
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 24.h),
                   Consumer<AddSoundProvider>(
                    builder: (context,addSoundProvider,child) {
                      return addSoundProvider.isAddSoundLoading ? Center(child: CircularProgressIndicator(),) : Mybutton(
                        text: "Upload",
                        color:isFormValid ? Color(0xFFFAD051) : Color.fromRGBO(255, 255, 255, 0.4) ,
                        ontap:() async {

                       if (_formKey.currentState!.validate()) {
                         if (addSoundProvider.selectedAudio == null || addSoundProvider.selectedImage == null || addSoundProvider.category == null) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text("Please select all fields"),
                               backgroundColor: Colors.red,
                             ),
                           );
                         }else{
                           await  addSoundProvider.uploadSound(
                             category: addSoundProvider.category!,
                             title: _titleController.text,
                             subtitle: _subtitleController.text,
                             image: addSoundProvider.selectedImage!,
                             audio: addSoundProvider.selectedAudio!,
                           );

                           debugPrint("Music uploaded successfully");
                           if(addSoundProvider.isAddSoundSuccess){

                             _titleController.clear();
                             _subtitleController.clear();
                             addSoundProvider.setCategory(null);
                             addSoundProvider.setAudio(null);
                             addSoundProvider.setImage(null);

                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text("${addSoundProvider.addSoundData?.message}"),
                                 backgroundColor: Colors.green,
                               ),
                             );
                           }
                         }
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text("Please fill in all fields"),
                             backgroundColor: Colors.red,
                           ),

                         );
                       }







                        }
                        ,
                      );
                    }
                  ),
                  SizedBox(height: 30.h),
                  Divider(color: Colors.white.withOpacity(0.3)),
                  SizedBox(height: 20.h),
                  infoSection(
                      context, "Supported Formats:", "MP3, WAV, AAC, FLAC"),
                  // _buildInfoSection(context, "Why Upload Music?", "Enjoy seamless playback, organize your favorite tracks, and access exclusive soundscapes."),
                  // _buildInfoSection(context, "How to Upload?", "Tap on 'Select Music File', choose your track, and press 'Upload' to add it to your library."),
                ],
              ),
            )
            ,
          ),
        ),
      ),
    );
  }

}
