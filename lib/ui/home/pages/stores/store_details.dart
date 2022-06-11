import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:badges/badges.dart';
import 'package:embajadores/data/controllers/formhelper.dart';
import 'package:embajadores/data/models/global_stores.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({Key? key, required this.storeData}) : super(key: key);
  final StoreData? storeData;
  @override
  StoreDetailsState createState() => StoreDetailsState();
}

class StoreDetailsState extends State<StoreDetails> {
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final CustomColors _colors = CustomColors();
  final APIService _apiService = APIService();
  final prefs = UserPreferences();
  OpenCloseStore? _openCloseStore;
  List<TargetFocus> targets = [];
  var keyHelp = GlobalKey();
  StoreData? _storeData;

  @override
  void initState() {
    _openCloseStore = OpenCloseStore();
    _storeData = widget.storeData;
    super.initState();

    if (prefs.firstViewStore == true) {
      Future.delayed(const Duration(microseconds: 5000)).then((value) {
        setMainTutorial();
        showTutorial();
      });
      prefs.firstViewStore = false;
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
                    "Detalles tienda",
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
                              TextSpan(
                                text: "\n\n",
                              ),
                              TextSpan(
                                text:
                                "A continuación visualizará los detalles del estado actual de la tienda seleccionada.\nSolo se mostrarán detalles de las tiendas actualmente abiertas.\n",
                              ),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.message,
                                    size: 14,
                                    color: Colors.cyanAccent,
                                  )),
                              TextSpan(
                                text:
                                " Si lo requiere envíe un mensaje a través de WhatsApp al técnico que tiene asignada actualmente la tienda, no es necesario que lo tenga registrado en sus contactos. (Requiere WhatsApp instalado en su dispositivo).\n\n\n",
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

  @override
  Widget build(BuildContext context) {
    String massive = _storeData!.incidentes!.masivo! ? 'Si' : 'No';
    int downServices = _storeData!.incidentes!.serviciosCaidos!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colors.contextColor(context),
        foregroundColor: _colors.iconsColor(context),
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: <Widget>[
              Badge(
                //showBadge: _showCount,
                badgeContent: Text(_storeData!.id.toString()),
                child: Icon(
                  Icons.store,
                  color: _colors.iconsColor(context),
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_storeData!.nombre}',
              //key: keyWelcome,
              style: TextStyle(
                color: _colors.iconsColor(context),
                fontSize: 15,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0.0),
            child: Wrap(
              children: <Widget>[
                infoContainer(
                    Icons.store, 'Estado:', _storeData!.descEstado!),
                infoContainer(Icons.location_city, 'Ciudad:',
                    _storeData!.ciudad!.nombre!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    infoContainer(
                        Icons.error, 'Incidentes:', '$downServices'),
                    infoContainer(
                        Icons.warning_amber_rounded, 'Masiva:', massive),
                  ],
                ),
                infoContainer(Icons.support_agent, 'Asignado:',
                    ' ${_storeData!.usuario!.nombre!}${_storeData!.usuario!.apellidos!}'),
                Visibility(
                  visible: _storeData!.usuario!.nombre != 'Sin asignar',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoContainer(Icons.smartphone, 'Celular:',
                          '${_storeData!.usuario!.celular!}'),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            launchWhatsApp();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.message,
                                color: _colors.iconsColor(context),
                                size: 20,
                              ),
                              const Text(
                                ' Enviar mensaje',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                infoContainer(Icons.alternate_email, 'Email:',
                    ' ${_storeData!.usuario!.email!}'),
                Row(
                  children: [
                    infoContainer(Icons.note, 'Detalles:', ''),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AutoSizeText(
                    '${_storeData!.incidentes!.ultimaObservacion}',
                    textAlign: TextAlign.justify,
                    minFontSize: 4,
                    style: const TextStyle(fontSize: 12),
                  ),
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
            FloatingActionButton(
              backgroundColor: _colors.contextColor(context),
              tooltip: 'Atrás',
              child: Container(
                margin: const EdgeInsets.all(2),
                child: Icon(
                  Icons.cancel,
                  color: _colors.iconsColor(context),
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            Visibility(
              visible: false, //_storeData!.descEstado! == 'Abierta',
              child: FloatingActionButton(
                backgroundColor: _colors.contextColor(context),
                tooltip: 'Cerrar tienda',
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                ),
                onPressed: () {
                  _updateStoreStatusDialog(context, _storeData!)
                      .then((value) => Navigator.pop(context, true));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+57 ${_storeData!.usuario!.celular!}',
      text: 'Por favor reportar novedades',
    );

    await launch('$link');
  }

  Container infoContainer(IconData icon, String label, String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: _colors.iconsColor(context),
            size: 18,
          ),
          Text(
            ' $label',
            style: TextStyle(
              color: _colors.textColor(context),
              fontSize: 14,
            ),
          ),
          Text(
            ' $text',
            style: TextStyle(
                color: _colors.textColor(context),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStoreStatusDialog(
      BuildContext context, StoreData storeData) async {
    _notesController.text = 'Cierre de ${storeData.nombre}';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '¿Realizar cierre de ${storeData.nombre}?',
              style: const TextStyle(fontSize: 12),
            ),
            content: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                height: 120,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      controller: _notesController,
                      name: 'notes',
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Notas: ',
                        hintText: ('No es un campo obligatorio'),
                        border: const OutlineInputBorder(),
                        hoverColor: _colors.iconsColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cierre'),
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    _openCloseStore!.tipo =
                    storeData.descEstado == 'Cerrada' ? 2 : 3;
                    _openCloseStore!.idTienda = storeData.id;
                    _openCloseStore!.usuariosOperacion = 0;
                    _openCloseStore!.fechaCierre = DateTime.now().toString();
                    _openCloseStore!.fechaApertura = DateTime.now().toString();
                    _openCloseStore!.observacion = _notesController.text;
                    _apiService.openCloseStore(_openCloseStore!).then((value) {
                      if (value.status == true) {
                        EasyLoading.showInfo('La tienda se ha cerrado',
                            maskType: EasyLoadingMaskType.custom,
                            duration: const Duration(milliseconds: 1000),
                            dismissOnTap: true);
                        _notesController.clear();
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      } else {
                        EasyLoading.showInfo(
                            'No se pudo cambiar el estado de la tienda',
                            maskType: EasyLoadingMaskType.custom,
                            duration: const Duration(milliseconds: 1000),
                            dismissOnTap: true);
                      }
                    });
                  }
                },
              ),
            ],
          );
        });
  }
}
