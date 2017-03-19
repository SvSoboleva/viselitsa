# encoding: utf-8
# Класс, отвечающий за ввод данных в программу "виселица"

class WordReader
  # Метод, возвращающий случайное слово, прочитанное из файла,
  # имя файла передается как аргумент метода
  def read_from_file(file_name)
    begin
      f = File.new(file_name, "r:UTF-8") # открываем файл, явно указывая его кодировку
      lines = f.readlines   # читаем все строки в массив
      f.close # закрываем файл
    rescue SystemCallError => error
      puts "Ошибка доступа к файлу. #{error.message}"
      return nil
    end  
    UnicodeUtils.downcase(lines.sample.chomp)
  end
end
