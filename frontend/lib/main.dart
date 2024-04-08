import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/item.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  PaginationDemo(),
    );
  }
}



class PaginationDemo extends StatefulWidget {
  @override
  _PaginationDemoState createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<PaginationDemo> {
  ScrollController _scrollController = ScrollController();
  List<String> _data = [];
  int _perPage = 20;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreData();
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 2));
      List<String> newData = await fetchDataFromApi(_data.length, _perPage);
      if (newData.isEmpty) {
        _hasMore = false;
      } else {
        _data.addAll(newData);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> fetchDataFromApi(int offset, int limit) async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(limit, (index) => 'Item ${offset + index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
          }, icon: Icon(Icons.add))
        ],
        title: Text('Pagination Demo'),
      ),
      body: ListView.builder(
        itemCount: _data.length + (_hasMore ? 1 : 0),
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _data.length) {
            return ListTile(
              title: Text(_data[index]),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String serverUrl = 'http://192.168.1.16:3000';

  final nameController = TextEditingController();

  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('$serverUrl/api/v1/items'));

    if (response.statusCode == 200) {
      final List<dynamic> itemList = jsonDecode(response.body);
      final List<Item> items = itemList.map((item) {
        return Item.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception("Failed to fetch items");
    }
  }

  Future<Item> addItem(String name) async {
    final response = await http.post(Uri.parse('$serverUrl/api/v1/items'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}));

    if (response.statusCode == 201) {
      final dynamic json = jsonDecode(response.body);
      final Item item = Item.fromJson(json);
      return item;
    } else {
      throw Exception('Failed to add item');
    }
  }

  Future<void> updateItem(int id, String name) async {
    final response = await http.put(Uri.parse('$serverUrl/api/v1/items/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}));

    if (response.statusCode != 200) {
      throw Exception("Failed to update item");
    }
  }

  Future<void> deleteItem(int id) async {
    final response =
        await http.delete(Uri.parse('$serverUrl/api/v1/items/$id'));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete item");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: fetchItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          TextEditingController nameController = TextEditingController(text: item.name);
                          return ListTile(
                            title: Text(item.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await deleteItem(item.id);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Edit Item'),
                                            content: TextFormField(
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                labelText: 'Item name',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateItem(item.id,
                                                      nameController.text);
                                                  setState(() {
                                                    nameController.clear();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Item'),
                  content: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        addItem(nameController.text);
                        setState(() {
                          nameController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
