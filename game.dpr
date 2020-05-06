program game;

{$APPTYPE CONSOLE}

uses
  Windows, Sysutils;

type
  MySet = set of char;

var
  firstplayer, secondplayer: MySet;
  p: string;
  j, k: Integer;
  exits: Boolean;

procedure cleanscreen;
var
  ConsoleHandle: THandle;
  ConsoleInfo: TConsoleScreenBufferInfo;
  Coord, Coord1: TCoord;
  WrittenChars: DWORD;
  hStdOut: HWND;
begin
  hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  FillChar(ConsoleInfo, SizeOf(TConsoleScreenBufferInfo), 0);
  FillChar(Coord, SizeOf(TCoord), 0);
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(ConsoleHandle, ConsoleInfo);
  FillConsoleOutputCharacter(ConsoleHandle, ' ', ConsoleInfo.dwSize.X *
    ConsoleInfo.dwSize.Y, Coord, WrittenChars);
  Coord1.X := 0;
  Coord1.Y := 0;
  SetConsoleCursorPosition(hStdOut, Coord1);
end;

procedure rules;
begin
  Write('HELLO! Welcome to the game ''Guess the word''');
  Writeln;
  Writeln('Rules are the following:');
  Writeln('The first player enters 10 letters of the Latin alphabet.');
  Writeln('The second player try to quess this 10 letters in 3 attempts.');
  Writeln('The second player wins when he guesses more than 5 symbols.');
  Writeln('The first player wins when the second guesses less than 5 symbols.');
  Writeln('Otherwise - draw');
  Writeln('Do you want to play?');
end;

function check(m: MySet): Boolean;
var
  i: Integer;
  s: char;
begin
  result := true;
  for i := 1 to 10 do
  begin
    repeat
      read(s);
      LowerCase(s);
      if (not(s in ['A' .. 'z']) or (s in m)) then
        result := false;
      m := m + [s];
    until (not(s in ['A' .. 'z']) or (s in m));
  end;
end;

procedure first;
var
  flag: Boolean;
begin
  Writeln('It''s first player turn!');
  repeat
    Write('Please, enter 10 latinic letters: ');
    flag := check(firstplayer);
    if flag = false then
    begin
      Writeln('Oh no, you enter not only latinic letters, try ones again!');
      readln;
    end;
  until flag;
end;

procedure second;
var
  flag: Boolean;
begin
  case j of
    1:
      write('first');
    2:
      write('second');
    3:
      write('third');
  end;

  write(' try');
  Writeln;
  if k <> 0 then
    Writeln('You already guess ', k, ' symbols');
  repeat
    Writeln('Please, enter ', 10, ' latinic letters: ');
    flag := check(secondplayer);
    if flag = false then
      Writeln('Oh no, you enter not only latinic letters, try ones again!');
  until flag;
end;

procedure mistakes;
var
  i: Integer;

begin
  k := 0;
  Writeln('The second player finish his ', j, ' try');
  Writeln('So,let''s check what he guess.');
  write('     ');
  for i := 1 to 10 do
  begin
    if firstplayer = secondplayer then
      Inc(k);
  end;
  Writeln;

  Writeln(k, ' symbols are guessed');
  Writeln;
  if j = 3 then
    Writeln('That was last try')
  else
    Writeln('There are ', 3 - j, ' tryies left');
  if k = 10 then
    exits := true;
end;

begin
  firstplayer := [];
  secondplayer := [];
  rules;
  readln(p);
  while ((p = 'Yes') or (p = 'yEs') or (p = 'yeS') or (p = 'YEs') or (p = 'yES')
    or (p = 'YeS') or (p = 'YES') or (p = 'yes')) do
  begin
    Writeln('Press ''Enter'' to start.');
    readln;
    cleanscreen;
    first;
    Writeln('Press ''Enter'' to  second player start.');
    readln;
    cleanscreen;
    exits := false;
    j := 0;
    Write('It''s the second player turn!');
    Writeln;
    while (j < 3) and (exits = false) do
    begin
      Inc(j);
      second;
      readln;
      cleanscreen;
      if exits = false then
        mistakes;
      readln;
      cleanscreen;

      cleanscreen;
    end;
    Writeln;
    if k < 5 then
      Writeln('The FIRST player wins, there are ', k,
        ' symbols are guessed, congratulations');
    if k > 5 then
      Writeln('The SECOND player wins there are ', k,
        ' symbols are guessed, congratulations');
    if k = 5 then
      Writeln('It is a DRAW, congratulations to bouth players');
    Writeln('Try again?');
    readln(p);
  end;

  Writeln('Goodbye, see you soon');
  Writeln('Press ''Enter'' to exit.');
  readln;

end.
