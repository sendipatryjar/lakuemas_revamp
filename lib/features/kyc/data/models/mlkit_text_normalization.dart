import '../../../../cores/utils/app_utils.dart';

String normalizeNikText(String text) {
  String result = text.trim();

  result =
      result.replaceAll("NIK", "").replaceAll(":", "").replaceAll(": ", "");
  result = result.replaceAll(' ', '');
  result = result.replaceAll('a', '');
  result = result.replaceAll('O', '0');
  result = result.replaceAll('o', '0');
  result = result.replaceAll('D', '0');
  result = result.replaceAll('S', '5');
  result = result.replaceAll('B', '8');
  result = result.replaceAll('b', '6');
  result = result.replaceAll('L', '6');
  result = result.replaceAll('g', '9');
  result = result.replaceAll('?', '7');
  result = result.replaceAll('l', '1');
  result = result.replaceAll('I', '1');
  result = result.replaceAll('i', '1');
  result = result.replaceAll('}', '1');
  result = result.replaceAll('{', '1');
  result = result.replaceAll(']', '1');
  result = result.replaceAll('[', '1');
  result = result.replaceAll('|', '1');
  result = result.replaceAll('!', '1');
  result = result.replaceAll('T', '1');
  result = result.replaceAll('t', '1');
  result = result.replaceAll('e', '2');
  result = result.replaceAll(':', '');
  result = result.replaceAll('*', '');

  return result;
}

String normalizePobText(String text) {
  if (text.contains(RegExp(r'[a-z]'))) {
    String result = text;
    if (result.contains("/")) {
      result = result.replaceFirst("T", "");
    }
    result = result.replaceAll(RegExp('[^A-Z]'), "");
    result = result.replaceFirst("T", "");
    result = result.replaceFirst("L", "");
    return result.trim();
  }

  return text.trim();
}

String normalizeNamaText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("NEMA", "")
      .replaceAll("NAME", "")
      .replaceAll(":", "")
      .trim();

  return result;
}

String? normalizeDobText(String text) {
  if ((text.length == 10) && (text.contains(" ") == false)) {
    return text;
  }
  String result = text.toUpperCase().trim();

  result = result.replaceAll("-", "");
  result = result.replaceAll(".", "");
  result = result.replaceAll(' ', '');
  result = result.replaceAll('O', '0');
  result = result.replaceAll('o', '0');
  result = result.replaceAll('D', '0');
  result = result.replaceAll('S', '5');
  result = result.replaceAll('B', '8');
  result = result.replaceAll('b', '6');
  result = result.replaceAll('L', '1');
  result = result.replaceAll('g', '9');
  result = result.replaceAll('?', '7');
  result = result.replaceAll('l', '1');
  result = result.replaceAll('I', '1');
  result = result.replaceAll('i', '1');
  result = result.replaceAll('}', '1');
  result = result.replaceAll('{', '1');
  result = result.replaceAll(']', '1');
  result = result.replaceAll('[', '1');
  result = result.replaceAll('|', '1');
  result = result.replaceAll('!', '1');
  result = result.replaceAll('T', '1');
  result = result.replaceAll('t', '1');
  result = result.replaceAll(':', '');
  result = result.replaceAll('*', '');

  if (result.toLowerCase().contains("nu")) {
    return null;
  }

  if (result.length == 8) {
    var year = result.substring(4);
    if (year.length < 4 && (year.startsWith("9") || year.startsWith("8"))) {
      year = "1$year";
    }
    result = "${result.substring(0, 2)}-${result.substring(2, 4)}-$year";
    return result;
  }

  return null;
}

String normalizeJenisKelaminText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("GOL. DARAHO", "")
      .replaceAll("GOL. DARAH", "")
      .replaceAll("GOL DARAH", "")
      .replaceAll("LAKFEARI", "")
      .replaceAll("LAKFLAK", "")
      .replaceAll("KELAMIN", "")
      .replaceAll("KEIAMIN", "")
      .replaceAll("JENIS", "")
      .replaceAll("DENIS", "")
      .replaceAll("DARAH ", "")
      .replaceAll("ENIS", "")
      .replaceAll("DARA", "")
      .replaceAll("GO", "")
      .replaceAll("L. ", "")
      .replaceAll(" H0", "")
      .replaceAll(" HO", "")
      .replaceAll(":", "")
      .replaceAll(" 0", "")
      .replaceAll(" O", "")
      .trim();

  if (result == "LAK-LAK" ||
      result == "LAKI-LAK" ||
      result == "AK-LAK" ||
      result == "LAKFLAKI" ||
      result == "LAKHLAK" ||
      result == "LAKFEAKI" ||
      result == "LAKELAKI" ||
      result == "LAKELAK" ||
      result == "LAKHLAKI" ||
      result == "LAKHEAK" ||
      result == "LAK-LAKI" ||
      result == "LAKHEAKI" ||
      result == "LAKIFEAK" ||
      result == "LAKFEAKE" ||
      result == "LAKIFEAKI" ||
      result == "LAKFEAR" ||
      result == "LAKFLAK" ||
      result == "LAK-LAKE" ||
      result == "LAK-EAK" ||
      result == "LAKFEAK" ||
      result == "LAK-EAKI" ||
      result == "LAKELAKE" ||
      result == "HAKLEAKE" ||
      result == "HAKEAKE") {
    return "Laki-Laki";
  }

  return result;
}

