import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
    as ml_kit;
import 'package:permission_handler/permission_handler.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../cores/widgets/camera_overlay/selfie/selfie_camera_overly.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../../cores/widgets/camera_overlay/id_card/idcard_camera_overlay.dart';
import '../../../../cores/widgets/camera_overlay/id_card/overlay_model.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../data/models/field_detector.dart';
import '../../data/models/mlkit_text_normalization.dart';
import '../cubits/camera/camera_cubit.dart';

class CameraOverlayFor {
  static const String ktp = 'ktp';
  static const String selfie = 'selfie';
  static const String npwp = 'npwp';
  static const String bankAccount = 'bank-account';
}

class CameraOverlayScreen extends StatelessWidget {
  final String cameraOverlayFor;
  final String aditionalData;

  const CameraOverlayScreen({
    super.key,
    required this.cameraOverlayFor,
    required this.aditionalData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CameraCubit>(),
      child: _Content(
          key: key,
          cameraOverlayFor: cameraOverlayFor,
          aditionalData: aditionalData),
    );
  }
}

class _Content extends StatefulWidget {
  final String cameraOverlayFor;
  final String aditionalData;
  const _Content({
    super.key,
    required this.cameraOverlayFor,
    required this.aditionalData,
  });

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with WidgetsBindingObserver {
  final OverlayFormat format = OverlayFormat.cardID1;
  bool isPaused = false;

  _requestCamera() {
    return Permission.camera.request().then((value) {
      appPrint("camera permission: $value");
      context.read<CameraCubit>().changePermission(value);
    }).onError((error, stackTrace) {
      context
          .read<CameraCubit>()
          .changePermission(PermissionStatus.permanentlyDenied);
    }).catchError((e) {
      context
          .read<CameraCubit>()
          .changePermission(PermissionStatus.permanentlyDenied);
    });
  }

  @override
  void initState() {
    super.initState();
    appPrint("CameraTab initState called");
    WidgetsBinding.instance.addObserver(this);
    _requestCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      appPrint("CameraTab AppLifecycleState.resumed called");
      appPrint("isPaused: $isPaused");
      if (isPaused) {
        _requestCamera();
      }
      isPaused = false;
    }
    if (state == AppLifecycleState.paused) {
      appPrint("CameraTab AppLifecycleState.paused called");
      isPaused = true;
    }
  }

