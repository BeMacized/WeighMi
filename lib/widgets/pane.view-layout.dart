import 'package:flutter/material.dart';

import '../globals.dart';
import 'custom-card.widget.dart';

class PaneViewLayout extends StatelessWidget {
  final bool showBackButton;
  final String title;
  final Widget child;

  const PaneViewLayout({Key key, this.showBackButton, this.title, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(
            context,
            title,
            showBackButton ?? Application.navigator.canPop(),
          ),
          _buildCard(context, child),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 108,
          left: 18,
          right: 18,
        ),
        child: SizedBox.expand(
          child: CustomCard(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(
      BuildContext context, String title, bool showBackButton) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 96),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 32,
                  bottom: 32 + 96.0,
                  left: showBackButton ? 6 : 18,
                  right: 18,
                ),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: <Widget>[
                      if (showBackButton)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: Application.navigator.canPop()
                              ? Application.navigator.pop
                              : null,
                        ),
                      Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: Container(color: Theme.of(context).backgroundColor)),
      ],
    );
  }
}
