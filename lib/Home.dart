import 'package:dbms_project/Api_Services.dart';
import 'package:dbms_project/Home.dart';
import 'package:flutter/material.dart';

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
                  child: const Icon(
                    Icons.business_center,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'DBMS PROJECT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Insurance Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
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

  Widget _buildNavigationCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
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
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        style:
                        TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
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

// ----------------------------------------------------------------
// 🔹 POLICYHOLDERS DIALOG (WITH UPDATE FEATURE)
// ----------------------------------------------------------------

class PolicyholdersDialog extends StatefulWidget {
  final ApiService apiService;
  const PolicyholdersDialog({super.key, required this.apiService});

  @override
  State<PolicyholdersDialog> createState() => _PolicyholdersDialogState();
}

class _PolicyholdersDialogState extends State<PolicyholdersDialog> {
  List<Map<String, dynamic>> _policyholders = [];
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var data = await widget.apiService.getPolicyholders();
      setState(() {
        _policyholders = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addPolicyholder() async {
    if (_nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _contactController.text.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await widget.apiService.addPolicyholder(
        name: _nameController.text,
        dob: _dobController.text,
        contact: _contactController.text,
      );
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("✅ Policyholder added successfully!"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to add: $e');
    }
  }

  Future<void> _updatePolicyholder(String id) async {
    if (_nameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _contactController.text.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await widget.apiService.updatePolicyholder(
        id: id,
        name: _nameController.text,
        dob: _dobController.text,
        contact: _contactController.text,
      );
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("✏️ Policyholder updated successfully!"),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to update: $e');
    }
  }

  Future<void> _deletePolicyholder(String id) async {
    setState(() => _isLoading = true);
    try {
      await widget.apiService.deletePolicyholder(id);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("🗑️ Policyholder deleted successfully!"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to delete: $e');
    }
  }

  void _showAddDialog() {
    _nameController.clear();
    _dobController.clear();
    _contactController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Policyholder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
            TextField(controller: _contactController, decoration: const InputDecoration(labelText: 'Contact Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addPolicyholder();
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> ph) {
    _nameController.text = ph['name'];
    _dobController.text = ph['dob'];
    _contactController.text = ph['contact'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Policyholder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
            TextField(controller: _contactController, decoration: const InputDecoration(labelText: 'Contact Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePolicyholder(ph['policyholder_id']);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Policyholders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ]),
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Policyholder"),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _policyholders.isEmpty
                  ? const Center(child: Text("No Policyholders Found"))
                  : ListView(
                children: _policyholders.map((ph) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(ph['name']),
                      subtitle: Text("DOB: ${ph['dob']} | Contact: ${ph['contact']}"),
                      trailing: Wrap(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(ph)),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePolicyholder(ph['policyholder_id'])),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
