import 'dart:math';

class PrepaymentResult {
  final double normalEmi;
  final int originalMonths;
  final int newMonths;
  final int monthsSaved;
  final double originalInterest;
  final double newInterest;
  final double interestSaved;
  const PrepaymentResult({required this.normalEmi,required this.originalMonths,required this.newMonths,required this.monthsSaved,required this.originalInterest,required this.newInterest,required this.interestSaved});
}

class CalculatorService {
  static double simpleInterest(double p,double rate,double years)=>p*rate*years/100;
  static double compoundAmount(double p,double rate,double years)=>p*pow(1+rate/100,years).toDouble();
  static double emi(double p,double annualRate,int months){if(months<=0||p<0)return 0;final r=annualRate/1200;if(r==0)return p/months;final x=pow(1+r,months);return p*r*x/(x-1);}
  static double savingsGoal(double target,double saved,int months)=>months<=0?0:max(0,(target-saved)/months).toDouble();
  static double discountPrice(double price,double discount)=>price*(1-discount/100);
  static double gstAmount(double amount,double rate)=>amount*rate/100;
  static double fuelMonthlyCost(double km,double mileage,double price)=>mileage<=0?0:km/mileage*price;
  static double electricityCost(double watts,double hours,double days,double unitPrice)=>watts/1000*hours*days*unitPrice;
  static double monthlyVaddi(double principal,double rupeesPerHundred,double months)=>principal*(rupeesPerHundred/100)*months;
  static double fdMaturity(double principal,double annualRate,double years)=>compoundAmount(principal,annualRate,years);
  static double sipFutureValue(double monthly,double annualRate,int months){if(months<=0)return 0;final r=annualRate/1200;if(r==0)return monthly*months;return monthly*((pow(1+r,months)-1)/r)*(1+r);}
  static double rdFutureValue(double monthly,double annualRate,int months)=>sipFutureValue(monthly,annualRate,months);
  static double inflationFutureCost(double current,double annualInflation,double years)=>current*pow(1+annualInflation/100,years).toDouble();
  static double unitPrice(double price,double quantity)=>quantity<=0?0:price/quantity;
  static double billPerPerson(double amount,int people)=>people<=0?0:amount/people;
  static double rentAfterIncrease(double rent,double increase)=>rent*(1+increase/100);

  static PrepaymentResult loanPrepayment(double principal,double annualRate,int months,double extraMonthly){
    if(principal<=0||months<=0||extraMonthly<0){return const PrepaymentResult(normalEmi:0,originalMonths:0,newMonths:0,monthsSaved:0,originalInterest:0,newInterest:0,interestSaved:0);}
    final normal=emi(principal,annualRate,months);
    final originalInterest=normal*months-principal;
    final payment=normal+extraMonthly;
    final r=annualRate/1200;
    var balance=principal;
    var paid=0;
    var interestPaid=0.0;
    while(balance>0.01&&paid<months*10){
      final interest=balance*r;
      interestPaid+=interest;
      final principalPaid=max(0.0,payment-interest);
      if(principalPaid<=0)break;
      balance=max(0.0,balance-principalPaid);
      paid++;
    }
    final saved=max(0,months-paid);
    return PrepaymentResult(normalEmi:normal,originalMonths:months,newMonths:paid,monthsSaved:saved,originalInterest:max(0,originalInterest),newInterest:max(0,interestPaid),interestSaved:max(0,originalInterest-interestPaid));
  }
}
