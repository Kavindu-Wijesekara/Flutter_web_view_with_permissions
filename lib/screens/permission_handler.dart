
import 'package:ausmed_web_view_flutter_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerScreen extends StatefulWidget {
  const PermissionHandlerScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PermissionHandlerScreenState createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  @override
  void initState() {
    super.initState();
    permissionServiceCall();
  }

  permissionServiceCall() async {
    await permissionServices().then(
      (value) {
        if (value[Permission.storage]!.isGranted &&
            value[Permission.camera]!.isGranted &&
            value[Permission.location]!.isGranted &&
            value[Permission.microphone]!.isGranted) {
          /* ========= New Screen Added  ============= */

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      Permission.location,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.location]!.isPermanentlyDenied) {
      openAppSettings();
      //setState(() {});
    } 
    // else {
    //   if (statuses[Permission.location]!.isDenied) {
    //     permissionServiceCall();
    //   }
    // }

    if (statuses[Permission.storage]!.isPermanentlyDenied) {
      openAppSettings();
      //setState(() {});
    } 
    // else {
    //   if (statuses[Permission.storage]!.isDenied) {
    //     permissionServiceCall();
    //   }
    // }

    if (statuses[Permission.microphone]!.isPermanentlyDenied) {
      openAppSettings();
      // setState(() {});
    } 
    // else {
    //   if (statuses[Permission.microphone]!.isDenied) {
    //     permissionServiceCall();
    //   }
    // }

    if (statuses[Permission.camera]!.isPermanentlyDenied) {
      openAppSettings();
      // setState(() {});
    } 
    // else {
    //   if (statuses[Permission.camera]!.isDenied) {
    //     permissionServiceCall();
    //   }
    // }
    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            permissionServiceCall();
          },
          child: const Text(
            "Need permission for certain activities in order to run this app. Click here to enable Enable Permissions.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
