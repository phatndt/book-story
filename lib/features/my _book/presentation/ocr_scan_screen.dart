import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:book_story/core/extension/function_extension.dart';
import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/my%20_book/presentation/widget/text_recognizer_painter.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/snack_bar.dart';
import '../di/my_book_module.dart';

// class OcrScanScreen extends ConsumerStatefulWidget {
//   const OcrScanScreen({
//     Key? key,
//     required this.cameraDescription,
//   }) : super(key: key);
//   final CameraDescription cameraDescription;
//
//   @override
//   ConsumerState createState() => _OcrScanScreenState();
// }
//
// class _OcrScanScreenState extends ConsumerState<OcrScanScreen> {
//   late List<CameraDescription>? _cameras;
//   late CameraController? _controller;
//   late bool isShowLoading;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _cameras = null;
//     isShowLoading = false;
//     _controller = CameraController(
//       widget.cameraDescription,
//       ResolutionPreset.max,
//       enableAudio: false,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21 // for Android
//           : ImageFormatGroup.bgra8888, // for iOS
//     );
//     _initializeControllerFuture = _controller!.initialize();
//   }
//
//   Future<void> startCamera() async {
//     _cameras = await availableCameras();
//     _controller = CameraController(
//       widget.cameraDescription,
//       ResolutionPreset.max,
//       enableAudio: false,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21 // for Android
//           : ImageFormatGroup.bgra8888, // for iOS
//     );
//     _initializeControllerFuture = _controller!.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(ocrScanStateNotifierProvider, (previous, next) async {
//       if (next is UILoadingState) {
//         setState(() {
//           isShowLoading = next.loading;
//         });
//       } else if (next is UISuccessState) {
//         setState(() {
//           _cameras = next.data;
//           _controller = CameraController(
//             _cameras![0],
//             ResolutionPreset.max,
//           );
//         });
//         await _controller?.initialize();
//       } else if (next is UIErrorState) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(ErrorSnackBar(message: next.error.toString()));
//       }
//     });
//     return SafeArea(
//       child: ModalProgressHUD(
//         inAsyncCall: isShowLoading,
//         child: Scaffold(
//           appBar: CustomAppBar(
//             leading: Image.asset(
//               'assets/logo/logo.png',
//             ),
//             title: Text(
//               'shelfie'.tr(),
//               style: S.textStyles.heading3,
//             ),
//           ),
//           backgroundColor: const Color(0xffF2F6FA),
//           body: FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 // If the Future is complete, display the preview.
//                 return CameraPreview(_controller!);
//               } else {
//                 // Otherwise, display a loading indicator.
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     // get camera rotation
//     final camera = widget.cameraDescription;
//     final rotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation);
//     if (rotation == null) return null;
//
//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;
//
//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }
// }
class OcrScanScreen extends StatefulWidget {
  const OcrScanScreen({
    Key? key,
    required this.cameraDescription,
  }) : super(key: key);
  final List<CameraDescription> cameraDescription;

  @override
  State<OcrScanScreen> createState() => _OcrScanScreenState();
}

