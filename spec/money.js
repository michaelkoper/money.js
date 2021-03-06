// Generated by CoffeeScript 2.2.4
(function() {
  describe("Money", function() {
    beforeEach(function() {
      return Money.currencies = {
        'EUR': {
          identifier: 'EUR',
          fixed: 2,
          name: 'euro',
          factor: 100,
          separator: ',',
          thousands: '.',
          format: function(base) {
            return `${base} €`;
          },
          unambiguousFormat: function(base) {
            return `${base} €`;
          },
          formatWithTags: function(base) {
            return `${base} <span>€</span>`;
          }
        },
        'CLP': {
          identifier: 'CLP',
          fixed: 0,
          name: 'pesos',
          factor: 1,
          separator: ',',
          thousands: '.',
          format: function(base) {
            return `$${base}`;
          }
        },
        'USD': {
          identifier: 'USD',
          fixed: 2,
          name: 'dollar',
          factor: 100,
          separator: '.',
          thousands: ',',
          format: function(base) {
            return `$${base}`;
          },
          unambiguousFormat: function(base) {
            return `$${base}`;
          },
          formatWithTags: function(base) {
            return `<span>$</span>${base}`;
          }
        },
        'AUD': {
          identifier: 'AUD',
          fixed: 2,
          name: 'Australian Dollar',
          factor: 100,
          separator: '.',
          thousands: ',',
          format: function(base) {
            return `$${base}`;
          },
          unambiguousFormat: function(base) {
            return `AU$${base}`;
          },
          formatWithTags: function(base) {
            return `<span>AU$</span>${base}`;
          }
        }
      };
    });
    describe("#init", function() {
      it("accepts a String as currency", function() {
        var money;
        money = new Money(1000, 'CLP');
        return expect(money.currency.identifier).toEqual('CLP');
      });
      return it("accepts a Currency as currency", function() {
        var money, otherMoney;
        money = new Money(1000, 'CLP');
        otherMoney = new Money(1000, money.currency);
        return expect(otherMoney.currency.identifier).toEqual('CLP');
      });
    });
    describe("#format", function() {
      it("returns the monetary value as a string", function() {
        var money;
        money = new Money(12345, 'EUR');
        expect(money.formatted()).toEqual("123,45 €");
        money = new Money(12345, 'USD');
        return expect(money.formatted()).toEqual("$123.45");
      });
      it("does not display a decimal when factor is 1", function() {
        var money;
        money = new Money(100, 'CLP');
        return expect(money.formatted()).toEqual("$100");
      });
      it("shows thousands", function() {
        var money;
        money = new Money(100000, 'EUR');
        return expect(money.formatted()).toEqual("1.000,00 €");
      });
      describe(":no_cents option", function() {
        it("filters when value has no decimals", function() {
          var money;
          money = new Money(1000, 'EUR');
          return expect(money.formatted({
            no_cents: true
          })).toEqual("10 €");
        });
        return it("filters when value has decimals", function() {
          var money;
          money = new Money(1040, 'EUR');
          return expect(money.formatted({
            no_cents: true
          })).toEqual("10 €");
        });
      });
      return describe(":no_cents_if_whole option", function() {
        it("filters when value has no decimals", function() {
          var money;
          money = new Money(1000, 'EUR');
          return expect(money.formatted({
            no_cents_if_whole: true
          })).toEqual("10 €");
        });
        return it("does't filter when value has decimals", function() {
          var money;
          money = new Money(1040, 'EUR');
          return expect(money.formatted({
            no_cents_if_whole: true
          })).toEqual("10,40 €");
        });
      });
    });
    describe("formattedUnambiguous", function() {
      return it("returns an unambiguous format", function() {
        var money;
        money = new Money(12345, 'AUD');
        return expect(money.formattedUnambiguous()).toEqual("AU$123.45");
      });
    });
    describe("formattedUnambiguous", function() {
      return it("returns an format with tags", function() {
        var money;
        money = new Money(12345, 'AUD');
        return expect(money.formattedWithTags()).toEqual("<span>AU$</span>123.45");
      });
    });
    describe("#add", function() {
      return it("adds cents", function() {
        var money;
        money = new Money(1040, 'EUR');
        return expect(money.add(100).cents).toEqual(1140);
      });
    });
    describe("#subtract", function() {
      return it("subtract cents", function() {
        var money;
        money = new Money(1040, 'EUR');
        return expect(money.subtract(100).cents).toEqual(940);
      });
    });
    describe("#duplicate", function() {
      return it("duplicates a money object", function() {
        var money, newMoney;
        money = new Money(1040, 'EUR');
        newMoney = money.dup();
        return expect(money.cents).toEqual(newMoney.cents);
      });
    });
    describe("#multiply", function() {
      it("with factor of 2", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.multiply(2).cents).toEqual(2000);
      });
      return it("with factor of 2.5", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.multiply(2.5).cents).toEqual(2500);
      });
    });
    describe("#divide", function() {
      it("with factor of 2", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.divide(2).cents).toEqual(500);
      });
      it("with factor of 2.5", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.divide(3).cents).toEqual(333);
      });
      return it("with factor of 250", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.divide(250).cents).toEqual(4);
      });
    });
    describe("#equal", function() {
      it("is equal when same currency and same amount", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isEqual(otherMoney)).toBeTruthy();
      });
      it("isn't equal when same currency but different amount", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1010, 'EUR');
        return expect(money.isEqual(otherMoney)).toBeFalsy();
      });
      return it("isn't equal when same amount but different currency", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'USD');
        return expect(money.isEqual(otherMoney)).toBeFalsy();
      });
    });
    describe("#isPositive", function() {
      return it("is positive when cents are bigger than 0", function() {
        var money;
        money = new Money(1000, 'EUR');
        return expect(money.isPositive()).toBeTruthy();
      });
    });
    describe("#isNegative", function() {
      return it("is negative when cents are smaller than 0", function() {
        var money;
        money = new Money(-1000, 'EUR');
        return expect(money.isPositive()).toBeFalsy();
      });
    });
    describe("#isZero", function() {
      return it("is negative when cents are smaller than 0", function() {
        var money;
        money = new Money(0, 'EUR');
        return expect(money.isZero()).toBeTruthy();
      });
    });
    describe("#isBiggerThan", function() {
      it("returns true if it is bigger", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(0, 'EUR');
        return expect(money.isBiggerThan(otherMoney)).toBeTruthy();
      });
      it("returns false if it is smaller", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(2000, 'EUR');
        return expect(money.isBiggerThan(otherMoney)).toBeFalsy();
      });
      return it("returns false when it is equal", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isBiggerThan(otherMoney)).toBeFalsy();
      });
    });
    describe("#isBiggerOrEqualThan", function() {
      it("returns true if it is bigger", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(0, 'EUR');
        return expect(money.isBiggerOrEqualThan(otherMoney)).toBeTruthy();
      });
      it("returns false if it is smaller", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(2000, 'EUR');
        return expect(money.isBiggerOrEqualThan(otherMoney)).toBeFalsy();
      });
      return it("returns true when it is equal", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isBiggerOrEqualThan(otherMoney)).toBeTruthy();
      });
    });
    describe("#isSmallerThan", function() {
      it("returns true if it is smaller", function() {
        var money, otherMoney;
        money = new Money(0, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerThan(otherMoney)).toBeTruthy();
      });
      it("returns false if it is bigger", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerThan(otherMoney)).toBeFalsy();
      });
      return it("returns false when it is equal", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerThan(otherMoney)).toBeFalsy();
      });
    });
    return describe("#isSmallerOrEqualThan", function() {
      it("returns true if it is smaller", function() {
        var money, otherMoney;
        money = new Money(0, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerOrEqualThan(otherMoney)).toBeTruthy();
      });
      it("returns false if it is bigger", function() {
        var money, otherMoney;
        money = new Money(2000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerOrEqualThan(otherMoney)).toBeFalsy();
      });
      return it("returns true when it is equal", function() {
        var money, otherMoney;
        money = new Money(1000, 'EUR');
        otherMoney = new Money(1000, 'EUR');
        return expect(money.isSmallerOrEqualThan(otherMoney)).toBeTruthy();
      });
    });
  });

}).call(this);
