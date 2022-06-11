import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/cities_stores.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FilterStores extends StatefulWidget {
  const FilterStores({Key? key}) : super(key: key);

  @override
  FilterStoresState createState() => FilterStoresState();
}

class FilterStoresState extends State<FilterStores> {
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  final _listStatus = <String>[
    'Cerrada',
    'Abierta',
  ];
  var keyCancel = GlobalKey();
  var keyHelp = GlobalKey();
  var keySave = GlobalKey();
  var cityId = 0;
  int? status;
  var massive = false;
  var fails = false;
  var filter = '';
  var fs = '&&';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (prefs.firstStoreFilter == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setMainTutorial();
        showTutorial();
      });
      prefs.firstStoreFilter = false;
    }
  }

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: targets, // List<TargetFocus>
        colorShadow: Colors.black, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        textSkip: "Omitir",
        // paddingFocus: 10,
        // focusAnimationDuration: Duration(milliseconds: 500),
        // pulseAnimationDuration: Duration(milliseconds: 500),
        // pulseVariation: Tween(begin: 1.0, end: 0.99),
        onFinish: () {}, onClickTarget: (target) {
        }, onSkip: () {
          EasyLoading.showInfo('Tutorial omitido por el usuario.',
              maskType: EasyLoadingMaskType.custom,
              duration: const Duration(milliseconds: 1000));
        })
      ..show();
    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(call next target programmatically
    // tutoriaious(); // call previous target programmatically
  }

  void setMainTutorial() {
    targets.clear();
    targets.add(TargetFocus(
        identify: "Target 0",
        keyTarget: keyHelp,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Consultar tiendas",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                "A continuación, se mostrará el tutorial de la pantalla Consultar tiendas, este módulo le permitirá filtrar los registros de la pantalla Tiendas.\nSe recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.help_outline,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text:
                                " en la parte superior derecha de la pantalla. Recuerde que los tutoriales se dividen por sección.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para continuar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: keyHelp,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(
                                    Icons.location_city,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text: " Filtrar por ciudad\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.store,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text:
                                " Filtrar por estado de la tienda (Abierta, Cerrada)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.error,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text:
                                " Filtrar por tiendas que reportan masivos\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text:
                                " Filtrar por tiendas que reportan incidentes\n\n\n",
                              ),
                              TextSpan(
                                text:
                                "Puede establecer varios filtros al tiempo para especificar los datos deseados.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para finalizar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: keySave,
        shape: ShapeLightFocus.RRect,
        alignSkip:
        AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para continuar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Enviar filtro",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                "Envía el filtro establecido con las opciones seleccionadas, este se verá reflejado en la pantalla de Tiendas.\nSi envía el filtro en sin opciones, se utilizará el filtro por defecto.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
    targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: keyCancel,
        shape: ShapeLightFocus.RRect,
        alignSkip:
        AlignmentGeometry.lerp(Alignment.topRight, Alignment.center, 0.0),
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Toque en cualquier parte para finalizar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Cancelar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    //color: Colors.deepPurpleAccent,
                    //height: 200,
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.justify,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                "Cancela la operación actual y regresa a la pantalla anterior.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
  }

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
              'Consultar tiendas',
              //key: keyWelcome,
              style: TextStyle(
                color: _colors.iconsColor(context),
                fontSize: 20,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              FormHelper.showMessage(
                context,
                "Embajadores",
                "¿Ver tutorial de la sección?",
                "Si",
                    () {
                  setMainTutorial();
                  showTutorial();
                  Navigator.of(context).pop();
                },
                buttonText2: "No",
                isConfirmationDialog: true,
                onPressed2: () {
                  Navigator.of(context).pop();
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.help_outline,
                color: _colors.iconsColor(context),
                key: keyHelp,
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
        child: Wrap(
          children: <Widget>[
            FutureBuilder<List<City>>(
                future: _apiService.getCities(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<City>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return FormBuilderDropdown<City>(
                      name: 'city',
                      //initialValue: _listCity.first,
                      decoration: InputDecoration(
                          labelText: 'Ciudad',
                          prefixIcon: Icon(Icons.location_city,
                              color: _colors.iconsColor(context),
                              size: 18)),
                      hint: const Text('Seleccionar ciudad'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: snapshot.data!
                          .map((city) => DropdownMenuItem<City>(
                          value: city,
                          child: Text(city.nombre!)))
                          .toList(),
                      onChanged: (city) {
                        if (city != null) {
                          setState(() {
                            cityId = city.id!;
                          });
                        }
                      },
                    );
                  }
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_outlined,
                    color: _colors.iconsColor(context),
                    size: 20,
                  ),
                  const Text('Reportan fallas'),
                  Switch(
                      activeColor: _colors.iconsColor(context),
                      value: fails,
                      onChanged: (value) {
                        setState(() {
                          fails = !fails;
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
              key: keyCancel,
              backgroundColor: _colors.contextColor(context),
              heroTag: "cancel_query",
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
              key: keySave,
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
                if (cityId > 0) {
                  filter += '${fs}id_ciudad=$cityId';
                }
                if (status != null) {
                  filter += '${fs}estado=$status';
                }
                if (massive == true) {
                  filter += '${fs}masivos=$massive';
                }
                if (fails == true) {
                  filter += '${fs}servicios_caidos=$fails';
                }
                Navigator.pop(context, filter);
              },
            ),
          ],
        ),
      ),
    );
  }
}
