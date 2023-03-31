function leave {
    cleanup
    exit 1
}

main_folder=`pwd`

function cleanup {
    cd ${main_folder}
    rm -r tasks/build 2> /dev/null
    rm -r clang-tidy 2> /dev/null
}

mkdir clang-tidy

cp .clang-format clang-tidy/.
cp .clang-tidy clang-tidy/.

for f in tasks/*; do
    if [ -d "$f" ]; then

        # We are in the task folder. Iterate over all files and check formatting
        
        for file in `find $f/. -name '*.h' -or -name '*.cpp' -or -name '*.hpp'`
        do
            if [[ "$file" == *test* ]]; then
                continue
            fi

            (echo "[CLANG-FORMAT] ${file}" && clang-format --dry-run --Werror $file) || leave

            mkdir -p clang-tidy/`dirname $file`

            # Remove all includes to prevent from checking libs
            # sed '/#include/d' $file > clang-tidy/${file}.cpp
            cp $file clang-tidy/${file}.cpp

            cd clang-tidy

            # Generate compile_commands.json
            pwd=`pwd`
            printf "[{\"directory\": \"${pwd}\"," > compile_commands.json
            printf "\"command\": \"clang++ -g -Wall -Wextra -Werror ${file}.cpp -o ${file}.cpp.o\"," >> compile_commands.json
            printf "\"file\": \"${file}.cpp\"}]" >> compile_commands.json

            (echo "[CLANG-TIDY] ${file}" && clang-tidy ${file}.cpp) || leave
            cd ..
        done

        cd $f

        if grep -q "int main()" ./*; then
            # Found test file, let's use it
            echo "[TESTS] Tests found, compiling"
        else
            continue
        fi

        CMAKELISTS_CREATED=false
        if test -f CMakeLists.txt; then
            echo "[TESTS] CMakeLists found, using it"
        else
            echo CMakeLists not found, using generic one
            cp ${main_folder}/GenericCMakeLists.txt CMakeLists.txt
            CMAKELISTS_CREATED=true
        fi
        
        cmake -B ../build
        cmake --build ../build
        ../build/target || leave

        rm -rf ../build

        if $CMAKELISTS_CREATED; then
          rm CMakeLists.txt
        fi
    fi
done