import 'package:flutter/material.dart';

void main() {
  runApp(const LostFoundApp());
}

class LostFoundApp extends StatelessWidget {
  const LostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lost & Found Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5546D9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F5FC),
      ),
      home: const HomeScreen(),
    );
  }
}

class FoundItem {
  String name;
  String category;
  String location;
  String description;
  String type;
  String date;

  FoundItem({
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.type,
    required this.date,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String searchText = '';
  String filter = 'All';

  final List<FoundItem> items = [
    FoundItem(
      name: 'Black Wallet',
      category: 'Personal',
      location: 'College Library',
      description: 'Black leather wallet found near the library.',
      type: 'Lost',
      date: '12 Nov 2026',
    ),
    FoundItem(
      name: 'Blue Water Bottle',
      category: 'Accessories',
      location: 'Computer Lab',
      description: 'Blue water bottle found on a classroom desk.',
      type: 'Found',
      date: '11 Nov 2026',
    ),
    FoundItem(
      name: 'Student ID Card',
      category: 'Documents',
      location: 'Main Block',
      description: 'Student ID card found near the entrance.',
      type: 'Found',
      date: '10 Nov 2026',
    ),
    FoundItem(
      name: 'Wireless Earphones',
      category: 'Electronics',
      location: 'Canteen',
      description: 'Wireless earphones reported missing.',
      type: 'Lost',
      date: '09 Nov 2026',
    ),
  ];

  List<FoundItem> get filteredItems {
    return items.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(searchText.toLowerCase()) ||
              item.location.toLowerCase().contains(searchText.toLowerCase());

      final matchesFilter = filter == 'All' || item.type == filter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void addItem(FoundItem item) {
    setState(() {
      items.insert(0, item);
      selectedTab = 0;
      filter = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5546D9),
        foregroundColor: Colors.white,
        title: const Text(
          'Lost & Found Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: selectedTab == 0
          ? homePage()
          : selectedTab == 1
              ? reportPage()
              : myItemsPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'My Items',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello, Student! 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Find your lost belongings or help someone.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search items or locations...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: statCard(
                  'Lost Items',
                  items.where((e) => e.type == 'Lost').length.toString(),
                  Icons.search,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: statCard(
                  'Found Items',
                  items.where((e) => e.type == 'Found').length.toString(),
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Browse Categories',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['All', 'Lost', 'Found'].map((value) {
              return ChoiceChip(
                label: Text(value),
                selected: filter == value,
                onSelected: (_) {
                  setState(() {
                    filter = value;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Recently Reported Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (filteredItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text('No matching items found.'),
              ),
            ),
          ...filteredItems.map((item) {
            return itemCard(item);
          }),
        ],
      ),
    );
  }

  Widget statCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget itemCard(FoundItem item) {
    final isLost = item.type == 'Lost';

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor:
              isLost ? Colors.orange.shade50 : Colors.green.shade50,
          child: Icon(
            isLost ? Icons.search : Icons.check_circle_outline,
            color: isLost ? Colors.orange : Colors.green,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${item.location}\n${item.category} • ${item.date}',
          ),
        ),
        trailing: Chip(
          label: Text(
            item.type,
            style: TextStyle(
              color: isLost ? Colors.deepOrange : Colors.green,
              fontSize: 12,
            ),
          ),
          backgroundColor:
              isLost ? Colors.orange.shade50 : Colors.green.shade50,
          side: BorderSide.none,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemDetailsScreen(item: item),
            ),
          );
        },
      ),
    );
  }

  Widget reportPage() {
    return ReportItemScreen(onSubmit: addItem);
  }

  Widget myItemsPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'All Reported Items',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...items.map((item) => itemCard(item)),
      ],
    );
  }
}

class ReportItemScreen extends StatefulWidget {
  final Function(FoundItem) onSubmit;

  const ReportItemScreen({super.key, required this.onSubmit});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String type = 'Lost';
  String category = 'Personal';

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report an Item',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide the details to help reconnect belongings.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 22),
          const Text('Report Type'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: ['Lost', 'Found'].map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Item Name'),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter item name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Category'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: [
              'Personal',
              'Electronics',
              'Documents',
              'Accessories',
              'Others',
            ].map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Location'),
          const SizedBox(height: 8),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: 'Where was it lost or found?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Description'),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter item description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    locationController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                  return;
                }

                widget.onSubmit(
                  FoundItem(
                    name: nameController.text.trim(),
                    category: category,
                    location: locationController.text.trim(),
                    description: descriptionController.text.trim(),
                    type: type,
                    date: '12 Nov 2026',
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item reported successfully!'),
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5546D9),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetailsScreen extends StatelessWidget {
  final FoundItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: const Color(0xFF5546D9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.deepPurple.shade50,
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: Color(0xFF5546D9),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Chip(label: Text('${item.type} Item')),
            const Divider(height: 30),
            InfoRow(label: 'Category', value: item.category),
            InfoRow(label: 'Location', value: item.location),
            InfoRow(label: 'Date', value: item.date),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(item.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact feature can be added next.'),
                    ),
                  );
                },
                icon: const Icon(Icons.person_search),
                label: const Text('Contact / Claim Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
