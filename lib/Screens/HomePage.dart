import 'package:api_movies/Provider/Main_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model Class/MovieModel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Main_Provider provider = Provider.of<Main_Provider>(context, listen: false);


    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<Main_Provider>(
                  builder: (context1, value, child) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: value.Movienamecontroller,
                          decoration: const InputDecoration(
                            //suffix: Icon(Icons.search),

                            isDense: true,
                            hintText: 'MOVIE NAME',
                            // hintStyle: GoogleFonts.karma(textStyle:
                            hintStyle: TextStyle(color: Colors.grey,),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            filled: true,
                            fillColor: Colors.blueGrey,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff668698))),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff668698))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff668698))),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        SizedBox(height: 10,),
                        MaterialButton(
                            onPressed: ()
                            {
                              value.page = 1;
                               provider.get_api(value.Movienamecontroller.text,value.page);
                              //print(value.api_picList);
                              },
                          child: Text("SEARCH",style: TextStyle(color: Colors.white)),
                            color: Colors.blue

                        )
                      ],
                    );
                  }
                ),
                Consumer<Main_Provider>(
                  builder: (context2, value, child) {
                    return SizedBox(
                      height: height/1.5,
                      child: value.api_picList.isNotEmpty?
                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 3
                          ),
                          itemCount: value.api_picList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                              Card(
                              //color: Colors.blueGrey,
                              child: value.api_picList[index].photo != "null" ?
                              Image.network("https://image.tmdb.org/t/p/w780/${value.api_picList[index].photo}",fit: BoxFit.fill,):
                                Icon(Icons.camera_alt_outlined),
                            );

                          }
                      ): SizedBox()
                    );
                  }
                ),
                SizedBox(height: 5,),
                Consumer<Main_Provider>(
                    builder: (context4, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        value.CURRENT_page>0?
                        Icon(Icons.arrow_back_ios,color: Colors.blueGrey,):SizedBox(),
                        Container(
                          height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
                          child: Text(value.CURRENT_page.toString()),
                        ),
                        Icon(Icons.arrow_forward_ios,color: Colors.blueGrey,),
                      ],
                    );
                  }
                ),
                SizedBox(height: 10,),
                Consumer<Main_Provider>(
                    builder: (context3, value, child) {
                    return value.api_picList.isNotEmpty?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            onPressed: ()
                            {
                              if(value.page>0)
                              {
                                value.page--;
                                provider.get_api(value.Movienamecontroller.text, value.page);
                              }
                              //print(value.api_picList);
                            },
                            child: Text("BACK",style: TextStyle(color: Colors.white)),color: Colors.grey
                        ),
                        SizedBox(width: 10,),
                        MaterialButton(
                            onPressed: ()
                            {
                              print("page = ${value.page}");
                              value.page++;
                              provider.get_api(value.Movienamecontroller.text,value.page);
                              //print(value.api_picList);
                            },
                            child: Text("NEXT",style: TextStyle(color: Colors.white)),color: Colors.grey
                        ),
                      ],
                    ): SizedBox();
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
