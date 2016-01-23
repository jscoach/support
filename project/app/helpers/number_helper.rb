module NumberHelper
  # Slightly customized humanized numbers (eg: "1K" instead of "1 Thousand")
  def humanized_number(number)
    str = number_to_human number,
      precision: 1,
      significant: false,
      format: "%n%u",
      units: {
        thousand: "K",
        million: "M",
        billion: "B",
        trillion: "T",
        quadrillion: "Q"
      }

    # Change precision to 0 if string has more than 4 letters (eg: "123k" instead of "123.5k")
    str.length > 4 ? str.sub(/\.\d(\w)$/, '\1') : str
  end
end
