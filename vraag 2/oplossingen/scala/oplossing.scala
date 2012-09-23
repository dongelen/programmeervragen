1.to(100).map { x =>
	(x % 3, x % 5) match {
		case (0, 0) => "FizzBuzz"
		case (0, _) => "Fizz"
		case (_, 0) => "Buzz"
		case _ => x.toString
	}
} foreach(println)


// alternatief
// 
def fizzbuzz(n: Int) : String = {
	if (n % 15 == 0) "FizzBuzz"
	else if (n % 3 == 0) "Fizz"
	else if (n % 5 == 0) "Buzz"
	else n.toString
}

1.to(100).map(fizzbuzz).foreach(println)