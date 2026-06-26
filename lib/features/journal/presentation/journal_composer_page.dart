import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/journal/journal_providers.dart';

class JournalComposerPage extends ConsumerStatefulWidget {
  final int? entryId;

  const JournalComposerPage({super.key, this.entryId});

  @override
  ConsumerState<JournalComposerPage> createState() => _JournalComposerPageState();
}

class _JournalComposerPageState extends ConsumerState<JournalComposerPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _category = 'تأمل'; // Default
  DateTime _createdAt = DateTime.now();

  Timer? _autosaveTimer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadEntry();
    
    _titleController.addListener(_onTextChanged);
    _bodyController.addListener(_onTextChanged);
  }

  Future<void> _loadEntry() async {
    if (widget.entryId != null) {
      final repository = ref.read(journalRepositoryProvider);
      final entry = await repository.getEntry(widget.entryId!);
      if (entry != null && mounted) {
        setState(() {
          _titleController.text = entry.title;
          _bodyController.text = entry.body;
          _category = entry.category;
          _createdAt = entry.createdAt;
        });
      }
    }
  }

  void _onTextChanged() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 2), _saveEntry);
  }

  Future<void> _saveEntry() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    
    if (title.isEmpty && body.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(journalRepositoryProvider);
      await repo.saveEntry(
        id: widget.entryId, // If we had it, but actually the saveEntry returns ID, we'd need to update our local ID if it was null.
        category: _category,
        title: title,
        body: body,
      );
      // Invalidate the list provider so it refreshes
      ref.invalidate(journalEntriesProvider);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            _saveEntry().then((_) {
              if (context.mounted) context.pop();
            });
          },
        ),
        title: Text(
          'تأمل جديد',
          style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: OutlinedButton.icon(
              onPressed: _saveEntry,
              icon: _isSaving 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save, size: 18),
              label: const Text('حفظ'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.secondary,
                side: BorderSide(color: colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Subtle journal line
          Positioned(
            top: 0,
            bottom: 0,
            right: 48.0,
            width: 1.0,
            child: Container(
              color: colorScheme.secondaryContainer,
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  // Date Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE d MMMM', 'ar').format(_createdAt),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Category Dropdown/Selector (optional, but good to have since it defaults to 'تأمل')
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _category,
                      icon: Icon(Icons.arrow_drop_down, color: colorScheme.outline),
                      items: ['شكر', 'طلبات صلاة', 'تأمل'].map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _category = val);
                          _onTextChanged();
                        }
                      },
                    ),
                  ),
                  
                  // Title Input
                  TextField(
                    controller: _titleController,
                    style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'عنوان التأمل...',
                      hintStyle: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Body Input
                  Expanded(
                    child: TextField(
                      controller: _bodyController,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.8,
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'ابدأ في تدوين تأملاتك هنا...',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
