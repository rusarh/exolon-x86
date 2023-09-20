set x=exo
@echo Compile 
@del tmp\%x%.obj > NUL
@tasm /c /z %x% %x% 
@..\SOFT\tlink /t /x /v  %x%.obj 
@copy /y %x%.com ..\tmp\%x%.com

