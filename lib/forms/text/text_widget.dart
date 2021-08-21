import 'package:cosecheros/forms/text/text.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

class TextWidget extends StatefulWidget {
  final TextElement element;
  final String errorText;
  final FormElementEventDispatcherFunction dispatcher;

  const TextWidget({
    Key key,
    this.element,
    this.errorText,
    this.dispatcher,
  }) : super(key: key);

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  TextEditingController _controller = TextEditingController();

  VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () => widget.dispatcher(
          ChangeValueEvent(
            value: _controller.text,
            elementId: widget.element.id,
          ),
        );
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    if (_listener != null) {
      _controller?.removeListener(_listener);
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.text != widget.element.value) {
      _controller.text = widget.element.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          LabelWidget(widget.element.label),
          TextField(
            decoration: InputDecoration(
              labelText: widget.element.inputLabel,
              errorText: widget.errorText,
              hintText: widget.element.hint,
              helperText: widget.element.help,
            ),
            keyboardType: widget.element.inputType,
            controller: _controller,
            maxLines: getMaxLines(widget.element.inputType),
          ),
        ],
      ),
    );
  }

  int getMaxLines(TextInputType textInputType) {
    return textInputType == TextInputType.multiline ? null : 1;
  }
}
