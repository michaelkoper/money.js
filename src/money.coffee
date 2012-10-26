###

Money Class

Make handling money much easier and most importantly avoid rounding
errors.

###

class Money

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


  toString: ->
    fixed = @currency.fixed
    if @options.no_cents
      fixed = 0
    (@cents / @currency.factor)
      .toFixed(fixed)
      .replace(/\./, @currency.separator)

  formatted: (options)->
    @currency.format(this.toString())

  dup: ->
    new Money(this, @currency)

  add: (v) ->
    new Money(@cents + v.toMoney().cents, @currency)

  subtract: (v) ->
    new Money(@cents - v.toMoney().cents, @currency)

  multiply: (v) ->
    new Money(Math.round(@cents * v), @currency)

  divide: (v) ->
    new Money(Math.round(@cents / v), @currency)

  toMoney: (cur) ->
    this

#
# Numbers are assumed to be in human format, not cents.
#
Number::toMoney = (cur) ->
  currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency]
  new Money(this * currency.factor, cur)

String::toMoney = (cur) ->
  new Money(this, cur)


# export the money class
(exports ? this).Money = Money

