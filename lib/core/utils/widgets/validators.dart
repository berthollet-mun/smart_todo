class Validators {
  Validators._();

  // ═══════════════════════════════════════════════════════
  // NOM
  // ═══════════════════════════════════════════════════════
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.trim().length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // EMAIL
  // ═══════════════════════════════════════════════════════
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email est requis';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // MOT DE PASSE
  // ═══════════════════════════════════════════════════════
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  /// Validation mot de passe fort (optionnel, pour register)
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Minimum 8 caractères';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Au moins une lettre majuscule';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Au moins une lettre minuscule';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Au moins un chiffre';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // CONFIRMATION MOT DE PASSE
  // ═══════════════════════════════════════════════════════
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // TITRE (LISTE / ITEM)
  // ═══════════════════════════════════════════════════════
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le titre est requis';
    }
    if (value.trim().length < 1) {
      return 'Le titre ne peut pas être vide';
    }
    if (value.trim().length > 100) {
      return 'Le titre ne peut pas dépasser 100 caractères';
    }
    return null;
  }

  /// Validation du titre d'un item de checklist
  static String? validateItemTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le titre de l\'item est requis';
    }
    if (value.trim().length > 200) {
      return 'Le titre ne peut pas dépasser 200 caractères';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // DESCRIPTION
  // ═══════════════════════════════════════════════════════
  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'La description ne peut pas dépasser 500 caractères';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // RECHERCHE
  // ═══════════════════════════════════════════════════════
  static String? validateSearch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer un terme de recherche';
    }
    if (value.trim().length < 2) {
      return 'Minimum 2 caractères pour la recherche';
    }
    return null;
  }

  /// Valide que le terme de recherche est assez long (sans message d'erreur)
  static bool isSearchValid(String? value) {
    return value != null && value.trim().length >= 2;
  }

  // ═══════════════════════════════════════════════════════
  // DATE
  // ═══════════════════════════════════════════════════════
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) return null; // optionnel
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'Format de date invalide (AAAA-MM-JJ)';
    }
    try {
      DateTime.parse(value);
    } catch (_) {
      return 'Date invalide';
    }
    return null;
  }

  /// Valide que la date n'est pas dans le passé
  static String? validateFutureDate(String? value) {
    final dateError = validateDate(value);
    if (dateError != null) return dateError;
    if (value == null || value.isEmpty) return null;

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (date.isBefore(today)) {
        return 'La date ne peut pas être dans le passé';
      }
    } catch (_) {
      return 'Date invalide';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // HEURE
  // ═══════════════════════════════════════════════════════
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) return null; // optionnel
    final regex = RegExp(r'^\d{2}:\d{2}(:\d{2})?$');
    if (!regex.hasMatch(value)) {
      return 'Format d\'heure invalide (HH:MM)';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // TYPE DE LISTE
  // ═══════════════════════════════════════════════════════
  static String? validateListType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le type de liste est requis';
    }
    if (value != 'simple' && value != 'checklist') {
      return 'Le type doit être "simple" ou "checklist"';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // PERMISSION
  // ═══════════════════════════════════════════════════════
  static String? validatePermission(String? value) {
    if (value == null || value.isEmpty) {
      return 'La permission est requise';
    }
    if (value != 'read' && value != 'edit') {
      return 'La permission doit être "read" ou "edit"';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // CHAMP REQUIS GÉNÉRIQUE
  // ═══════════════════════════════════════════════════════
  static String? required(String? value, [String fieldName = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════
  // UTILITAIRE : COMBINER PLUSIEURS VALIDATEURS
  // ═══════════════════════════════════════════════════════
  /// Applique plusieurs validateurs, retourne la première erreur
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}