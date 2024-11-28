import 'package:flutter/material.dart';
import 'package:product/ui/screens/product_list_screen.dart';
import '../../data/repositories/product_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> _categories = {}; // Stores category name and image
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

//fetch the category data
  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await ProductRepository().fetchProducts();
      final categories = <String, String>{};

      for (var product in products) {
        final categoryName = product.category.name;
        final categoryImage = product.category.image;

        // Avoid duplicates
        if (!categories.containsKey(categoryName)) {
          categories[categoryName] = categoryImage;
        }
      }

      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 3 / 2, // Adjust the height-to-width ratio
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final categoryName = _categories.keys.elementAt(index);
                    final categoryImage = _categories[categoryName];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to Product List Screen when a category is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductListScreen(categoryName: categoryName),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                categoryImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                categoryName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
