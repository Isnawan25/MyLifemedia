import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

String formatTanggal(String? tanggal) {
  if (tanggal == null || tanggal.isEmpty) return "-";
  try {
    final date = DateTime.parse(tanggal).toLocal();
    return DateFormat("d MMM yyyy", "id_ID").format(date);
  } catch (e, st) {
    debugPrint("formatTanggal: gagal parse '$tanggal' -> $e");
    debugPrint(st.toString());
    return tanggal; // fallback
  }
}

String formatTanggalWaktu(String? tanggal) {
  if (tanggal == null || tanggal.isEmpty) return "-";
  try {
    final date = DateTime.parse(tanggal).toLocal();
    return DateFormat("d MMM yyyy • HH.mm", "id_ID").format(date);
  } catch (e, st) {
    debugPrint("formatTanggalWaktu: gagal parse '$tanggal' -> $e");
    debugPrint(st.toString());
    return tanggal;
  }
}