String normalizeAlamatText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("RI/KEILDESAA", "")
      .replaceAll("RTKELIIDESAA", "")
      .replaceAll("TIKEL/LDESA", "")
      .replaceAll("RTKEL/DESAA", "")
      .replaceAll("RTKELVDESA", "")
      .replaceAll("RIKELBESAA", "")
      .replaceAll("KECAMATAN", "")
      .replaceAll("KEL/DESSA", "")
      .replaceAll("KELIDESAA", "")
      .replaceAll("KELI/DESA", "")
      .replaceAll("KELILDESA", "")
      .replaceAll("KELIIDESA", "")
      .replaceAll("KELILDESA", "")
      .replaceAll("KEL/ DESA", "")
      .replaceAll("KELLIDESA", "")
      .replaceAll("KECAMATDN", "")
      .replaceAll("HECAMATAN", "")
      .replaceAll("KEILIBESA", "")
      .replaceAll("KELILBESA", "")
      .replaceAll("NECAMATAN", "")
      .replaceAll("KELL/DESA", "")
      .replaceAll("KEL/DESAA", "")
      .replaceAll("KELLDESAA", "")
      .replaceAll("KEL/DESA", "")
      .replaceAll("KELLIBES", "")
      .replaceAll("KEI/DESA", "")
      .replaceAll("HELLDESA", "")
      .replaceAll("KELIBESA", "")
      .replaceAll("KELLBESA", "")
      .replaceAll("KEL/DESA", "")
      .replaceAll("KELLDESA", "")
      .replaceAll("KEILDESA", "")
      .replaceAll("KEILBESA", "")
      .replaceAll("KELIDESA", "")
      .replaceAll("KEVDESA", "")
      .replaceAll("KEVBESA", "")
      .replaceAll("KELBESA", "")
      .replaceAll("KE/DESA", "")
      .replaceAll("ELLDESA", "")
      .replaceAll("KELDESA", "")
      .replaceAll("ALAMAT", "")
      .replaceAll("LAMAT", "")
      .replaceAll("RTIRW", "")
      .replaceAll("RT/RW", "")
      .replaceAll("ELDESA", "")
      .replaceAll("KEVDES", "")
      .replaceAll("RTIRWN", "")
      .replaceAll(" TIA ", " ")
      .replaceAll("RT ", "")
      .replaceAll("RT/ ", "")
      .replaceAll("RW ", "")
      .replaceAll(":", "")
      .replaceAll("=", "")
      .replaceAll("  ", " ")
      .trim();

  appPrint("result result result result result $result");

  return result;
}

String normalizeKawinText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("PERKAWINAN", "")
      .replaceAll("PERKAWINA", "")
      .replaceAll("STATUS", "")
      .replaceAll("TATUS", "")
      .replaceAll("STAFUS", "")
      .replaceAll("R ", "")
      .replaceAll("T ", "")
      .replaceAll(":", "")
      .trim();

  if (result == "BELUMKAWINE") {
    return 'BELUM KAWIN';
  }

  return result;
}

String normalizePekerjaanText(String text) {
  String result = text.toUpperCase();

  result = result.replaceAll("PEKERJAAN", "").replaceAll(":", "").trim();

  if (result == "PELAJARIMAHASISSWA" ||
      result == "PELAJARIMAHASISWA" ||
      result == "PELAJARIMAHASISVWA" ||
      result == "PELAJARMAHASISWA") {
    return "Pelajar/Mahasiswa";
  }
  if (result == "PEGAVWAI SWASTA") {
    return "PEGAWAI SWASTA";
  }
  return result;
}

String normalizeKewarganegaraanText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("KEWARGANEGARAAN", "")
      .replaceAll("EUMUR", "")
      .replaceAll("HDUP", "")
      .replaceAll("H ", "")
      .replaceAll("N ", "")
      .replaceAll(":", "")
      .trim();

  return result;
}

String normalizeAgamaText(String text) {
  String result = text.toUpperCase();

  result = result
      .replaceAll("AGAMA", "")
      .replaceAll(":", "")
      .replaceAll("GAMA", "")
      .trim();

  if (result == "SLAM" ||
      result == "AM" ||
      result == "SLA AM" ||
      result == "ISLU AM" ||
      result == "SL LAM" ||
      result == "ISLAME" ||
      result == "SLA M" ||
      result == "ISL AM" ||
      result == "ISLA AM" ||
      result == "S AM" ||
      result == "SLL AM" ||
      result == "SL AM" ||
      result == "SE AM" ||
      result == "1SLAM" ||
      result == "ISLAMM" ||
      result == "SLA" ||
      result == "LAM" ||
      result == "1S AME" ||
      result == "1SLANM") {
    result = "Islam";
  }
  appPrint(result);
  if (result.trim().isEmpty) {
    return "";
  } else {
    return result;
  }
}
