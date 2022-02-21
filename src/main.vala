
const string filename = "vala-file.txt";
const string filedata = "Hello, world!\n";

public static int main(string[] argv) {
    var ops = Fuse.Operations();

    ops.getattr = (path, stat) => {
        if(path == "/") {
            stat.st_mode = Posix.S_IFDIR | 0755;
            stat.st_nlink = 2;
            return 0;
        }
        if(path == @"/$filename") {
            stat.st_mode = Posix.S_IFREG | 0777;
            stat.st_nlink = 1;
            stat.st_size = filedata.length;
            return 0;
        }
        return -Posix.ENOENT;
    };

    ops.open = (path, ref fi) => 0;

    ops.read = (path, buffer, size, offset, ref file_info) => {
        if(path == @"/$filename") {
            if(offset >= filedata.length) {
                return 0;
            }

            if(offset + size > filedata.length) {
                Memory.copy(buffer, filedata[(long)offset:filedata.length], filedata.length - offset);
                return filedata.length - (int)offset;
            }

            Memory.copy(buffer, filedata[(long)offset:filedata.length], size);
            return (int)size;
        }

        return -Posix.ENOENT;
    };

    ops.readdir = (path, buf, filler, offset, ref file_info) => {
        filler(buf, ".", null, 0);
        filler(buf, "..", null, 0);
        filler(buf, filename, null, 0);
        return 0;
    };

    return Fuse.main(argv, ops, null);
}