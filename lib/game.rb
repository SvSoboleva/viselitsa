# encoding: utf-8
# Основной класс игры. Хранит состояние игры и предоставляет функции
# для развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.)

class Game
  attr_reader :status, :errors, :good_letters, :bad_letters, :letters
  attr_accessor :version
  MAX_ERRORS = 7

  def initialize(slovo)
    @letters = get_letters(slovo)

    # переменная-индикатор кол-ва ошибок, всего можно сделать не более 7 ошибок
    @errors = 0

    # массивы, хранящие угаданные и неугаданные буквы
    @good_letters = []
    @bad_letters = []

    # спец. поле индикатор состояния игры (см. метод get_status)
    @status = :in_progress # :won , :lost
  end

  def errors_left
    MAX_ERRORS - @errors
  end

  # Метод, который возвращает массив букв загаданного слова
  def get_letters(slovo)
    if (slovo == nil || slovo == "")
      abort "Задано пустое слово, не о чем играть. Закрываемся."
    else
      slovo = slovo.encode("UTF-8")
    end
    return slovo.split("")
  end

  def is_good?(letter)
    @letters.include?(letter) ||
    (letter == "е" && letters.include?("ё")) ||
    (letter == "ё" && letters.include?("е")) ||
    (letter == "и" && letters.include?("й")) ||
    (letter == "й" && letters.include?("и"))
  end

  def add_letter_to(letters, letter)
    letters << letter # запишем её в число "правильных" буква

    case letter
    when 'е' then letters << 'ё'
    when 'ё' then letters << 'е'
    when 'и' then letters << 'й'
    when 'й' then letters << 'и'
    end
  end

  def solved?
    (@letters - @good_letters).empty?
  end

  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  def lost?
   @status == :lost || @errors >= MAX_ERRORS
  end

  def in_progress?
    @status == :in_progress
  end

  def won?
    @status == :won
  end

  def max_errors
    MAX_ERRORS
  end

  # Основной метод игры "сделать следующий шаг"
  def next_step(letter)
    # выходим из метода возвращая пустое значение
    return if @status == :lost || @status == :won
    return if repeated?(letter)

    # если в слове есть буква, или буква входит в пары е-ё и и-й , которые будем считать за одну букву
    if is_good?(letter)
      add_letter_to(@good_letters, letter)

      # дополнительная проверка - угадано ли на этой букве все слово целиком
      @status = :won if solved?
    else # если в слове нет введенной буквы – добавляем ошибочную букву и увеличиваем счетчик
      add_letter_to(@bad_letters, letter)
      @errors += 1
      @status = :lost if lost? # если ошибок больше 7 - статус игры -1, проигрышь
    end
  end

  def ask_next_letter
    puts "\nВведите следующую букву"
    letter = ""
    while letter == "" do
      letter = UnicodeUtils.downcase(STDIN.gets.encode("UTF-8").chomp)
    end
    # после получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end
end
