import 'package:expenses/components/chart.bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Charts extends StatelessWidget {
  const Charts({super.key, required this.recentTransaction});

  final List<Transaction> recentTransaction;

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      //pegar a data de hoje e subtrair os dias conforme o index
      final weekDay = DateTime.now().subtract(Duration(days: index));

      // vai pegar a primeira letra do dia da semana
      String dayName = DateFormat.E().format(weekDay)[0];
      double totalSum = 0.0;

      // percorrer a lista de transações, verifica se as datas são iguais e soma os valores
      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      print(DateFormat.E().format(weekDay)[0]);
      print(totalSum);

      return {'day': dayName, 'value': totalSum};
    });
  }

  double get _weekTotalValue {
    //fold percorre a lista e acumula um valor
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'] as String,
                value: tr['value'] as double,
                percentage: (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
