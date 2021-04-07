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
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
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
                (widget.allPicks[0]=='')?Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      widget.allPicks[0],
                    height: 200,
                  ),
                ),
                (widget.allPicks[1]=='')?Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.allPicks[1],
                    height: 200,
                  ),
                ),
                (widget.allPicks[2]=='')?Container():Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.allPicks[2],
                    height: 200,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}