import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;


void main() {
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.amber,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  var titulo = "";
  var aux = ""; //recebe o texto
  var itemCount = 0;

  void _buscarLivros() async {
    titulo = _controller.text;
    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': '{$titulo}'},
    );

    final response = await http.get(url);



    if (titulo != ""){

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        itemCount = jsonResponse['totalItems'];
        print('Number of books about $titulo: $itemCount.');
        setState(() {});
        aux = 'Foram encontrados $itemCount livros sobre "$titulo" ';

      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    
      
    }
    
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: _buscarLivros,
                
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar')),
            const SizedBox(height: 16),

            


            Text(
              '$aux', //mostra o texto
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
