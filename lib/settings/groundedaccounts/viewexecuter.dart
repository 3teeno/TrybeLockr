import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/accountexecutorlist/executor_list_param.dart';
import 'package:trybelocker/model/accountexecutorlist/executor_list_response.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/accountexecutor_viewmodel.dart';

import '../../UniversalFunctions.dart';

class ViewExecuterScreen extends StatefulWidget {
  static const String TAG = "/view_Executer";

  @override
  ViewExecuterScreenState createState() => ViewExecuterScreenState();
}

class ViewExecuterScreenState extends State<ViewExecuterScreen> {
  List<UserData> groundAcctslist = [];
  AccountExecutorViewModel _accountViewModel;
  bool isDataLoaded = false;
  bool isnearpostLoading = false;
  int currentPage = 1;
  int limit = 10;
  bool allnearPost = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      getlist();
    });
  }

  void getlist() {
    isDataLoaded = false;
    isnearpostLoading = false;
    currentPage = 1;
    allnearPost = false;
    if (isnearpostLoading == false && allnearPost == false) {
      setState(() {
        isnearpostLoading = true;
      });
      getacceptedexecutorlist(true, currentPage);
    }
  }

  void getacceptedexecutorlist(bool isClear, int currentPage) async {
    ExecutorListParam request = new ExecutorListParam();
    request.uid = MemoryManagement.getuserId();

    var response =
        await _accountViewModel.requestedexecutorlist(request, context);
    ExecutorListResponse executorListResponse = response;
    if (isClear == true) {
      groundAcctslist.clear();
    }
    isDataLoaded = true;
    if (executorListResponse != null &&
        executorListResponse.userData != null &&
        executorListResponse.userData.length > 0) {
      if (executorListResponse.userData.length < limit) {
        allnearPost = true;
        isnearpostLoading = false;
      }
      if (executorListResponse != null) {
        if (executorListResponse.status != null &&
            executorListResponse.status.isNotEmpty) {
          if (executorListResponse.status.compareTo("success") == 0) {
            groundAcctslist.addAll(executorListResponse.userData);





            if (MemoryManagement.getsaveotheraccounts() != null) {
              UserDetails userDetail = new UserDetails.fromJson(
                  jsonDecode(MemoryManagement.getsaveotheraccounts()));

                UserDetail data=userDetail.userDetails.firstWhere((element) => element.userid==groundAcctslist[0].id.toString(),orElse:() => null);
                print("heheh${json.encode(userDetail.userDetails)}");
                if(data==null){
                  UserDetail userdetail = new UserDetail();

                  userdetail.email = "";
                  userdetail.phonenumber = "";
                  userdetail.password = "";
                  userdetail.userimage =
                      groundAcctslist[0].userImage.trim();
                  userdetail.userid =
                      groundAcctslist[0].id.toString();
                  userdetail.username =
                      groundAcctslist[0].username.trim();
                  userdetail.logintype = MemoryManagement.getlogintype();
                  userDetail.userDetails.add(userdetail);

                  MemoryManagement.setsaveotheraccounts(userDetails: json.encode(userDetail));
                }


            }





            setState(() {});
          } else {}
        }
      }
      setState(() {
        isnearpostLoading = false;
      });
    } else {
      allnearPost = true;
      setState(() {
        isnearpostLoading = false;
      });
    }
  }


  getListUserId(UserDetail userdetail){


  }

  @override
  Widget build(BuildContext context) {
    _accountViewModel = Provider.of<AccountExecutorViewModel>(context);

    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Settings",
          ),
          backgroundColor: getColorFromHex(AppColors.black),
        ),
        body: Stack(
          children: <Widget>[
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                settingsHeader(
                    'Executor Accounts', MemoryManagement.getuserprofilepic()),
                NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      if (isnearpostLoading == false &&
                          allnearPost == false &&
                          scroll.metrics.pixels ==
                              scroll.metrics.maxScrollExtent) {
                        setState(() {
                          // _recentUserPostViewModel.setLoading();
                          isnearpostLoading = true;
                          currentPage++;
                          getacceptedexecutorlist(false, currentPage);
                        });
                      }
                      return;
                    },
                    child: Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: groundAcctslist.length,
                            itemBuilder: (context, i) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        /* Navigator.of(context, rootNavigator: false)
                                            .push(MaterialPageRoute(builder: (context) => DeleteExecutorScreen(groundAcctslist[i]))).then((value){
                                          getlist();
                                        });*/
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                            width: 50,
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                left: 10,
                                                top: 2,
                                                bottom: 2,
                                                right: 2),
                                            child: ClipOval(
                                              child: getprofilepic(i),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            groundAcctslist[i].username,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                ],
                              );
                            })))
              ],
            )),
            getFullScreenProviderLoader(
                status: _accountViewModel.getLoading(), context: context)
          ],
        ));
  }

  getprofilepic(int index) {
    if (groundAcctslist[index].userImage != null &&
        groundAcctslist[index].userImage.isNotEmpty) {
      if (groundAcctslist[index].userImage.contains("https") ||
          groundAcctslist[index].userImage.contains("http")) {
        return getCachedNetworkImage(
            url: groundAcctslist[index].userImage, fit: BoxFit.cover);
      } else {
        return getCachedNetworkImage(
            url: APIs.userprofilebaseurl + groundAcctslist[index].userImage,
            fit: BoxFit.cover);
      }
    } else {
      return getCachedNetworkImage(
          url:
              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
          fit: BoxFit.cover);
    }
  }
}
