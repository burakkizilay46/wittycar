// ignore_for_file: constant_identifier_names

class AppConstants {
  static const EMAIL_REGEX = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const LOCALE_PATH = 'assets/translations';
  static const SAMPLE_BASE_URL = 'https://jsonplaceholder.typicode.com';
  
  // Firebase Functions API URLs
  static const AUTH_API_BASE_URL = 'http://127.0.0.1:5001/wittycar-996ea/us-central1/api';
  static const LOCAL_API_BASE_URL = 'http://127.0.0.1:5001/wittycar-996ea/us-central1/api';
  
  // Use local URL for development, production URL for release
  static const bool USE_LOCAL_API = true; // Set to true for local development
  static String get API_BASE_URL => USE_LOCAL_API ? LOCAL_API_BASE_URL : AUTH_API_BASE_URL;
  
  static const EN_LOCALE = 'en';
}
