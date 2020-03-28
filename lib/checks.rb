require 'strscan'

module Checks
  def check_indent(content_string, case_start, case_end)
    space_indent = space_indent_check(content_string, case_start, case_end)
    content_string.each_with_index do |elem, idx|
      elem.reset
      idx.scan(/\s+/)
      string_pos = if elem.matched?
        elem.matched.length
      else
        0
      end
    end
  end

  def space_indent_check(content_string, case_start, case_end)
    arr = []
    line = 0
    content_string.each_with_index do |elem, idx|
      elem.reset
      arr << line
      if elem.exist?(Regex.new(case_start))
        line += 1
      else
        next
      end
    end
    arr
  end

  def check_space(content_string)
    content_string.each_with_index do |elem, idx|
      space_before(idx + 1, elem, "{")
      space_before(idx + 1, elem, "(")
      space_after(idx + 1, elem, "}")
      space_after(idx + 1, elem, ")")
      space_after(idx + 1, elem, ":")
      space_after(idx + 1, elem, ",")
    end
  end

  def check_before(line, str, char)
    str.reset
    str.scan_until(Regex.new(char))
    while str.matched?
      str.scan(/\+/)
      str.scan_until(Regexp.new(char))
    end
  end

end