import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/data/repositories/product_repository.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProductsByCategory(categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTile(product: product);
              },
            );
          } else {
            return const Center(child: Text('No products available.'));
          }
        },
      ),
    );
  }

  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    // Fetch the products and filter by category
    final response = await ProductRepository().fetchProducts();
    return response.where((product) {
      return product.category.name == categoryName;
    }).toList();
  }
}

class ProductTile extends StatefulWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 150,
              child: CarouselSlider(
                  items: widget.product.images.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text('Image not available'));
                          },
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                  )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price}',
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
