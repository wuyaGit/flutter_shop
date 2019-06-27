import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with AutomaticKeepAliveClientMixin {

  final List<BottomNavigationBarItem> bottomTabs = [
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.home),
      title: new Text('首页'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.search),
      title: new Text('分类'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.shopping_cart),
      title: new Text('购物车'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(CupertinoIcons.profile_circled),
      title: new Text('会员中心'),
    ),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage(),
  ];

  int currentIndex = 0;
  var currentPage;
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentPage = tabBodies[currentIndex];
    // pageController = new PageController()
    //   ..addListener((){
    //     if (currentPage != pageController.page.round()) {
    //       setState(() {
    //         currentPage = pageController.page.round();
    //       });
    //     }
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),

      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: new BottomNavigationBar(
        
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[index];
          });  
        },
      ),
      
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}