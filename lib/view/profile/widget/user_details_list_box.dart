import 'package:flutter/material.dart';

class UserDetailsListBox extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;

  const UserDetailsListBox({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name: $name",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
              color: Colors.black87,
            ),
          ),
          Divider( color: Colors.blue.shade200),
          SizedBox(height: 6),
          Text(
            "Email: $email",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
                fontWeight: .w600
            ),
          ),
          Divider( color: Colors.blue.shade200),
          SizedBox(height: 4),
          Text(
            "Phone Number: $phoneNumber",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: .w600
            ),
          ),
        ],
      ),
    );

  }
}
