import 'dart:math';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:darq/darq.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Resume extends StatefulWidget {
  const Resume({Key? key, required this.data, this.title}) : super(key: key);
  final List<Incident>? data;
  final String? title;

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  List<TargetFocus> targets = [];
  var keyCancel = GlobalKey();
  var keyHelp = GlobalKey();
  var keySave = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTutorial();
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
      print(target);
    }, onSkip: () {
      EasyLoading.showInfo('Tutorial omitido por el usuario.',
          maskType: EasyLoadingMaskType.custom,
          duration: const Duration(milliseconds: 1000));
    })
      ..show();
    // tutorial.skip();
    // tutorial.finish();
    // tutorial.next(); // call next target programmatically
    // tutorial.previous(); // call previous target programmatically
  }

  void setTutorial() {
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
                    "Resumen",
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
                                    "Resumen general de incidentes agrupado por servicio afectado. Recuerde que puede seleccionar varios filtros en la página de Incidentes.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white),
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
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final CustomColors colors = CustomColors();
    var resumeData = widget.data!
        .groupBy((e) => e.serNombre)
        .select((e, index) => ResumeData(
            affectedService: e.first.serNombre,
            failType: e.first.tpfNombre,
            components: e.first.componentes,
            affectedStores: e.elements.length,
            usersOperation: e.sum((e) => e.incUsuariosOperacion!),
            affectedUsers: e.sum((e) => e.incUsuariosAfectados!)))
        .toList();

    for (var element in resumeData) {
      print('Servicio afectado: ${element.affectedService}');
      print('Tipo de falla: ${element.failType}');
      print('Componente con falla: ${element.components}');
      print('CAVs afectados ${element.affectedStores}');
      print('Usuarios en operación: ${element.usersOperation}');
      print('Usuarios afectados: ${element.affectedUsers}');
    }

    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        appBarTheme: NeumorphicAppBarThemeData(
            buttonStyle: NeumorphicStyle(
              color: colors.iconsColor(context),
              shadowLightColor: colors.iconsColor(context),
              boxShape: const NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.flat,
              depth: 2,
              intensity: 0.9,
            ),
            textStyle:
                TextStyle(color: colors.textColor(context), fontSize: 12),
            iconTheme:
                IconThemeData(color: colors.textColor(context), size: 25)),
        depth: 1,
        intensity: 5,
      ),
      child: Scaffold(
        appBar: NeumorphicAppBar(
          leading: Container(
            padding: const EdgeInsets.all(5),
            child: NeumorphicIcon(
              Icons.table_chart_outlined,
              size: 50,
              style: NeumorphicStyle(
                  color: colors.iconsColor(context),
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: colors.shadowColor(context),
                  depth: 1.5,
                  intensity: 0.7),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NeumorphicText(
                'Resumen',
                //key: keyWelcome,
                style: NeumorphicStyle(
                  color: colors.iconsColor(context),
                  intensity: 0.7,
                  depth: 1.5,
                  shadowLightColor: colors.shadowColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 18,
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
                    setTutorial();
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
                child: NeumorphicIcon(
                  Icons.help_outline,
                  key: keyHelp,
                  size: 40,
                  style: NeumorphicStyle(
                      color: colors.iconsColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: colors.shadowColor(context),
                      depth: 1.5,
                      intensity: 0.7),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(widget.title!,
                          style: const TextStyle(color: Colors.orange)),
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: resumeData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _resumeCard(
                                context, resumeData, index, colors);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              NeumorphicFloatingActionButton(
                key: keyCancel,
                style: NeumorphicStyle(
                    color: colors.contextColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: colors.shadowColor(context),
                    depth: 2,
                    intensity: 1),
                tooltip: 'Cancelar',
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.cancel,
                    color: colors.iconsColor(context),
                    size: 30,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Visibility(
                visible: false,
                child: NeumorphicFloatingActionButton(
                  //key: keySave,
                  style: NeumorphicStyle(
                      color: colors.contextColor(context),
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      shadowLightColor: colors.shadowColor(context),
                      depth: 2,
                      intensity: 1),
                  tooltip: 'Enviar actualización',
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.system_update_alt,
                      color: colors.iconsColor(context),
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    //saveAndValidate();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _resumeCard(BuildContext context, List<ResumeData> incidentResume,
    int index, CustomColors colors) {
  var serviceName = incidentResume[index].affectedService;
  var failType = incidentResume[index].failType;
  var components = incidentResume[index].components;
  var affectedStores = incidentResume[index].affectedStores;
  var usersOperation = incidentResume[index].usersOperation;
  var affectedUser = incidentResume[index].affectedUsers;
  return Container(
    height: 120,
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
    child: Column(
      children: [
        Table(
          defaultColumnWidth: const FixedColumnWidth(180.0),
          border: TableBorder.all(
              color: colors.borderColor(context),
              style: BorderStyle.solid,
              width: 1),
          children: [
            _tableRow(context, 'Servicio afectado', serviceName!, 12, colors),
            _tableRow(context, 'Tipo de falla', failType!, 12, colors),
            _tableRow(
                context, 'Componentes afectados', components!, 12, colors),
            _tableRow(context, 'Tiendas afectadas', affectedStores.toString(),
                12, colors),
            _tableRow(context, 'Usuarios en operación',
                usersOperation.toString(), 12, colors),
            _tableRow(context, 'Usuarios afectados', affectedUser.toString(),
                12, colors),
          ],
        ),
      ],
    ),
  );
}

TableRow _tableRow(BuildContext context, String description, String quantity,
    double fontSize, CustomColors colors) {
  return TableRow(children: [
    Column(children: [
      Text(
        description,
        style: TextStyle(color: colors.textColor(context), fontSize: fontSize),
      )
    ]),
    Column(children: [
      AutoSizeText(
        quantity,
        maxLines: 3,
        minFontSize: 4,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    ]),
  ]);
}
