import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:Season/services/user.dart';
import 'package:Season/widgets/bookings/index.dart';
import 'package:Season/widgets/error.dart';
import 'package:Season/widgets/finance/financeIndex.dart';
import 'package:Season/widgets/hostings/hostingIndex.dart';
import 'package:Season/widgets/marketing-review/marketing-review.dart';

import 'widgets/accommodations/accomodation.dart';
import 'widgets/operations/operation.dart';
// import 'package:widget_permission_manager/authorization.dart';
// import 'package:widget_permission_manager/authorization_widget.dart';
// import 'package:tuple/tuple.dart';

class HomeBottomMenu extends StatefulWidget {
  const HomeBottomMenu({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  _HomeBottomMenuState createState() => _HomeBottomMenuState();
}

class _HomeBottomMenuState extends State<HomeBottomMenu> {
  CurrentUser currentUser = new CurrentUser();
  var user;
  int selectedPos = 0;
  double bottomNavBarHeight = 60;
  String menuTitle = "";
  String _role = "";
  // Authorization _authorizationAdmin =
  //     Authorization(0, 'Admin only', ['admin', 'director']);
  // Authorization _authorizationAll =
  //     Authorization(0, 'All', ['admin', 'director', 'agent', 'technician']);

  late CircularBottomNavigationController _navigationController;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Accommodations", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    new TabItem(Icons.assignment, "Operations", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    new TabItem(Icons.euro, "Finances", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    new TabItem(Icons.ballot_outlined, "Bookings", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    new TabItem(Icons.home_work, "Hostings", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    new TabItem(
        Icons.document_scanner_outlined, "Marketing Review", Color(0xFF05A8CF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
    // new TabItem(Icons.notifications, "Notifications", Colors.cyan,
    //     labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
  ]);

  @override
  void initState() {
    currentUser.getCurrentUser().then((result) {
      print(result);
      setState(() {
        user = result;
        _role = user.role[0];
      });
      //  role = user.role[0]['id'];
    });
    selectedPos = this.widget.index;
    _navigationController = new CircularBottomNavigationController(selectedPos);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    var bookingPage = arguments['page'];
    if (_role == "agent") {
      tabItems = List.of([
        new TabItem(Icons.home, "Accommodations", Color(0xFF05A8CF),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        new TabItem(Icons.assignment, "Operations", Color(0xFF05A8CF),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
      ]);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(bookingPage),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer(p) {
    // AuthorizationWidget(
    //   role: _role,
    //   children: [
    //     Tuple2(
    //       _authorizationAdmin,

    //     ),
    //     Tuple2(_authorizationAll, )
    //   ],
    // );
    Color selectedColor = tabItems[selectedPos].circleColor;
    var _page;
    switch (selectedPos) {
      case 0:
        _page = Accomodation(user: user);
        menuTitle = "ACCOMMODATIONS";
        break;
      case 1:
        _page = Operation(user: user);
        menuTitle = "OPERATIONS";
        break;
      case 2:
        if (user.permissions.contains("manage finances")) {
          _page = FinanceIndexWidget(user: user);
          menuTitle = "FINANCES";
        } else {
          menuTitle = "PAGE NOT FOUND";
          _page = ErrorPermissionWidget();
        }
        break;
      case 3:
        if (user.permissions.contains("view bookings listing")) {
          _page = IndexBookingWidget(user: user, page: p == null ? 0 : p);
          menuTitle = "BOOKINGS";
        } else {
          menuTitle = "PAGE NOT FOUND";
          _page = ErrorPermissionWidget();
        }
        break;
      case 4:
        if (user.permissions.contains("view partners listing")) {
          _page = HostingIndexWidget(user: user);
          menuTitle = "HOSTINGS";
        } else {
          menuTitle = "PAGE NOT FOUND";
          _page = ErrorPermissionWidget();
        }
        break;
      case 5:
        if (user.permissions.contains("view marketing-review")) {
          _page = MarketingReviewWidget(user: user);
        } else {
          menuTitle = "PAGE NOT FOUND";
          _page = ErrorPermissionWidget();
        }
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(child: _page
            // child: Text(
            //   slogan,
            //   style: TextStyle(
            //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            // ),
            ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          // _navigationController.value++;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos!;
          // print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
