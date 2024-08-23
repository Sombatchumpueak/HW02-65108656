import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.http("fakestoreapi.com", "products");
    var response = await http.get(url);
    setState(() {
      products = productFromJson(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IT@WU Shop")),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                var imgUrl = product.image;
                imgUrl ??=
                    "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";
                return ListTile(
                  title: Text("${product.title}"),
                  subtitle: Text("\$${product.price}"),
                  leading: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(imgUrl),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(),
                        settings: RouteSettings(
                          arguments: product,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    var imgUrl = product.image;
    imgUrl ??=
        "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "Category",
              style: TextStyle(color: const Color.fromARGB(255, 207, 203, 203)),
            ),
            subtitle: Text(
              "${product.category}",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
                "Rating : ${product.rating!.rate}/5 of ${product.rating!.count}"),
          ),
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(imgUrl),
          ),
          ListTile(
            title: Text(
              "${product.title}",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "\$ ${product.price}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          RatingBar.builder(
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: const Color.fromARGB(255, 255, 61, 61),
            ),
            onRatingUpdate: (value) => print(value),
            minRating: 0,
            itemCount: 5,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            initialRating: product.rating!.rate ?? 0,
          ),
        ],
      ),
    );
  }
}
