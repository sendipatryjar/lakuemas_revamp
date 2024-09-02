import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

bool isValidOcrText(
    {required dynamic blockOrLine, required List<String> params}) {
  bool result = false;
  for (var param in params) {
    if (blockOrLine.text.toLowerCase().contains(param)) {
      result = true;
      break;
    }
  }
  return result;
}

TextLine? checkAndGet({required TextLine line, required List<String> params}) {
  TextLine? result;
  for (var param in params) {
    if (line.text.toLowerCase().contains(param.toLowerCase())) {
      result = line;
      break;
    }
  }
  return result;
}

bool checkNikField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "nik";
}

bool checkNamaField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "nama" ||
      text == "nema" ||
      text == "name" ||
      text == "nana" ||
      text == "namu";
}

bool checkTglLahirField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "lahir" ||
      text == "tempat" ||
      text == "tempatigllahir" ||
      text == "empatgllahir" ||
      text == "tempat/tgl" ||
      text == "tempattgllahir";
}

bool checkJenisKelaminField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kelamin" || text == "jenis" || text == "jeris";
}

bool checkAlamatField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "alamat" ||
      text == "lamat" ||
      text == "alaahom" ||
      text == "alama" ||
      text == "alamao" ||
      text == "alamarw";
}

bool checkRtRwField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "rt/rw" ||
      text == "rw " ||
      text == "rt" ||
      text == "rtirw" ||
      text == "rtrw";
}

bool checkKelDesaField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kel/desa" ||
      text == "helldesa" ||
      text == "kelldesa" ||
      text == "ketdesa";
}

bool checkKecamatanField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kecamatan" || dataText.contains("kecamatan");
}

bool checkAgamaField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "agama" || text == "gama";
}

bool checkKawinField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kawin" || text == "perkawinan" || text == "perkawinan:";
}

bool checkPekerjaanField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kerja" || text == "pekerjaan";
}

bool checkKewarganegaraanField(String dataText) {
  final text = dataText.toLowerCase().trim();
  return text == "kewarganegaraan" ||
      text == "negaraan" ||
      text == "kewarganegaraan:";
}

/// [INFO]
/// check is inside the rect or not
bool isInside(Rect? rect, Rect? isInside) {
  if (rect == null) {
    return false;
  }

  if (isInside == null) {
    return false;
  }

  if (rect.center.dy <= isInside.bottom &&
      rect.center.dy >= isInside.top &&
      rect.center.dy >= isInside.right &&
      rect.center.dx <= 650) {
    return true;
  }

  return false;
}

/// [INFO]
/// check is inside the 3 rect (for addresses)
bool isInside3Rect({Rect? isThisRect, Rect? isInside, Rect? andAbove}) {
  if (isThisRect == null) {
    return false;
  }

  if (isInside == null) {
    return false;
  }

  if (andAbove == null) {
    return false;
  }

  if (isThisRect.center.dy <= andAbove.top &&
      isThisRect.center.dy >= isInside.top &&
      isThisRect.center.dx >= isInside.left) {
    return true;
  }

  return false;
}
