import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 'http://10.0.2.2:5000' for the Android Emulator to connect to your local Flask server.
  // For the iOS Simulator or a physical device, replace '10.0.2.2' with your computer's actual local IP address.
  // For a web build, you can use 'http://127.0.0.1:5000'.
  final String _baseUrl = "https://dbms-backend-project.onrender.com";

  // --- Helper Methods ---

  // Helper for GET requests
  Future<List<Map<String, dynamic>>> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // The API returns integers for IDs, but the Flutter code expects Strings.
      // This converts all values in the map to strings for consistency.
      return data.map((item) {
        return Map<String, dynamic>.from(
          item,
        ).map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    } else {
      throw Exception(
        'Failed to load data from $endpoint. Status code: ${response.statusCode}',
      );
    }
  }

  // Helper for POST requests
  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to post data to $endpoint. Status code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Helper for DELETE requests
  Future<void> _delete(String endpoint, String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint/$id'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete item from $endpoint. Status code: ${response.statusCode}',
      );
    }
  }

  // --- Policyholders ---
  Future<List<Map<String, dynamic>>> getPolicyholders() =>
      _get('policyholders');

  Future<Map<String, dynamic>> addPolicyholder({
    required String name,
    required String dob,
    required String contact,
  }) => _post('policyholders', {'name': name, 'dob': dob, 'contact': contact});

  Future<void> deletePolicyholder(String id) => _delete('policyholders', id);

  // --- Policies ---
  Future<List<Map<String, dynamic>>> getPolicies() => _get('policies');

  Future<Map<String, dynamic>> addPolicy({
    required String policyholderId,
    required String premium,
    required String policyType,
  }) => _post('policies', {
    'policyholder_id': int.parse(policyholderId),
    'premium': premium,
    'policy_type': policyType,
  });

  Future<void> deletePolicy(String id) => _delete('policies', id);

  // --- Claims ---
  Future<List<Map<String, dynamic>>> getClaims() => _get('claims');

  Future<Map<String, dynamic>> addClaim({
    required String policyId,
    required String claimDate,
    required String claimAmount,
    required String status,
  }) => _post('claims', {
    'policy_id': int.parse(policyId),
    'claim_date': claimDate,
    'claim_amount': claimAmount,
    'status': status,
  });

  Future<void> deleteClaim(String id) => _delete('claims', id);

  // --- Agents ---
  Future<List<Map<String, dynamic>>> getAgents() => _get('agents');

  Future<Map<String, dynamic>> addAgent({
    required String agentName,
    required String phone,
  }) => _post('agents', {'agent_name': agentName, 'phone': phone});

  Future<void> deleteAgent(String id) => _delete('agents', id);
}
