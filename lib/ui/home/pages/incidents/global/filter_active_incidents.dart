import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FilterActiveIncidents extends StatefulWidget {
  const FilterActiveIncidents({Key? key}) : super(key: key);

  @override
  FilterActiveIncidentsState createState() => FilterActiveIncidentsState();
}

class FilterActiveIncidentsState extends State<FilterActiveIncidents> {
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  final _listStatus = <String>[
    'En curso',
    'Pendiente',
  ];
  var cityId = 0;
  int? status;
  var massive = false;
  var fails = false;
  var filter = '';
  var fs = '%26%26';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colors.contextColor(context),
        foregroundColor: _colors.iconsColor(context),
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: <Widget>[
              Icon(
                Icons.store,
                color: _colors.iconsColor(context),
                size: 50,
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Consultar incidentes activos',
              style: TextStyle(
                color: _colors.iconsColor(context),
                fontSize: 16,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.help_outline,
                color: _colors.iconsColor(context),
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<City>>(
                future: _apiService.getCities(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<City>> snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : FormBuilderDropdown<City>(
                    name: 'city',
                    //initialValue: _listCity.first,
                    decoration: InputDecoration(
                        labelText: 'Ciudad',
                        prefixIcon: Icon(Icons.location_city,
                            color: _colors.iconsColor(context),
                            size: 18)),
                    hint: const Text('Seleccionar ciudad'),
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ciudad requerida')
                    ]),
                    items: snapshot.data!
                        .map((city) => DropdownMenuItem<City>(
                        value: city,
                        child: Text(city.nombre!)))
                        .toList(),
                  );
                }),
            FormBuilderDropdown(
              name: 'status',
              decoration: InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.lock_open,
                      color: _colors.iconsColor(context), size: 18)),
              hint: const Text('Seleccionar estado actual'),
              items:
              _listStatus.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                status = _listStatus.indexOf(value.toString());
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Icon(
                    Icons.error,
                    color: _colors.iconsColor(context),
                    size: 20,
                  ),
                  const Text('Incidentes masivos'),
                  Switch(
                      activeColor: _colors.iconsColor(context),
                      value: massive,
                      onChanged: (value) {
                        setState(() {
                          massive = !massive;
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: _colors.contextColor(context),
              tooltip: 'Cancelar',
              child: Container(
                margin: const EdgeInsets.all(2),
                child: Icon(
                  Icons.cancel,
                  color: _colors.iconsColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FloatingActionButton(
              //key: keyCancel,
              backgroundColor: _colors.contextColor(context),
              tooltip: 'Enviar actualización',
              child: Container(
                margin: const EdgeInsets.all(2),
                child: Icon(
                  Icons.filter_list_alt,
                  color: _colors.iconsColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                if (cityId > 0) filter += '${fs}id_ciudad=$cityId';
                if (status != null) filter += '${fs}estado=$status';
                if (massive == true) filter += '${fs}masivos=$massive';
                Navigator.pop(context, filter);
              },
            ),
          ],
        ),
      ),
    );
  }
}
