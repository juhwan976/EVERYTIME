import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_content_button.dart';
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
  final EdgeInsets _customContainerContentMargin = EdgeInsets.only(
    top: appHeight * 0.01,
    left: appWidth * 0.05,
    right: appWidth * 0.05,
  );

  final Map<String, List<ButtonInfo>> _data = {
    '계정': [
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
    ],
    '커뮤니티': [
      ButtonInfo(
        title: '닉네임 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '프로필 이미지 변경',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '이용 제한 내역',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '쪽지 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '커뮤니티 이용규칙',
        onPressed: () {},
      ),
    ],
    '앱 설정': [
      ButtonInfo(
        title: '다크 모드',
        data: '시스템 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '알림 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '암호 잠금',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '캐시 삭제',
        onPressed: () {},
      ),
    ],
    '이용 안내': [
      ButtonInfo(
        title: '앱 버전',
        data: '6.2.23(2022062319)',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '문의하기',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '공지사항',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '서비스 이용약관',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '개인정보 처리방침',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '오픈소스 라이선스',
        onPressed: () {},
      ),
    ],
    '기타': [
      ButtonInfo(
        title: '정보 동의 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '회원 탈퇴',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '로그아웃',
        onPressed: () {},
      ),
    ],
  };

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
                  _buildUserInfo(),
                  ..._buildSections(),
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
    return list.length * (appHeight * 0.0625) - appHeight * 0.0375;
  }

  Widget _buildUserInfo() {
    return CustomContainer(
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
                  _buildUserId(),
                  _buildUserNameNickName(),
                  _buildUserUniv(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserId() {
    return StreamBuilder(
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
    );
  }

  Widget _buildUserNameNickName() {
    return StreamBuilder(
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
                    color: Theme.of(context).hintColor,
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
    );
  }

  Widget _buildUserUniv() {
    return StreamBuilder(
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
                    color: Theme.of(context).hintColor,
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
    );
  }

  List<Widget> _buildSections() {
    return List.generate(
      _data.length,
      (dataIndex) {
        return CustomContainer(
          usePadding: true,
          // height: appHeight * 0.2875,
          child: Column(
            children: [
              CustomContainerTitle(
                title: _data.keys.elementAt(dataIndex),
                type: CustomContainerTitleType.none,
              ),
              Container(
                height: _calculateContainerHeight(
                    _data.values.elementAt(dataIndex)),
                margin: _customContainerContentMargin,
                child: Column(
                  children: List.generate(
                    _data.values.elementAt(dataIndex).length,
                    (buttonListIndex) {
                      return CustomContainerContentButton(
                        buttonInfoList: _data.values.elementAt(dataIndex),
                        currentIndex: buttonListIndex,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ButtonInfo {
  final String title;
  final String? data;
  final Function? onPressed;

  ButtonInfo({
    required this.title,
    this.data,
    this.onPressed,
  });
}
