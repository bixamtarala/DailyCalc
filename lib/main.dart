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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  static const tools = <_Tool>[
    _Tool('Expense Calculator', Icons.wallet, 'Money', 'Income, expenses and savings'),
    _Tool('EMI Calculator', Icons.account_balance, 'Loans', 'Monthly loan payment'),
    _Tool('Loan Prepayment', Icons.speed, 'Loans', 'See months and interest saved'),
    _Tool('Monthly Vaddi', Icons.currency_rupee, 'Loans', '₹ per ₹100 monthly interest'),
    _Tool('Simple Interest', Icons.percent, 'Money', 'Principal, rate and years'),
    _Tool('Compound Interest', Icons.trending_up, 'Money', 'Growth with compounding'),
    _Tool('SIP Calculator', Icons.savings, 'Savings', 'Estimate SIP future value'),
    _Tool('FD Calculator', Icons.lock_clock, 'Savings', 'Fixed deposit maturity'),
    _Tool('RD Calculator', Icons.calendar_month, 'Savings', 'Recurring deposit estimate'),
    _Tool('Inflation Calculator', Icons.show_chart, 'Money', 'Future cost after inflation'),
    _Tool('Discount', Icons.local_offer, 'Shopping', 'Final price after discount'),
    _Tool('GST', Icons.receipt_long, 'Shopping', 'GST amount and total'),
    _Tool('Unit Price', Icons.compare_arrows, 'Shopping', 'Compare price per unit'),
    _Tool('Bill Split', Icons.groups, 'Household', 'Split a bill between people'),
    _Tool('Rent Increase', Icons.home, 'Household', 'New rent after increase'),
    _Tool('Fuel Cost', Icons.local_gas_station, 'Household', 'Monthly fuel estimate'),
    _Tool('Electricity Cost', Icons.bolt, 'Household', 'Appliance electricity estimate'),
    _Tool('Age Calculator', Icons.cake, 'Life', 'Calculate age from date of birth'),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = tools.where((t) => '${t.name} ${t.category}'.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('DailyCalc')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Everyday Calculator for India', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Fast, private and offline-first. No login required.'),
        const SizedBox(height: 16),
        TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search calculators', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        ...visible.map((t) => Card(child: ListTile(
          leading: CircleAvatar(child: Icon(t.icon)), title: Text(t.name), subtitle: Text('${t.category} • ${t.subtitle}'), trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t.name == 'Age Calculator' ? const AgeScreen() : CalculatorScreen(tool: t.name))),
        ))),
        const SizedBox(height: 12),
        const Text('Financial outputs are estimates for informational purposes.'),
      ]),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final String tool;
  const CalculatorScreen({super.key, required this.tool});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final a = TextEditingController(), b = TextEditingController(), c = TextEditingController(), d = TextEditingController();
  String result = 'Enter values and calculate';
  double n(TextEditingController x) => double.tryParse(x.text.trim()) ?? 0;
  String money(double x) => '₹${x.isFinite ? x.toStringAsFixed(2) : '0.00'}';

  List<String> get labels {
    switch (widget.tool) {
      case 'Expense Calculator': return ['Monthly income (₹)', 'Monthly expenses (₹)', '', ''];
      case 'Simple Interest': case 'Compound Interest': case 'FD Calculator': return ['Principal (₹)', 'Annual rate (%)', 'Years', ''];
      case 'EMI Calculator': return ['Loan amount (₹)', 'Annual rate (%)', 'Months', ''];
      case 'Loan Prepayment': return ['Loan amount (₹)', 'Annual rate (%)', 'Remaining months', 'Extra payment/month (₹)'];
      case 'Monthly Vaddi': return ['Principal (₹)', '₹ interest per ₹100/month', 'Months', ''];
      case 'SIP Calculator': case 'RD Calculator': return ['Monthly investment (₹)', 'Annual return/rate (%)', 'Months', ''];
      case 'Inflation Calculator': return ['Current cost (₹)', 'Inflation rate (%)', 'Years', ''];
      case 'Discount': return ['Price (₹)', 'Discount (%)', '', ''];
      case 'GST': return ['Amount (₹)', 'GST rate (%)', '', ''];
      case 'Unit Price': return ['Total price (₹)', 'Quantity', '', ''];
      case 'Bill Split': return ['Bill amount (₹)', 'Number of people', '', ''];
      case 'Rent Increase': return ['Current rent (₹)', 'Increase (%)', '', ''];
      case 'Fuel Cost': return ['Monthly distance (km)', 'Mileage (km/l)', 'Fuel price (₹/l)', ''];
      default: return ['Power (watts)', 'Hours/day', 'Days', 'Electricity price (₹/unit)'];
    }
  }

  void calculate() {
    final x=n(a), y=n(b), z=n(c), w=n(d); String r;
    switch(widget.tool) {
      case 'Expense Calculator':
        final balance=x-y; final rate=x>0?balance/x*100:0; r='Balance: ${money(balance)}\nSavings rate: ${rate.toStringAsFixed(1)}%'; break;
      case 'Simple Interest': final i=CalculatorService.simpleInterest(x,y,z); r='Interest: ${money(i)}\nTotal: ${money(x+i)}'; break;
      case 'Compound Interest': final total=CalculatorService.compoundAmount(x,y,z); r='Maturity: ${money(total)}\nInterest: ${money(total-x)}'; break;
      case 'EMI Calculator': final m=z.round(); final e=CalculatorService.emi(x,y,m); r='Monthly EMI: ${money(e)}\nTotal payment: ${money(e*m)}\nTotal interest: ${money(e*m-x)}'; break;
      case 'Loan Prepayment': final p=CalculatorService.loanPrepayment(x,y,z.round(),w); r='Normal EMI: ${money(p.normalEmi)}\nNew tenure: ${p.newMonths} months\nMonths saved: ${p.monthsSaved}\nInterest saved: ${money(p.interestSaved)}'; break;
      case 'Monthly Vaddi': final i=CalculatorService.monthlyVaddi(x,y,z); r='Interest: ${money(i)}\nTotal: ${money(x+i)}'; break;
      case 'SIP Calculator': final v=CalculatorService.sipFutureValue(x,y,z.round()); r='Estimated value: ${money(v)}\nInvested: ${money(x*z.round())}\nEstimated gain: ${money(v-x*z.round())}'; break;
      case 'FD Calculator': final v=CalculatorService.fdMaturity(x,y,z); r='Maturity: ${money(v)}\nInterest: ${money(v-x)}'; break;
      case 'RD Calculator': final v=CalculatorService.rdFutureValue(x,y,z.round()); r='Estimated maturity: ${money(v)}\nDeposited: ${money(x*z.round())}'; break;
      case 'Inflation Calculator': r='Future estimated cost: ${money(CalculatorService.inflationFutureCost(x,y,z))}'; break;
      case 'Discount': final p=CalculatorService.discountPrice(x,y); r='Final price: ${money(p)}\nYou save: ${money(x-p)}'; break;
      case 'GST': final g=CalculatorService.gstAmount(x,y); r='GST: ${money(g)}\nTotal: ${money(x+g)}'; break;
      case 'Unit Price': r='Price per unit: ${money(CalculatorService.unitPrice(x,y))}'; break;
      case 'Bill Split': r='Each person pays: ${money(CalculatorService.billPerPerson(x,y.round()))}'; break;
      case 'Rent Increase': final nr=CalculatorService.rentAfterIncrease(x,y); r='New rent: ${money(nr)}\nIncrease: ${money(nr-x)}'; break;
      case 'Fuel Cost': r='Estimated monthly fuel cost: ${money(CalculatorService.fuelMonthlyCost(x,y,z))}'; break;
      default: r='Estimated electricity cost: ${money(CalculatorService.electricityCost(x,y,z,w>0?w:8))}\n${w>0?'':'Using ₹8/unit default'}';
    }
    setState(()=>result=r);
  }

  @override void dispose(){a.dispose();b.dispose();c.dispose();d.dispose();super.dispose();}
  @override Widget build(BuildContext context){final l=labels; final ctrls=[a,b,c,d]; return Scaffold(appBar: AppBar(title: Text(widget.tool)),body:ListView(padding:const EdgeInsets.all(20),children:[
    for(var i=0;i<4;i++) if(l[i].isNotEmpty)...[TextField(controller:ctrls[i],keyboardType:const TextInputType.numberWithOptions(decimal:true),decoration:InputDecoration(labelText:l[i],border:const OutlineInputBorder())),const SizedBox(height:12)],
    FilledButton.icon(onPressed:calculate,icon:const Icon(Icons.calculate),label:const Text('Calculate')),const SizedBox(height:18),Card(child:Padding(padding:const EdgeInsets.all(20),child:SelectableText(result,style:Theme.of(context).textTheme.titleMedium)))
  ]));}
}

