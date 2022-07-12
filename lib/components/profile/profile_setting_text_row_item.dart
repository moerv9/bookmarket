import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/cupertino_style.dart';

class ProfileSettingTextRowItem extends StatefulWidget {
  const ProfileSettingTextRowItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.value,
    required this.fillEmptyData,
    required this.editFormPage,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String value;
  final bool fillEmptyData;
  final Widget editFormPage;

  @override
  State<ProfileSettingTextRowItem> createState() =>
      _ProfileSettingTextRowItemState();
}

class _ProfileSettingTextRowItemState extends State<ProfileSettingTextRowItem> {
  @override
  Widget build(BuildContext context) {
    String emptyText = "(keine Information)";
    TextStyle emptyStyle = Styles.standardText;

    // Handles navigation and prompts refresh.
    void navigateToPage(Widget editForm) {
      Route route = CupertinoPageRoute(builder: (context) => editForm);
      Navigator.push(context, route);
    }

    return CupertinoFormRow(
        prefix: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                widget.icon,
                color: Colors.grey,
                size: 25.0,
              ),
            ),
            Text(
              widget.title,
              style: Styles.standardText,
            )
          ],
        ),
        child: CupertinoButton(
            child: Row(children: [
              Expanded(
                  child: Text(
                widget.value != ""
                    ? widget.value
                    : (widget.fillEmptyData ? emptyText : ""),
                style: (widget.value != "" ? Styles.h2 : emptyStyle),
              )),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.grey,
                size: 25.0,
              )
            ]),
            onPressed: () {
              navigateToPage(widget.editFormPage);
            }));
  }
}
