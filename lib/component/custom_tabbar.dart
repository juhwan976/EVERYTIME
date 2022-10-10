import 'package:everytime/bloc/tabbar_bloc.dart';
import 'package:everytime/component/custom_tabbar_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.tabBarBloc,
    required this.buttonTitleList,
  }) : super(key: key);

  final TabBarBloc tabBarBloc;
  final List<String> buttonTitleList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.09,
      width: appWidth,
      padding: EdgeInsets.only(
        left: appWidth * 0.025,
        right: appWidth * 0.025,
      ),
      child: StreamBuilder(
        stream: tabBarBloc.getCurrentIndex,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: List.generate(
                (buttonTitleList.length + 1),
                (index) {
                  if (index == 0) {
                    return SizedBox(
                      width: appWidth * 0.025,
                    );
                  } else {
                    return CustomTabBarButton(
                      title: buttonTitleList.elementAt(index - 1),
                      index: index - 1,
                      currentIndex: snapshot.data as int,
                      onPressed: () {
                        tabBarBloc.updateCurrentIndex(index - 1);
                      },
                    );
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
