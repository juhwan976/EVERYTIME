import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/home_page/my_info_page/my_info_page.dart';
import 'package:flutter/material.dart';

class CustomContainerContentButton extends StatelessWidget {
  const CustomContainerContentButton({
    Key? key,
    required this.buttonInfoList,
    required this.currentIndex,
  }) : super(key: key);

  final List<ButtonInfo> buttonInfoList;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: currentIndex != 0 ? appHeight * 0.0375 : 0,
      ),
      height: appHeight * 0.025,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonInfoList[currentIndex].title,
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
              (buttonInfoList[currentIndex].data != null)
                  ? Text(
                      buttonInfoList[currentIndex].data!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        onPressed: () {
          buttonInfoList[currentIndex].onPressed?.call();
        },
      ),
    );
  }
}
