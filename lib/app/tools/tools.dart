
import 'package:get/get.dart';
import 'package:naoty/app/widgets/loading_dialog.dart';

const tokenBox = "token";
const userBox = "username";

showLoadingDialog() {
  return Get.dialog(LoadingDialog(color: Get.theme.primaryColor,), barrierDismissible: false);
}

closeLoadingDialog() {
  if(Get.isDialogOpen!) Get.back();
}