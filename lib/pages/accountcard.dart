import 'package:flutter/material.dart';
import 'package:finalproject/models/account.dart';
import 'package:finalproject/data/dao.dart';

class AccountCard extends StatefulWidget {
  final Account account;
  final VoidCallback onChanged;

  const AccountCard({super.key, required this.account, required this.onChanged});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _showPassword = false;

  void _editAccount() {
    final websiteCtrl = TextEditingController(text: widget.account.websiteName);
    final emailCtrl = TextEditingController(text: widget.account.email);
    final passwordCtrl = TextEditingController(text: widget.account.password);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: websiteCtrl, decoration: const InputDecoration(labelText: 'Website name')),
            const SizedBox(height: 8),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email or username')),
            const SizedBox(height: 8),
            TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              widget.account.websiteName = websiteCtrl.text.trim();
              widget.account.email = emailCtrl.text.trim();
              widget.account.password = passwordCtrl.text.trim();
              await Dao.getInstance().updateAccount(widget.account);
              Navigator.pop(context);
              widget.onChanged();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Delete ${widget.account.websiteName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await Dao.getInstance().deleteAccount(widget.account.id);
              Navigator.pop(context);
              widget.onChanged();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.account.websiteName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: _editAccount),
                IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: _deleteAccount),
              ],
            ),
            const SizedBox(height: 8),
            Text("Email or username: ${widget.account.email}"),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "Password: ${_showPassword ? widget.account.password : '•' * widget.account.password.length}",
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
