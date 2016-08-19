module Formattable
  def format_date date
    date.strftime("%a, %b #{date.day.ordinalize}")
  end

  def format_amount_slim amount
    if amount % 1 == 0
      format_amount_without_decimal
    else
      format_amount_with_decimal
    end
  end

  def format_amount_with_decimal_plain amount
    number_with_precision(amount, :precision => 2, :delimiter => ',')
  end

  def format_amount_with_decimal amount
    "$" + number_with_precision(amount, :precision => 2, :delimiter => ',')
  end

  def format_amount_without_decimal amount
    "$" + number_with_precision(amount, :precision => 0, :delimiter => ',')
  end
end
