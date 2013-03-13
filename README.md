A lighweight javascript library for handling money in different currencies.

### Features

* Parsing/formatting Money strings.
* Adding, Subtracting, multiplying, dividing.

### Installation

Include the money.js:

<pre>
  &lt;script type="text/javascript" src="path/to/money.js">&lt;/script>
</pre>

I wanted to keep the javascript file small so I only implemented 4 currencies (EUR, GBP, USD, CLP) but the currencies are very easy to add/override.

<pre>
  Money.currencies = {

    'PEN': {
        fixed: 2,
        name: 'nuevo soles',
        factor: 100,
        separator: ',',
        thousands: '.',
        format: function(base){
          return "S/."+base
        }
      },

      'MXN': {
        fixed: 2,
        name: 'mexican pesos',
        factor: 100,
        separator: '.',
        thousands: ',',
        format: function(base){
          return "$"+base
        }
      }

    }
</pre>

### Usage

<pre>
  // Create a money object of 1000,00 euro
  money = new Money(1000, 'EUR');
  money.currency; // 'EUR'
  money.cents;    // 1000

  // Formatting money
  money = Money.new(100000, 'EUR')
  money.formatted(); // 1.000,00 €

  // Formatting Dollars
  money = new Money(100000, 'USD')
  money.formatted(); // $1,000.00

  // Formatting money without cents
  money.formatted({no_cents: true}); // $1,000

  // Calculating
  money = new Money(1000, 'USD');
  money.add(100);      // new Money(1010, 'USD')
  money.subtract(100); // new Money(900, 'USD')
  money.divide(2);     // new Money(500, 'USD')
  money.multiply(2);   // new Money(2000, 'USD')

  // Equal check
  money = new Money(1000, 'USD');
  otherMoney = new Money(1000, 'USD');
  money.isEqual(otherMoney); // true

  // Is positive?
  money.isPositive(); // true
  money.isNegative(); // false
  money.isZero();     // false

</pre>

### Credits

The money.js library is inspired by the great Ruby money library ([RubyMoney/money](https://github.com/RubyMoney/money))
