import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget brokenCodeInfinityHeight() {
      return Column(
        children: <Widget>[
          /// 从上层widget下发的Constraints将约束此Widget横向布局，所以不受影响
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.red,
          ),
          /// Error: BoxConstraints forces an infinite height
          Container(
            height: double.infinity,
            color: Colors.green,
          ),
          /// 修正方法：设置具体高度，或用Expanded或SizedBox包裹/替代。
          ///Expanded(
          ///  child: Container(
          ///    height: double.infinity,
          ///    color: Colors.green,
          ///  ),
          ///),
        ],);
    }

    Widget brokenCodeInfinityWidth() {
      return Center(
        child: Row(
          children: <Widget>[
            /// Error: BoxConstraints forces an infinite width
            /// 解释：Row无限宽，TextField也无限宽，无法决定实际宽度
            TextField(
                decoration: InputDecoration(
                  hintText: 'a textfield',
                )),
            /// 修正方法：用Expanded或SizedBox包裹，
            /// 使TextField能确定具体占用的横向空间
            ///Expanded(
            ///  child: TextField(
            ///    decoration: InputDecoration(
            ///      hintText: 'a textfield',
            ///    ),
            ///  ),
            ///),
          ],
        ),);
    }

    Widget brokenCodeUnboundedHeight() {
      return Column(
        children: <Widget>[
          /// Error: Vertical viewport was given unbounded height
          ListView.builder(
            itemBuilder: (context, index) {
              return Text(index.toString());
            },
            itemCount: 3,
            /// 修决方法2：
            /// 设置ListView.shrinkWrap=true，使其占用尽可能小的纵向空间
            /// shrinkWrap: true,
          ),
          /// 修正方法1：
          /// 用Expanded或Flexible包裹ListView，使其占用确定的纵向空间
          ///Flexible(
          ///  child: ListView.builder(
          ///    itemBuilder: (context, index) {
          ///      return Text(index.toString());
          ///    },
          ///    itemCount: 3,
          ///  ),
          ///),
        ],
      );
    }

    Widget brokenCodeRenderFlexError() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.grey,
            child: Column(
              children: <Widget>[
                /// Error: RenderFlex children have non-zero flex \
                /// but incoming height constraints are unbounded.
                Expanded(child: Text('hello')),
                /// 修正方法：第1步. 设置column.mainAxisSize = MainAxisSize.min，
                ///                使列在竖直方向占据尽量小的空间(而不是占据更多的空间)
                /// Flexible(child: Text('hello')),
              ],
              /// 修正方法：第2步. 使用Flexible(或使用Flex并设置FlexFit.loose)
              /// mainAxisSize: MainAxisSize.min,
            ),
          ),
        ],
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: brokenCodeInfinityWidth(),
      ),);
  }
}

