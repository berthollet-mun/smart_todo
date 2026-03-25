import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateTimeHelper {
  DateTimeHelper._();

  // ═══════════════════════════════════════════════════════
  // FORMATS
  // ═══════════════════════════════════════════════════════
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayDate = DateFormat('dd/MM/yyyy');
  static final DateFormat _displayDateTime = DateFormat('dd/MM/yyyy HH:mm');

  // ─── Formats avec locale : créés à la demande pour éviter
  //     les crashs si la locale 'fr' n'est pas initialisée ─────
  static DateFormat _safeFr(String pattern) {
    try {
      return DateFormat(pattern, 'fr');
    } catch (_) {
      return DateFormat(pattern);
    }
  }

  // ═══════════════════════════════════════════════════════
  // FORMATER POUR L'API
  // ═══════════════════════════════════════════════════════

  /// DateTime → "2024-12-31"
  static String toApiDate(DateTime date) {
    return _apiDateFormat.format(date);
  }

  /// hour + minute → "18:00:00"
  static String toApiTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:00';
  }

  /// TimeOfDay → "18:00:00"
  static String timeOfDayToApi(TimeOfDay timeOfDay) {
    return toApiTime(timeOfDay.hour, timeOfDay.minute);
  }

  /// Date d'aujourd'hui au format API → "2024-12-31"
  static String todayApiFormat() => toApiDate(DateTime.now());

  // ═══════════════════════════════════════════════════════
  // PARSER DEPUIS L'API
  // ═══════════════════════════════════════════════════════

  /// "2024-12-31" → DateTime?
  static DateTime? parseApiDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return _apiDateFormat.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// "2024-01-15 14:30:00" → DateTime?
  static DateTime? parseApiDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      return DateTime.parse(dateTimeStr);
    } catch (_) {
      return null;
    }
  }

  /// "18:00:00" → {hour: 18, minute: 0}
  static Map<String, int>? parseApiTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final parts = timeStr.split(':');
      return {
        'hour': int.parse(parts[0]),
        'minute': int.parse(parts[1]),
      };
    } catch (_) {
      return null;
    }
  }

  /// "18:00:00" → TimeOfDay
  static TimeOfDay? parseApiTimeOfDay(String? timeStr) {
    final parsed = parseApiTime(timeStr);
    if (parsed == null) return null;
    return TimeOfDay(hour: parsed['hour']!, minute: parsed['minute']!);
  }

  /// "18:00:00" → hour (int)
  static int? parseHour(String? timeStr) {
    final parsed = parseApiTime(timeStr);
    return parsed?['hour'];
  }

  /// "18:00:00" → minute (int)
  static int? parseMinute(String? timeStr) {
    final parsed = parseApiTime(timeStr);
    return parsed?['minute'];
  }

  // ═══════════════════════════════════════════════════════
  // FORMATER POUR L'AFFICHAGE
  // ═══════════════════════════════════════════════════════

  /// "2024-12-31" → "31/12/2024"
  static String displayDate(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return '';
    return _displayDate.format(date);
  }

  /// "2024-12-31" → "31 décembre 2024"
  static String displayDateFull(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return '';
    try {
      return _safeFr('dd MMMM yyyy').format(date);
    } catch (_) {
      return _displayDate.format(date);
    }
  }

  /// "18:00:00" → "18:00"
  static String displayTime(String? apiTime) {
    if (apiTime == null || apiTime.isEmpty) return '';
    try {
      final parts = apiTime.split(':');
      return '${parts[0]}:${parts[1]}';
    } catch (_) {
      return apiTime ?? '';
    }
  }

  /// DateTime → "31/12/2024 18:00"
  static String displayDateTime(DateTime date) {
    return _displayDateTime.format(date);
  }

  /// "2024-01-15 14:30:00" → "15/01/2024 14:30"
  static String displayApiDateTime(String? apiDateTime) {
    final date = parseApiDateTime(apiDateTime);
    if (date == null) return '';
    return _displayDateTime.format(date);
  }

  /// DateTime → "31 déc"
  static String displayDayMonth(DateTime date) {
    try {
      return _safeFr('dd MMM').format(date);
    } catch (_) {
      return DateFormat('dd MMM').format(date);
    }
  }

  /// "2024-12-31" → "31 déc"
  static String displayApiDayMonth(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return '';
    return displayDayMonth(date);
  }

  /// DateTime → "Janvier 2024"
  static String displayMonthYear(DateTime date) {
    try {
      return _safeFr('MMMM yyyy').format(date);
    } catch (_) {
      return DateFormat('MMMM yyyy').format(date);
    }
  }

  /// DateTime → "Lundi"
  static String displayDayName(DateTime date) {
    try {
      return _safeFr('EEEE').format(date);
    } catch (_) {
      return DateFormat('EEEE').format(date);
    }
  }

  /// DateTime → "Lun"
  static String displayDayNameShort(DateTime date) {
    try {
      return _safeFr('EEE').format(date);
    } catch (_) {
      return DateFormat('EEE').format(date);
    }
  }

  /// "2024-12-31" + "18:00:00" → "31/12/2024 à 18:00"
  static String displayDateAndTime(String? apiDate, String? apiTime) {
    final dateStr = displayDate(apiDate);
    final timeStr = displayTime(apiTime);
    if (dateStr.isEmpty && timeStr.isEmpty) return '';
    if (dateStr.isEmpty) return timeStr;
    if (timeStr.isEmpty) return dateStr;
    return '$dateStr à $timeStr';
  }

  // ═══════════════════════════════════════════════════════
  // COMPARAISONS
  // ═══════════════════════════════════════════════════════

  /// Vérifie si la date est aujourd'hui
  static bool isToday(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Vérifie si la date est demain
  static bool isTomorrow(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Vérifie si la date est hier
  static bool isYesterday(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Vérifie si la date est passée (avant aujourd'hui)
  static bool isPast(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  /// Vérifie si la date est dans le futur (après aujourd'hui)
  static bool isFuture(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isAfter(today);
  }

  /// Vérifie si la date est cette semaine
  static bool isThisWeek(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final start =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = DateTime(
        endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        date.isBefore(end.add(const Duration(seconds: 1)));
  }

  /// Vérifie si deux dates API sont le même jour
  static bool isSameDay(String? apiDate1, String? apiDate2) {
    final d1 = parseApiDate(apiDate1);
    final d2 = parseApiDate(apiDate2);
    if (d1 == null || d2 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  // ═══════════════════════════════════════════════════════
  // LABELS RELATIFS
  // ═══════════════════════════════════════════════════════

  /// "Aujourd'hui", "Demain", "Hier", ou la date
  static String relativeLabel(String? apiDate) {
    if (apiDate == null) return '';
    if (isToday(apiDate)) return 'Aujourd\'hui';
    if (isTomorrow(apiDate)) return 'Demain';
    if (isYesterday(apiDate)) return 'Hier';
    return displayDate(apiDate);
  }

  /// "Aujourd'hui", "Demain", "Lundi 31/12/2024"
  static String relativeLabelWithDay(String? apiDate) {
    if (apiDate == null) return '';
    if (isToday(apiDate)) return 'Aujourd\'hui';
    if (isTomorrow(apiDate)) return 'Demain';
    if (isYesterday(apiDate)) return 'Hier';
    final date = parseApiDate(apiDate);
    if (date == null) return '';
    final dayName = displayDayName(date);
    final formattedDate = displayDate(apiDate);
    final capitalizedDay = dayName[0].toUpperCase() + dayName.substring(1);
    return '$capitalizedDay $formattedDate';
  }

  /// Nombre de jours restants (négatif si passé)
  static int daysRemaining(String? apiDate) {
    final date = parseApiDate(apiDate);
    if (date == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.difference(today).inDays;
  }

  /// "Dans 3 jours", "Il y a 2 jours", etc.
  static String daysRemainingLabel(String? apiDate) {
    final days = daysRemaining(apiDate);
    if (days == 0) return 'Aujourd\'hui';
    if (days == 1) return 'Demain';
    if (days == -1) return 'Hier';
    if (days > 1) return 'Dans $days jours';
    return 'Il y a ${days.abs()} jours';
  }

  // ═══════════════════════════════════════════════════════
  // GÉNÉRATEURS DE DATES
  // ═══════════════════════════════════════════════════════

  /// Liste des 7 jours de la semaine contenant [date]
  static List<DateTime> getWeekDays(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );
  }

  /// Liste des jours d'un mois
  static List<DateTime> getMonthDays(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(
      lastDay.day,
      (i) => firstDay.add(Duration(days: i)),
    );
  }

  /// Vérifie si un DateTime est aujourd'hui
  static bool isTodayDate(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Vérifie si deux DateTime sont le même jour
  static bool areSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}