import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatefulWidget {
  final String title;
  final Function(void Function(String))? update;
  final String? info;

  const LoadingDialog({super.key, required this.title, this.update, this.info});

  @override
  State<StatefulWidget> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<LoadingDialog> {
  late String info;

  @override
  initState() {
    super.initState();

    info = widget.info ?? "";

    widget.update?.call((info) {
      setState(() {
        this.info = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 4.r),
            child: Text(info),
          ),
        ],
      ),
    );
  }
}