import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio.dart';

class AddAudio extends StatefulWidget {
  static const routeName = '/AddAudioScreen';

  const AddAudio({Key? key}) : super(key: key);

  @override
  State<AddAudio> createState() => _AddAudioState();
}

class _AddAudioState extends State<AddAudio> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _audioData = {
    'key': '',
    'title': '',
    'distance': '',
    'angle': '',
    'tag': '',
  };

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    await Provider.of<AudioClassification>(context, listen: false)
        .addAudio(
          Audio(
            key: _audioData['key']!,
            title: _audioData['title']!,
            distance: double.parse(_audioData['distance']!),
            angle: double.parse(_audioData['angle']!),
            tag: _audioData['tag']!,
          ),
        )
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Audio Added.')),
          ),
        )
        .catchError(
          (onError) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could\'nt Add Audio.')),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Audio'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Field Empty!';
                }
                return null;
              },
              onSaved: (value) {
                _audioData['title'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Distance',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Field Empty!';
                }
                return null;
              },
              onSaved: (value) {
                _audioData['distance'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Angle',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Field Empty!';
                }
                return null;
              },
              onSaved: (value) {
                _audioData['angle'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tag',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Field Empty!';
                }
                return null;
              },
              onSaved: (value) {
                _audioData['tag'] = value!;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await submit();
                if(!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
