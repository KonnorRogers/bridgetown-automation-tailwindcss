module Utils
  def prepend_to_file(file, str)
    File.open(file, 'w') do |open_file|
      open_file.puts(str)
      File.foreach(file) do |line|
        open_file.puts(line)
      end
    end
  end
end
