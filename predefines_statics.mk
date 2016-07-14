OPTIMIZATION = -O0


OBJECTS =		$(patsubst %.c,%.o,$(wildcard *.c)) \
				$(patsubst %.cpp,%.o,$(wildcard *.cpp))

TARGET_HEADERS=	$(wildcard ./*.h) \
				$(wildcard ./*.hpp)