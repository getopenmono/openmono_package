monomake project "my_test" && \
	cd my_test && \
	make && \
	cd ..

if ! stat my_test/my_test.elf; then
	exit 1
fi
rm -rf my_test