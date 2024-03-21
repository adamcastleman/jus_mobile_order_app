class PhoneNumberFormatter {
  // Formats a 10-digit string into the (XXX) XXX-XXXX format.
  // Returns the original string if it's not 10 digits long.
  static String format(String phoneNumber) {
    // Ensure the phone number contains only digits
    String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the string contains exactly 10 digits
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else {
      // Return the original string or handle the error as appropriate
      return phoneNumber;
    }
  }
}
