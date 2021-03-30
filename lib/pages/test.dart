// import 'dart:convert';
// import 'dart:io';
//
// import 'package:asapack/album_list.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// class Dashboard extends StatefulWidget{
//   DashboardState createState() => DashboardState();
// }
//
// class DashboardState extends State<Dashboard>{
//   final formKey = GlobalKey<FormState>();
//   final formKey1 = GlobalKey<FormState>();
//   File imageFile = null;
//   String imgPath ='assets/images/defimg.png';
//   TextEditingController nameController = new TextEditingController();
//   TextEditingController emailController = new TextEditingController();
//   TextEditingController phoneController = new TextEditingController();
//   TextEditingController qtyController = new TextEditingController();
//   TextEditingController locationController = new TextEditingController();
//   TextEditingController heightController = new TextEditingController();
//   TextEditingController widthController = new TextEditingController();
//   TextEditingController lengthController = new TextEditingController();
//
//   static void showAlertDialog(BuildContext context){
//     AlertDialog alert=AlertDialog(
//       content: new Row(
//         children: [
//           CircularProgressIndicator(),
//           Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
//         ],),
//     );
//     showDialog(barrierDismissible: false,
//       context:context,
//       builder:(BuildContext context){
//         return alert;
//       },
//     );
//   }
//
//   submitData() async{
//     if(formKey.currentState.validate()) {
//       showAlertDialog(context);
//       String photoBase64 = "";
//       if(imageFile != null){
//         List<int> imageBytes = imageFile.readAsBytesSync();
//         photoBase64 = base64Encode(imageBytes);
//         print(photoBase64);
//       }
//       String url = 'http://betawebspace.com/clients/development/asatech/users/post_user_enquiry_details';
//       var postBody = {
//         "image":photoBase64,
//         "fname": nameController.text,
//         "email": emailController.text,
//         "mobile": phoneController.text,
//         "qty": qtyController.text,
//         "location": locationController.text,
//         "height": heightController.text,
//         "width": widthController.text,
//         "length": lengthController.text,
//       };
//       final response = await http.post(url, body: postBody);
//       if (response.statusCode == 200) {
//         Navigator.pop(context);
//         String mResponse = response.body;
//         final Map<String, dynamic> data = json.decode(mResponse);
//         var status = data['post_user_enquiry_details_response_true'];
//         if (status) {
//           nameController.text = "";
//           emailController.text = "";
//           phoneController.text = "";
//           qtyController.text = "";
//           locationController.text = "";
//           heightController.text = "";
//           widthController.text = "";
//           lengthController.text = "";
//           setState(() {
//             imageFile = null;
//           });
//           FocusScope.of(context).requestFocus(new FocusNode());
//           Fluttertoast.showToast(
//               msg: 'Data send successfully',
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 2,
//               backgroundColor: Colors.black26,
//               textColor: Colors.white);
//         }
//       }
//     }
//   }
//
//   goToAlbum() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => AlbumList()));
//   }
//
//   Widget commonTextFields(String label, TextEditingController mController,
//       TextInputType textInputType) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         child: TextFormField(
//           controller: mController,
//           keyboardType: textInputType,
//           maxLength: label=='Phone Number'?13:50,
//           validator: (val) {
//             if(label == 'Email'){
//               if(val.isEmpty){
//                 return 'Please enter '+label;
//               }
//               if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
//                 return 'Please enter valid email';
//               }
//               else{
//                 return null;
//               }
//             }
//             else if(label == 'Phone Number'){
//               if(val.length<10){
//                 return 'Enter valid '+label;
//               }
//               else{
//                 return null;
//               }
//             }
//             else{
//               if(val.isEmpty){
//                 return 'Please enter '+label;
//               }
//               else {
//                 return null;
//               }
//             }
//           },
//           decoration: InputDecoration(
//             hintText: label,
//             contentPadding:
//             EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             counterText: "",
//             fillColor: const Color(0xffEBEDEF),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               borderSide: BorderSide(color: Colors.white, width: 0),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               borderSide: BorderSide(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget smallField(String lable, TextEditingController mController,
//       TextInputType textInputType, double mPaddingLeft, double mPaddingRight) {
//     return Flexible(
//       child: Padding(
//         padding: EdgeInsets.only(left: mPaddingLeft, right: mPaddingRight),
//         child: TextFormField(
//           controller: mController,
//           keyboardType: textInputType,
//           validator: (val) {
//             return val.isEmpty
//                 ? 'Required'
//                 : null;
//           },
//           decoration: InputDecoration(
//             hintText: lable,
//             contentPadding:
//             EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//             hintStyle: TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: const Color(0xffEBEDEF),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               borderSide: BorderSide(color: Colors.white, width: 0),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               borderSide: BorderSide(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future imageSelector(BuildContext context, String pickerType) async {
//     switch (pickerType) {
//       case "gallery":
//
//       /// GALLERY IMAGE PICKER
//         imageFile = await ImagePicker.pickImage(
//             source: ImageSource.gallery, imageQuality: 90);
//         break;
//
//       case "camera": // CAMERA CAPTURE CODE
//         imageFile = await ImagePicker.pickImage(
//             source: ImageSource.camera, imageQuality: 90);
//         break;
//     }
//
//     if (imageFile != null) {
//       print("You selected  image : " + imageFile.path);
//       setState(() {
//         debugPrint("SELECTED IMAGE PICK   $imageFile");
//       });
//     } else {
//       print("You have not taken image");
//     }
//   }
//
//   // Image picker
//   void _settingModalBottomSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: new Wrap(
//               children: <Widget>[
//                 new ListTile(
//                     title: new Text('Gallery'),
//                     onTap: () => {
//                       imageSelector(context, "gallery"),
//                       Navigator.pop(context),
//                     }),
//                 new ListTile(
//                   title: new Text('Camera'),
//                   onTap: () => {
//                     imageSelector(context, "camera"),
//                     Navigator.pop(context)
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         backgroundColor: Colors.white,
// //        appBar: AppBar(
// //          title: Text(widget.title),
// //        ),
//         body: SafeArea(
//           top: true,
//           bottom: true,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 50.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 30.0, right: 10.0, left: 10.0),
//                           child: InkWell(
//                             onTap: (){
//                               _settingModalBottomSheet(context);
//                             },
//                             child: Container(
//                               height: 80.0,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[500],
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                   image: DecorationImage(
//                                     image: imageFile == null
//                                         ? AssetImage(imgPath)
//                                         : FileImage(imageFile),
//                                     fit: BoxFit.cover,
//
//                                   )),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.add,
//                                       color: Colors.grey[500],),
//                                     Text(
//                                       'Upload Image',
//                                       style: TextStyle(
//                                           fontSize: 18.0,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.grey[500]
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Form(
//                           key: formKey,
//                           child: Column(
//                             children: [
//                               commonTextFields('Name', nameController, TextInputType.text),
//                               commonTextFields(
//                                   'Email', emailController, TextInputType.emailAddress),
//                               commonTextFields(
//                                   'Phone Number', phoneController, TextInputType.number),
//                               commonTextFields(
//                                   'Quantity', qtyController, TextInputType.number),
//                               commonTextFields(
//                                   'Location', locationController, TextInputType.text),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
//
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     smallField('Height', heightController,
//                                         TextInputType.number, 0, 5),
//                                     smallField('Width', widthController,
//                                         TextInputType.number, 5, 5),
//                                     smallField('Length', lengthController,
//                                         TextInputType.number, 5, 0),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 20.0),
//                           child: Container(
//                             width: 200.0,
//                             child: RaisedButton(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(18.0),
//                                   side: BorderSide(color: const Color(0xff407e72))),
//                               onPressed: () {
//                                 submitData();
//                               },
//                               color: const Color(0xff407e72),
//                               textColor: Colors.white,
//                               child: Text("Submit", style: TextStyle(fontSize: 14)),
//                             ),
//                           ),
//                         ),
// //                      Padding(
// //                        padding: const EdgeInsets.only(bottom: 50.0, top: 10.0),
// //                        child: Container(
// //                          width: 200.0,
// //                          child: RaisedButton(
// //                            shape: RoundedRectangleBorder(
// //                                borderRadius: BorderRadius.circular(18.0),
// //                                side: BorderSide(color: const Color(0xff407e72))),
// //                            onPressed: () {
// //                              Navigator.push(
// //                                  context,
// //                                  MaterialPageRoute(
// //                                      builder: (context) => AlbumList()));
// //                            },
// //                            color: const Color(0xff407e72),
// //                            textColor: Colors.white,
// //                            child: Text("Gallery", style: TextStyle(fontSize: 14)),
// //                          ),
// //                        ),
// //                      ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0.0,
//                 left: 0.0,
//                 right: 0.0,
//                 child: BottomAppBar(
//                   child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             height: 44,
//                             child: Material(
//                               type: MaterialType.transparency,
//                               child: InkWell(
//                                 onTap: () {
//                                   goToAlbum();
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text("Gallery",
//                                       style: TextStyle(
//                                           fontSize: 20.0,
//                                           fontWeight: FontWeight.w800
//                                       ),),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 10.0),
//                                       child: Icon(Icons.image, color: Colors.blue, size: 24),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//   }
//
// }