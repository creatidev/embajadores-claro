import 'dart:convert';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:embajadores/data/controllers/themenotifier.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:embajadores/ui/home/pages/incidents/global/incident_details.dart';
import 'package:embajadores/ui/home/pages/incidents/global/resume_incidents.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

var jsonDemo =
    '{"status":true,"message":"Consulta exitosa","data":[{"id_incidencia":99999,"inc_tipo":1,"inc_usuarios_operacion":50,"inc_usuarios_afectados":20,"inc_fecha_apertura":"$dateTime","inc_fecha_cierre":"$dateTime","inc_masivo":0,"inc_observacion":"Incidente de demostración","id_usuario":99,"usu_nombre":"Demostración aplicación","usu_apellidos":"","id_ciudad":36,"ciu_nombre":"Bogotá","id_tienda":999,"tie_nombre":"CAV Virtual","tie_estado_operacion":1,"id_servicio":1,"ser_nombre":"Demostración","id_tipo_falla":1,"tpf_nombre":"Incidente de demostración","id_estado":2,"ine_nombre":"En curso","observaciones":"Incidente de demostración","componentes":"Todos/No Aplica"}]}';

class AllIncidents extends StatefulWidget {
  const AllIncidents({
    Key? key,
  }) : super(key: key);

  //final
  @override
  AllIncidentsState createState() => AllIncidentsState();
}

class AllIncidentsState extends State<AllIncidents> {
  //String _filter = '%26%26id_estado=2||id_estado=1';
  final CustomColors _colors = CustomColors();
  final prefs = UserPreferences();
  List<TargetFocus> targets = [];
  var apiService = APIService();
  String? jsonCategories;
  int? requirementStatus;
  int keyCount = 0;
  var _filter = '';
  var _title = 'Todos';
  List<Incident> _data = [];

  Future<List<Incident>> getAllUserIncidents(String filter) async {
    final counter = Provider.of<CounterProvider>(context, listen: false);
    var data = apiService.getUserIncidents(filter);

    await data.then((value) {
      _data = value;
      prefs.ownerCount = value.length;
      counter.onChange(value.length);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Incident>>(
            future: getAllUserIncidents(_filter),
            builder:
                (BuildContext context, AsyncSnapshot<List<Incident>> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                    height: 500,
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Container(
                    //color: Colors.black26,
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(_title,
                                style: const TextStyle(color: Colors.orange)),
                          ),
                        ),
                        Wrap(
                          children: <Widget>[
                            ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _incidentCard(
                                      context, snapshot.data!, index);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: const [
          Icons.local_fire_department,
          Icons.warning_amber_outlined,
          Icons.warning,
          Icons.disabled_by_default,
          Icons.cleaning_services_rounded,
          Icons.table_chart_outlined,
        ],
        secondaryIconsText: const [
          'Masivo',
          'En curso',
          'Pendiente',
          'No Masivo',
          'Cancelar filtro',
          'Resumen',
        ],
        secondaryIconsOnPress: [
          () => {setFilter(0)},
          () => {setFilter(1)},
          () => {setFilter(2)},
          () => {setFilter(3)},
          () => {
                EasyLoading.showInfo('Filtro cancelado',
                        maskType: EasyLoadingMaskType.custom,
                        duration: const Duration(milliseconds: 3000),
                        dismissOnTap: true)
                    .then(
                  (value) {
                    setState(() {
                      _filter = '';
                      _title = 'Todos';
                    });
                  },
                )
              },
          () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Resume(
                              data: _data,
                              title: _title,
                            )))
              },
        ],
        secondaryBackgroundColor: Colors.blueGrey,
        secondaryForegroundColor: Colors.orange,
        primaryBackgroundColor: Colors.orange,
        primaryForegroundColor: Colors.white,
      ),
    );
  }

