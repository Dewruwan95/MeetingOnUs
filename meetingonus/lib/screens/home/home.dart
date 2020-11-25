import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:splashscreen/splashscreen.dart';

Stream meetings = FirebaseFirestore.instance.collection('Meetings').snapshots();

class MeetingList extends StatefulWidget {
  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  Future<void> loadData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting List'),
      ),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            color: Colors.green,
          );
        },
      ),
    );
  }
}

class MyStream extends StatefulWidget {
  @override
  _MyStreamState createState() => _MyStreamState();
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class _MyStreamState extends State<MyStream> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: meetings,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data.documents.length > 0) {
              return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 10.0,
                          color: prefix0.bgGrey,
                        ),
                        InkWell(
                          onTap: () {
                            //--------------------------------------------------------------------
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.3,
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              height: 80.0,
                              color: Colors.white,
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${snapshot.data.documents[index]['schedule_date'].split("-")[1].split(" ")[2]} "
                                      "${snapshot.data.documents[index]['schedule_date'].split("-")[1].split(" ")[3]}",
                                      style: textStyleOrangeSS(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        snapshot.data
                                            .documents[index]['schedule_date']
                                            .split("-")[0],
                                        style: subTitleDarkSS(),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  snapshot.data.documents[index]
                                      ['meeting_title'],
                                  style: subTitle(),
                                ),
                                subtitle: Text(
                                  snapshot.data.documents[index]['user_name'],
                                  style: smallAddressSS(),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              Container(
                                color: orange,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      //taskCompleted = true;
                                    });
                                    // crudObj.updateData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId, {
                                    //   'completed': this.taskCompleted,
                                    // });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                          "lib/assets/icon/checked.png"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Completed",
                                          style: subTitleWhite2SansRegular(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            secondaryActions: <Widget>[
                              Container(
                                color: primary,
                                child: InkWell(
                                  onTap: () {
                                    //--------------------------------------------------------------------------------------------
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.pencilAlt,
                                          size: 18.0, color: Colors.white),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Edit",
                                          style: subTitleWhite2SansRegular(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: primary,
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      // crudObj.deleteData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId,);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (BuildContext context) => Landing(
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                            "lib/assets/icon/delete.png"),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            "Delete",
                                            style: subTitleWhite2SansRegular(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Column(
                children: <Widget>[Text("my list")],
              );
            }
          }),
    );
  }
}

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: meetings,
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map<Widget>((document) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 10.0,
                      color: prefix0.bgGrey,
                    ),
                    InkWell(
                      onTap: () {
                        //--------------------------------------------------------------------
                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.3,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 80.0,
                          color: Colors.white,
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${document['user_name']}",
                                  style: textStyleOrangeSS(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "${document['schedule_time']}",
                                    style: subTitleDarkSS(),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                             "${document['meeting_title']}",
                              style: subTitle(),
                            ),
                            subtitle: Text(
                              "${document['user_name']}",
                              style: smallAddressSS(),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            color: orange,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  //taskCompleted = true;
                                });
                                // crudObj.updateData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId, {
                                //   'completed': this.taskCompleted,
                                // });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      "lib/assets/icon/checked.png"),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 7.0),
                                    child: Text(
                                      "Completed",
                                      style: subTitleWhite2SansRegular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        secondaryActions: <Widget>[
                          Container(
                            color: primary,
                            child: InkWell(
                              onTap: () {
                                //--------------------------------------------------------------------------------------------
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.pencilAlt,
                                      size: 18.0, color: Colors.white),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 7.0),
                                    child: Text(
                                      "Edit",
                                      style: subTitleWhite2SansRegular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: primary,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  // crudObj.deleteData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId,);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) => Landing(
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                        "lib/assets/icon/delete.png"),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        "Delete",
                                        style: subTitleWhite2SansRegular(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                //   Center(
                //   child: Container(
                //     width: 70.0,
                //     height: 50.0,
                //     child: Text("Title :" + document['meeting_title']),
                //   ),
                // )
                ;
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