class AgeScreen extends StatefulWidget { const AgeScreen({super.key}); @override State<AgeScreen> createState()=>_AgeScreenState(); }
class _AgeScreenState extends State<AgeScreen>{DateTime? dob; String get age {if(dob==null)return 'Select your date of birth';final now=DateTime.now();var years=now.year-dob!.year;var months=now.month-dob!.month;var days=now.day-dob!.day;if(days<0){months--;final prev=DateTime(now.year,now.month,0);days+=prev.day;}if(months<0){years--;months+=12;}return '$years years, $months months, $days days';}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Age Calculator')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[FilledButton.icon(onPressed:()async{final d=await showDatePicker(context:context,firstDate:DateTime(1900),lastDate:DateTime.now(),initialDate:DateTime(2000));if(d!=null)setState(()=>dob=d);},icon:const Icon(Icons.calendar_today),label:Text(dob==null?'Select date of birth':'${dob!.day}/${dob!.month}/${dob!.year}')),const SizedBox(height:20),Card(child:Padding(padding:const EdgeInsets.all(24),child:Text(age,style:Theme.of(context).textTheme.headlineSmall,textAlign:TextAlign.center)))])));}

class _Tool {final String name,category,subtitle;final IconData icon;const _Tool(this.name,this.icon,this.category,this.subtitle);}
