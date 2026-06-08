import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowflow_ai/presentation/providers/home/home_provider.dart';
import 'package:knowflow_ai/presentation/screens/chat/chat_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kho Dữ Liệu Công Nghệ'),
        centerTitle: true,
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.errorMessage != null
              ? Center(child: Text('Lỗi: ${homeState.errorMessage}', textAlign: TextAlign.center))
              : homeState.items.isEmpty
                  ? const Center(child: Text('Không có dữ liệu.'))
              : ListView.builder(
                  itemCount: homeState.items.length,
                  itemBuilder: (context, index) {
                    final item = homeState.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: item.imageUrl.isNotEmpty
                            ? Image.asset(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 50),
                              )
                            : const Icon(Icons.device_hub, size: 50),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        icon: const Icon(Icons.chat),
        label: const Text('Hỏi Chatbot'),
      ),
    );
  }
}
