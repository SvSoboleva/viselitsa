# encoding: utf-8
# Основной класс игры. Хранит состояние игры и предоставляет функции
# для развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.)

class Game
  attr_reader :status, :errors, :good_letters, :bad_letters, :letters

  def initialize(slovo)
    @letters = get_letters(slovo)

    # переменная-индикатор кол-ва ошибок, всего можно сделать не более 7 ошибок
    @errors = 0

    # массивы, хранящие угаданные и неугаданные буквы
    @good_letters = []
    @bad_letters = []

    # спец. поле индикатор состояния игры (см. метод get_status)
    @status = 0
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

  # Основной метод игры "сделать следующий шаг"
  def next_step(bukva)
    if @status == -1 || @status == 1
      return # выходим из метода возвращая пустое значение
    end

    # если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода
    if @good_letters.include?(bukva) || @bad_letters.include?(bukva)
      return
    end

    # если в слове есть буква, или буква входит в пары е-ё и и-й , которые будем считать за одну букву
    if @letters.include?(bukva) ||
         (bukva == "е" && letters.include?("ё")) ||
         (bukva == "ё" && letters.include?("е")) ||
         (bukva == "и" && letters.include?("й")) ||
         (bukva == "й" && letters.include?("и"))

      @good_letters << bukva # запишем её в число "правильных" буква

      case bukva
      when 'е' then @good_letters << 'ё'
      when 'ё' then @good_letters << 'е'
      when 'и' then @good_letters << 'й'
      when 'й' then @good_letters << 'и'
      end

      # дополнительная проверка - угадано ли на этой букве все слово целиком
      if (@letters - @good_letters).empty?
        @status = 1 # статус - победа
      end
    else # если в слове нет введенной буквы – добавляем ошибочную букву и увеличиваем счетчик
      @bad_letters << bukva
      @errors += 1
      if @errors >= 7 # если ошибок больше 7 - статус игры -1, проигрышь
        @status = -1
      end
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
