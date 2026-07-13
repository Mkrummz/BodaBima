import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_store.dart';
import '../theme/app_theme.dart';

class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Claims')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('File a claim'),
        onPressed: () => _openFileClaim(context),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (store.claims.isEmpty) {
            return const Center(child: Text('No claims yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: store.claims.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _ClaimCard(claim: store.claims[i]),
          );
        },
      ),
    );
  }

  void _openFileClaim(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FileClaimPage()),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final Claim claim;
  const _ClaimCard({required this.claim});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${claim.type} · ${claim.policyName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                _StatusChip(status: claim.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(claim.description,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.event, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Filed ${DateFormat('MMM d, yyyy').format(claim.dateFiled)}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const Spacer(),
                Text('Claim #${claim.id.toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ClaimStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ClaimStatus.submitted => ('Submitted', const Color(0xFF2F80ED)),
      ClaimStatus.inReview => ('In review', const Color(0xFFE2A800)),
      ClaimStatus.approved => ('Approved', AppColors.accent),
      ClaimStatus.paid => ('Paid', const Color(0xFF27AE60)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class FileClaimPage extends StatefulWidget {
  const FileClaimPage({super.key});

  @override
  State<FileClaimPage> createState() => _FileClaimPageState();
}

class _FileClaimPageState extends State<FileClaimPage> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  Policy? _policy;
  String _type = 'Accident';

  static const _types = ['Accident', 'Theft', 'Outpatient', 'Property damage'];

  @override
  void initState() {
    super.initState();
    _policy = AppStore.instance.policies.first;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _policy == null) return;
    AppStore.instance.fileClaim(
      policy: _policy!,
      type: _type,
      description: _descController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Claim submitted successfully')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final policies = AppStore.instance.policies;
    return Scaffold(
      appBar: AppBar(title: const Text('File a claim')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Which policy?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Policy>(
              initialValue: _policy,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: policies
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text('${p.name} (${p.type})'),
                      ))
                  .toList(),
              onChanged: (p) => setState(() => _policy = p),
            ),
            const SizedBox(height: 16),
            const Text('Claim type',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (t) => setState(() => _type = t ?? _type),
            ),
            const SizedBox(height: 16),
            const Text('What happened?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe the incident…',
              ),
              validator: (v) => (v == null || v.trim().length < 5)
                  ? 'Please add a short description'
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit claim'),
            ),
          ],
        ),
      ),
    );
  }
}
