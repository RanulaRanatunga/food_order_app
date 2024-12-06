//
//  ErrorHandlingWidget
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

import 'package:flutter/material.dart';

class ErrorHandlingWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorHandlingWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            )
          ]
        ],
      ),
    );
  }
}
