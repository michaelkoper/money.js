###

Money Class

Make handling money much easier and most importantly avoid rounding
errors.

###

class @Money

  @currencies = {
    'EUR': {
      fixed: 2
      name: 'euro'
      factor: 100
      separator: ','
      thousands: '.'
      format: (base) ->
        return "#{base} €"
    }
    'CLP': {
      fixed: 0
      name: 'pesos'
      factor: 1
      separator: ','
      thousands: '.'
      format: (base) ->
        return "$#{base}"
    }
    'PEN': {
      fixed: 2
      name: 'nuevo soles'
      factor: 100
      separator: ','
      thousands: '.'
      format: (base) ->
        return "S/.#{base}"
    }
    'USD': {
      fixed: 2
      name: 'dollar'
      factor: 100
      separator: '.'
      thousands: ','
      format: (base) ->
        return "$#{base}"
    }
    'MXN': {
      fixed: 2
      name: 'mexican pesos'
      factor: 100
      separator: '.'
      thousands: ','
      format: (base) ->
        return "$#{base}"
    }
  }
  @defaultCurrency = 'EUR'

  constructor: (value, cur, options) ->
    @options = options || {}
    if cur instanceof Object
      @currency = cur
    else
      @currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency]
    if value instanceof Money
      @cents = value.cents
      if @currency.name != value.currency.name
        @currency = value.currency

    else if ((typeof(value) == 'string') or (value instanceof String))
      @cents = Math.round(value.replace(/\,/, '.') * @currency.factor)

    else if ((typeof(value) == 'number') or (value instanceof Number))
      @cents = Math.round(value)

    else
      @cents = 0



  toString: (options)->
    options = options || {}
    fixed = @currency.fixed
    if options.no_cents
      fixed = 0
    amount = (@cents / @currency.factor)

    # Make it minus if less then 0
    minus = (if amount < 0 then "-" else "")
    # Make it a string and possitive
    toString = parseInt(amount = Math.abs(+amount or 0).toFixed(fixed)) + ""

    # How many numbers before the first thousands
    amountPrefix = if (amountPrefix = toString.length) > 3 then amountPrefix % 3 else 0
    prefixNumber = if amountPrefix then toString.substr(0, amountPrefix) + @currency.thousands else ""

    # number without prefix which need the thousands
    replacedNumber = toString.substr(amountPrefix).replace(/(\d{3})(?=\d)/g, "$1" + @currency.thousands)

    decimals = (if fixed then @currency.separator + Math.abs(amount - toString).toFixed(fixed).slice(2) else "")

    minus + prefixNumber + replacedNumber + decimals

  formatted: (options)->
    @currency.format(this.toString(options))

  dup: ->
    new Money(this, @currency)

  add: (v) ->
    new Money(@cents + v.toMoney(@currency).cents, @currency)

  subtract: (v) ->
    new Money(@cents - v.toMoney(@currency).cents, @currency)

  multiply: (v) ->
    new Money(Math.round(@cents * v), @currency)

  divide: (v) ->
    new Money(Math.round(@cents / v), @currency)

  toMoney: (cur) ->
    this

  equal: (money)->


#
# Numbers are assumed to be in human format, not cents.
#
Number::toMoney = (cur) ->
  currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency]
  new Money(this, cur)

String::toMoney = (cur) ->
  new Money(this, cur)


