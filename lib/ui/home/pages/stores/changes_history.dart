import 'package:embajadores/data/services/api_service.dart';
import 'package:embajadores/data/models/incidents.dart';
import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

APIService apiService = APIService();
CustomColors _colors = CustomColors();

class ChangesHistory extends StatelessWidget {
  const ChangesHistory({Key? key, required this.incidentId}) : super(key: key);
  final int incidentId;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colors.contextColor(context),
        foregroundColor: _colors.iconsColor(context),
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Icon(
            Icons.history,
            color: _colors.iconsColor(context),
            size: 50,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Historial de cambios',
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: FutureBuilder<List<Update>>(
              future: apiService.getIncidentUpdates(incidentId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Update>> snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return infoContainer(snapshot.data!, index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
          ],
        ),
      ),
    );
  }

  Container infoContainer(List<Update> listUpdate, int index) {
    var description = listUpdate[index].descripcion;
    var status = listUpdate[index].nombreEstado;
    var creationDate = DateFormat('dd MMM yyyy - hh:mm a')
        .format(listUpdate[index].fechaCreacion!);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Estado:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(status ?? '', style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: <Widget>[
              const Text("Fecha:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(creationDate, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const Divider(),
          const Text('Detalles:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Divider(),
          Expanded(
            flex: 0,
            child: Text(
              description ?? '',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
