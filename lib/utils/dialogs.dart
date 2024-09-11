import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

late BuildContext dialogContext;

showNoticeDialog(BuildContext context, {String? title, required String message}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppTheme.lightGray,
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: title == null
            ? null
            : Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: title == null
              ? const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              : const TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkGray,
                ),
        ),
      );
    },
  );
}

showSuccessDialog(BuildContext context, {String message = 'Success', Function? onDismiss}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppTheme.lightGray,
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset('assets/images/icon_success.png', height: 42),
          ],
        ),
      );
    },
  ).then((value) {
    if (onDismiss != null) {
      onDismiss();
    }
  });
}

showErrorDialog(BuildContext context, {String? title, required String message, VoidCallback? onConfirm}) {
  String msg = (message != '') ? message : 'Ocurrió un error';
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppTheme.lightGray,
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
        titlePadding: title == null ? EdgeInsets.zero : null,
        title: Column(
          children: [
            title == null
                ? const SizedBox()
                : Column(
                    children: [
                      Image.asset(
                        'assets/images/icon_error.png',
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
        content: Column(
          children: [
            if (title == null)
              Image.asset(
                'assets/images/icon_error.png',
                height: 30,
              ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: title == null
                    ? const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      )
                    : const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: AppTheme.darkGray,
                      ),
              ),
            ),
          ],
        ),
        actions: [
          (onConfirm != null)
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: ElevatedButton(onPressed: onConfirm, child: const Text('Aceptar'))),
                    ],
                  ))
              : Container()
        ],
      );
    },
  );
}

showConfirmDialog(BuildContext context, {String message = 'Confirm', VoidCallback? onCancel, VoidCallback? onConfirm}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
        title: Text(message, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
        actions: [
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: OutlinedButton(onPressed: onCancel, child: const Text('Cancelar'))),
                  const SizedBox(width: 20),
                  Expanded(child: ElevatedButton(onPressed: onConfirm, child: const Text('Aceptar'))),
                ],
              ))
        ],
      );
    },
  );
}

showAceptDialog(BuildContext context, {String message = 'Confirm', VoidCallback? onConfirm}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/icon_success.png', height: 42),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(onPressed: onConfirm, child: const Text('Aceptar'))),
                ],
              ))
        ],
      );
    },
  );
}
