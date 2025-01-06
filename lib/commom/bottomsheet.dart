import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../helpers/sizeManager.dart';

bottomSheetPopUp(
    {@required Widget? child,
    BuildContext? ctx,
    Color? color,
    dynamic height,
    bool enableDrag = false,
    bool isDismissible = false}) {
  return showCupertinoModalBottomSheet(
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      context: ctx as BuildContext,
      expand: false,
      elevation: 0,
      isDismissible: isDismissible,
      topRadius: const Radius.circular(30),
      builder: (context) {
        SizeManager sizeManager = SizeManager(context);
        return SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Container(
                height: height ?? MediaQuery.of(context).size.height * 0.5,
                padding: MediaQuery.of(context).viewInsets,
                child: Align(alignment: Alignment.bottomCenter, child: child)));
      });
}
