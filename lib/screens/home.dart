import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import 'restaurant_list.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final String zip_url="https://ordertopshelf.com/dev/topself_api/api/post/current_zip";
  final String cuisine_list_url = "https://ordertopshelf.com/dev/topself_api/api/post/cuisine_data";
  List data = List();
  String rest_name,zip,itemname,cusine_id,distance;
  var displayResult = '';
  final _minimumPadding=5.0;
  String _currentItemSelected;

  TextEditingController zipCodeControlled = TextEditingController();
  TextEditingController restaurantNameControlled = TextEditingController();
  TextEditingController itemNameControlled = TextEditingController();
  TextEditingController distanceControlled = TextEditingController();


  bool switching_val=false;
  onSwitchValChanged(bool newSwitchVal){

    setState(() {
      switching_val=newSwitchVal;
    });

    if(switching_val){
      this.getuser_Location();
    }else{
      zipCodeControlled.text = "200" ;
    }

  }

  Future<String> getJsonData() async {

    var response = await http.post(Uri.encodeFull(cuisine_list_url), headers: {"Accept": "application/json"});

    setState(() {
      data = json.decode(response.body);
    });
    print(data);
    return "success";
  }

  @override
  initState(){
    super.initState();
    this.getJsonData();

  }


  @override
  Widget build(BuildContext context) {



    TextStyle textStyle=Theme.of(context).textTheme.title;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(_minimumPadding*10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50,bottom: 50),
              child: Text("SEARCH RESTAURANT",textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Switch(value: switching_val,
                      onChanged: (newSwitchVal){
                        onSwitchValChanged(newSwitchVal);
                  }),
                  Container(
                      width: 263,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: distanceControlled,
                        decoration: InputDecoration(
                          labelText: "Distance",
                          hintText: "In Miles",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),

                ],

              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: _minimumPadding ,bottom: _minimumPadding),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: zipCodeControlled,
                  decoration: InputDecoration(
                    labelText: "Zip Code",
                    hintText: "Enter Zip Code",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: _minimumPadding , bottom: _minimumPadding),
              child: TextField(
                keyboardType: TextInputType.text,
                style: textStyle,
                controller: restaurantNameControlled,
                decoration: InputDecoration(
                  labelText: "Rest. Name",
                  hintText: "Enter Restaurant Name",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: _minimumPadding , bottom: _minimumPadding),
              child: TextField(
                keyboardType: TextInputType.text,
                style: textStyle,
                controller: itemNameControlled,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  hintText: "Enter Item Name",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                items: data.map((item){
                    return DropdownMenuItem<String>(
                    value: item['cuisine_id'],
                    child: new Text(item['cuisine_name']),
                  );
                }).toList(),

                onChanged: (newValueSelected){
                  setState(() {
                    _currentItemSelected =newValueSelected;
                  });

                },
                value: _currentItemSelected,
              ),
            ),

            RaisedButton(
              child: Text('Search'),
              color: Theme.of(context).accentColor,
              onPressed: (){
                setState(() {
                  rest_name = restaurantNameControlled.text.toString();
                  zip = zipCodeControlled.text.toString();
                  itemname = itemNameControlled.text.toString();
                  cusine_id = _currentItemSelected.toString();
                  distance = distanceControlled.text.toString();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>Restaurant_list(rest_name:rest_name,zip:zip,itemname:itemname,cusine_id:cusine_id,distance:distance),
                  ));
                 // _searchResult(rest_name,zip,itemname,cusine_id);
                });
              },
            )
          ],
        ),
      ),
    );


  }
  getuser_Location() async {

   var zip_data = null;
   Position position = await Geolocator().getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
   var latitude = position.latitude;
   var longitude = position.longitude;

     Map data2={
       "latitude":latitude,
       "longitude":longitude,
     };

     String position_body = json.encode(data2);
     var response = await http.post(Uri.encodeFull(zip_url),
         body: position_body, headers: {"Accept": "Application/json"});
     setState(() {
       zip_data = json.decode(response.body);
     });
   zipCodeControlled.text = zip_data ;

     print(zip_data);
     return "success";


  }

//  _searchResult(rest_name,zip,itemname,cusine_id)async{
//  var restaurant_name='';
//  var zip_code='';
//  var menu_item_name='';
//  var cuisine_id='';
//
//    restaurant_name=rest_name;
//    zip_code=zip;
//    menu_item_name=itemname;
//    cuisine_id=cusine_id;
//
////  if(restaurant_name==''){
////    restaurant_name='0';
////  }
////  if(zip_code==''){
////    zip_code='0';
////  }
////  if(menu_item_name==''){
////    menu_item_name='0';
////  }
//  if(cuisine_id=='null'){
//    cuisine_id='0';
//  }
//
//  Map data2={
//    "restaurant_name":restaurant_name,
//    "zip":zip_code,
//    "menu_item_name":menu_item_name,
//    "service_type":'CO',
//    "cuisine_id":cuisine_id
//  };
//  String body = json.encode(data2);
// print(body);
//  var jsonResponse2 = null;
//  var response2 = await http.post("https://ordertopshelf.com/dev/topself_api/api/post/restaurant", body: body, headers: {"Content-Type": "application/json"},);
//  if(response2.statusCode == 200) {
//    jsonResponse2 = json.decode(response2.body);
//    print(jsonResponse2);
//
//  }
//
//  }
}
