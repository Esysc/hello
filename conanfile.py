from conans import ConanFile, CMake, tools


class LibConan(ConanFile):
    ...

    def source(self):
        self.run("git clone https://github.com/Esysc/hello.git")

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder="repo.git")
        cmake.build()
