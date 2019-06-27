import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(title: Text('百姓生活+'),),
       body: FutureBuilder(
        future: getHomePageContext(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast(); // 顶部轮播组件数
            List<Map> navigatorList = (data['data']['category'] as List).cast(); // 类别
            String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
            String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
            String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话 
            List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList,),//页面顶部轮播组件
                  TopNavigator(navigatorList: navigatorList,),
                  AdBanner(advertesPicture: advertesPicture,),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,),
                  Recommend(recommendList: recommendList,),
                ],
              ),
            );
          } else {
            return Center(child: Text('加载中'),);
          }
        },

       ),
    );
  }
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {

  final List swiperDataList;
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['image']}", fit:BoxFit.fill,);
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ) ,
    );
  }
}


// 首页导航变形
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }

    return Container(
      // color: Colors.greenAccent,
      height: ScreenUtil().setHeight(260),
      padding: const EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(7),
        children: navigatorList.map((item){
          return gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }

  Widget gridViewItemUI(BuildContext context, item){
    return InkWell(
      onTap: (){
          print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(85)),
          Text(item['mallCategoryName']),
        ],
      ),
    );

  }

}

//广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;
  const AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueAccent,
      child: Image.network(this.advertesPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(child: Image.network(leaderImage),onTap: launchURL,),
      
    );
  }

  void launchURL() async {
    String url = 'tel:'+this.leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    }else {
      throw 'Could not launch $url';
    }
  }

}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }

  //推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        )
      ),
      child: new Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return buildItem(index);
        },
      ),
    );
  }

  Widget buildItem(index){
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.black12),
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

}