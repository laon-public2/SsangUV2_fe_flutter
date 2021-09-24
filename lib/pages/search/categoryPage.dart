import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/lendItem.dart';
import 'package:share_product_v2/widgets/rentItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<String> itemKind = [
    "빌려드려요",
    "빌려주세요",
  ];
  String _currentItem = "";

  final List<String> categories = [
    "생활용품",
    "여행",
    "스포츠/레저",
    "육아",
    "반려동물",
    "가전제품",
    "의류/잡화",
    "가구/인테리어",
    "자동차용품",
    "기타"
  ];

  String _currentCategory = "";

  @override
  void initState() {
    _currentItem = itemKind.first;
    _currentCategory = categories.first;
    super.initState();
  }

  void setCurrentCategory(String value) {
    print(value);
    setState(() {
      _currentCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 0.0,
          ),
          Container(
            height: 44,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((e) {
                  return Stack(
                    children: [
                      Positioned(bottom: 0, left: 0, right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:  Color(0xffDDDDDD),
                            ),
                          ),
                        ),
                      ),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CategoryOnlyText(
                            title: e,
                            currentTitle: _currentCategory,
                            onClick: (value){
                              setCurrentCategory(value);
                            }),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 16),
                      child: CustomDropdown(
                        items: itemKind,
                        value: _currentItem,
                        onChange: (value) {
                          setState(() {
                            _currentItem = value;
                          });
                        },
                      ),
                    ), // 빌려드려요 / 빌려주세요 드랍박스
                    ToItem(
                      value: _currentItem,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryOnlyText extends StatelessWidget {
  final String title;
  final String currentTitle;
  final ValueChanged<String> onClick;

  CategoryOnlyText({required this.title, required this.currentTitle, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("123 $title");
        onClick(title);
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: (title == currentTitle)
                  ? Theme.of(context).primaryColor
                  : Color(0xffDDDDDD),
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Color(0xff333333)),
          ),
        ),
      ),
    );
  }
}

class ToItem extends StatelessWidget {
  final String value;

  ToItem({required this.value});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, idx) {
          if (value == "빌려드려요")
            return LendItem(
              category: "가구/인테리어",
              title: "[사성 오피스] 사무실 대여 (누구나 대여 가능합니다.)",
              name: "laonstory",
              price: "500,000원",
            );
          else
            return RentItem(
              category: "가구/인테리어",
              title: "[사성 오피스] 사무실 대여 (누구나 대여 가능합니다.)",
              name: "laonstory",
              startPrice: "500,000",
              endPrice: "650,000원",
              startDate: "01/22",
              endDate: "02/02",
            );
        },
        separatorBuilder: (context, idx) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Divider(),
          );
        },
        itemCount: 50);
  }
}
