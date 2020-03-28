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
    level = 0
  end
end