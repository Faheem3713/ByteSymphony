import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/client_provider.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});
  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final _searchCtrl = TextEditingController();
  int page = 1;
  int pageSize = 10;
  String? sortBy;
  String? sortDir;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(clientsNotifierProvider.notifier)
          .load(page: page, pageSize: pageSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Clients')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(hintText: 'Search clients'),
                    onSubmitted: (q) {
                      page = 1;
                      ref
                          .read(clientsNotifierProvider.notifier)
                          .load(
                            page: page,
                            pageSize: pageSize,
                            search: q,
                            sortBy: sortBy,
                            sortDir: sortDir,
                          );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchCtrl.text = _searchCtrl.text,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text('Sort:'),
              DropdownButton<String>(
                value: sortBy,
                items: [
                  DropdownMenuItem(value: null, child: Text('Default')),
                  DropdownMenuItem(
                    value: 'firstName',
                    child: Text('First Name'),
                  ),
                  DropdownMenuItem(value: 'email', child: Text('Email')),
                ],
                onChanged: (v) {
                  setState(() {
                    sortBy = v;
                  });
                  ref
                      .read(clientsNotifierProvider.notifier)
                      .load(
                        page: 1,
                        pageSize: pageSize,
                        search: _searchCtrl.text,
                        sortBy: sortBy,
                        sortDir: sortDir,
                      );
                },
              ),
              IconButton(
                icon: Icon(Icons.swap_vert),
                onPressed: () {
                  setState(() {
                    sortDir = sortDir == 'asc' ? 'desc' : 'asc';
                  });
                  ref
                      .read(clientsNotifierProvider.notifier)
                      .load(
                        page: 1,
                        pageSize: pageSize,
                        search: _searchCtrl.text,
                        sortBy: sortBy,
                        sortDir: sortDir,
                      );
                },
              ),
            ],
          ),
          if (state.loading) LinearProgressIndicator(),
          Expanded(
            child: ListView.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, idx) {
                final c = state.items[idx];
                return ListTile(
                  title: Text('${c.firstName} ${c.lastName}'),
                  subtitle: Text('${c.email} • ${c.phone}'),
                  onTap: () {
                    // navigate to edit screen
                    Navigator.of(
                      context,
                    ).pushNamed('/client-form', arguments: c.id);
                  },
                );
              },
            ),
          ),
          // Pagination controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page ${state.page} of ${((state.total + pageSize - 1) / pageSize).ceil()}',
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: state.page > 1
                        ? () {
                            setState(() => page -= 1);
                            ref
                                .read(clientsNotifierProvider.notifier)
                                .load(
                                  page: page,
                                  pageSize: pageSize,
                                  search: _searchCtrl.text,
                                  sortBy: sortBy,
                                  sortDir: sortDir,
                                );
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: (state.page * pageSize) < state.total
                        ? () {
                            setState(() => page += 1);
                            ref
                                .read(clientsNotifierProvider.notifier)
                                .load(
                                  page: page,
                                  pageSize: pageSize,
                                  search: _searchCtrl.text,
                                  sortBy: sortBy,
                                  sortDir: sortDir,
                                );
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/client-form'),
        child: Icon(Icons.add),
      ),
    );
  }
}
