import 'package:flutter/material.dart';

void main() {
  runApp(SnackOrderApp());
}

class SnackOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snack Order App',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/snackList': (context) => SnackListScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snack Ordering'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/snackList');
              },
              child: Text('Start Ordering'),
            ),
          ],
        ),
      ),
    );
  }
}

class SnackListScreen extends StatefulWidget {
  @override
  _SnackListScreenState createState() => _SnackListScreenState();
}

class _SnackListScreenState extends State<SnackListScreen> {
  final List<Map<String, dynamic>> snacks = [
    {'name': 'Burger', 'price': 5.99},
    {'name': 'Pizza', 'price': 8.99},
    {'name': 'Fries', 'price': 2.99},
    {'name': 'Coke', 'price': 1.99},
    {'name': 'Sandwich', 'price': 4.99},
  ];
  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> snack) {
    setState(() {
      cart.add(snack);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snacks Menu'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart', arguments: cart);
            },
          ),
        ],
      ),
      body:  ListView.builder(
          itemCount: snacks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${snacks[index]['name']} - "
                  "\$${snacks[index]['price'].toStringAsFixed(2)}"),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => addToCart(snacks[index]),
              ),
            );
          },
        ),
      );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cart =
    ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;

    double getTotalPrice() {
      return cart.fold(0, (sum, item) => sum + item['price']);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart'),
          centerTitle: true, backgroundColor: Colors.orange),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${cart[index]['name']} -"
                        " \$${cart[index]['price'].toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                "Total Price: \$${getTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkout');
              },
              child: Text('Checkout'),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
  }
}

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout'),
          centerTitle: true, backgroundColor: Colors.orange),
      body: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter Your Name'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Enter Your Address'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Enter Your Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle order submission logic here
                },
                child: Text('Place Order'),
              ),
            ],
          ),
        );
  }
}