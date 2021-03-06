import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/ui/home/about.dart';
import 'package:embajadores/ui/home/pages/incidents/global/incident_query.dart';
import 'package:embajadores/ui/home/pages/incidents/global/all_incidents.dart';
import 'package:embajadores/ui/home/pages/incidents/local/my_incidents.dart';
import 'package:embajadores/ui/home/pages/stores/global/global_stores.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:embajadores/ui/home/pages/stores/register_store.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/ui/authentication/sign_in_page.dart';
import 'package:embajadores/ui/home/pages/stores/my_stores.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/userinfo.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:we_slide/we_slide.dart';
import 'package:badges/badges.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _advancedDrawerController = AdvancedDrawerController();
  final WeSlideController _weSlideController = WeSlideController();
  final _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();
  final CustomColors _colors = CustomColors();
  List<Widget> buttons = <Widget>[];
  List<Widget> pages = <Widget>[];
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  var _mainIcon = Icons.store;
  var _rolIcon = Icons.verified_user_sharp;
  var mainIcon = GlobalKey();
  var keyHelp = GlobalKey();
  var keyMenu = GlobalKey();
  late double _panelMaxSize;
  var _showTutorial = true;
  var _currentIndex = 0;
  var _title = 'Inicio';
  var _showCount = true;
  final _filter = '';
  var _rolTitle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //prefs.userRolId = '2';
    if (prefs.userRolId == '2' || prefs.userRolId == '3') {
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        if (prefs.ownerCount == 0) {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return const RegisterStore();
            },
          ));
        }
      });
    }

    if (prefs.firstRun == true) {
      Future.delayed(const Duration(microseconds: 3000)).then((value) {
        setMainTutorial(int.parse(prefs.userRolId));
        showTutorial();
      });
      prefs.firstRun = false;
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
      print(target);
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

  void showNoTutorial() {
    targets.clear();
    EasyLoading.showInfo('No hay tutoriales disponibles para esta secci??n.',
        maskType: EasyLoadingMaskType.custom,
        duration: const Duration(milliseconds: 3000),
        dismissOnTap: true);
  }

  void setMainTutorial(int rolId) {
    switch (rolId) {
      case 2:
        setManagerTutorials();
        break;
      case 3:
        setOperatorTutorials();
        break;
      case 4:
        setClientTutorials();
        break;
    }
  }

  void setManagerTutorials() {
    switch (_currentIndex) {
      case 0:
        _showTutorial = true;
        setMyStoresTutorial();
        break;
      case 1:
        _showTutorial = true;
        setMyIncidentsTutorial();
        break;
      case 2:
        _showTutorial = true;
        setIncidentsTutorial();
        break;
      case 3:
        _showTutorial = true;
        setStoresTutorial();
        break;
      case 4:
        _showTutorial = true;
        setReportsTutorial();
        break;
      case 5:
        _showTutorial = false;
        break;
    }
  }

  void setOperatorTutorials() {
    switch (_currentIndex) {
      case 0:
        _showTutorial = true;
        setMyStoresTutorial();
        break;
      case 1:
        _showTutorial = true;
        setMyIncidentsTutorial();
        break;
      case 2:
        _showTutorial = true;
        setIncidentsTutorial();
        break;
      case 3:
        _showTutorial = false;
        break;
    }
  }

  void setClientTutorials() {
    switch (_currentIndex) {
      case 0:
        _showTutorial = true;
        setIncidentsTutorial();
        break;
      case 1:
        _showTutorial = true;
        setStoresTutorial();
        break;
      case 2:
        _showTutorial = false;
        break;
    }
  }

  void setMyStoresTutorial() {
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
                    "Bienvenido",
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
                                    "A continuaci??n, se mostrar?? el tutorial del uso de la aplicaci??n Embajadores, que describir?? a detalle como se debe utilizar esta aplicaci??n. Se recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " en la parte superior derecha de la pantalla. Recuerde que los tutoriales se dividen por secci??n.",
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
                  const Text(
                    "Mis tiendas",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          NeumorphicIcon(
                                            Icons.store,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color: Colors.green,
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor:
                                                    Colors.greenAccent,
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                          const Text(
                                            'Abierta',
                                            style: TextStyle(fontSize: 8),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.label,
                                                size: 14,
                                                color: Colors.cyanAccent,
                                              ),
                                              Text('Nombre de la tienda')
                                            ],
                                          ),
                                          Row(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.location_city,
                                                size: 14,
                                                color: Colors.cyanAccent,
                                              ),
                                              Text('Ciudad de la tienda')
                                            ],
                                          ),
                                          Row(
                                            children: const <Widget>[
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 14,
                                                color: Colors.cyanAccent,
                                              ),
                                              Text('Registrado hace')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          NeumorphicIcon(
                                            Icons.logout,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color: Colors.red,
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor:
                                                    Colors.redAccent,
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                          const VerticalDivider(),
                                          NeumorphicIcon(
                                            Icons.app_registration,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color:
                                                    _colors.iconsColor(context),
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor: _colors
                                                    .shadowColor(context),
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              const TextSpan(
                                text: " \n\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.green,
                              )),
                              const TextSpan(
                                text: " Tienda abierta\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.red,
                              )),
                              const TextSpan(
                                text: " Tienda cerrada\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.login,
                                size: 14,
                                color: Colors.greenAccent,
                              )),
                              const TextSpan(
                                text: " Realizar apertura de la tienda (*)\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.logout,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text: " Realizar cierre de la tienda (*)\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.app_registration,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Registrar incidente en la tienda seleccionada.\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.expand_more,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Expanda para ver detalles adicionales.\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text: " Registrar tiendas adicionales.\n\n\n",
                              ),
                              const TextSpan(
                                text:
                                    "(*) Apertura y cierre de la tienda:\nLas tiendas registradas facilitan el registro de la apertura y cierre y la creaci??n de incidentes relacionados a la misma.\nEl registro se realiza tanto local como en l??nea, pero las mostradas en esta pantalla corresponden a las registradas de forma local.\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.login,
                                size: 14,
                                color: Colors.greenAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Al realizar la apertura, la tienda se registra en lin??a como tienda en operaci??n. Puede registrar notas de apertura o dejar la nota por defecto.\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.logout,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Al realizar el cierre, la tienda se registra en lin??a como tienda cerrada. Puede registrar notas de apertura o dejar la nota por defecto.\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.delete,
                                size: 14,
                                color: Colors.grey,
                              )),
                              const TextSpan(
                                text:
                                    " Si la tienda se encuentra cerrada, puede eliminar el registro asociado, expandiendo los detalles encontrar?? el bot??n de eliminaci??n.",
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
        identify: "Target 2",
        keyTarget: mainIcon,
        enableOverlayTab: true,
        //shape: ShapeLightFocus.RRect,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Icono de estado",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
                                    "Muestra el tipo y la cantidad de datos mostrados en pantalla. Presione para desplegar el men?? secundario.\n\n\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.cyan,
                              )),
                              TextSpan(
                                text: " Incidentes\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.cyan,
                              )),
                              TextSpan(
                                text: " Tiendas\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.data_usage,
                                size: 14,
                                color: Colors.cyan,
                              )),
                              TextSpan(
                                text: " Reportes",
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
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 3",
        keyTarget: keyMenu,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        alignSkip: AlignmentGeometry.lerp(
            Alignment.bottomRight, Alignment.center, 0.0),
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
                    "Men?? principal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
                                    "Presione o deslice desde el borde izquierdo de la pantalla hac??a la derecha para mostrar el men?? principal.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ]));
    targets.add(TargetFocus(
        identify: "Target 4",
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(
            const Size(400, 50), Offset(0.0, _panelMaxSize * 0.95)),
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
                    "Men?? secundario",
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
                                    "Mostrar?? acciones b??sicas para la cuenta de usuario actual. \nDeslice hac??a arriba para visualizar men??.",
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

  void setMyIncidentsTutorial() {
    targets.clear();
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
                  const Text(
                    "Mis incidentes",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 40,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          NeumorphicIcon(
                                            Icons.warning_amber_rounded,
                                            size: 40,
                                            style: NeumorphicStyle(
                                                color: Colors.orangeAccent,
                                                shape: NeumorphicShape.flat,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            10)),
                                                shadowLightColor: Colors.orange,
                                                depth: 1,
                                                intensity: 0.7),
                                          ),
                                          const Text(
                                            'En curso',
                                            style: TextStyle(fontSize: 8),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.label,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Servicio afectado')
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.location_city,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Nombre de la tienda')
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons
                                                  .supervised_user_circle_outlined,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Usuarios en operaci??n')
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.error,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(' Usuarios afectados')
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.access_time_outlined,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Registrado hace')
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        NeumorphicIcon(
                                          Icons.app_registration,
                                          size: 40,
                                          style: NeumorphicStyle(
                                              color: Colors.redAccent,
                                              shape: NeumorphicShape.flat,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          10)),
                                              shadowLightColor: Colors.red,
                                              depth: 1,
                                              intensity: 0.7),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              const TextSpan(
                                text: '\n\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              const TextSpan(
                                text: ' Incidente en curso\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text: ' Incidente pendiente por informaci??n\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.app_registration,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text: ' Actualizar incidente seleccionado.\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.expand_more,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text:
                                    ' Expanda para ver detalles adicionales.\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.notes,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text: ' Detalles.\n\n\n',
                              ),
                              const TextSpan(
                                text:
                                    "'En esta pantalla solo se mostrar??n los incidentes relacionados a su cuenta que se encuentren en estado 'En curso' o 'Pendiente'.\n",
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
                          'Toque en cualquier parte para finalizar.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]));
  }

  void setIncidentsTutorial() {
    targets.clear();
    targets.add(TargetFocus(
        identify: 'Target 1',
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
                    'Incidentes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 40,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              NeumorphicIcon(
                                                Icons.warning_amber_rounded,
                                                size: 20,
                                                style: NeumorphicStyle(
                                                    color: Colors.orangeAccent,
                                                    shape: NeumorphicShape.flat,
                                                    boxShape: NeumorphicBoxShape
                                                        .roundRect(BorderRadius
                                                            .circular(10)),
                                                    shadowLightColor:
                                                        Colors.orange,
                                                    depth: 1,
                                                    intensity: 0.7),
                                              ),
                                              const Text(
                                                'En curso',
                                                style: TextStyle(fontSize: 8),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: const <Widget>[
                                                  Icon(
                                                    Icons.label,
                                                    size: 14,
                                                    color: Colors.cyanAccent,
                                                  ),
                                                  Text(' Servicio afectado',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              ),
                                              Row(
                                                children: const <Widget>[
                                                  Icon(
                                                    Icons.location_city,
                                                    size: 14,
                                                    color: Colors.cyanAccent,
                                                  ),
                                                  Text(' Nombre de la tienda',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            NeumorphicIcon(
                                              Icons.app_registration,
                                              size: 20,
                                              style: NeumorphicStyle(
                                                  color: Colors.redAccent,
                                                  shape: NeumorphicShape.flat,
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowLightColor: Colors.red,
                                                  depth: 1,
                                                  intensity: 0.7),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.support_agent,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' T??cnico que registra',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons
                                                  .supervised_user_circle_outlined,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Usuarios en operaci??n',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.error,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(' Usuarios afectados',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.access_time_outlined,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Registrado hace',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.notes,
                                              size: 14,
                                              color: Colors.cyanAccent,
                                            ),
                                            Text(' Detalles',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              const TextSpan(
                                text: "\n\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              const TextSpan(
                                text: " Incidente en curso\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text: " Incidente pendiente por informaci??n\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              const TextSpan(
                                text: ' Incidente masivo en curso\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.local_fire_department_sharp,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text:
                                    ' Incidente masivo pendiente por informaci??n\n',
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.app_registration,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Actualizar/visualizar incidente seleccionado\n",
                              ),
                              const WidgetSpan(
                                  child: Icon(
                                Icons.expand_more,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              const TextSpan(
                                text:
                                    " Expanda para ver detalles adicionales\n\n\n",
                              ),
                              const TextSpan(
                                text:
                                    "En esta pantalla se mostrar??n todos los incidentes que se encuentren en estado 'En curso' o 'Pendiente'.\n",
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
        identify: 'Target 1',
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
                  Row(
                    children: const <Widget>[
                      Text(
                        'Men?? de opciones',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent,
                            fontSize: 20.0),
                      ),
                      Icon(
                        Icons.arrow_drop_down_circle_sharp,
                        size: 40,
                        color: Colors.orange,
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    "Seleccione el filtro deseado y luego oprima en 'Visualizar resumen' para visualizar un informe resumido.\n\n",
                              ),
                              WidgetSpan(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                                ' Filtrar por incidentes masivos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.warning,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                                ' Filtrar por incidentes en curso',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.warning,
                                              size: 14,
                                              color: Colors.redAccent,
                                            ),
                                            Text(
                                                ' Filtrar por incidentes pendientes',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.disabled_by_default,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(' Excluir incidentes masivos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.cleaning_services,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(' Cancelar filtro',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.table_chart_outlined,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            Text(' Visualizar resumen',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
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
  }

  void setStoresTutorial() {
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
                    "Tiendas",
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
                                    "A continuaci??n, se mostrar?? el tutorial de la pantalla tiendas, este m??dulo le permitir?? controlar en tiempo real el estado de las tiendas e incidentes presentados en las mismas.\nSe recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " en la parte superior derecha de la pantalla. Recuerde que los tutoriales se dividen por secci??n.",
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
                  const Text(
                    "Men?? principal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
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
                                Icons.expand_less,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text:
                                    " Bot??n de men?? principal de monitoreo de tiendas\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.grid_3x3,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Visualice tiendas en 3 columnas\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.grid_4x4,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Visualice tiendas en 4 columnas\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.grid_on,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Visualice tiendas en 12 columnas (*)\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.grid_off,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Restablece la vista por defecto\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.cleaning_services_rounded,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Restablece el filtro por defecto\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.filter_list_alt,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text:
                                    " Filtrar tiendas por datos especificos\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text:
                                    " Guarda y comparte captura de la vista actual\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.grey,
                              )),
                              TextSpan(
                                text: " Tienda cerrada\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.green,
                              )),
                              TextSpan(
                                text: " Tienda abierta\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.store,
                                size: 14,
                                color: Colors.orange,
                              )),
                              TextSpan(
                                text: " Tienda con incidente en curso\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.crop_square,
                                size: 14,
                                color: Colors.redAccent,
                              )),
                              TextSpan(
                                text:
                                    " Tienda con afectada por incidente masivo\n\n\n",
                              ),
                              TextSpan(
                                text:
                                    "(*) Esta opci??n le permite ver todas las tiendas en una sola vista.\nPara ver informaci??n detallada de una tienda especifica, presione sobre el indicador de la tienda. Esto lo llevar?? a una nueva pantalla.\nEn la parte inferior se mostrar?? un resumen que se establece seg??n el filtro aplicado, de lo contrario mostrar?? la informaci??n por defecto.",
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
  }

  void setReportsTutorial() {
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
                    "Reportes",
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
                                    "A continuaci??n, se mostrar?? el tutorial de la pantalla Reportes, este m??dulo le permitir?? descargar los registros realizados en un archivo Excel.\nSe recomienda leerlo por completo la primera vez, pero puede omitirlo y verlo cuando lo desee tocando en el icono ",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.help_outline,
                                size: 14,
                                color: Colors.cyanAccent,
                              )),
                              TextSpan(
                                text:
                                    " en la parte superior derecha de la pantalla. Recuerde que los tutoriales se dividen por secci??n.",
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
                  const Text(
                    "Men?? principal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 20.0),
                  ),
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
                                Icons.expand_less,
                                size: 14,
                                color: Colors.orangeAccent,
                              )),
                              TextSpan(
                                text: " Bot??n de men?? principal de reportes\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.cleaning_services_rounded,
                                size: 14,
                                color: Colors.white,
                              )),
                              TextSpan(
                                text: " Restablece el filtro por defecto\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.filter_list_alt,
                                size: 14,
                                color: Colors.white,
                              )),
                              TextSpan(
                                text: " Filtrar por datos especificos\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                Icons.share,
                                size: 14,
                                color: Colors.white,
                              )),
                              TextSpan(
                                text:
                                    " Descarga y comparte los datos filtrados (*)\n\n\n",
                              ),
                              TextSpan(
                                text:
                                    "(*) Descarga solamente los datos filtrados actualmente, por defecto los datos mostrados corresponden al mes actual hasta el d??a y la hora en curso.",
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
  }

  _setPages(String rolId) {
    buttons.clear();
    pages.clear();
    setState(() {});
    print('ID Rol: $rolId');
    switch (rolId) {
      case '2':
        {
          _rolTitle = 'Supervisor';
          _rolIcon = Icons.supervised_user_circle_outlined;
          pages.add(MyStores());
          pages.add(MyIncidents());
          pages.add(AllIncidents());
          pages.add(GlobalStatusStores(filter: _filter));
          pages.add(const IncidentsQuery());
          pages.add(AboutPage());
          buttons.add(customListTile(Icons.store, 'Mis tiendas', 0));
          buttons.add(
              customListTile(Icons.warning_amber_rounded, 'Mis incidentes', 1));
          buttons.add(
              customListTile(Icons.warning_amber_rounded, 'Incidentes', 2));
          buttons.add(customListTile(Icons.store, 'Tiendas', 3));
          buttons.add(customListTile(Icons.data_usage, 'Reportes', 4));
          buttons.add(customListTile(Icons.info_outline, 'Acerca de...', 5));
        }
        break;
      case '3':
        {
          _rolTitle = 'Operador';
          _rolIcon = Icons.support_agent;
          pages.add(MyStores());
          pages.add(MyIncidents());
          pages.add(AllIncidents());
          pages.add(AboutPage());
          buttons.add(customListTile(Icons.store, 'Mis tiendas', 0));
          buttons.add(
              customListTile(Icons.warning_amber_rounded, 'Mis incidentes', 1));
          buttons.add(
              customListTile(Icons.warning_amber_rounded, 'Incidentes', 2));
          buttons.add(customListTile(Icons.help_outline, 'Acerca de...', 3));
        }
        break;
      case '4':
        {
          _rolTitle = 'Cliente';
          _rolIcon = Icons.verified_user_sharp;
          pages.add(AllIncidents());
          pages.add(GlobalStatusStores(filter: _filter));
          pages.add(AboutPage());
          buttons.add(
              customListTile(Icons.warning_amber_rounded, 'Incidentes', 0));
          buttons.add(customListTile(Icons.store, 'Tiendas', 1));
          buttons.add(customListTile(Icons.help_outline, 'Acerca de...', 2));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _panelMaxSize = MediaQuery.of(context).size.height;
    const double panelMinSize = 60.0;
    _setPages(prefs.userRolId);
    return AdvancedDrawer(
      backdropColor: _colors.contextColor(context),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                width: 70.0,
                height: 70.0,
                margin: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _colors.contextColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _rolIcon,
                  color: Colors.redAccent,
                  size: 50,
                )),
            NeumorphicText(
              _rolTitle,
              style: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: _colors.shadowColor(context),
                  depth: 1.5,
                  intensity: 0.7),
              textStyle: NeumorphicTextStyle(
                fontSize: 15, //customize size here
                // AND others usual text style properties (fontFamily, fontWeight, ...)
              ),
            ),
            const Divider(),
            AutoSizeText(
              '${prefs.userName} ${prefs.lastName}',
              maxLines: 2,
              minFontSize: 8,
              style: TextStyle(
                  color: _colors.iconsColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            AutoSizeText(
              prefs.email,
              maxLines: 1,
              minFontSize: 8,
              style: TextStyle(
                  color: _colors.iconsColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            const Divider(),
            Column(
              children: buttons,
            ),
            const Divider(),
            ListTile(
              leading: NeumorphicIcon(
                Icons.logout,
                size: 30,
                style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 1,
                    intensity: 0.7),
              ),
              title: NeumorphicText(
                ' Cerrar sesi??n',
                style: NeumorphicStyle(
                  color: _colors.textColor(context),
                  intensity: 0.7,
                  depth: 1,
                  shadowLightColor: _colors.shadowTextColor(context),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: NeumorphicIcon(
                Icons.keyboard_arrow_right,
                size: 30,
                style: NeumorphicStyle(
                    color: _colors.iconsColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 1,
                    intensity: 0.7),
              ),
              onTap: () {
                FormHelper.showMessage(
                  context,
                  "Embajadores",
                  "??Cerrar sesi??n?",
                  "Si",
                  () async {
                    final prefs = UserPreferences();
                    prefs.removeValues();
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignInPage(),
                        ),
                        (route) => false);
                  },
                  buttonText2: "No",
                  isConfirmationDialog: true,
                  onPressed2: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text('Quantic Innovations'),
              ),
            ),
          ],
        ),
      ),
      child: NeumorphicTheme(
          theme: NeumorphicThemeData(
            lightSource: LightSource.topLeft,
            accentColor: NeumorphicColors.accent,
            appBarTheme: NeumorphicAppBarThemeData(
                buttonStyle: NeumorphicStyle(
                  color: _colors.iconsColor(context),
                  shadowLightColor: _colors.iconsColor(context),
                  boxShape: const NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.flat,
                  depth: 2,
                  intensity: 0.9,
                ),
                textStyle:
                    TextStyle(color: _colors.textColor(context), fontSize: 12),
                iconTheme:
                    IconThemeData(color: _colors.textColor(context), size: 25)),
            depth: 1,
            intensity: 5,
          ),
          child: Scaffold(
            key: _scaffoldKey,
            appBar: NeumorphicAppBar(
              leading: GestureDetector(
                //key: keyLogo,
                onTap: () {
                  if (_weSlideController.isOpened) {
                    _weSlideController.hide();
                  } else {
                    _weSlideController.show();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: <Widget>[
                      Badge(
                        key: mainIcon,
                        showBadge: _showCount,
                        badgeContent: Consumer<CounterProvider>(
                          builder: (context, notifier, child) => Text(
                              notifier.counter.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                        child: NeumorphicIcon(
                          _mainIcon,
                          size: 40,
                          style: NeumorphicStyle(
                              color: _colors.iconsColor(context),
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10)),
                              shadowLightColor: _colors.shadowColor(context),
                              depth: 1.5,
                              intensity: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NeumorphicText(
                    _title,
                    //key: keyWelcome,
                    style: NeumorphicStyle(
                      color: _colors.iconsColor(context),
                      intensity: 0.7,
                      depth: 1.5,
                      shadowLightColor: _colors.shadowColor(context),
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
                      "??Ver tutorial de la secci??n?",
                      "Si",
                      () {
                        setMainTutorial(int.parse(prefs.userRolId));
                        _showTutorial == false
                            ? showNoTutorial()
                            : showTutorial();
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
                          color: _colors.iconsColor(context),
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          shadowLightColor: _colors.shadowColor(context),
                          depth: 1.5,
                          intensity: 0.7),
                    ),
                  ),
                ),
              ],
            ),
            body: WeSlide(
              controller: _weSlideController,
              panelMinSize: panelMinSize,
              panelMaxSize: _panelMaxSize,
              overlayColor: _colors.iconsColor(context),
              overlayOpacity: 0.9,
              overlay: true,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.800,
                          child: pages[_currentIndex]),
                    ],
                  ),
                ),
              ),
              panel: const UserInfo(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 46),
              child: NeumorphicFloatingActionButton(
                key: keyMenu,
                mini: true,
                style: NeumorphicStyle(
                    color: _colors.contextColor(context),
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    shadowLightColor: _colors.shadowColor(context),
                    depth: 2,
                    intensity: 1),
                tooltip: 'Inicio',
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.menu_open,
                    color: _colors.iconsColor(context),
                    size: 30,
                  ),
                ),
                onPressed: () async {
                  _advancedDrawerController.showDrawer();
                },
              ),
            ),
          )),
    );
  }

  Widget customListTile(IconData iconData, String label, int index) {
    return ListTile(
      leading: NeumorphicIcon(
        iconData,
        size: 30,
        style: NeumorphicStyle(
            color: _colors.iconsColor(context),
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            shadowLightColor: _colors.shadowColor(context),
            depth: 1,
            intensity: 0.7),
      ),
      title: NeumorphicText(
        label,
        style: NeumorphicStyle(
          color: _colors.textColor(context),
          intensity: 0.7,
          depth: 1,
          shadowLightColor: _colors.shadowTextColor(context),
        ),
        textStyle: NeumorphicTextStyle(
          fontSize: 14,
        ),
      ),
      trailing: NeumorphicIcon(
        Icons.keyboard_arrow_right,
        size: 30,
        style: NeumorphicStyle(
            color: _colors.iconsColor(context),
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            shadowLightColor: _colors.shadowColor(context),
            depth: 1,
            intensity: 0.7),
      ),
      onTap: () {
        setState(() {
          _advancedDrawerController.hideDrawer();
          if (_weSlideController.isOpened) _weSlideController.hide();
          _title = label;
          _mainIcon = iconData;
          _showCount = index != 4;
          _currentIndex = index;
        });
        print('Indice seleccionado: $_currentIndex');
        print('Mostrar tutorial: $_showTutorial');
      },
    );
  }

  Widget underConstruction() {
    return Container(
      color: _colors.contextColor(context),
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
            'Su cuenta no dispone de los privilegios requeridos     para visualizar esta pantalla.'),
      ),
    );
  }
}
