import 'dart:async';

import 'package:flash_web/common/color.dart';
import 'package:flash_web/config/service_config.dart';
import 'package:flash_web/generated/l10n.dart';
import 'package:flash_web/model/tron_info_model.dart';
import 'package:flash_web/provider/common_provider.dart';
import 'package:flash_web/provider/index_provider.dart';
import 'package:flash_web/router/application.dart';
import 'package:flash_web/service/method_service.dart';
import 'package:flash_web/util/common_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';

class WalletWapPage extends StatefulWidget {
  @override
  _WalletWapPageState createState() => _WalletWapPageState();
}

class _WalletWapPageState extends State<WalletWapPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _account = '';
  bool _tronFlag = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(3);
      });
    }
    Provider.of<IndexProvider>(context, listen: false).init();
    _getTronInfo();
    _reloadAccount();
  }

  @override
  void dispose() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    bool langType = Provider.of<IndexProvider>(context, listen: true).langType;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.white,
      appBar: _appBarWidget(context),
      drawer: _drawerWidget(context),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _mainWidget(context),
        ],
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      width: ScreenUtil().setWidth(750),
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          _topWidget(context),
          SizedBox(height: ScreenUtil().setHeight(30)),
          _tronInfo != null ? _androidDownloadWidget(context) : Container(),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _tronInfo != null ? _picWidget(context) : Container(),
        ],
      ),
    );
  }

  Widget _topWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: MyColors.themeColorWap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Flash  Wallet',
                      style: Util.textStyle4WapEn(context, 1, Colors.white,
                          spacing: 0.0, size: 40),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    child: Text(
                      '${S.of(context).walletTips01}',
                      style: Util.textStyle4Wap(context, 2, Colors.white,
                          spacing: 0.0, size: 22),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _androidDownloadWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              launch('${_tronInfo.androidDownloadUrl}').catchError((error) {});
            },
            child: Container(
              child: Chip(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(18),
                    top: ScreenUtil().setHeight(22),
                    right: ScreenUtil().setWidth(18),
                    bottom: ScreenUtil().setHeight(22)),
                backgroundColor: MyColors.themeColorWap,
                label: Text(
                  'Android ${S.of(context).walletDownload}',
                  style: Util.textStyle4WapEn(context, 1, Colors.white,
                      spacing: 0.0, size: 30),
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Container(
            child: Text(
              'V${_tronInfo.androidVersionNum} ${S.of(context).walletVersion}',
              style: Util.textStyle4WapEn(context, 1, Colors.grey[850],
                  spacing: 0.0, size: 28),
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _picWidget(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'images/app-01.png',
              fit: BoxFit.contain,
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setWidth(700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.lightBg,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Image.asset('images/logo150.png',
            fit: BoxFit.contain,
            width: ScreenUtil().setWidth(110),
            height: ScreenUtil().setWidth(110)),
      ),
      leading: IconButton(
        hoverColor: MyColors.white,
        icon: Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
          child: Icon(Icons.menu,
              size: ScreenUtil().setWidth(55), color: Colors.grey[800]),
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      centerTitle: true,
    );
  }

  Widget _drawerWidget(BuildContext context) {
    int _homeIndex = CommonProvider.homeIndex;
    return Drawer(
      child: Container(
        color: MyColors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text(
                '${S.of(context).actionTitle0}',
                style: Util.textStyle4Wap(context, 2,
                    _homeIndex == 0 ? Colors.black : Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(0);
                });
                Application.router.navigateTo(context, 'wap/swap',
                    transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.donut_small,
                color: _homeIndex == 0 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle2}',
                style: Util.textStyle4Wap(context, 2,
                    _homeIndex == 2 ? Colors.black : Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(2);
                });
                Application.router.navigateTo(context, 'wap/lend',
                    transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.broken_image,
                color: _homeIndex == 2 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle3}',
                style: Util.textStyle4Wap(context, 2,
                    _homeIndex == 3 ? Colors.black : Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(3);
                });
                Application.router.navigateTo(context, 'wap/wallet',
                    transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.account_balance_wallet,
                color: _homeIndex == 3 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                '${S.of(context).actionTitle4}',
                style: Util.textStyle4Wap(context, 2,
                    _homeIndex == 4 ? Colors.black : Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                setState(() {
                  CommonProvider.changeHomeIndex(4);
                });
                Application.router.navigateTo(context, 'wap/about',
                    transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.file_copy_sharp,
                color: _homeIndex == 4 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                _account == ''
                    ? '${S.of(context).connectAccount}'
                    : _account.substring(0, 4) +
                        '...' +
                        _account.substring(
                            _account.length - 4, _account.length),
                style: Util.textStyle4Wap(context, 2, Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {},
              leading: Icon(
                Icons.account_circle,
                color: Colors.grey[700],
              ),
            ),
            ListTile(
              title: Text(
                'English/中文',
                style: Util.textStyle4Wap(context, 2, Colors.grey[700],
                    spacing: 0.0, size: 32),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Provider.of<IndexProvider>(context, listen: false)
                    .changeLangType();
                Navigator.pop(context);
                Util.showToast4Wap(S.of(context).success, timeValue: 2);
              },
              leading: Icon(
                Icons.language,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TronInfo _tronInfo;

  TronInfo get tronInfo => _tronInfo;

  _getTronInfo() async {
    try {
      String url = servicePath['tronInfoQuery'];
      await requestGet(url).then((val) {
        var respData = Map<String, dynamic>.from(val);
        TronInfoRespModel respModel = TronInfoRespModel.fromJson(respData);
        if (respModel != null &&
            respModel.code == 0 &&
            respModel.data != null) {
          if (respModel.data.tronInfo != null) {
            if (mounted) {
              setState(() {
                _tronInfo = respModel.data.tronInfo;
              });
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  bool _reloadAccountFlag = false;

  _reloadAccount() async {
    _getAccount();
    _timer = Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (_reloadAccountFlag) {
        _getAccount();
      }
    });
  }

  _getAccount() async {
    _reloadAccountFlag = false;
    _tronFlag = js.context.hasProperty('tronWeb');
    if (_tronFlag) {
      var result = js.context["tronWeb"]["defaultAddress"]["base58"];
      if (result.toString() != 'false' && result.toString() != _account) {
        if (mounted) {
          setState(() {
            _account = result.toString();
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _account = '';
        });
      }
    }
    _reloadAccountFlag = true;
  }
}
