import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_manager/core/logger.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';

class AddEditTaskPage extends StatefulWidget {
  final TodoModel? todo;

  const AddEditTaskPage({super.key, this.todo});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  late String _title;
  late TextEditingController titleController;
  Importance _importance = Importance.none;
  DateTime? _deadline = DateTime.now();
  bool isNeedDeadline = false;

  Widget getImportanceWidget(Importance importance) {
    String importanceText = "";
    Color? importanceColor = Theme.of(context).textTheme.bodyMedium?.color;

    switch (importance) {
      case Importance.high:
        importanceText = AppLocalizations.of(context)!.imporanceHight;
        importanceColor = Theme.of(context).colorScheme.error;
        break;
      case Importance.low:
        importanceText = AppLocalizations.of(context)!.imporanceLow;
        break;
      case Importance.none:
        importanceText = AppLocalizations.of(context)!.importanceNone;
        break;
    }
    return Row(
      children: [
        importance == Importance.high
            ? SvgPicture.asset("assets/icons/hight_priority.svg")
            : importance == Importance.low
                ? SvgPicture.asset("assets/icons/low_priority.svg")
                : const SizedBox(),
        SizedBox(width: importance == Importance.none ? 0 : 5),
        Text(
          importanceText,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: importanceColor),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _title = widget.todo!.title;
      titleController = TextEditingController(text: widget.todo!.title);
      _importance = widget.todo!.importance;
      _deadline = widget.todo!.deadline ?? _deadline;
      isNeedDeadline = widget.todo!.deadline != null;
    } else {
      titleController = TextEditingController();
      _title = '';
    }
  }

  void _saveTask() {
    final newTodo = TodoModel(
      title: _title,
      importance: _importance,
      deadline: _deadline,
    );
    logger.i(
        'Task "${newTodo.title}" saved with importance "${newTodo.importance}" and deadline "${newTodo.deadline}"');

    Navigator.pop(context, newTodo);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
      logger.i('Deadline set to "$_deadline"');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(locale);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: (isNeedDeadline && _deadline == null) || _title.isEmpty
                ? null
                : _saveTask,
            child: Text(
              AppLocalizations.of(context)!.save,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Что надо сделать…'),
              maxLines: 9,
              minLines: 3,
              style: Theme.of(context).textTheme.bodyMedium,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => setState(() => _title = v),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!.importance,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            DropdownButtonFormField<Importance>(
              value: _importance,
              items: Importance.values.map((Importance importance) {
                return DropdownMenuItem<Importance>(
                  value: importance,
                  child: getImportanceWidget(importance),
                );
              }).toList(),
              selectedItemBuilder: (context) =>
                  Importance.values.map((Importance importance) {
                return getImportanceWidget(importance);
              }).toList(),
              dropdownColor: Theme.of(context).colorScheme.surface,
              onChanged: (Importance? newValue) {
                setState(() {
                  _importance = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.deadline,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    isNeedDeadline
                        ? InkWell(
                            onTap: () => _selectDate(context),
                            child: Text(
                              dateFormat.format(_deadline ?? DateTime.now()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Switch(
                  value: isNeedDeadline,
                  onChanged: (v) => setState(() => isNeedDeadline = v),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                  inactiveTrackColor: Theme.of(context).colorScheme.secondary,
                )
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            InkWell(
              onTap: widget.todo == null ? null : () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete,
                    color: widget.todo == null
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!.remove,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: widget.todo == null
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.error,
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
