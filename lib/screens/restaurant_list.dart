import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';


class Restaurant_list extends StatefulWidget {
  String rest_name,zip,itemname,cusine_id,distance;
  Restaurant_list({this.rest_name,this.zip,this.itemname,this.cusine_id,this.distance});
  @override
  _Restaurant_listState createState() => _Restaurant_listState(rest_name,zip,itemname,cusine_id,distance);


}

class _Restaurant_listState extends State<Restaurant_list> {
  String rest_name,zip,itemname,cusine_id,distance;
  _Restaurant_listState(this.rest_name,this.zip,this.itemname,this.cusine_id,this.distance);

  final String restaurant_list_url =
      "https://ordertopshelf.com/dev/topself_api/api/post/restaurant";
  List data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {


       var restaurant_name=rest_name;
       var zip_code=zip;
       var menu_item_name=itemname;
       var cuisine_id=cusine_id;
       var rest_distance = distance;

      if(cuisine_id=='null'){
      cuisine_id='0';
    }

    Map data2={
    "restaurant_name":restaurant_name,
    "zip":zip_code,
    "menu_item_name":menu_item_name,
    "service_type":'CO',
    "cuisine_id":cuisine_id,
    "distance":rest_distance
  };
      String body2 = json.encode(data2);
    var response = await http.post(Uri.encodeFull(restaurant_list_url),
        body: body2, headers: {"Accept": "Application/json"});

    setState(() {
      data = json.decode(response.body);
    });
    print(body2);
    /*array('class_id'=>$class_id, 'section_id'=>$section_id,'class_name'=>$class,'section_name'=>$section );*/
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          /*  decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.brown, Colors.orange,Colors.white])),*/
          child: data != null
              ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              var rest_data = data[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10.0,
                  child: ListTile(

                    title: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                "${rest_data["logo"]}",
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),

                        Text(
                          "${rest_data["name"]}",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${rest_data["address"]}",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    RaisedButton(
                     child: Text("Explore"),
                     color: Theme.of(context).accentColor,
                      onPressed: (){},
                  ),

                      ],
                    ),

                  ),
                ),
              );
            },
          )
              : CircularProgressIndicator(
            backgroundColor: Colors.red,
          ),
        ),
      ),

    );
  }
}
