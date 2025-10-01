import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/movies_databases.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({super.key});

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {
  MoviesDatabase? db;

  @override
  void initState() {
    super.initState();
    db = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de peliculas: "),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              "/add",
            ).then((value) => setState(() {})),
            icon: Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db!.SELECT(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else {
            if (snapshot.hasData) {
              return snapshot.data!.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // data generated objetc
                        final obj = snapshot.data![index];
                        return Container(
                          height: 100,
                          color: Colors.grey,
                          // child: Text(snapshot.data[index].nameMovie),
                          child: Column(
                            children: [
                              Text(obj.nameMovie!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pushNamed(context, "/add",arguments: obj), //arguments: obj manda los parametros entre pantallas
                                    icon: Icon(Icons.edit_sharp),
                                  ),
                                  // Expanded(child: Container()),
                                  IconButton(
                                    onPressed: () async {
                                      return showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _buildAlertDialog(obj.idMovie!),
                                      );
                                    },
                                    icon: Icon(Icons.delete_sharp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text("no existen datos"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }

  Widget _buildAlertDialog(int idMovie) {
    return AlertDialog(
      title: Text("Mensaje del sistema"),
      content: Text("Deseas eliminar el registro? "),
      actions: [
        TextButton(
          onPressed: () => db!.DELETE("tblMovies",idMovie).then((value){
            final msj;
            if( value > 0 ){
                msj = "Registro borrado exitosamente";
              setState(() {});
            }else{
               msj = "No se elimino el registro";
            }
            final snackBar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          }),
          child: Text("Aceptar", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}