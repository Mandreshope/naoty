import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naoty/app/data/models/note_model.dart';
import 'package:naoty/app/data/repositories/note_repository.dart';
import 'package:naoty/app/modules/home/home_controller.dart';
import 'package:naoty/app/tools/tools.dart';
import 'package:naoty/app/widgets/alert_popup.dart';
import 'package:naoty/app/widgets/confirm_dialog.dart';

class EditorController extends GetxController {
  final NoteRepository repository;
  EditorController({required this.repository});

  TextEditingController contentController = TextEditingController();

  NoteModel? note = Get.find<HomeController>().note;
  var user = GetStorage().read(userBox);

  RxBool _isBtnSaveEnabled = false.obs;
  bool get isBtnSaveEnabled => this._isBtnSaveEnabled.value;
  set isBtnSaveEnabled(value) => this._isBtnSaveEnabled.value = value;

  @override
  void onInit() {
    loadNote();
    checkFieldIsEmpty();
    super.onInit();
  }

  checkFieldIsEmpty() {
    if (contentController.text.trim() == "") {
      isBtnSaveEnabled = false;
    } else {
      isBtnSaveEnabled = true;
    }
  }

  loadNote() {
    // If in edit mode then load the provided title
    if (note != null) {
      contentController.text = note!.content!;
    }
  }

  Future<void> save() async {
    if (!isBtnSaveEnabled) {
      return;
    }
    if (note == null) {
      showLoadingDialog();
      repository.add(contentController.text, user['id']).then((value) {
        closeLoadingDialog();
        Get.back();
      }).catchError((onError) {
        closeLoadingDialog();
        Get.dialog(AlertPopup(
          isError: true,
          title: "Erreur",
          content: onError.toString(),
          onCanceled: () {
            Get.back();
          },
        ));
      });
    } else {
      edit();
    }
  }

  Future<void> edit() async {
    showLoadingDialog();
    repository.edit(note!.id, contentController.text).then((value) {
      closeLoadingDialog();
      Get.back();
    }).catchError((onError) {
      closeLoadingDialog();
      Get.dialog(AlertPopup(
        isError: true,
        title: "Erreur",
        content: onError.toString(),
        onCanceled: () {
          Get.back();
        },
      ));
    });
  }

  void clear() async {
    bool? confirmed = await Get.dialog<bool>(ConfirmDialog(
      title: "Supprimer ?",
      content: "Voulez-vous tout supprimer ?",
      onAccepted: () => Get.back(result: true),
      onCanceled: () => Get.back(result: false),
    ));
    if (confirmed!) {
      contentController.clear();
    }
  }
}
