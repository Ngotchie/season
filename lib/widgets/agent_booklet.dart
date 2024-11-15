import 'dart:io';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AgentBookletWidget extends StatefulWidget {
  final File file;
  final String url;
  const AgentBookletWidget({
    Key? key,
    required this.file,
    required this.url,
  }) : super(key: key);

  @override
  State<AgentBookletWidget> createState() => _AgentBookletWidgetState();
}

class _AgentBookletWidgetState extends State<AgentBookletWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agents Booklet'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
        key: _pdfViewerKey,
      ),
    );
    // body: SfPdfViewer.network(
    //   'https://chic-aparts.com/agent_booklet.pdf',
    //   key: _pdfViewerKey,
    // ));
  }
}
