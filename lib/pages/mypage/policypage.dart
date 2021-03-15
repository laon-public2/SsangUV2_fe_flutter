import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/policy.dart';
import 'package:share_product_v2/providers/policyProvider.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<PolicyProvider>(context, listen: false).getPolicies();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBarWithPrev("약관 및 정책", 1.0, context),
      body: body(context),
    );
  }

  Widget body(context) {
    return Consumer<PolicyProvider>(builder: (_, policy, __) {
      return makeList(context, policy.policies);
    });
  }

  Widget makeList(context, List<PolicyModel> list) {
    return Column(
        children:
            list.map((e) => menuItem(context, e.title, e.content)).toList());
  }

  Widget menuItem(context, String title, String content) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Color(0xffeeeeee)),
      )),
      child: SizedBox(
        height: 48.h,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("/policy/detail",
                arguments: {"title": title, "content": content});
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              )),
        ),
      ),
    );
  }
}
