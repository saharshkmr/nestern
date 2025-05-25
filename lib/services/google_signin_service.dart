import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  // Private constructor for singleton pattern
  GoogleSignInService._();
  
  // Singleton instance
  static final GoogleSignInService _instance = GoogleSignInService._();
  
  // Factory constructor to return the singleton instance
  factory GoogleSignInService() => _instance;
  
  // Using nullable GoogleSignIn to track initialization state
  static GoogleSignIn? _googleSignIn;
  
  // Flag to track initialization status
  static bool _isInitialized = false;
  
  // Initialize the service - should be called once at app startup
  static void initialize() {
    // Only initialize if not already done
    if (!_isInitialized) {
      if (kIsWeb) {
        // Web-specific initialization with client ID
        _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            // 'https://www.googleapis.com/auth/userinfo.profile',
          ],
          // clientId: '384575493809-29l6ldlbbqpks0gpjjguidk87u3gdktg.apps.googleusercontent.com',
        );
      } else {
        // Mobile-specific initialization
        _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            // 'https://www.googleapis.com/auth/userinfo.profile',
          ],
        );
      }
      
      _isInitialized = true;
      print('GoogleSignInService initialized for ${kIsWeb ? 'web' : 'mobile'}');
    } else {
      print('GoogleSignInService already initialized, skipping');
    }
  }

  // Platform-aware sign-in method
  static Future<GoogleSignInAccount?> signIn() async {
    // Ensure service is initialized
    if (!_isInitialized) {
      initialize();
    }
    
    try {
      print('Starting Google Sign In process...');
      
      GoogleSignInAccount? googleUser;
      
      if (kIsWeb) {
        // Web-specific approach with retry logic
        try {
          // Try silent sign-in first
          googleUser = await _googleSignIn!.signInSilently();
          print('Silent sign-in attempt result: ${googleUser?.email ?? "failed"}');
        } catch (e) {
          print('Silent sign-in error: $e');
        }
        
        // If silent sign-in fails, use regular signIn
        if (googleUser == null) {
          googleUser = await _googleSignIn!.signIn();
        }
      } else {
        // Mobile approach
        googleUser = await _googleSignIn!.signIn();
      }
      
      if (googleUser == null) {
        print('Google Sign In was canceled by user');
        return null;
      }
      
      print('Google Sign In successful for: ${googleUser.email}');
      
      // Get authentication tokens with retry mechanism
      GoogleSignInAuthentication? googleAuth;
      for (int attempt = 0; attempt < 3; attempt++) {
        googleAuth = await googleUser.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          print('Successfully obtained tokens on attempt ${attempt + 1}');
          break;
        }
        print('Tokens are null on attempt ${attempt + 1}, retrying...');
        
        // Clear auth cache before retry
        if (attempt < 2) { // Don't clear on last attempt
          try {
            await googleUser.clearAuthCache();
            await Future.delayed(Duration(milliseconds: 500));
          } catch (e) {
            print('Error clearing auth cache: $e');
          }
        }
      }
      
      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        print('Failed to obtain Google auth tokens after multiple attempts');
        print('Access token: ${googleAuth?.accessToken}');
        if (googleAuth?.idToken != null) {
          print('ID token: ${googleAuth!.idToken!.substring(0, min(10, googleAuth.idToken!.length))}...');
        } else {
          print('ID token: null');
        }
      } else {
        print('Authentication successful with valid tokens');
      }
      
      return googleUser;
    } catch (error) {
      print('Google Sign In Error: $error');
      return null;
    }
  }

  // Get authentication details with robust error handling
  static Future<GoogleSignInAuthentication?> getAuthDetails(GoogleSignInAccount account) async {
    try {
      // First try - standard authentication
      GoogleSignInAuthentication auth = await account.authentication;
      
      // Verify tokens were retrieved
      if (auth.idToken == null || auth.accessToken == null) {
        print('Initial authentication missing tokens, trying with cache clearing...');
        
        // Try clearing cache and re-authenticating
        await account.clearAuthCache();
        auth = await account.authentication;
        
        if (auth.idToken == null || auth.accessToken == null) {
          print('WARNING: Still unable to retrieve tokens after cache clearing');
          return null;
        }
      }
      
      print('Authentication details retrieved successfully');
      return auth;
    } catch (e) {
      print('Error getting authentication details: $e');
      return null;
    }
  }

  // Sign out from Google
  static Future<void> signOut() async {
    try {
      if (!_isInitialized || _googleSignIn == null) {
        print('GoogleSignIn was not initialized before signOut');
        return;
      }
      
      final bool isSignedIn = await _googleSignIn!.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn!.signOut();
        print('Successfully signed out from Google');
      } else {
        print('User was not signed in');
      }
    } catch (e) {
      print('Error during Google sign out: $e');
    }
  }
  
  // Helper method to check the current sign-in status
  static Future<bool> isSignedIn() async {
    try {
      if (!_isInitialized) {
        initialize();
      }
      return await _googleSignIn!.isSignedIn();
    } catch (e) {
      print('Error checking sign-in status: $e');
      return false;
    }
  }
  
  // Helper function for dart:math min function
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}