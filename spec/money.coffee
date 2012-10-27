describe "Money", ->

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






