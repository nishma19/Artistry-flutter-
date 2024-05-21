import 'package:artistry/models/workshop_model.dart';
import 'package:artistry/screens/user/Artist_user/list_workshops.dart';
import 'package:artistry/services/workshop_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class WorkshopForm extends StatefulWidget {
  final Workshop? workshop;
  final String? artistId;

  WorkshopForm({Key? key, this.workshop,this.artistId})
      : super(key: key);

  @override
  _WorkshopFormState createState() => _WorkshopFormState();
}

class _WorkshopFormState extends State<WorkshopForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late double _price;
  late DateTime _date;
  late TimeOfDay _time;
  late String _venue;
  late int _status;
  late String _artistId;
  late List<String> _participants;

  @override
  void initState() {
    super.initState();
    if (widget.workshop != null) {
      _title = widget.workshop!.title;
      _description = widget.workshop!.description;
      _price = widget.workshop!.price;
      _date = widget.workshop!.date;
      _time = TimeOfDay.fromDateTime(widget.workshop!.date);
      _venue = widget.workshop!.venue;
      _status = widget.workshop!.status;
      _artistId = widget.workshop!.artistId;
      _participants = List.from(widget.workshop!.participants);
    } else {
      _title = '';
      _description = '';
      _price = 0.0;
      _date = DateTime.now();
      _time = TimeOfDay.now();
      _venue = '';
      _status = 1;
      _artistId = widget.artistId ?? "";
      _participants = [];
    }
  }

  WorkshopService _workshopService=WorkshopService();

  @override
  Widget build(BuildContext context) {
    print(widget.artistId);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workshop == null ? 'Add Workshop' : 'Edit Workshop'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => setState(() => _title = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => setState(() => _description = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _price = double.parse(value)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: _date.toString().substring(0, 10)),
                      decoration: InputDecoration(labelText: 'Date'),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _date = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: _time.format(context)),
                      decoration: InputDecoration(labelText: 'Time'),
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _time,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _time = selectedTime;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _venue,
                decoration: InputDecoration(labelText: 'Venue'),
                onChanged: (value) => setState(() => _venue = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: _artistId,
                decoration: InputDecoration(labelText: 'Artist ID'),
                onChanged: (value) => setState(() => _artistId = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist ID';
                  }
                  return null;
                },
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final workshop = Workshop(
                      id: widget.workshop?.id ??Uuid().v1(),
                      title: _title,
                      description: _description,
                      price: _price,
                      date: _date,
                      venue: _venue,
                      status:1,
                      artistId: _artistId,
                      participants: _participants,
                    );
                    if (widget.workshop == null) {
                      _workshopService.addWorkshop(workshop);
                    } else {
                  _workshopService.updateWorkshop(workshop);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.workshop == null ? 'Add' : 'Update'),
              ),
              if (widget.workshop != null)
                ElevatedButton(
                  onPressed: () {
                    _workshopService.deleteWorkshop(widget.workshop!.id);
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
