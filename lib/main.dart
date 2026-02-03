import 'package:flutter/material.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE65100),
      ),
      home: const MainScreen(),
    );
  }
}

// --- ФУНКЦИЯ ДЛЯ ПЛАВНОГО ПЕРЕХОДА ---
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Настройка анимации появления (Fade)
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 400), // Длительность анимации
  );
}

// --- УНИВЕРСАЛЬНАЯ ШАПКА ---
class CustomHeader extends StatelessWidget {
  final bool showAddress;
  const CustomHeader({super.key, this.showAddress = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    createRoute(const MainScreen()),
                    (route) => false,
                  );
                },
                child: const Icon(Icons.restaurant, color: Colors.white, size: 40),
              ),
              const Column(
                children: [
                  Text("СЕРВИС ПО ЗАКАЗУ ЕДЫ", style: TextStyle(color: Colors.white, fontSize: 10)),
                  Text("\"ВКУСОМАНИЯ\"", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: const Icon(Icons.menu, color: Colors.white, size: 35),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white, thickness: 1.5, height: 1),
        if (showAddress)
          GestureDetector(
            onTap: () => Navigator.of(context).push(createRoute(const AddressScreen())),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 28),
                  Text(" Назарбаева 45/1", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// --- ВЫПАДАЮЩЕЕ МЕНЮ (Drawer) ---
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      "8 705 456 4321", "8 708 789 8765", "8 708 765 4573",
      "Оплата", "Доставка", "Поддержка",
      "Гоголя 55/1", "Назарбаева 33", "Аманжолова 89"
    ];

    return Drawer(
      backgroundColor: const Color(0xFFE65100),
      child: SafeArea(
        child: Column(
          children: [
            const CustomHeader(showAddress: false),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(items[index], style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ЭКРАН 1: ГЛАВНАЯ ---
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> cats = ["Фаст-фуд", "Азиатская кухня", "Грузинская кухня", "Пиццы", "Суши, роллы", "Торты"];

    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                child: const TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Что вам привезти?",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.82,
                ),
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(createRoute(RestaurantScreen(title: cats[index]))),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: const Center(child: Icon(Icons.fastfood, size: 60, color: Colors.orange)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(cats[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ЭКРАН 2: РЕСТОРАНЫ ---
class RestaurantScreen extends StatelessWidget {
  final String title;
  const RestaurantScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Доставки $title", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 15, mainAxisSpacing: 15,
                children: List.generate(4, (index) => Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Center(child: Icon(Icons.store, size: 50, color: Colors.orange)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Назарбаева 54/1\nАманжолова 45", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ЭКРАН 3: АДРЕС ---
class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(showAddress: false),
            const SizedBox(height: 30),
            const Text("ВЫБЕРИТЕ АДРЕС ДОСТАВКИ:", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 250, width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.map, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Text("Назарбаева 45/1", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("ДАЛЕЕ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}