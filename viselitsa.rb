# encoding: utf-8
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

current_path = File.dirname(__FILE__)

require "unicode_utils/downcase"

require_relative "./lib/game.rb"
require_relative "./lib/result_printer.rb"
require_relative "./lib/word_reader.rb"

VERSION = 'Игра Виселица версия 4'

# объект, отвечающий за ввод слова в игру
word_reader = WordReader.new

# Имя файла, откуда брать слово для загадывания
words_file_name = current_path + "/data/words.txt"

# создаем объект типа Game, в конструкторе передаем загаданное слово из word_reader-а
game = Game.new(word_reader.read_from_file(words_file_name))

# объект, печатающий результаты
printer = ResultPrinter.new(game)

while game.in_progress? do
  # выводим статус игры
  printer.print_status(game)
  # просим угадать следующую букву
  game.ask_next_letter
end

printer.print_status(game)
