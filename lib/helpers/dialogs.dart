import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commom/ui/gamerzRaisedButton.dart';

class CustomDialogs {
  successDialog({
    required title,
    required context,
    required content,
    required animation,
    required action,
    required actionText,
  }) {
    Get.dialog(
      // title: "",
      // titleStyle: TextStyle(height: 0, fontSize: 1),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: new Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: modalContent(
                  context, title, content, actionText, animation, action)
              // Container(
              //     height: 420,
              //     padding: EdgeInsets.symmetric(horizontal: 10),
              //     // height: 500,
              //     child: Column(children: [
              //       Container(
              //           child: Column(
              //         children: [
              //           SizedBox(height: 10),
              //           Lottie.asset(
              //             '$animation',
              //             width: 125,
              //             height: 125,
              //             fit: BoxFit.fill,
              //           ),
              //           SizedBox(height: 20),
              //           Text('$title',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color: Color(0xff333333),
              //                   fontSize: 20)),
              //           SizedBox(height: 10),
              //           Text('$content',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color: Color(0xff888888),
              //                   fontSize: 18)),
              //           SizedBox(height: 20),
              //         ],
              //       )),
              //       SizedBox(
              //         height: 35,
              //         width: MediaQuery.of(context).size.width * 0.4,
              //         child: SWbutton(title: '$actionText', onPressed: action),
              //       )
              //     ]))
              )),
      barrierDismissible: false,
    );
  }

  Widget modalContent(context, title, descriptions, actionText, image, action) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Color.fromARGB(255, 80, 80, 80)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: GamerzElevatedButton(
                        label: '$actionText', onPressed: action)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  showDialogModal(
      {required context,
      required title,
      required content,
      required okayAction,
      required declineAction}) async {
    return (await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: new AlertDialog(
          title: new Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: new Text(
            content,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          actions: <Widget>[
            TextButton(
              child: new Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: okayAction,
            ),
            TextButton(
              child: new Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: declineAction,
            ),
          ],
        ),
      ),
    ));
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
