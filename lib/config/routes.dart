import 'package:custed2/core/route.dart';
import 'package:custed2/ui/home_tab/home_go_to_wechat.dart';
import 'package:custed2/ui/pages/cbs_page.dart';
import 'package:custed2/ui/pages/cet_avatar_page.dart';
import 'package:custed2/ui/pages/debug_page.dart';
import 'package:custed2/ui/pages/empty_room_page.dart';
import 'package:custed2/ui/pages/exam_page.dart';
import 'package:custed2/ui/pages/map_page.dart';
import 'package:custed2/ui/pages/school_calendar_page.dart';
import 'package:custed2/ui/user_tab/netdisk_page.dart';
import 'package:custed2/ui/webview/webview_browser.dart';

final custccBase = 'https://cust.cc';

// 因inappwebview问题 暂时使用旧版登录
// final loginPage = AppRoute(
//   title: '登录',
//   page: WebviewLogin(),
  // page: LoginWebPage(),
// );

// 因webview, 提供传统登录方式
// final loginPageLegacy = AppRoute(
//   title: '登录(Legacy)',
//   page: LoginPageLegacy(),
// );

final debugPage = AppRoute(
  title: 'Terminal',
  page: DebugPage(),
);

final cbsPage = AppRoute(
  title: 'CBS',
  page: CbsPage(),
);

final cetAvatarPage = AppRoute(
  title: '四六级照片',
  page: CetAvatarPage(),
);

final jwWebPage = AppRoute(
  title: '教务系统',
  page: WebviewBrowser('$custccBase/go/jwgl'),
);

//final tikuWebPage = AppRoute(
//  title: '考试题库',
//  page: TikuWebPage(),
//);

final tiku2WebPage = AppRoute(
  title: '考试题库',
  //page: Tiku2WebPage(),
  page: WebviewBrowser('https://tiku-ng.lacus.site'),
);

final schoolCalendarPage = AppRoute(
  title: '校历',
  page: SchoolCalendarPage(),
);

final mapPage = AppRoute(
  title: '地图',
  page: MapPage(),
);

final netdiskPage = AppRoute(
  // title: '网盘与备份',
  title: '网盘',
  page: NetdiskPage(),
);

final netdiskWebPage = AppRoute(
  title: '长理网盘',
  page: WebviewBrowser('$custccBase/go/netdisk'),
);

final feedbackPage = AppRoute(
  title: '反馈',
  page: WebviewBrowser('$custccBase/go/feedback')
);

final bbsPage = AppRoute(
    title: '校内导航',
    page: WebviewBrowser('https://bbs.cust.app')
);

final emptyRoomPage = AppRoute(
  title: '空教室',
  page: EmptyRoomPage()
);

final selfWebPage = AppRoute(
  title: '校园网',
  //page: SelfWebPage(),
  page: WebviewBrowser('$custccBase/go/self'),
);

final ticeWebPage = AppRoute(
  title: '体测成绩',
  //page: TiceWebPage(),
  page: WebviewBrowser('$custccBase/go/tice'),
);

final gotoWechat = AppRoute(
  title: '',
  page: GoToWechat(),
);

final examPage = AppRoute(
  title: '考试安排',
  page: ExamPage(),
);