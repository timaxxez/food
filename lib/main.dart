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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          primary: const Color(0xFFE65100),
          secondary: Colors.orangeAccent,
        ),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}

// --- МОДЕЛЬ ДАННЫХ ---
class UserData {
  final String firstName;
  final String lastName;
  final String phone;

  UserData({required this.firstName, required this.lastName, required this.phone});
}

// --- АНИМАЦИЯ ПЕРЕХОДА ---
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// --- КАРТОЧКА ИНФОРМАЦИИ ---
class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ЭКРАН РЕГИСТРАЦИИ ---
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _tryRegister() {
    if (_nameController.text.trim().isEmpty || 
        _surnameController.text.trim().isEmpty || 
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Пожалуйста, заполните все поля!"),
          backgroundColor: Colors.redAccent.shade700,
        ),
      );
      return;
    }

    final user = UserData(
      firstName: _nameController.text,
      lastName: _surnameController.text,
      phone: _phoneController.text,
    );
    Navigator.of(context).pushReplacement(createRoute(MainScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, color: Colors.white, size: 100),
                const SizedBox(height: 10),
                const Text("ВКУСОМАНИЯ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 50),
                _buildInput("Имя", Icons.person_outline, _nameController),
                const SizedBox(height: 15),
                _buildInput("Фамилия", Icons.person_outline, _surnameController),
                const SizedBox(height: 15),
                _buildInput("Номер телефона", Icons.phone_android, _phoneController, type: TextInputType.phone),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  onPressed: _tryRegister,
                  child: const Text("ЗАРЕГИСТРИРОВАТЬСЯ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Padding(padding: const EdgeInsets.only(left: 15), child: Icon(icon, color: Colors.grey)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}

// --- ШАПКА ---
class CustomHeader extends StatelessWidget {
  final bool showAddress;
  final UserData? user;
  const CustomHeader({super.key, this.showAddress = true, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (user != null) {
                    Navigator.of(context).pushAndRemoveUntil(createRoute(MainScreen(user: user!)), (route) => false);
                  }
                },
                child: const Icon(Icons.restaurant, color: Colors.white, size: 40),
              ),
              const Column(
                children: [
                  Text("СЕРВИС ПО ЗАКАЗУ ЕДЫ", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1)),
                  Text("ВКУСОМАНИЯ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.menu, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white54, thickness: 1, height: 1),
        if (showAddress)
          GestureDetector(
            onTap: () => Navigator.of(context).push(createRoute(const AddressScreen())),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.black.withOpacity(0.1),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text("Караганда, пр. Н.Назарбаева 45", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// --- МЕНЮ (DRAWER) ---
class CustomDrawer extends StatelessWidget {
  final UserData user;
  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<String> items = ["Оплата", "Доставка", "Поддержка", "ЛИЧНЫЕ ДАННЫЕ"];

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            CustomHeader(showAddress: false, user: user),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final String title = items[index];
                  bool isProfile = title == "ЛИЧНЫЕ ДАННЫЕ";

                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (title == "Оплата") Navigator.of(context).push(createRoute(const InfoPage(title: "ОПЛАТА", icon: Icons.payment, details: {"Метод": "Kaspi / Карты", "Валюта": "Тенге (₸)", "Защита": "SSL Secure"})));
                      if (title == "Доставка") Navigator.of(context).push(createRoute(const InfoPage(title: "ДОСТАВКА", icon: Icons.delivery_dining, details: {"Время": "30-60 мин", "Стоимость": "от 500 ₸", "Зона": "Весь город"})));
                      if (title == "Поддержка") Navigator.of(context).push(createRoute(const InfoPage(title: "ПОДДЕРЖКА", icon: Icons.headset_mic, details: {"Телефон": "8 (777) 228 67 67", "TG": "@vkusomania", "Email": "help@eda.kz"})));
                      if (isProfile) Navigator.of(context).push(createRoute(ProfileScreen(user: user)));
                    },
                    tileColor: isProfile ? Colors.white : Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    leading: Icon(
                      isProfile ? Icons.person : Icons.info_outline, 
                      color: isProfile ? Theme.of(context).primaryColor : Colors.white
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        color: isProfile ? Theme.of(context).primaryColor : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: isProfile ? Theme.of(context).primaryColor : Colors.white70, size: 16),
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

// --- ГЛАВНЫЙ ЭКРАН (БЕЗ ПОИСКА) ---
class MainScreen extends StatelessWidget {
  final UserData user;
  const MainScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"name": "Фаст-фуд", "icon": Icons.fastfood},
      {"name": "Азиатская кухня", "icon": Icons.ramen_dining},
      {"name": "Грузинская кухня", "icon": Icons.dinner_dining}, 
      {"name": "Пиццы", "icon": Icons.local_pizza},
      {"name": "Суши, роллы", "icon": Icons.set_meal},
      {"name": "Торты", "icon": Icons.cake},
    ];

    return Scaffold(
      endDrawer: CustomDrawer(user: user),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(user: user),
            const SizedBox(height: 10), // Небольшой отступ вместо поиска
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 15, 
                  mainAxisSpacing: 15, 
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(createRoute(RestaurantScreen(title: categories[index]["name"], user: user))),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]
                            ),
                            child: Center(
                              child: Icon(
                                categories[index]["icon"], 
                                size: 70, 
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          categories[index]["name"], 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center
                        ),
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

// --- ЭКРАН РЕСТОРАНОВ ---
class RestaurantScreen extends StatelessWidget {
  final String title;
  final UserData user;
  const RestaurantScreen({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> restaurantsData = {
      "Фаст-фуд": [
        {"name": "Gippo", "addr": "пр. Бухар-Жырау, 55", "icon": Icons.lunch_dining},
        {"name": "KFC", "addr": "пр. Н.Назарбаева, 19", "icon": Icons.fastfood},
        {"name": "Salam Bro", "addr": "ул. Гоголя, 34", "icon": Icons.lunch_dining},
        {"name": "Burger King", "addr": "City Mall, 3 этаж", "icon": Icons.fastfood},
      ],
      "Азиатская кухня": [
        {"name": "Turandot", "addr": "ул. Ермекова, 28", "icon": Icons.ramen_dining},
        {"name": "Pinta", "addr": "пр. Бухар-Жырау, 76", "icon": Icons.rice_bowl},
        {"name": "Korean House", "addr": "мкр. Степной-2, 3", "icon": Icons.soup_kitchen},
        {"name": "Zuma", "addr": "ул. Воинов-Интернационалистов", "icon": Icons.set_meal},
      ],
      "Грузинская кухня": [
        {"name": "Тбилисури", "addr": "пр. Н.Назарбаева, 19", "icon": Icons.dinner_dining},
        {"name": "Генацвале", "addr": "ул. Чкалова, 6", "icon": Icons.local_dining},
        {"name": "Дареджани", "addr": "ТЦ Global City", "icon": Icons.bakery_dining},
        {"name": "Алазани", "addr": "ул. Муканова, 18", "icon": Icons.dinner_dining},
      ],
      "Пиццы": [
        {"name": "Dodo Pizza", "addr": "пр. Бухар-Жырау, 59/2", "icon": Icons.local_pizza},
        {"name": "Pizza Blues", "addr": "ул. Ленина, 5", "icon": Icons.local_pizza},
        {"name": "Palermo", "addr": "ул. Гоголя, 49", "icon": Icons.local_pizza},
        {"name": "Papa John's", "addr": "пр. Республики, 18", "icon": Icons.local_pizza},
      ],
      "Суши, роллы": [
        {"name": "Samurai", "addr": "ул. Алиханова, 37", "icon": Icons.set_meal},
        {"name": "Yaponchik", "addr": "мкр. Гульдер-1", "icon": Icons.set_meal},
        {"name": "Sushi Wok", "addr": "пр. Н.Назарбаева, 33", "icon": Icons.rice_bowl},
        {"name": "Yakuza", "addr": "ул. Ерубаева, 44", "icon": Icons.set_meal},
      ],
      "Торты": [
        {"name": "Куликовский", "addr": "пр. Бухар-Жырау, 53", "icon": Icons.cake},
        {"name": "Хлебный Дом", "addr": "ул. Муканова, 1", "icon": Icons.bakery_dining},
        {"name": "Сладкая Сказка", "addr": "ул. Комиссарова, 22", "icon": Icons.cookie},
        {"name": "Рахат", "addr": "пр. Бухар-Жырау, 42", "icon": Icons.cake},
      ],
    };

    final currentRestaurants = restaurantsData[title] ?? [];

    return Scaffold(
      endDrawer: CustomDrawer(user: user),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(user: user),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: currentRestaurants.isEmpty 
              ? const Center(child: Text("Пока пусто...", style: TextStyle(color: Colors.white, fontSize: 18)))
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8,
                ),
                itemCount: currentRestaurants.length,
                itemBuilder: (context, index) {
                  final rest = currentRestaurants[index];
                  return Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                            child: Center(
                              child: Icon(
                                rest["icon"], 
                                size: 65, 
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(rest["name"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(rest["addr"], style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
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

// --- СТРАНИЦА ЛИЧНЫХ ДАННЫХ ---
class ProfileScreen extends StatelessWidget {
  final UserData user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(showAddress: false, user: user),
            const SizedBox(height: 30),
            const Text("ЛИЧНЫЕ ДАННЫЕ", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            InfoCard(label: "ИМЯ", value: user.firstName, icon: Icons.person),
            InfoCard(label: "ФАМИЛИЯ", value: user.lastName, icon: Icons.family_restroom),
            InfoCard(label: "ТЕЛЕФОН", value: user.phone, icon: Icons.phone_iphone),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  // Кнопка "НАЗАД" - теперь такая же, как везде (Белая)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("НАЗАД", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 15),
                  // Кнопка выхода - Красная, но той же формы
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700, 
                      foregroundColor: Colors.white, 
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(createRoute(const RegistrationScreen()), (route) => false),
                    child: const Text("ВЫЙТИ ИЗ АККАУНТА", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ЕДИНАЯ СТРАНИЦА ИНФОРМАЦИИ ---
class InfoPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, String> details;

  const InfoPage({super.key, required this.title, required this.icon, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(showAddress: false),
            const SizedBox(height: 30),
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ...details.entries.map((e) => InfoCard(label: e.key, value: e.value, icon: Icons.info_outline)).toList(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: Theme.of(context).primaryColor, 
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("ПОНЯТНО", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ЭКРАН ВЫБОРА АДРЕСА ---
class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(showAddress: false),
            const SizedBox(height: 40),
            const Text("АДРЕС ДОСТАВКИ", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Container(
              height: 250, width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))]
              ),
              child: Icon(Icons.map_rounded, size: 120, color: Theme.of(context).primaryColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text("Караганда, пр. Н.Назарбаева 45", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("ВЫБРАТЬ ЭТОТ АДРЕС", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}