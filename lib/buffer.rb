# require StringScanner

class Buffer
  attr_accessor :file_path, :line_ct, :content_s

  def initialize(file_path)
    self.file_path = file_path
    self.content_s = get_file_content(file_path)
    self.line_ct = content_s.length
  end

  private

  # rubocop: disable Lint/UselessAssignment
  def get_file_content(file_path)
    content_s = ''
    File.open(file_path, 'r') { |f| content_s = f.readlines.map(&:chomp) }
    content_scan = content_s.map { |v| v = StringScanner.new(v) }
    content_scan
  end
  # rubocop: enable Lint/UselessAssignment
end
