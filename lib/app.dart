import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fueler/pages/dashboard/dashboard-main.dart';

class FuelerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: FuelerHome(),
    );
  }
}

class FuelerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Übersicht",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear),
              label: "Einstellungen",
            ),
          ],
        ),
        tabBuilder: (context, index) {
          CupertinoTabView returnValue;
          switch (index) {
            case 0:
              returnValue = CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: DashboardPage(),
                );
              });
              break;
            case 1:
              returnValue = CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Hallo, Welt"),
                  ),
                );
              });
              break;
          }
          return returnValue;
        });
  }
}
