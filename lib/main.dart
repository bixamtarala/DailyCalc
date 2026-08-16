import 'package:flutter/material.dart';
import 'services/calculator_service.dart';

void main() => runApp(const DailyCalcApp());

class DailyCalcApp extends StatelessWidget {
  const DailyCalcApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'DailyCalc',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
    darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.teal),
    themeMode: ThemeMode.system,
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const tools = <_Tool>[
    _Tool('Simple Interest', Icons.percent, 'Principal, rate and years'),
    _Tool('Compound Interest', Icons.trending_up, 'Growth with compounding'),
    _Tool('EMI Calculator', Icons.account_balance, 'Monthly loan payment'),
    _Tool('Monthly Vaddi', Icons.currency_rupee, '₹ per ₹100 monthly interest'),
    _Tool('Discount', Icons.local_offer, 'Final price after discount'),
    _Tool('GST', Icons.receipt_long, 'GST amount and total'),
    _Tool('Fuel Cost', Icons.local_gas_station, 'Monthly fuel estimate'),
    _Tool('Electricity Cost', Icons.bolt, 'Appliance electricity estimate'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('DailyCalc')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Text('Everyday Calculator for India', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('Fast, private and offline-first. No login required.'),
      const SizedBox(height: 20),
      ...tools.map((t) => Card(child: ListTile(leading: Icon(t.icon), title: Text(t.name), subtitle: Text(t.subtitle), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalculatorScreen(tool: t.name))))),
      const SizedBox(height: 12),
      const Text('Financial outputs are estimates for informational purposes.'),
    ]),
  );
}

class CalculatorScreen extends StatefulWidget {
  final String tool;
  const CalculatorScreen({super.key, required this.tool});
  @override State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final a = TextEditingController(), b = TextEditingController(), c = TextEditingController();
  String result = 'Enter values and calculate';
  double n(TextEditingController x) => double.tryParse(x.text.trim()) ?? 0;
  String money(double x) => '₹${x.toStringAsFixed(2)}';
  List<String> get labels {
    switch(widget.tool) {
      case 'Simple Interest': return ['Principal (₹)', 'Annual rate (%)', 'Years'];
      case 'Compound Interest': return ['Principal (₹)', 'Annual rate (%)', 'Years'];
      case 'EMI Calculator': return ['Loan amount (₹)', 'Annual rate (%)', 'Months'];
      case 'Monthly Vaddi': return ['Principal (₹)', '₹ interest per ₹100/month', 'Months'];
      case 'Discount': return ['Price (₹)', 'Discount (%)', ''];
      case 'GST': return ['Amount (₹)', 'GST rate (%)', ''];
      case 'Fuel Cost': return ['Monthly distance (km)', 'Mileage (km/l)', 'Fuel price (₹/l)'];
      default: return ['Power (watts)', 'Hours/day', 'Days'];
    }
  }
  void calculate() {
    final x=n(a), y=n(b), z=n(c);
    String r;
    switch(widget.tool) {
      case 'Simple Interest': final i=CalculatorService.simpleInterest(x,y,z); r='Interest: ${money(i)}\nTotal: ${money(x+i)}'; break;
      case 'Compound Interest': final total=CalculatorService.compoundAmount(x,y,z); r='Maturity: ${money(total)}\nInterest: ${money(total-x)}'; break;
      case 'EMI Calculator': final emi=CalculatorService.emi(x,y,z.round()); r='Monthly EMI: ${money(emi)}\nTotal payment: ${money(emi*z.round())}'; break;
      case 'Monthly Vaddi': final i=CalculatorService.monthlyVaddi(x,y,z); r='Interest: ${money(i)}\nTotal: ${money(x+i)}'; break;
      case 'Discount': final p=CalculatorService.discountPrice(x,y); r='Final price: ${money(p)}\nYou save: ${money(x-p)}'; break;
      case 'GST': final g=CalculatorService.gstAmount(x,y); r='GST: ${money(g)}\nTotal: ${money(x+g)}'; break;
      case 'Fuel Cost': r='Estimated monthly fuel cost: ${money(CalculatorService.fuelMonthlyCost(x,y,z))}'; break;
      default: r='Estimated electricity cost: ${money(CalculatorService.electricityCost(x,y,z,8))}\nUsing ₹8/unit default';
    }
    setState(()=>result=r);
  }
  @override void dispose(){a.dispose();b.dispose();c.dispose();super.dispose();}
  @override
  Widget build(BuildContext context) {
    final l=labels;
    return Scaffold(appBar: AppBar(title: Text(widget.tool)), body: ListView(padding: const EdgeInsets.all(20), children: [
      TextField(controller:a, keyboardType: const TextInputType.numberWithOptions(decimal:true), decoration: InputDecoration(labelText:l[0], border: const OutlineInputBorder())),
      const SizedBox(height:12),
      TextField(controller:b, keyboardType: const TextInputType.numberWithOptions(decimal:true), decoration: InputDecoration(labelText:l[1], border: const OutlineInputBorder())),
      if(l[2].isNotEmpty)...[const SizedBox(height:12),TextField(controller:c, keyboardType: const TextInputType.numberWithOptions(decimal:true), decoration: InputDecoration(labelText:l[2], border: const OutlineInputBorder()))],
      const SizedBox(height:18), FilledButton.icon(onPressed:calculate, icon:const Icon(Icons.calculate), label:const Text('Calculate')),
      const SizedBox(height:18), Card(child:Padding(padding:const EdgeInsets.all(20),child:Text(result,style:Theme.of(context).textTheme.titleMedium))),
    ]));
  }
}

class _Tool {
  final String name, subtitle; final IconData icon;
  const _Tool(this.name, this.icon, this.subtitle);
}
