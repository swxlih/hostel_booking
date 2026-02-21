import 'package:flutter/material.dart';
import 'package:hostel_booking/main.dart';
import 'package:hostel_booking/utils/helper/razorpay_service/successpayment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final Function(PaymentSuccessResponse)? onSuccess;
  final Function(PaymentFailureResponse)? onError;
  final Function(ExternalWalletResponse)? onExternalWallet;
  final BuildContext? context;

  RazorpayService({
    this.onSuccess,
    this.onError,
    this.onExternalWallet,
    this.context,
  }) {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    
    // Setup event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

 void _handlePaymentSuccess(PaymentSuccessResponse response) {
  debugPrint('Payment Success: ${response.paymentId}');

  // Trigger success callback
  onSuccess?.call(response);

  // Navigate if context is available

   
    
    _showSnackBar(
      '✅ Payment Successful\nPayment ID: ${response.paymentId}',
      Colors.green,
    );

}


  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    
    // Call custom error callback if provided
    onError?.call(response);
    
    // Show snackbar if context is available
    if (context != null) {
      _showSnackBar(
        '❌ Payment Failed\nReason: ${response.message}',
        Colors.red,
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    
    // Call custom wallet callback if provided
    onExternalWallet?.call(response);
    
    // Show snackbar if context is available
    if (context != null) {
      _showSnackBar(
        '💼 External Wallet Selected: ${response.walletName}',
        Colors.blue,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Open Razorpay checkout with basic options
  void openCheckout({
    required String key,
    required int amount,
    String currency = 'INR',
    String name = 'Hostaa',
    String description = 'Payment',
    Map<String, String>? prefill,
    Map<String, dynamic>? theme,
    int timeout = 300,
  }) {
    var options = {
      'key': key,
      'amount': amount,
      'currency': currency,
      'name': name,
      'description': description,
      'timeout': timeout,
      'prefill': prefill ?? {
        'contact': '9999999999',
        'email': 'user@example.com',
      },
      'theme': theme ?? {
        'color': '#3399cc',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
      
      if (context != null) {
        _showSnackBar('Error opening payment gateway', Colors.orange);
      }
    }
  }

  // Open checkout with order ID (recommended for production)
  void openCheckoutWithOrder({
    required String key,
    required String orderId,
    required int amount,
    String currency = 'INR',
    String name = 'Hostaa',
    String description = 'Payment',
    Map<String, String>? prefill,
    Map<String, dynamic>? theme,
  }) {
    var options = {
      'key': key,
      'amount': amount,
      'currency': currency,
      'name': name,
      'description': description,
      'order_id': orderId,
      'prefill': prefill,
      'theme': theme,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  // Cleanup method
  void dispose() {
    _razorpay.clear();
    
  }
}