class _OcrScanScreenState extends State<OcrScanScreen> {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  List<String> _text = List.empty(growable: true);

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      cameraDescription: widget.cameraDescription,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
    });
    setState(() {
      _text = List.empty(growable: true);
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(recognizedText,
          inputImage.metadata!.size, inputImage.metadata!.rotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      setState(() {
        _text = List.empty(growable: true);
      });
      for (final block in recognizedText.blocks) {
        setState(() {
          _text.add(block.text);
        });
      }
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    setState(() {
      _isBusy = false;
    });
    if (mounted) {
      setState(() {});
    }
  }
}

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.title,
      required this.customPaint,
      required this.cameraDescription,
      this.text,
      required this.onImage,
      this.onScreenModeChanged,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final List<String>? text;
  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;
  final List<CameraDescription> cameraDescription;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  List<int> selectedIndex = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    if (widget.cameraDescription.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = widget.cameraDescription.indexOf(
        widget.cameraDescription.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < widget.cameraDescription.length; i++) {
        if (widget.cameraDescription[i].lensDirection ==
            widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }
    _imagePicker = ImagePicker();

    if (_cameraIndex != -1) {
      _startLiveFeed();
    } else {
      _mode = ScreenMode.gallery;
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Image.asset(
          'assets/logo/logo.png',
        ),
        title: Text(
          widget.title,
          style: S.textStyles.heading3,
        ),
        actions: [
          if (_allowPicker)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _switchScreenMode,
                child: Icon(
                  _mode == ScreenMode.liveFeed
                      ? Icons.photo_library_outlined
                      : (Platform.isIOS
                          ? Icons.camera_alt_outlined
                          : Icons.camera),
                  color: S.colors.black,
                ),
              ),
            ),
        ],
      ),
      body: _body(),
      // floatingActionButton: _floatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: _changingCameraLens
                  ? const Center(
                      child: Text('Changing camera lens'),
                    )
                  : CameraPreview(_controller!),
            ),
          ),
          if (widget.customPaint != null) widget.customPaint!,
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Slider(
              value: zoomLevel,
              min: minZoomLevel,
              max: maxZoomLevel,
              onChanged: (newSliderValue) {
                setState(() {
                  zoomLevel = newSliderValue;
                  _controller!.setZoomLevel(zoomLevel);
                });
              },
              divisions: (maxZoomLevel - 1).toInt() < 1
                  ? null
                  : (maxZoomLevel - 1).toInt(),
            ),
          )
        ],
      ),
    );
  }

  Widget _galleryBody() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          CustomElevatedButton(
              child: Text('From Gallery'),
              onPressed: () => _getImage(ImageSource.gallery)),
          SizedBox(height: 16.h),
          CustomElevatedButton(
            child: Text('Take a picture'),
            onPressed: () => _getImage(ImageSource.camera),
          ),
          SizedBox(height: 16.h),
          if (_image != null)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                      child: CheckboxListTile(
                        value: selectedIndex.contains(index),
                        onChanged: (bool? value) {
                          if (value == true) {
                            selectedIndex.add(index);
                          } else {
                            selectedIndex.remove(index);
                          }
                          setState(() {});
                        },
                        title: Text(widget.text![index]),
                      ),
                    ),
                  );
                },
                itemCount: widget.text!.length,
              ).isShow(widget.text != null),
            ),
          CustomElevatedButton(
              child: Text('Submit'),
              onPressed: selectedIndex.isNotEmpty
                  ? () {
                      List<String> temp = selectedIndex.map((e) => widget.text![e]).toList();
                      String nums = temp.reduce((value, element) => "$value $element");
                      Navigator.of(context).pop(nums);
                    }
                  : null),
        ],
      ),
    );
  }

  Widget? _floatingActionButton() {
    if (_mode == ScreenMode.gallery) return null;
    if (widget.cameraDescription.length == 1) return null;
    return SizedBox(
      height: 70.0,
      width: 70.0,
      child: FloatingActionButton(
        onPressed: _switchLiveCamera,
        child: Icon(
          Platform.isIOS
              ? Icons.flip_camera_ios_outlined
              : Icons.flip_camera_android_outlined,
          size: 40,
        ),
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
      _path = path;
    });
    final inputImage = InputImage.fromFilePath(path);
    setState(() {
      selectedIndex = List.empty(growable: true);
    });
    widget.onImage(inputImage);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    setState(() {
      selectedIndex = List.empty(growable: true);
    });
    widget.onImage(inputImage);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get camera rotation
    final camera = widget.cameraDescription[_cameraIndex];
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = widget.cameraDescription;
    _controller = CameraController(
      camera[0],
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _switchScreenMode() {
    _image = null;
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;
      _stopLiveFeed();
    } else {
      _mode = ScreenMode.liveFeed;
      _startLiveFeed();
    }
    if (widget.onScreenModeChanged != null) {
      widget.onScreenModeChanged!(_mode);
    }
    setState(() {});
  }
}
