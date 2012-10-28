// Generated by CoffeeScript 1.3.3
/*

  Money Class

  A lighweight javascript library for handling money in different currencies.
  http://github.com/michaelkoper/money.js

  Copyright (c) 2012 Michael Koper

  Dual licensed under the MIT and GPL licenses.

  @version 0.1
*/

this.Money = (function() {

  Money.currencies = {
    'EUR': {
      fixed: 2,
      name: 'euro',
      factor: 100,
      separator: ',',
      thousands: '.',
      format: function(base) {
        return "" + base + " €";
      }
    },
    'CLP': {
      fixed: 0,
      name: 'pesos',
      factor: 1,
      separator: ',',
      thousands: '.',
      format: function(base) {
        return "$" + base;
      }
    },
    'USD': {
      fixed: 2,
      name: 'dollar',
      factor: 100,
      separator: '.',
      thousands: ',',
      format: function(base) {
        return "$" + base;
      }
    },
    'GBP': {
      fixed: 2,
      name: 'British Pound',
      factor: 100,
      separator: '.',
      thousands: ',',
      format: function(base) {
        return "£" + base;
      }
    }
  };

  Money.defaultCurrency = 'EUR';

  function Money(value, cur, options) {
    this.options = options || {};
    if (cur instanceof Object) {
      this.currency = cur;
    } else {
      this.currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency];
    }
    if (value instanceof Money) {
      this.cents = value.cents;
      if (this.currency.name !== value.currency.name) {
        this.currency = value.currency;
      }
    } else if ((typeof value === 'string') || (value instanceof String)) {
      this.cents = Math.round(value.replace(/\,/, '.') * this.currency.factor);
    } else if ((typeof value === 'number') || (value instanceof Number)) {
      this.cents = Math.round(value);
    } else {
      this.cents = 0;
    }
  }

  Money.prototype.toString = function(options) {
    var amount, amountPrefix, decimals, fixed, minus, prefixNumber, replacedNumber, toString;
    options = options || {};
    fixed = this.currency.fixed;
    if (options.no_cents) {
      fixed = 0;
    }
    amount = this.cents / this.currency.factor;
    minus = (amount < 0 ? "-" : "");
    toString = parseInt(amount = Math.abs(+amount || 0).toFixed(fixed)) + "";
    amountPrefix = (amountPrefix = toString.length) > 3 ? amountPrefix % 3 : 0;
    prefixNumber = amountPrefix ? toString.substr(0, amountPrefix) + this.currency.thousands : "";
    replacedNumber = toString.substr(amountPrefix).replace(/(\d{3})(?=\d)/g, "$1" + this.currency.thousands);
    decimals = (fixed ? this.currency.separator + Math.abs(amount - toString).toFixed(fixed).slice(2) : "");
    return minus + prefixNumber + replacedNumber + decimals;
  };

  Money.prototype.formatted = function(options) {
    return this.currency.format(this.toString(options));
  };

  Money.prototype.dup = function() {
    return new Money(this, this.currency);
  };

  Money.prototype.add = function(v) {
    return new Money(this.cents + v.toMoney(this.currency).cents, this.currency);
  };

  Money.prototype.subtract = function(v) {
    return new Money(this.cents - v.toMoney(this.currency).cents, this.currency);
  };

  Money.prototype.multiply = function(v) {
    return new Money(Math.round(this.cents * v), this.currency);
  };

  Money.prototype.divide = function(v) {
    return new Money(Math.round(this.cents / v), this.currency);
  };

  Money.prototype.isEqual = function(otherMoney) {
    return this.cents === otherMoney.cents && this.currency === otherMoney.currency;
  };

  Money.prototype.isPositive = function() {
    return this.cents > 0;
  };

  Money.prototype.isNegative = function() {
    return this.cents < 0;
  };

  Money.prototype.isZero = function() {
    return this.cents === 0;
  };

  Money.prototype.toMoney = function(cur) {
    return this;
  };

  return Money;

})();

Number.prototype.toMoney = function(cur) {
  var currency;
  currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency];
  return new Money(this, cur);
};

String.prototype.toMoney = function(cur) {
  return new Money(this, cur);
};
