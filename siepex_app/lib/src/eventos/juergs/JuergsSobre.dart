import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JuergsSobre extends StatelessWidget {
  final Widget child;

  JuergsSobre({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,        
          //title: Text('Jogos Universitários da Uergs - Juergs'),
          title: new Text('Jogos Universitários da Uergs - Juergs',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/arte_uergs/Background_App_Uergs_teste.png'),
                    fit: BoxFit.fill)),
            child: ListView(
              children: <Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: ListTile(
                        title: Text(
                      "Objetivos:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))),
                ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Estimular a prática saudável e educativa do esporte, dando continuidade ao trabalho iniciado dentro das escolas de Ensino Médio, nas aulas de Educação Física e, nas edições anteriores dos Jogos; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Fomentar a prática do esporte universitário com fins educativos, cooperativos e competitivos, reforçando o espírito de grupo; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Integrar os alunos das diversas unidades da UERGS, estimulando o espírito de respeito, cooperação e solidariedade; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Destacar o estudante universitário como foco da atividade esportiva, valorizando os diversos âmbitos envolvidos na prática educativa: a saúde, o desempenho e a estética; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Contribuir para o desenvolvimento integral do(a) acadêmico(a) como ser social, autônomo, democrático e participante, estimulando o pleno exercício da cidadania através do esporte; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Reforçar a relação dos organizadores, apoiadores e patrocinadores junto ao público jovem, associando estes nomes a todos aspectos positivos do esporte; """))),
                            ListTile(
                    title: Text.rich(TextSpan(
                        text:
                            """• Consolidar o evento como uma competição universitária organizada, disciplinada, cooperativa, solidária e competitiva. """))),
              ],
            )));
  }
}
