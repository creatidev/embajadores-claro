import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/data/models/report_basic.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:darq/darq.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({Key? key, required this.listIncidents})
      : super(key: key);
  final List<Incident> listIncidents;
  @override
  IncidentReportState createState() => IncidentReportState();
}

class IncidentReportState extends State<IncidentReport> {
  final CustomColors _colors = CustomColors();
  List<Incident> listIncidents = [];
  var openedStore = 0;
  var closedStore = 0;
  var massive = 0;
  var incidents = 0;
  var totalIncidents = 0;
  List<Report> listReport = <Report>[];
  Report report = Report();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listIncidents = widget.listIncidents;
    getData();
  }

  void getData() {
    Iterable<String> services =
        listIncidents.select((e, index) => e.serNombre!).distinct();

    for (String service in services) {
      report.serviceName = service;
      report.users = listIncidents
          .where((i) => i.serNombre == service)
          .sum((i) => i.incUsuariosOperacion!);
      report.affectedUsers = listIncidents
          .where((i) => i.serNombre == service)
          .sum((i) => i.incUsuariosAfectados!);
      report.affectedStores =
          listIncidents.where((i) => i.serNombre == service).count();
      listReport.add(report);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(120.0),
          border: TableBorder.all(
              color: _colors.borderColor(context),
              style: BorderStyle.solid,
              width: 1),
          children: [
            _tableRow('Tiendas', 'Cantidad', 15),
            _tableRow('Abiertas', openedStore.toString(), 12),
            _tableRow('Cerradas', closedStore.toString(), 12),
            _tableRow('Masivos', massive.toString(), 12),
            _tableRow('Afectadas', incidents.toString(), 12),
            _tableRow('Incidentes', totalIncidents.toString(), 12),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String description, String quantity, double fontSize) {
    return TableRow(children: [
      Column(children: [
        Text(
          description,
          style:
              TextStyle(color: _colors.textColor(context), fontSize: fontSize),
        )
      ]),
      Column(children: [
        Text(
          quantity,
          style:
              TextStyle(color: _colors.textColor(context), fontSize: fontSize),
        )
      ]),
    ]);
  }
}
