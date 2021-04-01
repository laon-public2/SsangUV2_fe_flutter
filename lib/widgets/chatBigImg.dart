import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBigImg extends StatelessWidget {
  final String bigImg;
  ChatBigImg(this.bigImg);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 300.w,
          height: 600.h,
          color: Colors.transparent,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ExtendedImage.network(
                "http://115.91.73.66:11111/chat/resource/image?path=${this.bigImg}",
                fit: BoxFit.fitWidth,
                cache: true,
                borderRadius: BorderRadius.circular(5),
                loadStateChanged: (ExtendedImageState state) {
                  switch(state.extendedImageLoadState) {
                    case LoadState.loading :
                      return Image.asset(
                        "assets/icon/loadingGif/loadingIcon.gif",
                        fit: BoxFit.cover,
                      );
                      break;
                    case LoadState.completed :
                      break;
                    case LoadState.failed :
                      return GestureDetector(
                        child: Image.asset(
                          "assets/icon/icons8-cloud-refresh-96.png",
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                      break;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
