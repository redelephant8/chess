module LetterNumber
  def letter_to_number(input)
    case input
    when 'a'
      0
    when 'b'
      1
    when 'c'
      2
    when 'd'
      3
    when 'e'
      4
    when 'f'
      5
    when 'g'
      6
    when 'h'
      7
    end
  end

  def number_to_letter(input)
    case input
    when 0
      'a'
    when 1
      'b'
    when 2
      'c'
    when 3
      'd'
    when 4
      'e'
    when 5
      'f'
    when 6
      'g'
    when 7
      'h'
    end
  end
end