import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/fcm_model.dart';
import 'package:share_product_v2/providers/mainProvider.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/myPageProvider.dart';
import 'package:share_product_v2/providers/policyProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tokens;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white)
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MyPageProvider>(
            create: (_) => MyPageProvider(),
          ),
          ChangeNotifierProvider<RegUserProvider>(
            create: (_) => RegUserProvider(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider<PolicyProvider>(
            create: (_) => PolicyProvider(),
          ),
          ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider(),
          ),
          ChangeNotifierProvider<BannerProvider>(
            create: (_) => BannerProvider(),
          ),
          ChangeNotifierProvider<ContractProvider>(
            create: (_) => ContractProvider(),
          ),
          ChangeNotifierProvider<MapProvider>(
            create: (_) => MapProvider(),
          ),
          ChangeNotifierProvider<MainProvider>(
            create: (_) => MainProvider(),
          ),
          ChangeNotifierProvider<FCMModel>(
            create: (_) => FCMModel(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: Size(360, 680),
          allowFontScaling: false,
          builder: () => MaterialApp(
            navigatorKey: navigatorKey,
            title: '쌩유',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', "US"),
              const Locale('ko', "KO"),
            ],
            theme: ThemeData(
              fontFamily: "NotoSans",
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: Color(0xffFF0066),
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                  brightness: Brightness.light,
                  color: Colors.white,
                  elevation: 0.0),
            ),
            // home: SplashScreen(),
            // DefaultTabController(
            //   length: 3,
            //   child: Scaffold(
            //     body: TabBarView(
            //       physics: NeverScrollableScrollPhysics(),
            //       children: <Widget>[
            //         MainPage(),
            //         ProductReg(),
            //         LoginMyPage(),
            //       ],
            //     ),
            //     bottomNavigationBar: BottomBar(),
            //   ),
            // ),
            initialRoute: "/",
            routes: routes,
            // onGenerateRoute: (routeSettings) {
            //   if (routeSettings.name == "/product" ||
            //       routeSettings.name == "/product/detail") {
            //     Map<String, dynamic> args = routeSettings.arguments;
            //     return MaterialPageRoute(
            //       builder: (context) {
            //         return DetailProduct(
            //           id: args['id'],
            //         );
            //       },
            //     );
            //   }
            //   return null;
            // },
          ),
        ));
  }
}
