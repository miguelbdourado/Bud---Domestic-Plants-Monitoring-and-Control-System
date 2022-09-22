import 'package:bud_app/constants.dart';
import 'package:bud_app/model/bud/bud.api.dart';
import 'package:bud_app/model/bud/bud.dart';
import 'package:bud_app/model/group/group.dart';
import 'package:bud_app/model/plant_reference/plant_reference.api.dart';
import 'package:bud_app/model/plant_reference/plant_reference.dart';
import 'package:bud_app/model/user/user.dart';
import 'package:flutter/material.dart';

class BudCreateForm extends StatefulWidget {
  const BudCreateForm({Key? key, required this.user, required this.group})
      : super(key: key);

  final MyUser user;
  final Group group;

  @override
  State<BudCreateForm> createState() => _BudCreateFormState();
}

class _BudCreateFormState extends State<BudCreateForm> {
  bool _isLoading = true;
  String _name = "";
  late List<PlantReference> _plantRefs;
  PlantReference? _selectedPlantRef;
  bool? _interior = false;
  Bud? createdBud;

  @override
  void initState() {
    super.initState();
    getAllPlantRefs();
  }

  Future<void> getAllPlantRefs() async {
    _plantRefs = await PlantReferenceApi.getPlantRefs();
    setState(() {
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Bud Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) => setState(() => _name = value!),
    );
  }

  Widget _buildPlantReference() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(hintText: "Plant Species"),
        items: buildPlantItem(_plantRefs),
        onChanged: (value) =>
            setState(() => _selectedPlantRef = getPlantRef(value.toString())));
  }

  Widget _buildInterior() {
    return CheckboxListTile(
        title: const Text("Inside my home"),
        activeColor: kPrimaryColor,
        value: _interior,
        onChanged: (value) => setState(() => _interior = value));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
        : AlertDialog(
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildName(),
                    _buildPlantReference(),
                    _buildInterior()
                  ],
                )),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      BudApi.createBud(
                          widget.user,
                          widget.group.id,
                          Bud("", _name, 0, 0, 0, 0, _selectedPlantRef!,
                              _interior!, false));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'Added bud to group.',
                          style: TextStyle(color: kPrimaryColor),
                        )),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          );
  }

  buildPlantItem(List<PlantReference> plantRefs) {
    return plantRefs
        .map((plantRef) => DropdownMenuItem(
            value: plantRef.name,
            child: Text(
              plantRef.name,
            )))
        .toList();
  }

  PlantReference? getPlantRef(String value) {
    for (int i = 0; i < _plantRefs.length; i++) {
      if (_plantRefs[i].name == value.toString()) return _plantRefs[i];
    }
    return null;
  }
}
