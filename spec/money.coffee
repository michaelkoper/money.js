describe "Money", ->

  it "should true", ->
    true

  describe "#format", ->
    it "returns the monetary value as a string", ->
      money = new Money(123456, 'EUR')
      expect(money.formatted()).toEqual("1234,56 €")

    it "does not display a decimal when factor is 1", ->
      money = new Money(1000, 'CLP')
      expect(money.formatted()).toEqual("$1000")

    describe ":no_cents option", ->

      it "filters when value has no decimals", ->
        money = new Money(1000, 'EUR', {no_cents: true})
        expect(money.formatted()).toEqual("10 €")

      it "filters when value has decimals", ->
        money = new Money(1040, 'EUR', {no_cents: true})
        expect(money.formatted()).toEqual("10 €")




