class PhoneUtils {
  /// Validates if a phone number is in E.164 format
  static bool isValidE164(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    
    // Must start with +
    if (!phoneNumber.startsWith('+')) return false;
    
    // Remove + and check if all remaining are digits
    String digits = phoneNumber.substring(1);
    if (!RegExp(r'^\d+$').hasMatch(digits)) return false;
    
    // E.164 allows 7-15 digits
    return digits.length >= 7 && digits.length <= 15;
  }
  
  /// Formats a phone number to E.164 format by adding + if missing
  static String formatToE164(String phoneNumber) {
    String cleaned = phoneNumber.trim();
    
    if (cleaned.isEmpty) return cleaned;
    
    // Add + if not present
    if (!cleaned.startsWith('+')) {
      cleaned = '+$cleaned';
    }
    
    return cleaned;
  }
  
  /// Validates and throws exception with descriptive message if invalid
  static void validateE164(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      throw Exception('Phone number is required');
    }
    
    if (!phoneNumber.startsWith('+')) {
      throw Exception('Phone number must be in E.164 format (start with +)');
    }
    
    String digits = phoneNumber.substring(1);
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      throw Exception('Phone number can only contain digits after +');
    }
    
    if (digits.length < 7 || digits.length > 15) {
      throw Exception('Phone number must be 7-15 digits in E.164 format');
    }
  }
} 