// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siepex/models/modalidade.dart';
import 'package:provider/provider.dart';
import 'package:siepex/src/eventos/juergs/Widgets/confirmDialog.dart';
import 'package:siepex/src/eventos/juergs/Widgets/errorDialog.dart';
import 'package:siepex/src/eventos/juergs/admin/LancaResultGrupos.dart';
import 'package:siepex/src/eventos/juergs/admin/LancarResultados.dart';
import 'package:siepex/src/eventos/juergs/admin/ResultadosRustica.dart';
import 'package:siepex/src/eventos/juergs/admin/selectTeams.dart';

/*
  Nessa página o ADM pode:
  - Passar a competição para próxima fase.
  - Selecionar os times para os jogos da próxima fase.
  - Mudar local da competição (a principio cada competição ocorre em apenas um lugar)
  - ? Alterar data limite de inscrição ?
 */
class CompetitionPage extends StatelessWidget {
  final ValueNotifier<bool> editandoFormato = ValueNotifier(false);
  final ValueNotifier<bool> editandoLocal = ValueNotifier(false);
  final TextEditingController novoLocalController = TextEditingController();
  final ValueNotifier<int> currentFormat = ValueNotifier(2);

  Widget nextFaseButton(BuildContext context, Modalidade modalidade) {
    if (modalidade.fase < 4) {
      return Align(
        alignment: Alignment.center,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                          value: modalidade,
                          child: SelectTeamsPage(),
                        )));
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 45,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.white30,
                    spreadRadius: 1,
                    offset: Offset(0, 2))
              ],
            ),
            child: Center(
              child: Text(
                'Avançar de Fase',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget lancarResultados(BuildContext context, Modalidade modalidade) {
    if (modalidade.fase < 5) {
      return Align(
        alignment: Alignment.center,
        child: FlatButton(
          onPressed: () {
            if (modalidade.nome != 'Rústica') {
              if (modalidade.faseStr == 'Fase de Grupos') // FAse de grupos
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                              value: modalidade,
                              child: LancaResultadosGruposPage(),
                            )));
              else // Fazes eliminatórias
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                              value: modalidade,
                              child: LancarResultadosPage(),
                            )));
            } else
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: modalidade,
                            child: ResultadosRustica(),
                          )));
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 45,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.white30,
                    spreadRadius: 1,
                    offset: Offset(0, 2))
              ],
            ),
            child: Center(
              child: Text(
                'Lançar Resultados',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget selectButton1(context, Modalidade modalidade) {
    if (modalidade.nome != 'Rústica')
      return nextFaseButton(context, modalidade);
    else
      return Container();
  }

  Widget formatoCompeticao(Modalidade modalidade){
    if(modalidade.nome != 'Rústica')
    return ValueListenableBuilder(
              // Widget que lida com alterar o formato da competição.
              valueListenable: editandoFormato,
              builder: (context, newVal, child) {
                if (!editandoFormato.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 22, top: 12),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              'Formato da competição:',
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            FlatButton(
                                // minWidth: 100,
                                padding: EdgeInsets.zero,
                                height: 0,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () {
                                  if(modalidade.faseStr == 'Inscrição'){
                                    editandoFormato.value = true;
                                  }else{
                                    errorDialog(context, 'Atenção!', 'Você não pode alterar o formato da competição depois que ela já iniciou.');
                                  }
                                },
                                child: Text(
                                  'alterar',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22, top: 4),
                        child: Text(
                          modalidade.formatoDescricao,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 22, top: 12),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              'Formato da competição:',
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            FlatButton(
                                // minWidth: 100,
                                padding: EdgeInsets.zero,
                                height: 0,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () async {
                                  bool result = await modalidade.alterarFormato(currentFormat.value);
                                  if(!result){
                                    errorDialog(context, 'Erro', 'Um problema desconhecido ocorreu ao mudar o formato da competição');
                                  }
                                  editandoFormato.value = false;
                                },
                                child: Text(
                                  'pronto',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22, top: 4),
                        child: ValueListenableBuilder(
                          valueListenable: currentFormat,
                          builder: (context, neWval, child){
                            return Column(
                          children: [
                            ListTile(
                              leading: Radio(
                                value: 1,
                                groupValue: currentFormat.value,
                                onChanged: (newValue){
                                  currentFormat.value = newValue;      
                                },
                              ),
                              title: Text(Modalidade.formatoDescricaoMap[1]),
                              onTap: (){
                                  currentFormat.value = 1;      
                              },
                            ),
                            ListTile(
                              leading: Radio(
                                value: 2,
                                groupValue: currentFormat.value,
                                onChanged: (newValue){
                                  currentFormat.value = newValue;      
                                },
                              ),
                              title: Text(Modalidade.formatoDescricaoMap[2]),
                              onTap: (){
                                  currentFormat.value = 2;      
                              },
                            ),
                            ListTile(
                              leading: Radio(
                                value: 3,
                                groupValue: currentFormat.value,
                                onChanged: (newValue){
                                  currentFormat.value = newValue;      
                                },
                              ),
                              title: Text(Modalidade.formatoDescricaoMap[3]),
                              onTap: (){
                                  currentFormat.value = 3;      
                              },
                            ),
                            ListTile(
                              leading: Radio(
                                value: 4,
                                groupValue: currentFormat.value,
                                onChanged: (newValue){
                                  currentFormat.value = newValue;      
                                },
                              ),
                              title: Text(Modalidade.formatoDescricaoMap[4]),
                              onTap: (){
                                  currentFormat.value = 4;      
                              },
                            ),
                          ],
                        );
                          },
                        ), 
                        
                      ),
                    ],
                  );
                }
              },
            );
    return SizedBox(height: 0, width: 0,);
  }

  @override
  Widget build(BuildContext context) {
    Modalidade modalidade = Provider.of<Modalidade>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Competição'),
      ),
      body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0, top: 16),
              child: Text(
                modalidade.nome,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 12),
              child: Text(
                'Local da Competição:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: editandoLocal,
              builder: (context, newValue, child) {
                if (!editandoLocal.value) {
                  return Padding(
                    padding: EdgeInsets.only(left: 22, top: 4),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            modalidade.local,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        FlatButton(
                            minWidth: 100,
                            padding: EdgeInsets.zero,
                            height: 0,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              editandoLocal.value = true;
                            },
                            child: Text(
                              'editar',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ))
                      ],
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0, right: 16),
                        child: Container(
                          width: 300,
                          child: TextField(
                            controller: novoLocalController,
                            decoration:
                                InputDecoration(labelText: 'Novo Local'),
                          ),
                        ),
                      ),
                      FlatButton(
                          padding: EdgeInsets.zero,
                          height: 0,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () async {
                            // print(novoLocalController.value);
                            bool confirm = await confirmDialogWithReturn(
                                context,
                                'Confirmar',
                                'Tem certeza que deseja mudar o local da competição de "${modalidade.local}" para "${novoLocalController.value.text}"');
                            if (confirm) {
                              editandoLocal.value = false;
                              await modalidade.changeLocal(
                                  context, novoLocalController.value.text);
                            } else {
                              editandoLocal.value = false;
                            }
                          },
                          child: Text(
                            'pronto',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 12),
              child: Text(
                'Fase Atual:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 4),
              child: Text(
                modalidade.faseStr,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 12),
              child: Text(
                'Fim das inscrições:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, top: 4),
              child: Text(
                modalidade.dataLimiteString,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
            formatoCompeticao(modalidade),
            SizedBox(
              height: 40,
            ),
            selectButton1(context, modalidade),
            SizedBox(
              height: 40,
            ),
            lancarResultados(context, modalidade)
          ]),
    );
  }
}
