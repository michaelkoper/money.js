describe "Money", ->

  beforeEach ->
    Money.currencies = {
      'EUR': {
        identifier: 'EUR'
        fixed: 2
        name: 'euro'
        factor: 100
        separator: ','
        thousands: '.'
        format: (base) ->
          return "#{base} €"
        unambiguousFormat: (base) ->
          return "#{base} €"
        formatWithTags: (base)->
          return "#{base} <span>€</span>"
      }
      'CLP': {
        identifier: 'CLP'
        fixed: 0
        name: 'pesos'
        factor: 1
        separator: ','
        thousands: '.'
        format: (base) ->
          return "$#{base}"
      }
      'USD': {
        identifier: 'USD'
        fixed: 2
        name: 'dollar'
        factor: 100
        separator: '.'
        thousands: ','
        format: (base) ->
          return "$#{base}"
        unambiguousFormat: (base) ->
          return "$#{base}"
        formatWithTags: (base)->
          return "<span>$</span>#{base}"
      }
      'AUD': {
        identifier: 'AUD'
        fixed: 2
        name: 'Australian Dollar'
        factor: 100
        separator: '.'
        thousands: ','
        format: (base) ->
          return "$#{base}"
        unambiguousFormat: (base) ->
          return "AU$#{base}"
        formatWithTags: (base)->
          return "<span>AU$</span>#{base}"
      }

    }

  describe "#init", ->

    it "accepts a String as currency", ->
      money = new Money(1000, 'CLP')
      expect(money.currency.identifier).toEqual('CLP')

    it "accepts a Currency as currency", ->
      money = new Money(1000, 'CLP')
      otherMoney = new Money(1000, money.currency)
      expect(otherMoney.currency.identifier).toEqual('CLP')

  describe "#format", ->

    it "returns the monetary value as a string", ->
      money = new Money(12345, 'EUR')
      expect(money.formatted()).toEqual("123,45 €")
      money = new Money(12345, 'USD')
      expect(money.formatted()).toEqual("$123.45")

    it "does not display a decimal when factor is 1", ->
      money = new Money(100, 'CLP')
      expect(money.formatted()).toEqual("$100")

    it "shows thousands", ->
      money = new Money(100000, 'EUR')
      expect(money.formatted()).toEqual("1.000,00 €")

    describe ":no_cents option", ->

      it "filters when value has no decimals", ->
        money = new Money(1000, 'EUR')
        expect(money.formatted({no_cents: true})).toEqual("10 €")

      it "filters when value has decimals", ->
        money = new Money(1040, 'EUR')
        expect(money.formatted({no_cents: true})).toEqual("10 €")

    describe ":no_cents_if_whole option", ->
      it "filters when value has no decimals", ->
        money = new Money(1000, 'EUR')
        expect(money.formatted({no_cents_if_whole: true})).toEqual("10 €")

      it "does't filter when value has decimals", ->
        money = new Money(1040, 'EUR')
        expect(money.formatted({no_cents_if_whole: true})).toEqual("10,40 €")

  describe "formattedUnambiguous", ->

    it "returns an unambiguous format", ->
      money = new Money(12345, 'AUD')
      expect(money.formattedUnambiguous()).toEqual("AU$123.45")

  describe "formattedUnambiguous", ->
    it "returns an format with tags", ->
      money = new Money(12345, 'AUD')
      expect(money.formattedWithTags()).toEqual("<span>AU$</span>123.45")

  describe "#add", ->
    it "adds cents", ->
      money = new Money(1040, 'EUR')
      expect(money.add(100).cents).toEqual(1140)

  describe "#subtract", ->
    it "subtract cents", ->
      money = new Money(1040, 'EUR')
      expect(money.subtract(100).cents).toEqual(940)

  describe "#duplicate", ->
    it "duplicates a money object", ->
      money = new Money(1040, 'EUR')
      newMoney = money.dup()
      expect(money.cents).toEqual(newMoney.cents)

  describe "#multiply", ->
    it "with factor of 2", ->
      money = new Money(1000, 'EUR')
      expect(money.multiply(2).cents).toEqual(2000)
    it "with factor of 2.5", ->
      money = new Money(1000, 'EUR')
      expect(money.multiply(2.5).cents).toEqual(2500)

  describe "#divide", ->

    it "with factor of 2", ->
      money = new Money(1000, 'EUR')
      expect(money.divide(2).cents).toEqual(500)

    it "with factor of 2.5", ->
      money = new Money(1000, 'EUR')
      expect(money.divide(3).cents).toEqual(333)

    it "with factor of 250", ->
      money = new Money(1000, 'EUR')
      expect(money.divide(250).cents).toEqual(4)

  describe "#equal", ->

    it "is equal when same currency and same amount", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isEqual(otherMoney)).toBeTruthy()

    it "isn't equal when same currency but different amount", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1010, 'EUR')
      expect(money.isEqual(otherMoney)).toBeFalsy()

    it "isn't equal when same amount but different currency", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'USD')
      expect(money.isEqual(otherMoney)).toBeFalsy()

  describe "#isPositive", ->

    it "is positive when cents are bigger than 0", ->
      money = new Money(1000, 'EUR')
      expect(money.isPositive()).toBeTruthy()

  describe "#isNegative", ->

    it "is negative when cents are smaller than 0", ->
      money = new Money(-1000, 'EUR')
      expect(money.isPositive()).toBeFalsy()

  describe "#isZero", ->

    it "is negative when cents are smaller than 0", ->
      money = new Money(0, 'EUR')
      expect(money.isZero()).toBeTruthy()

  describe "#isBiggerThan", ->

    it "returns true if it is bigger", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(0, 'EUR')
      expect(money.isBiggerThan(otherMoney)).toBeTruthy()

    it "returns false if it is smaller", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(2000, 'EUR')
      expect(money.isBiggerThan(otherMoney)).toBeFalsy()

    it "returns false when it is equal", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isBiggerThan(otherMoney)).toBeFalsy()

  describe "#isBiggerOrEqualThan", ->
    it "returns true if it is bigger", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(0, 'EUR')
      expect(money.isBiggerOrEqualThan(otherMoney)).toBeTruthy()

    it "returns false if it is smaller", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(2000, 'EUR')
      expect(money.isBiggerOrEqualThan(otherMoney)).toBeFalsy()

    it "returns true when it is equal", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isBiggerOrEqualThan(otherMoney)).toBeTruthy()

  describe "#isSmallerThan", ->

    it "returns true if it is smaller", ->
      money = new Money(0, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerThan(otherMoney)).toBeTruthy()

    it "returns false if it is bigger", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerThan(otherMoney)).toBeFalsy()

    it "returns false when it is equal", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerThan(otherMoney)).toBeFalsy()

  describe "#isSmallerOrEqualThan", ->
    it "returns true if it is smaller", ->
      money = new Money(0, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerOrEqualThan(otherMoney)).toBeTruthy()

    it "returns false if it is bigger", ->
      money = new Money(2000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerOrEqualThan(otherMoney)).toBeFalsy()

    it "returns true when it is equal", ->
      money = new Money(1000, 'EUR')
      otherMoney = new Money(1000, 'EUR')
      expect(money.isSmallerOrEqualThan(otherMoney)).toBeTruthy()
