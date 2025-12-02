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

String formatNotifikasiShort(String? tanggal) {
  if (tanggal == null || tanggal.isEmpty) return "-";

  try {
    final date = DateTime.parse(tanggal).toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final notifDay = DateTime(date.year, date.month, date.day);

    final difference = today.difference(notifDay).inDays;

    if (difference == 0) {
      // Hari ini -> tampilkan jam
      return DateFormat("HH.mm").format(date);
    } else if (difference == 1) {
      return "Kemarin";
    } else {
      // Lebih dari kemarin -> tampilkan dd/MM/yy
      return DateFormat("dd/MM/yy").format(date);
    }
  } catch (e) {
    return tanggal;
  }
}

