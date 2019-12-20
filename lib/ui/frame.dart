import 'package:custed2/ui/tabs/home/home.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';

class AppFrame extends StatefulWidget {
  @override
  _AppFrameState createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  // See: https://github.com/flutter/flutter/issues/24105#issuecomment-530222677
  final _tabController = CupertinoTabController();
  final _tab0NavKey = GlobalKey<NavigatorState>();
  final _tab1NavKey = GlobalKey<NavigatorState>();
  final _tab2NavKey = GlobalKey<NavigatorState>();
  final _tab3NavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await _currentNavigatorKey().currentState.maybePop();
      },
      child: _buildScaffold(),
    );
  }

  GlobalKey<NavigatorState> _currentNavigatorKey() {
    switch (_tabController.index) {
      case 0:
        return _tab0NavKey;
      case 1:
        return _tab1NavKey;
      case 2:
        return _tab2NavKey;
      case 3:
        return _tab3NavKey;
    }
    throw 'unreachable';
  }

  Widget _buildScaffold() {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        // currentIndex: currentPage,
        // onTap: (n) {
        //   return _setPage(n);
        // },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('主页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tags),
            title: Text('成绩'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            title: Text('课表'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text('账户'),
          ),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return CupertinoTabView(
              navigatorKey: _tab0NavKey,
              defaultTitle: '主页',
              builder: (context) {
                return HomeTab();
              },
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: _tab1NavKey,
              defaultTitle: '成绩',
              builder: (context) {
                return PlaceholderWidget();
              },
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: _tab2NavKey,
              defaultTitle: '课表',
              builder: (context) {
                return PlaceholderWidget();
              },
            );
          case 3:
            return CupertinoTabView(
              navigatorKey: _tab3NavKey,
              defaultTitle: '账户',
              builder: (context) {
                return PlaceholderWidget();
              },
            );
        }
        throw 'unreachable';
      },
    );
  }
}
