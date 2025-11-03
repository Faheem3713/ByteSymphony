import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:task/core/network/dio_client.dart';
import 'package:task/models/client.dart';

final clientsNotifierProvider =
    StateNotifierProvider<ClientsNotifier, ClientsState>((ref) {
      return ClientsNotifier(ref);
    });

class ClientsState {
  final List<Client> items;
  final int total;
  final int page;
  final bool loading;
  final String? error;

  ClientsState({
    required this.items,
    required this.total,
    required this.page,
    required this.loading,
    this.error,
  });

  ClientsState copyWith({
    List<Client>? items,
    int? total,
    int? page,
    bool? loading,
    String? error,
  }) => ClientsState(
    items: items ?? this.items,
    total: total ?? this.total,
    page: page ?? this.page,
    loading: loading ?? this.loading,
    error: error,
  );

  factory ClientsState.initial() =>
      ClientsState(items: [], total: 0, page: 1, loading: false, error: null);
}

class ClientsNotifier extends StateNotifier<ClientsState> {
  final Ref ref;
  ClientsNotifier(this.ref) : super(ClientsState.initial());

  Future<void> load({
    int page = 1,
    int pageSize = 10,
    String? search,
    String? sortBy,
    String? sortDir,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final api = ref.read(apiServiceProvider);
      final data = await api.getClients(
        page: page,
        pageSize: pageSize,
        search: search,
        sortBy: sortBy,
        sortDir: sortDir,
      );
      // adapt reading depending on server response shape:
      final itemsRaw = data['items'] ?? data; // could be list or object
      final total = data['total'] ?? (itemsRaw is List ? itemsRaw.length : 0);

      final List<Client> items = (itemsRaw as List)
          .map((e) => Client.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      state = state.copyWith(
        items: items,
        total: total,
        page: page,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refresh() async => load(page: state.page);
}
