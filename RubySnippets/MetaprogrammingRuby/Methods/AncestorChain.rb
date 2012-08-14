module Printable
  def print
  end

  def prepare_cover
  end
end

module Document
  def print
  end

  def format_to_screen
  end

  def print_to_screen
    prepare_cover
    format_to_screen
    print
  end
end

class Book
  include Document
  include Printable
end