  void setFilter(int index) {
    setState(() {
      _filter = '';
      switch (index) {
        case 0:
          _filter += '%26%26inc_masivo=1';
          _title = 'Masivos';
          break;
        case 1:
          _filter = '%26%26id_estado=2';
          _title = 'En curso';
          break;
        case 2:
          _filter = '%26%26id_estado=1';
          _title = 'Pendientes';
          break;
        case 3:
          _filter = '%26%26inc_masivo!=1';
          _title = 'No masivos';
          break;
      }
    });
  }

  Widget _incidentCard(
      BuildContext context, List<Incident> incidentDetails, int index) {
    var serviceMassive = incidentDetails[index].incMasivo;
    var serviceName = incidentDetails[index].serNombre.toString();
    var serviceCity = incidentDetails[index].ciuNombre.toString();
    var serviceType = incidentDetails[index].tpfNombre.toString();
    var serviceComponent = incidentDetails[index].componentes.toString();
    var serviceStore = incidentDetails[index].tieNombre.toString();
    var serviceUsers = incidentDetails[index].incUsuariosOperacion.toString();
    var serviceAffected =
        incidentDetails[index].incUsuariosAfectados.toString();
    var serviceStatusId = incidentDetails[index].idEstado;
    var serviceStatus = incidentDetails[index].ineNombre.toString();
    var serviceOwnerName = incidentDetails[index].usuNombre.toString();
    var serviceOwnerSName = incidentDetails[index].usuApellidos.toString();
    var creationDate = incidentDetails[index].incFechaApertura;
    var serviceComments = incidentDetails[index].incObservacion;
    var endDate = incidentDetails[index].incFechaCierre;
    bool expanded = false;

    final now = DateTime.now();
    final difference = now.difference(creationDate!);
    final fifteenAgo = DateTime.now().subtract(difference);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: ExpansionTileCard(
        onExpansionChanged: (value) => expanded = value,
        leading: SizedBox(
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                serviceMassive == 1
                    ? Icons.local_fire_department_sharp
                    : Icons.warning_amber_outlined,
                color: serviceStatusId == 1
                    ? Colors.redAccent
                    : serviceStatusId == 2
                    ? Colors.orangeAccent
                    : serviceStatusId == 3
                    ? Colors.grey
                    : null,
                size: 20,
              ),
              Text(
                serviceStatus,
                style: const TextStyle(fontSize: 6),
              ),
            ],
          ),
        ),
        title: Container(
          width: 100,
          height: 40,
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.label,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  AutoSizeText(
                    ' $serviceName',
                    maxLines: 1,
                    minFontSize: 6,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.store,
                    color: _colors.iconsColor(context),
                    size: 15,
                  ),
                  AutoSizeText(
                    ' $serviceStore',
                    maxLines: 2,
                    minFontSize: 7,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Visibility(
          //visible: prefs.userRolId != '4',
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<bool>(
                        builder: (context) => IncidentDetailsUpdate(
                              incident: incidentDetails[index],
                              expanded: expanded,
                            ))).then((value) {
                  if (value == true) {
                    setState(() => super.widget);
                  }
                });
              },
              child: const Icon(
                Icons.app_registration,
                color: Colors.red,
                size: 20,
              )),
        ),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.support_agent,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    Text(
                      ' Registra: $serviceOwnerName $serviceOwnerSName',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.supervised_user_circle_outlined,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    Text(
                      ' Usuarios en operación: $serviceUsers',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    Text(
                      ' Usuarios afectados: $serviceAffected',
                      style: TextStyle(
                        color: serviceAffected == '0'
                            ? Colors.red
                            : Colors.orangeAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    Text(
                      ' ${timeago.format(fifteenAgo, locale: 'es')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: _colors.iconsColor(context),
                      size: 15,
                    ),
                    const Text(
                      ' Detalles',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: AutoSizeText(
                    serviceComments!,
                    minFontSize: 4,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: _colors.textColor(context), fontSize: 12),
                    overflowReplacement:
                        const Text('La descripción es muy extensa'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