  @override
  void dispose() {
    appPrint("CameraTab dispose called");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CameraCubit, CameraState>(
            builder: (context, state) {
              if (state.permissionStatus == PermissionStatus.granted) {
                return FutureBuilder<List<CameraDescription>?>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No camera found',
                              style: TextStyle(color: Colors.black),
                            ));
                      }
                      if (widget.cameraOverlayFor == CameraOverlayFor.selfie) {
                        return SelfieCameraOverlay(
                          camera: snapshot.data!.length > 1
                              ? snapshot.data![1]
                              : snapshot.data![0],
                          model: CardOverlay.byFormat(format),
                          onCapture: (file) => _onCapture(
                              context, file, widget.cameraOverlayFor),
                          info: _info(t, widget.cameraOverlayFor),
                        );
                      }
                      return IdCardCameraOverlay(
                        camera: snapshot.data!.first,
                        model: CardOverlay.byFormat(format),
                        onCapture: (file) =>
                            _onCapture(context, file, widget.cameraOverlayFor),
                        info: _info(t, widget.cameraOverlayFor),
                      );
                    } else {
                      return const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fetching cameras',
                            style: TextStyle(color: Colors.black),
                          ));
                    }
                  },
                );
              }
              if (state.permissionStatus == PermissionStatus.denied) {
                return Align(
                  alignment: Alignment.center,
                  child: _cameraDenied(
                    text:
                        'Perizinan kamera ditolak.\nTekan tombol dibawah ini untuk minta perizinan kamera.',
                    btnText: "minta izin kamera",
                    onTap: () {
                      _requestCamera();
                    },
                  ),
                );
              }
              if (state.permissionStatus ==
                  PermissionStatus.permanentlyDenied) {
                return Align(
                  alignment: Alignment.center,
                  child: _cameraDenied(
                    text:
                        'Perizinan kamera ditolak. Kamu harus ubah perizinan kamera pada menu pengaturan agar dapat membuka kamera pada aplikasi.\nTekan tombol di bawah ini untuk buka pengaturan.',
                    btnText: "buka pengaturan",
                    onTap: () async {
                      EasyLoading.show();
                      try {
                        await openAppSettings();
                      } catch (e) {
                        EasyLoading.dismiss();
                      }
                      EasyLoading.dismiss();
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: clrBlack040,
              centerTitle: true,
              title: Text(
                _titleAppbar(t, widget.cameraOverlayFor),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: MainBackButton(
                onPressed: () {
                  switch (widget.cameraOverlayFor) {
                    case CameraOverlayFor.ktp:
                      context.goNamed(AppRoutes.accountVerificationKtpGuide);
                      break;
                    case CameraOverlayFor.selfie:
                      context.goNamed(AppRoutes.accountVerificationSelfieGuide);
                      break;
                    case CameraOverlayFor.npwp:
                      context.goNamed(
                        AppRoutes.accountVerificationNpwp,
                        extra: {'aditionalData': widget.aditionalData},
                      );
                      break;
                    default:
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _cameraDenied({
    required String text,
    required String btnText,
    required Function() onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          MainButton(
            label: btnText,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  String _titleAppbar(AppLocalizations t, String cameraOverlayFor) {
    switch (cameraOverlayFor) {
      case CameraOverlayFor.ktp:
        return t.lblKtpPhoto;
      case CameraOverlayFor.selfie:
        return t.lblSelfiePhoto;
      case CameraOverlayFor.npwp:
        return 'Foto NPWP';
      default:
        return '-';
    }
  }

  String _info(AppLocalizations t, String cameraOverlayFor) {
    switch (cameraOverlayFor) {
      case CameraOverlayFor.ktp:
        return t.lblKtpOverlayDesc;
      case CameraOverlayFor.selfie:
        return t.lblKtpOverlayDesc;
      case CameraOverlayFor.npwp:
        return t.lblNpwpOverlayDesc;
      default:
        return '-';
    }
  }

  void _onCapture(
    BuildContext context,
    XFile xFile,
    String cameraOverlayFor,
  ) {
    switch (cameraOverlayFor) {
      case CameraOverlayFor.ktp:
        EasyLoading.show();
        recognizeNikFromKtp(xFile.path).then((value) {
          EasyLoading.dismiss();
          CardOverlay overlay = CardOverlay.byFormat(format);
          context.goNamed(
            AppRoutes.accountVerificationKtpResult,
            extra: {
              'xFile': xFile,
              'aspectRatio': overlay.ratio,
              'nik': value[0],
              'name': value[1],
              'pob': value[2],
              'dob': value[3],
            },
          );
        }).onError((error, stackTrace) {
          EasyLoading.dismiss();
          CardOverlay overlay = CardOverlay.byFormat(format);
          context.goNamed(
            AppRoutes.accountVerificationKtpResult,
            extra: {
              'xFile': xFile,
              'aspectRatio': overlay.ratio,
            },
          );
        });
        break;
      case CameraOverlayFor.selfie:
        context.goNamed(
          AppRoutes.accountVerificationSelfie,
          extra: {
            'xFile': xFile,
            'backScreen': AppRoutes.accountVerificationSelfieGuide,
            // 'aspectRatio': overlay.ratio,
            // 'nik': value,
          },
        );
        break;
      case CameraOverlayFor.npwp:
        CardOverlay overlay = CardOverlay.byFormat(format);
        context.goNamed(
          AppRoutes.accountVerificationNpwp,
          extra: {
            'xFile': xFile,
            'aspectRatio': overlay.ratio,
            'aditionalData': widget.aditionalData,
          },
        );
        break;
      default:
    }
  }

  Future<List<String?>> recognizeNikFromKtp(String path) async {
    if (path.isEmpty) {
      return [];
    }
    try {
      ml_kit.InputImage? inputImage = ml_kit.InputImage.fromFilePath(path);

      final textRecognizer =
          ml_kit.TextRecognizer(script: ml_kit.TextRecognitionScript.latin);
      final ml_kit.RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      List<String> nikParams = ["nik", "aik"];
      ml_kit.TextLine? nikLine;
      List<String> nameParams = [
        "nama",
        "nema",
        "name",
        "nana",
        "namu",
        "nata",
        "bana",
        "naa",
        "namma",
        "namta"
      ];
      ml_kit.TextLine? nameLine;
      List<String> ttlParams = ["tempat", "enpat", "tgl", "lahir", "tenpe"];
      ml_kit.TextLine? ttlLine;
      List<String> genderParams = [
        "kelamin",
        "keiamin",
        "jenis",
        "jernis",
        "jeris",
        "jers",
        "jens",
        "ilamin",
        "kelan",
      ];
      ml_kit.TextLine? genderLine;

      for (var block in recognisedText.blocks) {
        appPrint(
            "block${recognisedText.blocks.indexOf(block)}: ${block.text}, bounding box: ${block.boundingBox}");

        for (var line in block.lines) {
          appPrint(
              "line${block.lines.indexOf(line)}: ${line.text}, bounding box: ${line.boundingBox}, cornerPoints: ${line.cornerPoints}");
          if (isValidOcrText(blockOrLine: line, params: nikParams)) {
            nikLine = checkAndGet(line: line, params: nikParams);
          }
          if (isValidOcrText(blockOrLine: line, params: nameParams)) {
            nameLine = checkAndGet(
              line: line,
              params: nameParams,
            );
          }
          if (isValidOcrText(blockOrLine: line, params: ttlParams)) {
            ttlLine = checkAndGet(
              line: line,
              params: ttlParams,
            );
          }
          if (isValidOcrText(blockOrLine: line, params: genderParams)) {
            genderLine = checkAndGet(
              line: line,
              params: genderParams,
            );
          }
        }
      }

      appPrint(
          "nikLine: ${nikLine?.text}, boundingbox: ${nikLine?.boundingBox}, cornerPoints: ${nikLine?.cornerPoints}");
      appPrint(
          "nameLine: ${nameLine?.text}, boundingbox: ${nameLine?.boundingBox}, cornerPoints: ${nameLine?.cornerPoints}");
      appPrint(
          "ttlLine: ${ttlLine?.text}, boundingbox: ${ttlLine?.boundingBox}, cornerPoints: ${ttlLine?.cornerPoints}");
      appPrint(
          "genderLine: ${genderLine?.text}, boundingbox: ${genderLine?.boundingBox}, cornerPoints: ${genderLine?.cornerPoints}");

      String? nik;
      String? name;
      String? ttl;
      for (var block in recognisedText.blocks) {
        for (var line in block.lines) {
          // get nik
          if (nikLine?.boundingBox != null && nameLine?.boundingBox != null) {
            if (line.boundingBox.bottom > nikLine!.boundingBox.top &&
                line.boundingBox.bottom < nameLine!.boundingBox.top) {
              final intRegex = RegExp(r"\d");
              int numberLength = intRegex.allMatches(line.text).length;
              int wordLength = line.text.replaceAll(RegExp(r"\d"), "").length;
              if (numberLength > wordLength && line.text.length > 12) {
                nik = line.text;
              }
            }
            if ((nik ?? "").isEmpty) {
              final intRegex = RegExp(r"\d");
              int numberLength = intRegex.allMatches(line.text).length;
              int wordLength = line.text.replaceAll(RegExp(r"\d"), "").length;
              if (numberLength > wordLength && line.text.length > 12) {
                nik = line.text;
              }
            }
          }
          // get name
          if (nikLine?.boundingBox != null &&
              nameLine?.boundingBox != null &&
              ttlLine?.boundingBox != null) {
            if (line.boundingBox.top > nikLine!.boundingBox.bottom &&
                line.boundingBox.bottom < ttlLine!.boundingBox.top) {
              if (line.text != nameLine?.text) {
                name = line.text;
              }
            }
            if (name == null && genderLine?.boundingBox != null) {
              if (line.boundingBox.top > nikLine.boundingBox.bottom &&
                  line.boundingBox.bottom < genderLine!.boundingBox.top) {
                if (line.text != nameLine?.text && line.text != ttlLine?.text) {
                  name = line.text;
                }
              }
            }
          }
          // get ttl
          if (nameLine?.boundingBox != null &&
              ttlLine?.boundingBox != null &&
              genderLine?.boundingBox != null) {
            if (line.boundingBox.top > nameLine!.boundingBox.bottom &&
                line.boundingBox.bottom < genderLine!.boundingBox.top) {
              if (line.text != ttlLine?.text) {
                ttl = line.text;
              }
            }
            if (ttl == null && line.text.contains(", ")) {
              ttl = line.text;
            }
          }
        }
      }

      appPrint("nik: $nik");
      appPrint("name: $name");
      appPrint("ttl: $ttl");

      var nikNew = normalizeNikText(nik ?? "");
      var nameNew = name?.replaceAll(":", "").replaceAll(": ", "");
      ttl = ttl ?? "";
      String? pob =
          ttl.split(", ").asMap()[0]?.replaceAll(":", "").replaceAll(": ", "");
      String? dob =
          ttl.split(", ").asMap()[1]?.replaceAll(":", "").replaceAll(": ", "");
      if ((dob ?? "").isEmpty) {
        pob =
            ttl.split(" ").asMap()[0]?.replaceAll(":", "").replaceAll(": ", "");
        dob = "${ttl.split(" ").asMap()[1]}${ttl.split(" ").asMap()[2]}"
            .replaceAll(":", "")
            .replaceAll(": ", "");
      }
      var pobNew = normalizePobText(pob ?? "");
      var dobNew = normalizeDobText(dob ?? "");

      return [nikNew, nameNew, pobNew, dobNew];
    } catch (e) {
      appPrint("error ocr: $e");
      return [];
    }
  }

  Future<List<String?>> recognizeNikFromKtpOld(path) async {
    if (path != '') {
      ml_kit.InputImage? inputImage = ml_kit.InputImage.fromFilePath(path);

      final textRecognizer =
          ml_kit.TextRecognizer(script: ml_kit.TextRecognitionScript.latin);
      final ml_kit.RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      // String result = '';

      /// [INFO]
      /// variables to hold the data
      String nikResult = "";
      String nameResult = "";
      String tempatTglLahirResult = "";
      String tempatLahirResult = "";
      String tglLahirResult = "";
      String jenisKelaminResult = "";
      String alamatFullResult = "";
      String alamatResult = "";
      String rtrwResult = "";
      String kelDesaResult = "";
      String kecamatanResult = "";
      String agamaResult = "";
      String statusKawinResult = "";
      String pekerjaanResult = "";
      String kewarganegaraanResult = "";

      /// [INFO]
      /// variables to hold the Rect of the Field (the data field positioned)
      Rect? nikRect;
      Rect? namaRect;
      Rect? alamatRect;
      Rect? rtrwRect;
      Rect? kelDesaRect;
      Rect? kecamatanRect;
      Rect? jenisKelaminRect;
      Rect? tempatTanggalLahirRect;
      Rect? agamaRect;
      Rect? statusKawinRect;
      Rect? pekerjaanRect;
      Rect? kewarganegaraanRect;

      /// [INFO]
      /// Search the Field first (not the value)
      try {
        for (int i = 0; i < recognisedText.blocks.length; i++) {
          for (int j = 0; j < recognisedText.blocks[i].lines.length; j++) {
            for (int k = 0;
                k < recognisedText.blocks[i].lines[j].elements.length;
                k++) {
              final data = recognisedText.blocks[i].lines[j].elements[k];

              debugPrint(
                  "${"b$i l$j e$k ${data.text.toLowerCase().trim().replaceAll(" ", "")}"} ${data.boundingBox.center}");

              if (checkNikField(data.text)) {
                nikRect = data.boundingBox;
                debugPrint("nik field detected");
              }

              if (checkNamaField(data.text)) {
                namaRect = data.boundingBox;
                debugPrint("nama field detected");
              }

              if (checkTglLahirField(data.text)) {
                tempatTanggalLahirRect = data.boundingBox;
                debugPrint("tempat tgllahir field detected");
              }

              if (checkJenisKelaminField(data.text)) {
                jenisKelaminRect = data.boundingBox;
                debugPrint("jenis kelamin field detected");
              }

              if (checkAlamatField(data.text)) {
                alamatRect = data.boundingBox;
                debugPrint("alamat field detected");
              }

              if (checkRtRwField(data.text)) {
                rtrwRect = data.boundingBox;
                debugPrint("RT/RW field detected");
              }

              if (checkKelDesaField(data.text)) {
                kelDesaRect = data.boundingBox;
                debugPrint("kelurahan / desa field detected");
              }

              if (checkKecamatanField(data.text)) {
                kecamatanRect = data.boundingBox;
                debugPrint("kecamatan field detected");
              }

              if (checkAgamaField(data.text)) {
                agamaRect = data.boundingBox;
                debugPrint("agama field detected");
              }

              if (checkKawinField(data.text)) {
                statusKawinRect = data.boundingBox;
                debugPrint("statusKawin field detected");
              }

              if (checkPekerjaanField(data.text)) {
                pekerjaanRect = data.boundingBox;
                debugPrint("pekerjaan field detected");
              }

              if (checkKewarganegaraanField(data.text)) {
                kewarganegaraanRect = data.boundingBox;
                debugPrint("kewarganegaraan field detected");
              }
            }
          }
        }
      } catch (e) {
        debugPrint(e.toString());
        throw Exception("iteration failed");
      }

      /// [INFO]
      /// Check if the Field Rect is found
      debugPrint("nik rect $nikRect");
      debugPrint("nama rect $namaRect");
      debugPrint("alamat rect $alamatRect");
      debugPrint("rt rw rect $rtrwResult");
      debugPrint("kelDesa rect $kelDesaRect");
      debugPrint("kecamatan rect $kecamatanRect");
      debugPrint("jenis Kelamin rect $jenisKelaminRect");
      debugPrint("tempatTanggalLahir rect $tempatTanggalLahirRect");
      debugPrint("agama rect $agamaRect");
      debugPrint("statusKawin rect $statusKawinRect");
      debugPrint("pekerjaan rect $pekerjaanRect");
      debugPrint("kewarganegaraan rect $kewarganegaraanRect");

      /// [INFO]
      /// after get the Field Rect, we find the value based on field rect
      try {
        for (int i = 0; i < recognisedText.blocks.length; i++) {
          for (int j = 0; j < recognisedText.blocks[i].lines.length; j++) {
            final data = recognisedText.blocks[i].lines[j];

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: nikRect,
              andAbove: namaRect,
            )) {
              if (data.text.toLowerCase() != "nik") {
                debugPrint("------ nik");
                nikResult = ("$nikResult ${data.text}").trim();
                var result = normalizeNikText(nikResult);
                nikResult = result;
                debugPrint(nikResult);
              }
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: namaRect,
              andAbove: tempatTanggalLahirRect,
            )) {
              if (data.text.toLowerCase() != "nama") {
                debugPrint("------ name");
                nameResult = ("$nameResult ${data.text}").trim();
                var result = normalizeNamaText(nameResult);
                nameResult = result;
                debugPrint(nameResult);
              }
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: tempatTanggalLahirRect,
              andAbove: jenisKelaminRect,
            )) {
              if (data.text.toLowerCase() != "TempatTgl Lahir") {
                debugPrint("------ TempatTgl Lahir");
                tempatTglLahirResult =
                    ("$tempatTglLahirResult ${data.text}").trim();
                var splitedTTL = tempatTglLahirResult.split(',');
                tempatLahirResult = splitedTTL[0].replaceAll(":", "");
                tglLahirResult = splitedTTL[1];
                debugPrint(tempatTglLahirResult);
              }
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: jenisKelaminRect,
              andAbove: alamatRect,
            )) {
              if (data.text.toLowerCase() != "jenis kelamin" ||
                  data.text.toLowerCase() != "jenis" ||
                  data.text.toLowerCase() != "kelamin") {
                debugPrint("------ jenis kelamin");
                jenisKelaminResult =
                    ("$jenisKelaminResult ${data.text}").trim();
                var result = normalizeJenisKelaminText(jenisKelaminResult);
                jenisKelaminResult = result;
                debugPrint(jenisKelaminResult);
              }
            }

            if (isInside(data.boundingBox, jenisKelaminRect)) {
              jenisKelaminResult = "$jenisKelaminResult ${data.text}";
              debugPrint("------ jenis kelamin ");
              debugPrint(rtrwResult);
            }

            if (isInside3Rect(
                isThisRect: data.boundingBox,
                isInside: alamatRect,
                andAbove: agamaRect)) {
              alamatFullResult = "$alamatFullResult ${data.text}";
              debugPrint("------ alamat");

              debugPrint(alamatFullResult);
            }

            if (isInside3Rect(
                isThisRect: data.boundingBox,
                isInside: alamatRect,
                andAbove: rtrwRect)) {
              alamatResult = "$alamatResult ${data.text}";
              debugPrint("------ alamat");
              var result = normalizeAlamatText(alamatResult);
              alamatResult = result;
              debugPrint(alamatResult);
            }

            if (isInside3Rect(
                isThisRect: data.boundingBox,
                isInside: rtrwRect,
                andAbove: kelDesaRect)) {
              rtrwResult = "$rtrwResult ${data.text}";
              debugPrint("------ rtrw");
              var result = normalizeAlamatText(rtrwResult);
              rtrwResult = result;
              debugPrint(rtrwResult);
            }

            if (isInside3Rect(
                isThisRect: data.boundingBox,
                isInside: kelDesaRect,
                andAbove: kecamatanRect)) {
              kelDesaResult = "$kelDesaResult ${data.text}";
              debugPrint("------ keldes");
              var result = normalizeAlamatText(kelDesaResult);
              kelDesaResult = result;
              debugPrint(kelDesaResult);
            }

            if (isInside3Rect(
                isThisRect: data.boundingBox,
                isInside: kecamatanRect,
                andAbove: agamaRect)) {
              kecamatanResult = "$kecamatanResult ${data.text}";
              debugPrint("------ kecamatan");
              var result = normalizeAlamatText(kecamatanResult);
              kecamatanResult = result;
              debugPrint(kecamatanResult);
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: agamaRect,
              andAbove: statusKawinRect,
            )) {
              if (data.text.toLowerCase() != "agama") {
                debugPrint("------ agama");
                agamaResult = ("$agamaResult ${data.text}").trim();
                var result = normalizeAgamaText(agamaResult);
                agamaResult = result;
                debugPrint(agamaResult);
              }
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: statusKawinRect,
              andAbove: pekerjaanRect,
            )) {
              if (data.text.toLowerCase() != "status perkawinan" ||
                  data.text.toLowerCase() != "status" ||
                  data.text.toLowerCase() != "perkawinan") {
                debugPrint("------ status perkawinan");
                statusKawinResult = ("$statusKawinResult ${data.text}").trim();
                var result = normalizeKawinText(statusKawinResult);
                statusKawinResult = result;
                debugPrint(statusKawinResult);
              }
            }

            if (isInside3Rect(
              isThisRect: data.boundingBox,
              isInside: pekerjaanRect,
              andAbove: kewarganegaraanRect,
            )) {
              if (data.text.toLowerCase() != "pekerjaan") {
                debugPrint("------ pekerjaan");
                pekerjaanResult = ("$pekerjaanResult ${data.text}").trim();
                var result = normalizePekerjaanText(pekerjaanResult);
                pekerjaanResult = result;
                debugPrint(pekerjaanResult);
              }
            }

            if (isInside(data.boundingBox, kewarganegaraanRect)) {
              kewarganegaraanResult = "$kewarganegaraanResult ${data.text}";
              debugPrint("------ status kewarganegaraan result ");
              var result = normalizeKewarganegaraanText(kewarganegaraanResult);
              kewarganegaraanResult = result;
              debugPrint(kewarganegaraanResult);
            }
          }
        }
      } catch (e) {
        debugPrint(e.toString());
        throw Exception("iteration failed ");
      }

      /// [INFO]
      /// check the result value
      appPrint("result before normalization");
      appPrint("nik : $nikResult");
      appPrint("nama : $nameResult");
      appPrint("tempatLahir : $tempatLahirResult");
      appPrint("tglLahir : $tglLahirResult");
      appPrint("jenis kelamin : $jenisKelaminResult");
      appPrint("alamat full : $alamatFullResult");
      appPrint("rt rw : $rtrwResult");
      appPrint("kel desa : $kelDesaResult");
      appPrint("kecamatan : $kecamatanResult");
      appPrint("agama : $agamaResult");
      appPrint("status kawin : $statusKawinResult");
      appPrint("pekerjaan : $pekerjaanResult");
      appPrint("kewarganegaraan : $kewarganegaraanResult");

      return [nikResult, nameResult, tempatLahirResult, tglLahirResult];
    } else {
      return [];
    }
  }
}
