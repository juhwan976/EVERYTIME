import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final double _buttonWidth = appWidth * 0.15;

  final List<ButtonInfo> _settings = [
    ButtonInfo(
      title: '학교 인증',
      onPressed: () {},
    ),
    ButtonInfo(
      title: '비밀번호 변경',
      onPressed: () {},
    ),
    ButtonInfo(
      title: '이메일 변경',
      onPressed: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: appHeight * 0.0025,
                  ),
                  CustomContainer(
                    usePadding: false,
                    height: appHeight * 0.115,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: appWidth * 0.04,
                        right: appWidth * 0.04,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: appWidth * 0.15,
                            height: appWidth * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: appHeight * 0.025,
                              left: appWidth * 0.025,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: widget.userBloc.id,
                                  builder: (_, idSnapshot) {
                                    if (idSnapshot.hasData) {
                                      return Text(
                                        idSnapshot.data!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                                StreamBuilder(
                                  stream: widget.userBloc.name,
                                  builder: (_, nameSnapshot) {
                                    if (nameSnapshot.hasData) {
                                      return StreamBuilder(
                                        stream: widget.userBloc.nickName,
                                        builder: (__, nickNameSnapshot) {
                                          if (nickNameSnapshot.hasData) {
                                            return Text(
                                              '${nameSnapshot.data!} / ${nickNameSnapshot.data!}',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize: 15,
                                              ),
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                                StreamBuilder(
                                  stream: widget.userBloc.univ,
                                  builder: (_, univSnapshot) {
                                    if (univSnapshot.hasData) {
                                      return StreamBuilder(
                                        stream: widget.userBloc.year,
                                        builder: (__, yearSnapshot) {
                                          if (yearSnapshot.hasData) {
                                            return Text(
                                              '${univSnapshot.data!} ${yearSnapshot.data}학번',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize: 15,
                                              ),
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomContainer(
                    usePadding: true,
                    // height: appHeight * 0.2875,
                    child: Column(
                      children: [
                        const CustomContainerTitle(
                          title: '계정',
                          type: CustomContainerTitleType.none,
                        ),
                        Container(
                          height: _calculateContainerHeight(_settings),
                          margin: EdgeInsets.only(
                            top: appHeight * 0.01,
                            left: appWidth * 0.05,
                            right: appWidth * 0.05,
                          ),
                          child: Column(
                            children: List.generate(
                              _settings.length,
                              (index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: index != 0 ? appHeight * 0.0375 : 0,
                                  ),
                                  height: appHeight * 0.025,
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _settings[index].title,
                                        style: const TextStyle(
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _settings[index].onPressed?.call();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: _buttonWidth,
            child: MaterialButton(
              padding: EdgeInsets.only(
                right: appWidth * 0.07,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Text(
            '내 정보',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(
            width: _buttonWidth,
          ),
        ],
      ),
    );
  }

  double _calculateContainerHeight(List<dynamic> list) {
    // final double buttonHeight = appHeight * 0.025;

    return list.length * (appHeight * 0.0625) - appHeight * 0.0375;
  }
}

class ButtonInfo {
  final String title;
  final Function? onPressed;

  ButtonInfo({
    required this.title,
    this.onPressed,
  });
}
