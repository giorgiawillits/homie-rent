module Formattable
  def format_date date
    date.strftime("%a, %b #{date.day.ordinalize}")
  end

  def format_amount_slim
    if self.amount % 1 == 0
      amount_formatted_without_decimal
    else
      amount_formatted_with_decimal
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
