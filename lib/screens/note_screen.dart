import 'package:flutter/material.dart';
import '../category/note.dart';

class NoteScreen extends StatefulWidget {
  static const route = '/note';
  final Note? note;
  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool canAnimate = false;
  Note? currentNote;

  void saveChanges() async {
    final currentContext = context; // Store the current context

    // Perform the save operation
    if (currentNote != null) {
        await currentNote!.save();
    }

    // Pop the current screen after saving
    if (mounted) {
        Navigator.pop(currentContext);
    }
}

  deleteNote() async {
    final currentContext = context; // Store the current context

    // Pop the current screen before the async operation
    Navigator.pop(currentContext);

    // Perform the deletion
    if (currentNote != null) {
        await currentNote!.delete();
    }

    // Optionally, show feedback after the deletion (outside the async gap)
    Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(content: Text('Note deleted successfully')),
        );
    });
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note == null) {
      currentNote = Note(title: 'Untitled', content: '', tag: '');
    } else {
      currentNote = widget.note;
    }
    setState(() {});
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        canAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          top: 0,
          right: 0,
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.vertical,
            child: Column(children: [
              AnimatedOpacity(
                curve: Curves.ease,
                opacity: canAnimate ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Note',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Expanded(child: Container()),
                        widget.note != null
                            ? Row(children: [
                                InkWell(
                                  onTap: deleteNote,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                )
                              ])
                            : Container(),
                        InkWell(
                          onTap: saveChanges,
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                        )
                      ]),
                ),
              ),
              AnimatedSize(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    color: Colors.black,
                    height: 1,
                    width: canAnimate ? null : 0,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      currentNote?.getTimestamp() ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: [
                        const Text(
                          "#",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            onChanged: (value) => setState(() {
                              currentNote?.tag = value;
                            }),
                            initialValue: currentNote?.tag ?? '',
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                                hintText: 'Tag',
                                hintStyle: TextStyle(color: Colors.black54)),
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    currentNote?.title = value;
                  }),
                  initialValue: currentNote?.title ?? '',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 48, color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    currentNote?.content = value;
                  }),
                  cursorColor: Colors.black,
                  initialValue: currentNote?.content ?? '',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'Note description',
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}