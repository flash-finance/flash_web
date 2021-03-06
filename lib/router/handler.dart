import 'package:flash_web/page/pc/about_pc_page.dart';
import 'package:flash_web/page/pc/lend_pc_page.dart';
import 'package:flash_web/page/pc/swap_pc_page.dart';
import 'package:flash_web/page/pc/farm_pc_page.dart';
import 'package:flash_web/page/pc/wallet_pc_page.dart';
import 'package:flash_web/page/wap/about_wap_page.dart';
import 'package:flash_web/page/wap/lend_wap_page.dart';
import 'package:flash_web/page/wap/swap_wap_page.dart';
import 'package:flash_web/page/wap/farm_wap_page.dart';
import 'package:flash_web/page/wap/wallet_wap_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Handler farmPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return FarmPcPage();
});

Handler swapPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SwapPcPage();
});

Handler lendPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LendPcPage();
});

Handler walletPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return WalletPcPage();
});

Handler aboutPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return AboutPcPage();
});


Handler farmWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return FarmWapPage();
});

Handler swapWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SwapWapPage();
});

Handler lendWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LendWapPage();
});

Handler walletWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return WalletWapPage();
});

Handler aboutWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return AboutWapPage();
});