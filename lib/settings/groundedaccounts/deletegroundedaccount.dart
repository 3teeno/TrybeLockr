import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_account_listparams.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_password_reset.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/groundedAccount_viewmodel.dart';

import 'package:provider/src/provider.dart';

class DeleteGroundedAccScreen extends StatefulWidget {
static const String TAG = "/deletegroundacc";

  @override
  DeleteGroundedAccScreenState createState() => DeleteGroundedAccScreenState();
}

class DeleteGroundedAccScreenState extends State<DeleteGroundedAccScreen> {
  List<Data> groundAcctslist = [];
  GroundedAccountViewModel _accountViewModel;
  bool isDataLoaded = false;
  bool isnearpostLoading = false;
  int currentPage = 1;
  int limit = 10;
  bool allnearPost = false;
  @override
  void initState() {

    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      getaccounts();
    });
  }

  void getaccounts() {
    isDataLoaded = false;
    isnearpostLoading = false;
    currentPage = 1;
    allnearPost = false;
    _accountViewModel.setLoading();
    if (isnearpostLoading == false && allnearPost == false) {
      setState(() {
        isnearpostLoading = true;
      });
      getgroundedaccount(true, currentPage);
    }
  }

  void getgroundedaccount(bool isClear, int currentPage) async {
    GroundedAccountListparams request = GroundedAccountListparams();
    request.uid = MemoryManagement.getuserId();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _accountViewModel.groundedaccountlist(request, context);
    GroundedAccountlistResponse accountlistResponse = response;
    if (isClear == true) {
      groundAcctslist.clear();
    }
    isDataLoaded = true;
    if (accountlistResponse != null &&
        accountlistResponse.accountsData.data != null &&
        accountlistResponse.accountsData.data.length > 0) {
      if (accountlistResponse.accountsData.data.length < limit) {
        allnearPost = true;
        isnearpostLoading = false;
      }
      if (accountlistResponse != null) {
        if (accountlistResponse.status != null &&
            accountlistResponse.status.isNotEmpty) {
          if (accountlistResponse.status.compareTo("success") == 0) {
            groundAcctslist.addAll(accountlistResponse.accountsData.data);

            setState(() {
            });
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

  @override
  Widget build(BuildContext context) {

    _accountViewModel = Provider.of<GroundedAccountViewModel>(context);

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
                    settingsHeader('Delete Accounts',MemoryManagement.getuserprofilepic()),
                    NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scroll) {
                          if (isnearpostLoading == false &&
                              allnearPost == false &&
                              scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                            setState(() {
                              // _recentUserPostViewModel.setLoading();
                              isnearpostLoading = true;
                              currentPage++;
                              getgroundedaccount(false, currentPage);
                            });
                          }
                          return;
                        },
                        child:
                        Expanded(child:ListView.builder(
                            shrinkWrap: true,
                            itemCount: groundAcctslist.length,
                            itemBuilder: (context, i) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {

                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                            width: 50,
                                            height: 50,
                                            margin: EdgeInsets.only(left: 10,top: 2,bottom: 2,right: 2),
                                            child:  ClipOval(
                                              child:getprofilepic(i),
                                            ),

                                          ),SizedBox(
                                            width: 20,
                                          ),
                                          Text(groundAcctslist[i].username,style: TextStyle(color: Colors.white),),
                                          Spacer(),
                                          InkWell(onTap: (){
                                            deletaccountmethod(groundAcctslist[i]);
                                          },
                                          child:
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: getColorFromHex(AppColors.red),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            padding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                                            child: Text("Delete",style: TextStyle(color: Colors.white),),
                                          ))
                                        ],
                                      )
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                ],
                              );
                            })))
                  ],
                )),
            getFullScreenProviderLoader(status: _accountViewModel.getLoading(), context: context)
          ],
        ));
  }

  getprofilepic(int index) {
    if (groundAcctslist[index].userImage != null &&
        groundAcctslist[index].userImage.isNotEmpty) {
      if (groundAcctslist[index].userImage.contains("https") ||
          groundAcctslist[index].userImage.contains("http")) {
        return getCachedNetworkImage(url:groundAcctslist[index].userImage,fit: BoxFit.cover);
      } else {
        return getCachedNetworkImage(
            url:APIs.userprofilebaseurl + groundAcctslist[index].userImage,fit: BoxFit.cover);
      }
    } else {
      return getCachedNetworkImage(url:
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover);
    }
  }
  deletaccountmethod(Data groundAccts) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete an account?'),
          content: Text('Do you want to delete an Account'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(true);
                  deleteuseraccount(groundAccts.id);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void deleteuseraccount(int id) async {
    _accountViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _accountViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Deleteuseraccparams params = new Deleteuseraccparams(uid: id.toString());
      var response = await _accountViewModel.deleteuseraccount(params, context);
      DeleteuseraccResponse deleteuseraccResponse = response;
      if (deleteuseraccResponse.status.compareTo("success") == 0) {
        displaytoast("Sucessfully Deleted", context);
        getaccounts();
      } else {
        displaytoast("Failed to delete the account", context);
      }
    }
  }
}
