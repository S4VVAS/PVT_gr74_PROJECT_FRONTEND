import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/pages/pages.dart';
import 'package:history_go/src/components/drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationPermissionHandler _permissionHandler = LocationPermissionHandler();
  bool hasPermission;

  @override
  initState() {
    super.initState();
    _permissionHandler.hasPermission().then((value) {
      setState(() {
        hasPermission = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasPermission == null
        ? Center(child: CircularProgressIndicator())
        : hasPermission
            ? Scaffold(
                body: Stack(
                  children: <Widget>[
                    MapPage(),
                    Padding(
                      padding:
                          EdgeInsets.all(8.0) + MediaQuery.of(context).padding,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: DrawerButton(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                endDrawer: CustomDrawer(),
                endDrawerEnableOpenDragGesture: false,
              )
            : Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Location permission required",
                        style: Theme.of(context).textTheme.bodyText2),
                    Button(
                      "Request permission",
                      onPressed: () {
                        _permissionHandler.askPermission().whenComplete(() {
                          _permissionHandler
                              .hasPermission()
                              .then((value) => setState(() {
                                    hasPermission = value;
                                  }));
                        });
                      },
                    )
                  ],
                ));
  }
}
