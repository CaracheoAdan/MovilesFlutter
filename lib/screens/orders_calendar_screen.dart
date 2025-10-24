import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/order_dao.dart';

class OrdersCalendarScreen extends StatefulWidget {
  const OrdersCalendarScreen({super.key});

  @override
  State<OrdersCalendarScreen> createState() => _OrdersCalendarScreenState();
}

class _OrdersCalendarScreenState extends State<OrdersCalendarScreen> {
  final db = FoodDatabase();

  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Fecha -> lista de órdenes en esa fecha
  final Map<DateTime, List<OrderDao>> _events = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _normalize(DateTime.now());
    _loadOrders();
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  Future<void> _loadOrders() async {
    final orders = await db.selectOrders(); // idOrder, total, createdAt
    _events.clear();

    for (final o in orders) {
      // createdAt viene como 'YYYY-MM-DD HH:mm:ss'
      final str = (o.createdAt ?? '').replaceFirst(' ', 'T');
      DateTime when;
      try {
        when = DateTime.parse(str);
      } catch (_) {
        when = DateTime.now();
      }
      final key = _normalize(when);
      _events.putIfAbsent(key, () => []).add(o);
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  List<OrderDao> _getEventsForDay(DateTime day) {
    return _events[_normalize(day)] ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    final Color brand = const Color(0xFFFFB000);
    final Color ink = const Color(0xFF0F172A);
    final Color inkSoft = const Color(0xFF475569);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand,
        elevation: 0,
        title: const Text(
          'Calendario',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar<OrderDao>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2040, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _format,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle:
                        TextStyle(color: ink, fontWeight: FontWeight.w900),
                    formatButtonVisible: true,
                    formatButtonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ink),
                    ),
                    formatButtonTextStyle:
                        TextStyle(color: ink, fontWeight: FontWeight.w700),
                    leftChevronIcon: Icon(Icons.chevron_left, color: ink),
                    rightChevronIcon: Icon(Icons.chevron_right, color: ink),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: brand.withOpacity(.35),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    // Burbuja con cantidad de eventos
                    markersMaxCount: 3,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = _normalize(selectedDay);
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (f) => setState(() => _format = f),
                  onPageChanged: (f) => _focusedDay = f,
                ),

                const SizedBox(height: 8),

                // Resumen del día seleccionado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Pedidos de ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                        style: TextStyle(
                            color: ink, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_getEventsForDay(_selectedDay).length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Expanded(
                  child: _DayOrdersList(
                    orders: _getEventsForDay(_selectedDay),
                    money: _money,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: const Text('Ir al carrito',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/cart'),
      ),
    );
  }
}

class _DayOrdersList extends StatelessWidget {
  final List<OrderDao> orders;
  final String Function(int) money;

  const _DayOrdersList({required this.orders, required this.money});

  @override
  Widget build(BuildContext context) {
    final Color ink = const Color(0xFF0F172A);
    final Color inkSoft = const Color(0xFF475569);

    if (orders.isEmpty) {
      return const Center(
        child: Text('Sin pedidos en esta fecha'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final o = orders[i];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            title: Text(
              'Pedido #${o.idOrder ?? '-'}',
              style:
                  TextStyle(color: ink, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              (o.createdAt ?? '').isEmpty ? '' : o.createdAt!,
              style: TextStyle(color: inkSoft, fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              money(o.total ?? 0),
              style:
                  TextStyle(color: ink, fontWeight: FontWeight.w900),
            ),
            onTap: () {
              // Si quieres ir a detalle de pedido u orden items,
              // aquí puedes navegar a una pantalla de detalle.
              // Navigator.pushNamed(context, '/orderDetail', arguments: o);
            },
          ),
        );
      },
    );
  }
}
