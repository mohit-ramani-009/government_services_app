import 'package:flutter/material.dart';
class Utils {
  void showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}

// child: StreamBuilder<List<ConnectivityResult>>(
//     stream: Connectivity().onConnectivityChanged,
//     builder: (context, snapshot) {
//       List<ConnectivityResult> res = snapshot.data ?? [];
//       if (res.contains(ConnectivityResult.none)) {
//         return Text(
//           "Please Check internet Connection",
//           style: Theme.of(context)
//               .textTheme
//               .headlineLarge
//               ?.copyWith(color: Colors.green),
//         );
//       } else {
//         return Text(
//           "Connected",
//           style: Theme.of(context)
//               .textTheme
//               .headlineLarge
//               ?.copyWith(color: Colors.green),
//         );
//       }
//     }),