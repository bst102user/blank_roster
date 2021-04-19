import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeeAllPhotos extends StatefulWidget{
  final List<String> allPicks;
  SeeAllPhotos(this.allPicks);
  SeeAllPhotosState createState() => SeeAllPhotosState();
}

class SeeAllPhotosState extends State<SeeAllPhotos>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.allPicks[0]);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: CommonVar.app_theme_color, //change your color here
        ),
        title: Text(
          'All Pictures',
          style: TextStyle(
              color: CommonVar.app_theme_color
          ),),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            (widget.allPicks[0]=='')?Container():Container(
              width: MediaQuery.of(context).size.width,
              height: 225,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(AppApis.IMAGE_BASE_URL+widget.allPicks[0]),
                ),
              ),
            ),
            (widget.allPicks[1]=='')?Container():Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 225,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(AppApis.IMAGE_BASE_URL+widget.allPicks[1]),
                  ),
                ),
              ),
            ),
            (widget.allPicks[2]=='')?Container():Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                AppApis.IMAGE_BASE_URL+widget.allPicks[2],
                height: 200,
              ),
            )
          ],
        ),
      ),
    );
  }

}