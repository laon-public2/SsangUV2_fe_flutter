import "package:flutter/material.dart";

class Review extends StatefulWidget {
  @override
  _Review createState() => _Review();
}

class _Review extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '리뷰작성',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 30.0,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 1.0,
    );
  }

  _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.grey, size: 50.0),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '샘플유저',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '대여업체',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color(0xffff0066),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              '010-0000-0000',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff666666),
              ),
            ),
          ),
          SizedBox(height: 15),
          Divider(height: 1.0),
          SizedBox(height: 15),
          ListTile(
            title: Text(
              "사업자정보",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              '000-00000-0000.pdf',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff666666),
              ),
            ),
            trailing: SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                icon: Image.asset('assets/icon/write.png'),
                onPressed: () => null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
