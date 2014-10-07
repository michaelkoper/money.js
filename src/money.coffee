###

  Money Class

  A lighweight javascript library for handling money in different currencies.
  http://github.com/michaelkoper/money.js

  Copyright (c) 2014 Michael Koper

  Dual licensed under the MIT and GPL licenses.

  @version 0.2.2

###

class @Money

  # Default currencies
  @currencies =
    'EUR':
      identifier: 'EUR'
      fixed: 2
      name: 'euro'
      factor: 100
      separator: ','
      thousands: '.'
      format: (base) ->
        return "#{base} €"
    'USD':
      identifier: 'USD'
      fixed: 2
      name: 'dollar'
      factor: 100
      separator: '.'
      thousands: ','
      format: (base) ->
        return "$#{base}"
    'GBP':
      identifier: 'GBP'
      fixed: 2
      name: 'British Pound'
      factor: 100
      separator: '.'
      thousands: ','
      format: (base) ->
        return "£#{base}"

  @defaultCurrency = 'EUR'

  constructor: (value, cur, options) ->
    @options = options || {}
    currency = if typeof(cur) is 'object' then cur else null
    @currency = currency || Money.currencies[cur] || Money.currencies[Money.defaultCurrency]
    if ((typeof(value) == 'string') or (value instanceof String))
      @cents = Math.round(value.replace(/\,/, '.') * @currency.factor)
    else if ((typeof(value) == 'number') or (value instanceof Number))
      @cents = Math.round(value)
    else
      @cents = 0

  toString: (options)->
    options = options || {}

    fixed = if options.no_cents || (options.no_cents_if_whole && (@cents % @currency.factor == 0))
      0
    else
      @currency.fixed

    amount = (@cents / @currency.factor)

    # Make it minus if less then 0
    minus = if amount < 0 then "-" else ""
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
    new Money(this.cents, @currency)

  add: (v) ->
    new Money(@cents + v.toMoney(@currency).cents, @currency)

  subtract: (v) ->
    new Money(@cents - v.toMoney(@currency).cents, @currency)

  multiply: (v) ->
    new Money(Math.round(@cents * v), @currency)

  divide: (v) ->
    new Money(Math.round(@cents / v), @currency)

  isEqual: (otherMoney)->
    @cents == otherMoney.cents && @currency == otherMoney.currency

  isBiggerThan: (otherMoney)->
    @cents > otherMoney.cents
  isBiggerOrEqualThan: (otherMoney)->
    @cents >= otherMoney.cents

  isSmallerThan: (otherMoney)->
    @cents < otherMoney.cents
  isSmallerOrEqualThan: (otherMoney)->
    @cents <= otherMoney.cents

  isPositive: -> @cents > 0
  isNegative: -> @cents < 0
  isZero: -> @cents == 0

#
# Numbers are assumed to be in human format, not cents.
#
Number::toMoney = (cur) ->
  currency = Money.currencies[cur] || Money.currencies[Money.defaultCurrency]
  new Money(this, cur)

String::toMoney = (cur) ->
  new Money(this, cur)


