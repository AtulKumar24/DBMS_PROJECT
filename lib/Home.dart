import 'package:flutter/material.dart';
import 'package:dbms_project/Api_Services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Insurance Management System",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.business_center,
                      size: 80, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Text('DBMS PROJECT',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 2)),
                const SizedBox(height: 8),
                const Text('Insurance Management',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 50),
                _buildNavigationCard(
                  context,
                  title: 'Policyholders',
                  subtitle: 'Manage customer information',
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () => _showPolicyholdersDialog(context),
                ),
                const SizedBox(height: 15),
                _buildNavigationCard(
                  context,
                  title: 'Policies',
                  subtitle: 'Manage insurance policies',
                  icon: Icons.description,
                  color: Colors.green,
                  onTap: () => _showPoliciesDialog(context),
                ),
                const SizedBox(height: 15),
                _buildNavigationCard(
                  context,
                  title: 'Claims',
                  subtitle: 'Process insurance claims',
                  icon: Icons.assignment,
                  color: Colors.orange,
                  onTap: () => _showClaimsDialog(context),
                ),
                const SizedBox(height: 15),
                _buildNavigationCard(
                  context,
                  title: 'Agents',
                  subtitle: 'Manage insurance agents',
                  icon: Icons.support_agent,
                  color: Colors.purple,
                  onTap: () => _showAgentsDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context,
      {required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[600])),
                    ]),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showPolicyholdersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PolicyholdersDialog(apiService: apiService),
    );
  }

  void _showPoliciesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PoliciesDialog(apiService: apiService),
    );
  }

  void _showClaimsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClaimsDialog(apiService: apiService),
    );
  }

  void _showAgentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AgentsDialog(apiService: apiService),
    );
  }
}

// ===============================================================
// DIALOGS
// ===============================================================

// (To save space, here’s the working structure for one dialog;
// You’ll add others exactly the same way using your ApiService.)

class PolicyholdersDialog extends StatefulWidget {
  final ApiService apiService;
  const PolicyholdersDialog({super.key, required this.apiService});

  @override
  State<PolicyholdersDialog> createState() => _PolicyholdersDialogState();
}

class _PolicyholdersDialogState extends State<PolicyholdersDialog> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String? _error;
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final data = await widget.apiService.getPolicyholders();
      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showForm({Map<String, dynamic>? existing}) {
    if (existing != null) {
      _name.text = existing['name'];
      _dob.text = existing['dob'];
      _contact.text = existing['contact'];
    } else {
      _name.clear();
      _dob.clear();
      _contact.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Policyholder' : 'Edit Policyholder'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _dob, decoration: const InputDecoration(labelText: 'DOB (YYYY-MM-DD)')),
          TextField(controller: _contact, decoration: const InputDecoration(labelText: 'Contact')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (existing == null) {
                await widget.apiService.addPolicyholder(
                    name: _name.text, dob: _dob.text, contact: _contact.text);
              } else {
                await widget.apiService.updatePolicyholder(
                    id: existing['policyholder_id'],
                    name: _name.text,
                    dob: _dob.text,
                    contact: _contact.text);
              }
              _fetch();
            },
            child: Text(existing == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 600,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Policyholders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
          ]),
          ElevatedButton.icon(onPressed: () => _showForm(), icon: const Icon(Icons.add), label: const Text("Add")),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? const Center(child: Text("No Data"))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final item = _items[i];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("DOB: ${item['dob']} | Contact: ${item['contact']}"),
                  trailing: Wrap(children: [
                    IconButton(
                        onPressed: () => _showForm(existing: item),
                        icon: const Icon(Icons.edit, color: Colors.blue)),
                    IconButton(
                        onPressed: () async {
                          await widget.apiService.deletePolicyholder(item['policyholder_id']);
                          _fetch();
                        },
                        icon: const Icon(Icons.delete, color: Colors.red)),
                  ]),
                );
              },
            ),
          ),
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red))
        ]),
      ),
    );
  }
}

// ===============================================================
// DUMMY STUBS for other dialogs
// (You can copy same structure and replace API calls accordingly.)
// ===============================================================

class PoliciesDialog extends StatelessWidget {
  final ApiService apiService;
  const PoliciesDialog({super.key, required this.apiService});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("PoliciesDialog – to be implemented"));
}

class ClaimsDialog extends StatelessWidget {
  final ApiService apiService;
  const ClaimsDialog({super.key, required this.apiService});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("ClaimsDialog – to be implemented"));
}

class AgentsDialog extends StatelessWidget {
  final ApiService apiService;
  const AgentsDialog({super.key, required this.apiService});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("AgentsDialog – to be implemented"));
}
